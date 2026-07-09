-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 3 Validation
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Validate Silver Transformation
-- Date     : 10-07-2026
-- ==========================================================

USE cityreads;
-- ==========================================================
-- Silver Table Row Counts
-- ==========================================================

SELECT COUNT(*) AS silver_books
FROM silver_books;

SELECT COUNT(*) AS silver_customers
FROM silver_customers;

SELECT COUNT(*) AS silver_orders
FROM silver_orders;

SELECT COUNT(*) AS silver_loans
FROM silver_loans;

SELECT COUNT(*) AS silver_reviews
FROM silver_reviews;

-- ==========================================================
-- Rejected Rows Summary
-- ==========================================================

SELECT
table_name,
COUNT(*) AS rejected_rows
FROM silver_rejected_rows
GROUP BY table_name;

-- ==========================================================
-- Order Value Validation
-- ==========================================================

SELECT
order_id,
quantity,
order_value
FROM silver_orders
LIMIT 10;

-- ==========================================================
-- Loan Enrichment Validation
-- ==========================================================

SELECT
loan_id,
loan_date,
due_date,
return_date,
days_overdue,
overdue_category
FROM silver_loans
LIMIT 10;

-- ==========================================================
-- Status Standardization Validation
-- ==========================================================

SELECT DISTINCT status
FROM silver_orders;

-- ==========================================================
-- Membership Standardization Validation
-- ==========================================================

SELECT DISTINCT membership
FROM silver_customers;

-- ==========================================================
-- Rating Validation
-- ==========================================================

SELECT
MIN(rating) AS min_rating,
MAX(rating) AS max_rating
FROM silver_reviews;
-- ==========================================================
-- Duplicate Check
-- Expected Result: No rows returned
-- ==========================================================
SELECT book_id, COUNT(*)
FROM silver_books
GROUP BY book_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*)
FROM silver_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM silver_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT loan_id, COUNT(*)
FROM silver_loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

SELECT review_id, COUNT(*)
FROM silver_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;