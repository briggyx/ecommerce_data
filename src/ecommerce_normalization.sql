/*

First Normal Form (1NF):

Eliminate repeating groups: Each column should contain atomic values, meaning that each cell should hold a single value, and there should be no repeating groups of columns.
Ensure unique column names within a table.
Identify a primary key: Each table should have a primary key that uniquely identifies each row.
No ordering of rows or columns: The order in which rows or columns are stored should not matter.
No repeating rows. 

Second Normal Form (2NF):

Satisfy 1NF.
Eliminate partial dependencies: A non-prime attribute (an attribute that is not part of any candidate key) should be fully functionally dependent on the entire primary key.
Ensure that every non-prime attribute is fully functionally dependent on the primary key.

Third Normal Form (3NF):

Satisfy 2NF.
Eliminate transitive dependencies: Remove attributes that are dependent on other non-key attributes.
Ensure that all non-prime attributes are non-transitively dependent on the primary key.

*/


SELECT product_sku, COUNT(product_sku) repeats
FROM sales_by_sku
GROUP BY product_sku
HAVING COUNT(product_sku) > 1;

ALTER TABLE sales_by_sku
ADD PRIMARY KEY (product_sku);

SELECT product_sku, COUNT(product_sku) repeats
FROM sales_report
GROUP BY product_sku
HAVING COUNT(product_sku) > 1;

ALTER TABLE sales_report
ADD PRIMARY KEY (product_sku);

SELECT product_sku, COUNT(product_sku) repeats
FROM products
GROUP BY product_sku
HAVING COUNT(product_sku) > 1;

ALTER TABLE products
ADD PRIMARY KEY (product_sku);

-- all_sessions doesn't have any columns that could act as PK 
-- I'll create an autoincrement column for the PK
SELECT full_visitor_id, COUNT(full_visitor_id) repeats
FROM all_sessions
GROUP BY full_visitor_id
HAVING COUNT(product_sku) > 1;

SELECT visit_id, COUNT(visit_id) repeats
FROM all_sessions
GROUP BY visit_id
HAVING COUNT(visit_id) > 1;

ALTER TABLE all_sessions
ADD COLUMN session_id SERIAL PRIMARY KEY;

-- analytics doesn't have any columns that could act as PK 
-- I'll create an autoincrement column for the PK
SELECT visit_id, COUNT(visit_id) repeats
FROM analytics 
GROUP BY visit_id
HAVING COUNT(visit_id) > 1;

SELECT full_visitor_id, COUNT(full_visitor_id) repeats
FROM analytics 
GROUP BY full_visitor_id
HAVING COUNT(full_visitor_id) > 1;

ALTER TABLE analytics
ADD COLUMN session_id SERIAL PRIMARY KEY;

SELECT DISTINCT ecommerce_action_option
FROM all_sessions; 

SELECT DISTINCT ecommerce_action_step
FROM all_sessions; 

SELECT DISTINCT ecommerce_action_type
FROM all_sessions; 

SELECT DISTINCT search_keyword
FROM all_sessions; 

SELECT DISTINCT item_revenue
FROM all_sessions;

SELECT DISTINCT transaction_id
FROM all_sessions; 

SELECT DISTINCT transaction_revenue
FROM all_sessions;

SELECT DISTINCT item_quantity
FROM all_sessions;

SELECT DISTINCT product_revenue
FROM all_sessions;

SELECT DISTINCT product_quantity
FROM all_sessions; 

SELECT DISTINCT product_variant
FROM all_sessions; 

SELECT DISTINCT product_refund_amount
FROM all_sessions; 

SELECT DISTINCT type
FROM all_sessions; 

SELECT DISTINCT session_quality_dim
FROM all_sessions; 

SELECT DISTINCT transactions
FROM all_sessions;

SELECT DISTINCT total_transaction_revenue
FROM all_sessions;

-- delete blank columms
ALTER TABLE all_sessions
DROP COLUMN search_keyword; 

ALTER TABLE all_sessions
DROP COLUMN item_revenue; 

ALTER TABLE all_sessions
DROP COLUMN item_quantity; 

ALTER TABLE all_sessions
DROP COLUMN product_refund_amount;

-- Partial dependencies in all_sessions table: v2_product_name, product_price 
-- I will delete these 2 columns, as their info can be found in the products table 
ALTER TABLE all_sessions
DROP COLUMN v2_product_name;

ALTER TABLE all_sessions
DROP COLUMN product_price;

SELECT DISTINCT user_id
FROM analytics;

ALTER TABLE analytics
DROP COLUMN user_id;

SELECT DISTINCT units_sold
FROM analytics;

SELECT *
FROM analytics
WHERE revenue IS NOT NULL;

UPDATE analytics 
SET revenue = revenue / 1000000;

-- There is potential for revenue to be dependent on unit_price and units_sold, however, the formula for revenue varies 



SELECT * 
FROM sales_by_sku sbs
LEFT JOIN sales_report sr
ON sbs.product_sku = sr.product_sku
WHERE sr.product_sku IS NULL;

SELECT * 
FROM products p
LEFT JOIN sales_report sr
ON p.product_sku = sr.product_sku
WHERE sr.product_sku IS NULL;

-- Every product_sku in sales_report is in the products table, so I can delete sales_report 
SELECT * 
FROM sales_report sr
LEFT JOIN products p
ON sr.product_sku = p.product_sku
WHERE p.product_sku IS NULL;

DROP TABLE sales_report;

-- There are product_sku in sales_by_sku not in products
-- Insert those rows into products and delete sales_by_sku
SELECT * 
FROM sales_by_sku sbs
LEFT JOIN products p
ON sbs.product_sku = p.product_sku
WHERE p.product_sku IS NULL;

INSERT INTO products (product_sku, total_ordered)
SELECT sbs.product_sku, sbs.total_ordered
FROM sales_by_sku sbs
LEFT JOIN products p ON sbs.product_sku = p.product_sku
WHERE p.product_sku IS NULL;

DROP TABLE sales_by_sku;

--Drop visit_start_time from analytics table since it repeats visit_id
ALTER TABLE analytics
DROP COLUMN visit_start_time;






-- Both full_visitor_id and visit_id repeat in the table all_sessions
SELECT full_visitor_id, COUNT(full_visitor_id) repeats
FROM all_sessions
GROUP BY full_visitor_id
HAVING COUNT(full_visitor_id) > 1
ORDER BY repeats DESC;

SELECT visit_id, COUNT(visit_id) repeats
FROM all_sessions
GROUP BY visit_id
HAVING COUNT(visit_id) > 1;



-- Both full_visitor_id and visit_id repeat in the table analytics 
SELECT full_visitor_id, COUNT(full_visitor_id) repeats
FROM analytics
GROUP BY full_visitor_id
HAVING COUNT(full_visitor_id) > 1;

SELECT visit_id, COUNT(visit_id) repeats
FROM analytics
GROUP BY visit_id
HAVING COUNT(visit_id) > 1;

SELECT DISTINCT visit_number
FROM analytics;

-- It seems that each person gets a unique full_visitor_id, and each visit by that person is assigned a visit_id
-- Every time they add something to their cart/interacts with a product a record is added 
-- 
SELECT * 
FROM analytics 
WHERE full_visitor_id = '7311236652895887059';

SELECT *
FROM all_sessions
WHERE visit_id = '1491424686'

SELECT *
FROM all_sessions
WHERE full_visitor_id = '2.1338E+18'

-- There are overlapping full_visitor_id between analytics and all_sessions
-- It appears that analytics and all_sessions are very similar, except that all_sessions contains info about a person's location and duration of browsing and webpage info. 

SELECT an.full_visitor_id
FROM analytics an  
INNER JOIN all_sessions als
ON an.full_visitor_id = als.full_visitor_id;

SELECT an.visit_id, an. full_visitor_id, als.full_visitor_id 
FROM analytics an  
INNER JOIN all_sessions als
ON an.visit_id = als.visit_id
ORDER BY visit_id;

-- Dates span from "2016-08-01" to "2017-08-01" in all_sessions (1 year)
SELECT MAX(date) AS max_date, MIN(date) AS min_date
FROM all_sessions;

-- Dates span from "2017-05-01" to "2017-08-01" in analytics (3 months)
-- The overlap range is from "2017-05-01" to "2017-08-01" between the two tables 
SELECT MAX(date) AS max_date, MIN(date) AS min_date
FROM analytics;

copy (select * from analytics) to 'C:\ecommerce\analytics_cleaned.csv' delimiter ',' csv header

