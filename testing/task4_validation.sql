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
-- KPI Validation
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