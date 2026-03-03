/*
===============================================================================
Purpose: Category Contribution & Segmentation Analysis
===============================================================================

Description:
This script focuses on segmentation logic:
- Category contribution to total revenue
- Product cost segmentation
- Customer spending segmentation

This helps classify business entities into meaningful groups.
===============================================================================
*/

-- Category Contribution to Overall Sales
WITH category_sales AS (
    SELECT
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2
        ), '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


-- Product Cost Segmentation
WITH product_segment AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(*) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;


-- Customer Spending Segmentation
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(s.sales_amount) AS total_spending,
        DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS life_span
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = s.customer_key
    GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        total_spending,
        life_span,
        CASE 
            WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN life_span >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
