/*
===============================================================================
Purpose: Database & Schema Exploration
===============================================================================

Description:
This script explores the database structure and core dimensions.
It helps understand:
- Available tables
- Column structures
- Customer geography
- Product hierarchy (Category & Subcategory)

This is the first step in any analytical workflow.
===============================================================================
*/

-- Explore all tables in the database
SELECT * 
FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in dim_customers table
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

-- Explore all countries our customers come from
SELECT DISTINCT country 
FROM gold.dim_customers;

-- Explore product categories and subcategories
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name
FROM gold.dim_products;
