/*
===============================================================================
Purpose: Performance & Ranking Analysis
===============================================================================

Description:
This script focuses on performance evaluation:
- Revenue distribution by country
- Top performing products
- Worst performing products
- Ranking using ROW_NUMBER()

This helps identify high-value and underperforming products.
===============================================================================
*/

-- Distribution of sold items across countries
SELECT
    c.country,
    SUM(s.quantity) AS total_quantity_sold
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY c.country
ORDER BY total_quantity_sold DESC;

-- Top 5 Products by Revenue (Simple Method)
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Top 5 Products by Revenue (Using ROW_NUMBER)
SELECT *
FROM 
(
    SELECT 
        p.product_name,
        SUM(s.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS revenue_rank
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.product_name
) ranked_products
WHERE revenue_rank <= 5;

-- Worst 5 Performing Products
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;
