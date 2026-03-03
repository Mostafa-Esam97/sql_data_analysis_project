/*
===============================================================================
Purpose: Executive Business Overview KPIs
===============================================================================

Description:
This script calculates high-level business metrics such as:
- Sales performance
- Order activity
- Customer statistics
- Product counts
- Date ranges

These KPIs provide a quick snapshot of overall business health.
===============================================================================
*/

-- Find the date of the first and last order
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS range_order_years,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS range_order_months
FROM gold.fact_sales;

-- Find the youngest and oldest customers
SELECT 
    MAX(birth_date) AS youngest_birth_date,
    DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS youngest_customer_age,
    MIN(birth_date) AS oldest_birth_date,
    DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_customer_age
FROM gold.dim_customers;

-- Total Sales
SELECT SUM(sales_amount) AS total_sales 
FROM gold.fact_sales;

-- Total Quantity Sold
SELECT SUM(quantity) AS total_quantity 
FROM gold.fact_sales;

-- Average Selling Price
SELECT AVG(price) AS avg_price 
FROM gold.fact_sales;

-- Total Number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales;

-- Total Number of Products
SELECT COUNT(DISTINCT product_key) AS total_products 
FROM gold.dim_products;

-- Total Number of Customers
SELECT COUNT(DISTINCT customer_key) AS total_customers 
FROM gold.dim_customers;

-- Total Customers Who Placed Orders
SELECT COUNT(DISTINCT customer_key) AS total_active_customers 
FROM gold.fact_sales;

-- Consolidated KPI Report
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL 
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL 
SELECT 'Total Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers;
