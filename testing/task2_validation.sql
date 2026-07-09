-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 2 Validation
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Validate Bronze Incremental Load
-- Date     : 09-07-2026
-- ==========================================================

USE cityreads;

-- ==========================================================
-- Source vs Bronze Row Count Validation
-- ==========================================================

SELECT COUNT(*) AS source_books FROM books;
SELECT COUNT(*) AS bronze_books FROM bronze_books;

SELECT COUNT(*) AS source_customers FROM customers;
SELECT COUNT(*) AS bronze_customers FROM bronze_customers;

SELECT COUNT(*) AS source_orders FROM orders;
SELECT COUNT(*) AS bronze_orders FROM bronze_orders;

SELECT COUNT(*) AS source_loans FROM loans;
SELECT COUNT(*) AS bronze_loans FROM bronze_loans;

SELECT COUNT(*) AS source_reviews FROM reviews;
SELECT COUNT(*) AS bronze_reviews FROM bronze_reviews;

-- ==========================================================
-- Pipeline Metadata Validation
-- ==========================================================

SELECT *
FROM pipeline_metadata;

-- ==========================================================
-- Batch ID Validation
-- ==========================================================

SELECT DISTINCT batch_id
FROM bronze_books;

SELECT DISTINCT batch_id
FROM bronze_customers;

SELECT DISTINCT batch_id
FROM bronze_orders;

SELECT DISTINCT batch_id
FROM bronze_loans;

SELECT DISTINCT batch_id
FROM bronze_reviews;

-- ==========================================================
-- Ingestion Timestamp Validation
-- ==========================================================

SELECT MIN(ingested_at) AS first_load,
       MAX(ingested_at) AS last_load
FROM bronze_books;

SELECT MIN(ingested_at) AS first_load,
       MAX(ingested_at) AS last_load
FROM bronze_orders;