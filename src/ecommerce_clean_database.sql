-- Now, I will clean & transform the tables to prepare them for loading into Snowflake.

/* sales_by_sku 
ALTER TABLE sales_by_sku
RENAME COLUMN productsku TO product_sku;

UPDATE sales_by_sku
SET product_sku = TRIM(product_sku);
*/

/* sales_report 
ALTER TABLE sales_report
RENAME COLUMN productsku TO product_sku;

ALTER TABLE sales_report
RENAME COLUMN stocklevel TO stock_level;

ALTER TABLE sales_report
RENAME COLUMN restockingleadtime TO restocking_lead_time;

ALTER TABLE sales_report
RENAME COLUMN sentimentscore TO sentiment_score;

ALTER TABLE sales_report
RENAME COLUMN sentimentmagnitude TO sentiment_magnitude;

UPDATE sales_report 
SET product_sku = TRIM(product_sku);

UPDATE sales_report 
SET name = TRIM(name);

-- The following converts all product_sku and name to UTF8, required by Snowflake. 

UPDATE sales_report
SET 
    name = encode(name::bytea, 'escape'),
    product_sku = encode(product_sku::bytea, 'escape');	
	
ALTER TABLE sales_report
RENAME COLUMN restocking_lead_time TO restocking_lead_time_days;
*/


/* products 
ALTER TABLE products 
RENAME COLUMN sku TO product_sku;

ALTER TABLE products 
RENAME COLUMN orderedquantity TO ordered_quantity;

ALTER TABLE products 
RENAME COLUMN stocklevel TO stock_level;

ALTER TABLE products 
RENAME COLUMN restockingleadtime TO restocking_lead_time;

ALTER TABLE products 
RENAME COLUMN sentimentscore TO sentiment_score;

ALTER TABLE products 
RENAME COLUMN sentimentmagnitude TO sentiment_magnitude;

UPDATE products 
set product_sku = TRIM(product_sku);

UPDATE products 
set name = TRIM(name);

UPDATE products
SET 
    name = encode(name::bytea, 'escape'),
    product_sku = encode(product_sku::bytea, 'escape');
	
ALTER TABLE products 
RENAME COLUMN restocking_lead_time TO restocking_lead_time_days;
*/

/* all_sessions
ALTER TABLE all_sessions 
RENAME COLUMN fullvisitorid TO full_visitor_id;

ALTER TABLE all_sessions 
RENAME COLUMN channelgrouping TO channel_grouping;

ALTER TABLE all_sessions 
RENAME COLUMN totaltransactionrevenue TO total_transaction_revenue;

ALTER TABLE all_sessions 
RENAME COLUMN timeonsite TO time_on_site;

ALTER TABLE all_sessions 
RENAME COLUMN pageviews TO page_views;

ALTER TABLE all_sessions 
RENAME COLUMN sessionqualitydim TO session_quality_dim;

ALTER TABLE all_sessions 
RENAME COLUMN productrefundamount TO product_refund_amount;

ALTER TABLE all_sessions 
RENAME COLUMN visitid TO visit_id;

ALTER TABLE all_sessions 
RENAME COLUMN productquantity TO product_quantity;

ALTER TABLE all_sessions 
RENAME COLUMN productprice TO product_price;

ALTER TABLE all_sessions 
RENAME COLUMN productrevenue TO product_revenue;

ALTER TABLE all_sessions 
RENAME COLUMN productsku TO product_sku;

ALTER TABLE all_sessions 
RENAME COLUMN v2productname TO v2_product_name;

ALTER TABLE all_sessions 
RENAME COLUMN productvariant TO product_variant;

ALTER TABLE all_sessions 
RENAME COLUMN currencycode TO currency_code;

ALTER TABLE all_sessions 
RENAME COLUMN itemquantity TO item_quantity;

ALTER TABLE all_sessions 
RENAME COLUMN itemrevenue TO item_revenue;

ALTER TABLE all_sessions 
RENAME COLUMN transactionrevenue TO transaction_revenue;

ALTER TABLE all_sessions 
RENAME COLUMN transactionid TO transaction_id;

ALTER TABLE all_sessions 
RENAME COLUMN pagetitle TO page_title;

ALTER TABLE all_sessions 
RENAME COLUMN searchkeyword TO search_keyword;

ALTER TABLE all_sessions 
RENAME COLUMN v2productcategory TO v2_product_category;

ALTER TABLE all_sessions 
RENAME COLUMN pagepathlevel1 TO page_path_level1;

ALTER TABLE all_sessions 
RENAME COLUMN ecommerceaction_type TO ecommerce_action_type;

ALTER TABLE all_sessions 
RENAME COLUMN ecommerceaction_step TO ecommerce_action_step;

ALTER TABLE all_sessions 
RENAME COLUMN ecommerceaction_option TO ecommerce_action_option;


-- In the following, I'm inspecting distinct entries under some fields to check whether the same information is depicted with different spellings or caps.
SELECT DISTINCT channel_grouping
FROM all_sessions;

SELECT DISTINCT country
FROM all_sessions;

SELECT DISTINCT city
FROM all_sessions;

ALTER TABLE all_sessions 
RENAME COLUMN time_on_site TO time_on_site_minutes;

ALTER TABLE all_sessions
ALTER COLUMN date SET DATA TYPE DATE USING TO_DATE(date::text, 'YYYYMMDD');

SELECT DISTINCT type
FROM all_sessions;

UPDATE all_sessions
SET product_price = product_price / 1000000;

UPDATE all_sessions
SET total_transaction_revenue = total_transaction_revenue / 1000000;
*/

/* analytics
ALTER TABLE analytics 
RENAME COLUMN visitnumber TO visit_number;

ALTER TABLE analytics 
RENAME COLUMN visitid TO visit_id;

ALTER TABLE analytics 
RENAME COLUMN visitstarttime TO visit_start_time;

ALTER TABLE analytics 
RENAME COLUMN fullvisitorid TO full_visitor_id;

ALTER TABLE analytics 
RENAME COLUMN userid TO user_id;

ALTER TABLE analytics 
RENAME COLUMN channelgrouping TO channel_grouping;

ALTER TABLE analytics 
RENAME COLUMN socialengagementtype TO social_engagement_type;

ALTER TABLE analytics 
RENAME COLUMN pageviews TO page_views;

ALTER TABLE analytics 
RENAME COLUMN timeonsite TO time_on_site;

ALTER TABLE analytics
ALTER COLUMN date SET DATA TYPE DATE USING TO_DATE(date::text, 'YYYYMMDD');

UPDATE analytics
SET unit_price = unit_price / 1000000;

ALTER TABLE analytics 
RENAME COLUMN time_on_site TO time_on_site_minutes;
*/









































