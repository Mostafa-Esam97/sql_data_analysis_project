/*
===============================================================================
Purpose: Product Analytical View
===============================================================================

Description:
Creates a reusable product-level reporting view.
Includes:
- Product hierarchy
- Performance segmentation
- Revenue metrics
- Recency and lifecycle KPIs

Designed for dashboard integration.
===============================================================================
*/

CREATE OR ALTER VIEW gold.product_report AS

WITH base_query AS (
    SELECT
        s.order_number,
        s.order_date,
        s.customer_key,
        s.sales_amount,
        s.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    WHERE order_date IS NOT NULL
),

product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS life_span,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity
    FROM base_query
    GROUP BY 
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

SELECT
    *,
    DATEDIFF(MONTH,last_order_date, GETDATE()) AS recency,
    CASE 
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment
FROM product_aggregation;
