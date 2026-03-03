/*
===============================================================================
Purpose: Customer Analytical View
===============================================================================

Description:
Creates a reusable analytical view for customer-level reporting.
Includes:
- Demographics
- Segmentation
- Purchase behavior
- Key KPIs (Recency, AOV, Monthly Spend)

This view is ready for BI tools (Power BI / Tableau).
===============================================================================
*/

CREATE OR ALTER VIEW gold.customer_report AS

WITH base_query AS (
    SELECT
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        DATEDIFF(YEAR,c.birth_date, GETDATE()) AS customer_age
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = s.customer_key
    WHERE s.order_date IS NOT NULL
),

customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        customer_age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS life_span
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        customer_age
)

SELECT
    *,
    DATEDIFF(MONTH,last_order_date, GETDATE()) AS recency,
    CASE 
        WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN life_span >= 12 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment
FROM customer_aggregation;
