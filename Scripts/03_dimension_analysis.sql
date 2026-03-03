/*
===============================================================================
Purpose: Customer & Product Dimensional Analysis
===============================================================================

Description:
This script analyzes business dimensions such as:
- Customer demographics
- Geographic distribution
- Product categories
- Revenue by category and customer

This helps identify patterns across different business dimensions.
===============================================================================
*/

-- Total Customers by Country
SELECT 
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total Customers by Gender
SELECT 
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total Products by Category
SELECT 
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average Cost per Category
SELECT 
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Total Revenue per Category
SELECT
    p.category,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Total Revenue per Customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;
