-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 4 Validation
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Validate Gold Layer KPI Views
-- Date     : 10-07-2026
-- ==========================================================

USE cityreads;

-- ==========================================================
-- Original KPI Validation
-- ==========================================================

SELECT * FROM gold_kpi_revenue_growth;

SELECT * FROM gold_kpi_retention_rate;

SELECT * FROM gold_kpi_sell_through;

SELECT * FROM gold_kpi_return_compliance;

SELECT * FROM gold_kpi_review_coverage;

-- ==========================================================
-- Top Books Validation
-- ==========================================================

SELECT *
FROM gold_top_books;

-- ==========================================================
-- Top Books Per Genre Validation
-- ==========================================================

SELECT
    genre,
    COUNT(*) AS books_per_genre
FROM gold_top_books
GROUP BY genre;

-- ==========================================================
-- Customer Segments Validation
-- ==========================================================

SELECT *
FROM gold_customer_segments
LIMIT 20;

-- ==========================================================
-- Segment Distribution
-- ==========================================================

SELECT
    segment,
    COUNT(*) AS total_customers
FROM gold_customer_segments
GROUP BY segment;

-- ==========================================================
-- Top Books Count
-- ==========================================================

SELECT COUNT(*) AS total_top_books
FROM gold_top_books;
-- ==========================================================
-- ==========================================================
-- ADDITIONAL BUSINESS ENHANCEMENTS VALIDATION
-- ==========================================================
-- The following validations correspond to the
-- self-implemented KPIs and analytical Gold Views.
-- ==========================================================

-- ==========================================================
-- Additional KPI 6 : Average Order Value
-- ==========================================================

SELECT *
FROM gold_kpi_average_order_value;

-- ==========================================================
-- Additional KPI 7 : Delivery Success Rate
-- ==========================================================

SELECT *
FROM gold_kpi_delivery_success;

-- ==========================================================
-- Additional KPI 8 : Average Customer Rating
-- ==========================================================

SELECT *
FROM gold_kpi_average_rating;

-- ==========================================================
-- Top Customers Validation
-- ==========================================================

SELECT *
FROM gold_top_customers
LIMIT 10;

-- ==========================================================
-- Genre Performance Validation
-- ==========================================================

SELECT *
FROM gold_genre_performance;

-- ==========================================================
-- Revenue Share Validation

-- ==========================================================

SELECT
    ROUND(SUM(revenue_share_pct),2) AS total_revenue_share
FROM gold_genre_performance;

-- ==========================================================
-- Genre Count Validation
-- ==========================================================

SELECT
    COUNT(*) AS total_genres
FROM gold_genre_performance;

-- ==========================================================
-- NOTE:
-- Additional KPIs and Gold Views were implemented
-- beyond the assignment requirements to demonstrate
-- business analytics and executive dashboard capabilities.
-- ==========================================================

-- ==========================================================
-- End of Task 4 Validation
-- Original Deliverables Validated
-- Additional Business Enhancements Validated
-- ==========================================================