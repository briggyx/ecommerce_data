# Ecommerce ETL & Analysis 

**By Brigitte Yan, May 3, 2024**

**Tech stack & languages: PostgreSQL, Snowflake, pgAdmin 4**

[**Project Outline**](https://github.com/lighthouse-labs/Final-Project-SQL)

[**Data Source**](https://drive.google.com/drive/folders/1efDA4oc9w-bTbAvrESdOJpg9u-gEUBhJ)


## Abstract 
- 

## Introduction
This project demonstrates proficiency in the Extract, Transform, and Load (**ETL**) process. It begins with the retrieval of five .csv files from Google Drive, followed by their transformation in **PGAdmin4** using **PostgreSQL**, and finally, their loading into Snowflake. Within **Snowflake**, these data tables are then queried to address specific questions related to their contents.

The initial set of tables consists of: products.csv, all_sessions.csv, analytics.csv, sales_by_sku.cv, and sales_report.csv. These tables encompass various details such as location, duration, number of page views, transactions, and information about the products sold or viewed. The data records span a period of one year, from August 1, 2016, to August 1, 2017, and are likely sourced from the Google Store.

In PGAdmin4, the tables underwent cleaning and normalization to achieve third normal form (3NF), and an Entity-Relationship Diagram (ERD) was constructed for the database. Subsequently, the cleaned tables were exported to the local drive and then imported into Snowflake.

Within Snowflake, I queried the database to address important inquiries regarding overall revenue and the top-selling items, organized by country and city.


## Methods 

After downloading the .csv's onto my local disk, I opened up PGAdmin4 and created a new database called ecommerce, and populated it with five tables. Then, I used the PSQL tool to insert data from the .csv's into the database. After data insertion, I validated that the new tables matched the .csv's by visually inspecting that the columns all matched.   

Sample query for table creation & data insertion:
``` sql 
CREATE TABLE sales_by_sku (
	productSKU VARCHAR(16) NOT NULL,
	total_ordered SMALLINT
);

\COPY sales_by_sku(productSKU, total_ordered) FROM 'C:\Users\brigi\OneDrive\Desktop\ecommerce_data\data\sales_by_sku.csv' DELIMITER ',' CSV HEADER;
```
Afterwards, I cleaned up the tables by ensuring consistency in field names, adjusting column data types, removing trailing and leading spaces, converting NULL cells to blanks or 0s to facilitate upload into Snowflake, and dropping redundant columns.

Sample query for data cleaning:
``` sql 
ALTER TABLE sales_report
RENAME COLUMN productsku TO product_sku;

UPDATE sales_report 
SET name = TRIM(name);

UPDATE all_sessions
SET product_price = product_price / 1000000;

ALTER TABLE analytics
ALTER COLUMN date SET DATA TYPE DATE USING TO_DATE(date::text, 'YYYYMMDD');

UPDATE products
SET name = ''
WHERE name IS NULL;

ALTER TABLE all_sessions
DROP COLUMN product_refund_amount;
```

After cleaning the tables, I proceeded to normalize them to the third normal form (3NF). This involved ensuring that each column contained a single piece of data, eliminating any repeating rows or columns, assigning a primary key to each column, and removing any partial or transitive dependencies on non-key attributes. After bringing the database up to 3NF, I was left with three tables, after having started from five tables. 

Sample query for normalization:
``` sql 
ALTER TABLE sales_by_sku
ADD PRIMARY KEY (product_sku);

ALTER TABLE all_sessions
ADD COLUMN session_id SERIAL PRIMARY KEY;
``` 
After normalization, I linked together the three tables using foreign keys which pointed to primary keys in other tables (one-to-many cardinality). This was the resulting ERD:

![ERD of ecommerce database](docs\ecommerce_ERD.png)

Next, I exported the tables onto my local disk:
``` sql 
copy (select * from analytics) to 'C:\ecommerce\analytics_cleaned.csv' delimiter ',' csv header
```
Then, I uploaded the tables onto Snowflake:

![](docs/Screenshot%202024-03-29%20164253.png)

Finally, I queried the database in Snowflake to answer questions regarding revenue and the top-selling items.

![](docs/Screenshot%202024-03-29%20163921.png)

**Question 1: Which cities and countries have the highest level of transaction revenues on the site?** 
``` sql  
SELECT country, sum(total_transaction_revenue) ttr
FROM all_sessions
GROUP BY country 
ORDER BY ttr DESC;

SELECT city, sum(total_transaction_revenue) ttr
FROM all_sessions
GROUP BY city
ORDER BY ttr DESC;
``` 

**Question 2: What is the average number of products ordered from visitors in each city and country?**
``` sql  
SELECT country, round(avg(product_quantity),1) pq
FROM all_sessions
WHERE product_quantity > 0
GROUP BY country 
ORDER BY pq DESC;

SELECT city, round(avg(product_quantity),1) pq
FROM all_sessions
WHERE product_quantity > 0
GROUP BY city
ORDER BY pq DESC;
``` 
**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**
``` sql  
CREATE VIEW question3 AS
SELECT
    country,
    product_quantity,
    product_revenue,
    v2_product_category,
    product_sku
FROM
    all_sessions
WHERE
    product_quantity > 0
ORDER BY country; 

SELECT 
    q3.product_sku,  
    country,
    product_quantity,
    product_revenue,
    v2_product_category,
    name
FROM 
    question3 q3 
INNER JOIN 
    products p
ON 
    q3.product_sku = p.product_sku;

CREATE VIEW question3b AS
SELECT
    city,
    product_quantity,
    product_revenue,
    v2_product_category,
    product_sku
FROM
    all_sessions
WHERE
    product_quantity > 0
ORDER BY city; 

SELECT 
    q3b.product_sku,  
    city,
    product_quantity,
    product_revenue,
    v2_product_category,
    name
FROM 
    question3b q3b 
INNER JOIN 
    products p
ON 
    q3b.product_sku = p.product_sku;
```

**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**
``` sql
SELECT 
    p.name,
    q3.country,
    COUNT(p.name) AS number_sold
FROM 
    question3 q3 
INNER JOIN 
    products p
ON 
    q3.product_sku = p.product_sku
GROUP BY 
    p.name,
    q3.country
ORDER BY 
    q3.country, number_sold DESC;

SELECT 
    p.name,
    q3b.city,
    COUNT(p.name) AS number_sold
FROM 
    question3b q3b 
INNER JOIN 
    products p
ON 
    q3b.product_sku = p.product_sku
GROUP BY 
    p.name,
    q3b.city
ORDER BY 
    q3b.city, number_sold DESC;
```
**Question 5: Can we summarize the impact of revenue generated from each city/country?**
``` sql
SELECT 
    country, 
    ROUND(SUM(total_transaction_revenue) / (SELECT SUM(total_transaction_revenue) FROM all_sessions), 2) AS proportion_of_all_revenues
FROM 
    all_sessions
GROUP BY 
    country
ORDER BY 
    proportion_of_all_revenues DESC, 
    country;

SELECT 
    city, 
    ROUND(SUM(total_transaction_revenue) / (SELECT SUM(total_transaction_revenue) FROM all_sessions), 2) AS proportion_of_all_revenues
FROM 
    all_sessions
GROUP BY 
    city
ORDER BY 
    proportion_of_all_revenues DESC, 
    city;
```
## Results 
Question 1: Which cities and countries have the highest level of transaction revenues on the site?

**Answer: Top 5 countries: United States, Israel, Australia, Canada, Switzerland. Top 5 cities: San Francisco, Sunnyvale, Atlanta, Palo Alto, Tel Aviv-Yafo.** 


Question 2: What is the average number of products ordered from visitors in each city and country?

**Answer: Top 2 Countries: Spain (10), United States (4). Top 2 cities: Madrid (10), Salem (8).** 

Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?

**Answer: The items are suited to the cities' cultures and climates.** 

Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?

**Answer: A lot of outdoor security cameras, thermostats, indoor security cameras, sunglasses and t-shirts are sold in the U.S.** 

Question 5: Can we summarize the impact of revenue generated from each city/country? 

**Answer: 92% of total revenues comes from the U.S., 4% comes from Israel and 3% comes from Australia. 11% of total revenues comes from San Francisco, 7% is from Sunnyvale and 6% is from Atlanta.**

## Discussion

## Conclusion 



