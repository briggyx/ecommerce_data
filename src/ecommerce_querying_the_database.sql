/* Which cities and countries have the highest level of transaction revenues on the site? */
/* Answer: Top 5 countries: United States, Israel, Australia, Canada, Switzerland.
Top 5 cities: San Francisco, Sunnyvale, Atlanta, Palo Alto, Tel Aviv-Yafo.  */



-- The following queries comes up with 0 results, suggesting there are no overlaps in individuals in analytics and all_sessions
SELECT a.full_visitor_id
FROM analytics a
INNER JOIN all_sessions s 
ON a.full_visitor_id = s.full_visitor_id;

-- This is to double check that there aren't any overlap in individuals 
SELECT a.full_visitor_id, s.full_visitor_id
FROM analytics a
INNER JOIN all_sessions s 
ON a.visit_id = s.visit_id;

SELECT transaction_revenue tr
FROM all_sessions
ORDER BY tr DESC;

SELECT product_revenue pr
FROM all_sessions
ORDER BY pr DESC;

UPDATE all_sessions
SET TRANSACTION_REVENUE = TRANSACTION_REVENUE / 1000000,
    PRODUCT_REVENUE = PRODUCT_REVENUE / 1000000;

-- There are >14k distinct full_visitor_id and >15k rows, suggesting only a few full_visitor_id repeat, contrary to the analytics table 
SELECT DISTINCT full_visitor_id
FROM all_sessions;

SELECT full_visitor_id, COUNT(full_visitor_id)
FROM all_sessions
GROUP BY full_visitor_id
HAVING COUNT(full_visitor_id) > 1;

-- Looking at a single full_visitor_id that repeats several times, it looks like each row represents an ecommerce browsing session 
SELECT *
FROM all_sessions
WHERE full_visitor_id = '4278370000000000000';

-- List countries by total transaction revenue in descending order 
SELECT country, sum(total_transaction_revenue) ttr
FROM all_sessions
GROUP BY country 
ORDER BY ttr DESC;

-- List cities by total transaction revenue in descending order 
SELECT city, sum(total_transaction_revenue) ttr
FROM all_sessions
GROUP BY city
ORDER BY ttr DESC;

-------------------------------------------------------------------------------------------------------------------------
/* Question 2: What is the average number of products ordered from visitors in each city and country? */
/* Answer: Top 2 Countries: Spain (10), United States (4). Top 2 cities: Madrid (10), Salem (8).

-- average of all records for given countries
SELECT country, round(avg(product_quantity),1) pq
FROM all_sessions
GROUP BY country 
ORDER BY pq DESC;

-- average for records where there is > 0 quantity purchased 
SELECT country, round(avg(product_quantity),1) pq
FROM all_sessions
WHERE product_quantity > 0
GROUP BY country 
ORDER BY pq DESC;

-- average of all records for given cities 
SELECT city, round(avg(product_quantity),1) pq
FROM all_sessions
GROUP BY city 
ORDER BY pq DESC;

-- average for records where there is > 0 quantity purchased 
SELECT city, round(avg(product_quantity),1) pq
FROM all_sessions
WHERE product_quantity > 0
GROUP BY city
ORDER BY pq DESC;

-------------------------------------------------------------------------------------------------------------------------
/* Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country? */
-- Answer: The products are weather-suited to the buyers' countries 

select * from all_sessions

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

-------------------------------------------------------------------------------------------------------------------------
/* Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold? */

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

-------------------------------------------------------------------------------------------------------------------------
/* Question 5: Can we summarize the impact of revenue generated from each city/country? */ 

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


