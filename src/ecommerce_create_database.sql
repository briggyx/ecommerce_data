-- First, I will create a database and blank tables, the latter of which will have matching field names and data types as the flat-files.
-- Later, I will clean up and normalize the tables. 

/* 

CREATE DATABASE ecommerce; 
 
CREATE TABLE sales_by_sku (
	productSKU VARCHAR(16) NOT NULL,
	total_ordered SMALLINT
);

CREATE TABLE sales_report (
	productSKU VARCHAR(16) NOT NULL,
	total_ordered SMALLINT,
	name VARCHAR(60),
	stockLevel SMALLINT,
	restockingLeadTime SMALLINT,
	sentimentScore FLOAT,
	sentimentMagnitude FLOAT,
	raio FLOAT
);

CREATE TABLE products (
	SKU VARCHAR(16) NOT NULL,
	name VARCHAR(70),
	orderedQuantity SMALLINT,
	stockLevel SMALLINT,
	restockingLeadTime SMALLINT,
	sentimentScore FLOAT,
	sentimentMagnitude FLOAT
);

CREATE TABLE all_sessions (
	fullVisitorId BIGINT NOT NULL,
	channelGrouping VARCHAR(25),
	time INT,
	country VARCHAR(30),
	city VARCHAR(50),
	totalTransactionRevenue INT, 
	transactions SMALLINT,
	timeOnSite SMALLINT, 
	pageviews SMALLINT,
	sessionQualityDim SMALLINT,
	date INT,
	visitId INT,
	type VARCHAR(10),
	productRefundAmount SMALLINT, 
	productQuantity SMALLINT,
	productPrice INT,
	productRevenue INT,
	productSKU VARCHAR(20),
	v2ProductName VARCHAR(60),
	v2ProductCategory VARCHAR(30),
	productVariant VARCHAR(30),
	currencyCode VARCHAR(10),
	itemQuantity SMALLINT,
	itemRevenue SMALLINT,
	transactionRevenue INT,
	transactionId VARCHAR(20),
	pageTitle VARCHAR(50),
	searchKeyword VARCHAR(30),
	pagePathLevel1 VARCHAR(30),
	eCommerceAction_type SMALLINT,
	eCommerceAction_step SMALLINT,
	eCommerceAction_option VARCHAR(20)
);
	
CREATE TABLE analytics (
	visitNumber SMALLINT,
	visitId INT, 
	visitStartTime INT, 
	date INT, 
	fullvisitorId BIGINT, 
	userid VARCHAR(30),
	channelGrouping VARCHAR(30),
	socialEngagementType VARCHAR(30),
	units_sold SMALLINT, 
	pageviews SMALLINT, 
	timeonsite SMALLINT, 
	bounces SMALLINT,
	revenue INT, 
	unit_price INT
);		

-- Now, I will use the PSQL tool to input data from the flat-tiles into the tables that I just made.
-- Note that, the PSQL tool doesn't support relative paths and it won't go into zipped files, so that files inside a zipped folder need to be copied and pasted somewhere outside it temporarily.
\COPY sales_by_sku(productSKU, total_ordered) FROM 'C:\Users\brigi\OneDrive\Desktop\ecommerce_data\data\sales_by_sku.csv' DELIMITER ',' CSV HEADER;

\COPY sales_report(productSKU, total_ordered, name, stockLevel, restockingLeadTime, sentimentScore, sentimentMagnitude, ratio) FROM 'C:\Users\brigi\OneDrive\Desktop\ecommerce_data\data\sales_report.csv' DELIMITER ',' CSV HEADER;
	
\COPY products (SKU, name, orderedQuantity, stockLevel, restockingLeadTime, sentimentScore, sentimentMagnitude) FROM 'C:\Users\brigi\OneDrive\Desktop\ecommerce_data\data\products.csv' DELIMITER ',' CSV HEADER;	

-- I needed to alter some columns in all_sessions in order to make room for longer descriptions and extremely large numbers.
ALTER TABLE all_sessions 
ALTER COLUMN v2productcategory TYPE VARCHAR(60);

ALTER TABLE all_sessions 
ALTER COLUMN pageTitle TYPE VARCHAR(80);

ALTER TABLE all_sessions 
ALTER COLUMN fullvisitorid TYPE VARCHAR(35);

ALTER TABLE all_sessions
ALTER COLUMN pagetitle TYPE VARCHAR(600);

-- I had to clear the cell in column pageTitle rows 3509, 5350 in the flat-file because it wasn't UTF8 and couldn't be loaded by PSQL 
\COPY all_sessions (fullVisitorId, channelGrouping, time, country, city, totalTransactionRevenue, transactions, timeOnSite, pageviews, sessionQualityDim, date, visitId, type, productRefundAmount, productQuantity, productPrice, productRevenue, productSKU, v2ProductName, v2ProductCategory, productVariant, currencyCode, itemQuantity, itemRevenue, transactionRevenue, transactionId, pageTitle, searchKeyword, pagePathLevel1, eCommerceAction_type, eCommerceAction_step, eCommerceAction_option) FROM 'C:\Users\brigi\OneDrive\Desktop\ecommerce_data\data\all_sessions.csv' DELIMITER ',' CSV HEADER;

-- I needed to alter some columns in analytics in order to make room for longer descriptions and extremely large numbers.
ALTER TABLE analytics 
ALTER COLUMN fullvisitorid TYPE VARCHAR(35);

ALTER TABLE analytics 
ALTER COLUMN revenue TYPE BIGINT;

\COPY analytics (visitNumber, visitId, visitStartTime, date, fullvisitorId, userid, channelGrouping, socialEngagementType, units_sold, pageviews, timeonsite, bounces, revenue, unit_price) FROM 'C:\Users\brigi\OneDrive\Desktop\ecommerce_data\data\analytics.csv' DELIMITER ',' CSV HEADER;

-- Correct wrongly typed-out field names. 
ALTER TABLE sales_report
RENAME COLUMN raio TO ratio;


-- After populating the five tables with the flat-files, I will now validate that the new tables contain accurate information.
-- I will do this by viewing each table, and visualling inspecting that there are the correct number of rows, field names and data types. 
-- It appears that capital letters in field names during the creation of the tables aren't applied.
SELECT *
FROM sales_by_sku;

SELECT *
FROM sales_report;

SELECT *
FROM products;

SELECT *
FROM all_sessions;

SELECT *
FROM analytics;

*/
