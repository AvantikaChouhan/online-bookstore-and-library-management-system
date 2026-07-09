-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 2 - Bronze Incremental Load
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Incremental Bronze Loading using Watermark Pattern
-- Date     : 09-07-2026
-- ==========================================================

USE cityreads;
-- ==========================================================
-- Bronze Load : Books
-- ==========================================================

-- Step 1 : Read watermark

SET @last_load =
(
SELECT last_loaded_at
FROM pipeline_metadata
WHERE table_name = 'bronze_books'
);

-- Step 2 : Begin Transaction

START TRANSACTION;

INSERT INTO bronze_books
(
book_id,
title,
author,
genre,
price,
stock,
published_on,
ingested_at,
batch_id
)

SELECT
book_id,
title,
author,
genre,
price,
stock,
published_on,
NOW(),
CONCAT('BATCH_', DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s'))

FROM books

WHERE published_on > DATE(@last_load);

UPDATE pipeline_metadata
SET
last_loaded_at = NOW(),
rows_loaded = ROW_COUNT(),
status = 'SUCCESS'
WHERE table_name='bronze_books';

COMMIT;
-- ==========================================================
-- Bronze Load : Customers
-- ==========================================================

-- Step 1 : Read watermark

SET @last_load =
(
SELECT last_loaded_at
FROM pipeline_metadata
WHERE table_name = 'bronze_customers'
);

-- Step 2 : Begin Transaction

START TRANSACTION;

INSERT INTO bronze_customers
(
    customer_id,
    name,
    email,
    city,
    joined_on,
    membership,
    ingested_at,
    batch_id
)

SELECT
    customer_id,
    name,
    email,
    city,
    joined_on,
    membership,
    NOW(),
    CONCAT('BATCH_', DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s'))

FROM customers

WHERE joined_on > DATE(@last_load);

UPDATE pipeline_metadata
SET
    last_loaded_at = NOW(),
    rows_loaded = ROW_COUNT(),
    status = 'SUCCESS'
WHERE table_name = 'bronze_customers';

COMMIT;
-- ==========================================================
-- Bronze Load : Orders
-- ==========================================================

-- Step 1 : Read watermark

SET @last_load =
(
SELECT last_loaded_at
FROM pipeline_metadata
WHERE table_name = 'bronze_orders'
);

-- Step 2 : Begin Transaction

START TRANSACTION;

INSERT INTO bronze_orders
(
    order_id,
    customer_id,
    book_id,
    order_date,
    quantity,
    status,
    ingested_at,
    batch_id
)

SELECT
    order_id,
    customer_id,
    book_id,
    order_date,
    quantity,
    status,
    NOW(),
    CONCAT('BATCH_', DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s'))

FROM orders

WHERE order_date > DATE(@last_load);

UPDATE pipeline_metadata
SET
    last_loaded_at = NOW(),
    rows_loaded = ROW_COUNT(),
    status = 'SUCCESS'
WHERE table_name = 'bronze_orders';

COMMIT;
-- ==========================================================
-- Bronze Load : Loans
-- ==========================================================

-- Step 1 : Read watermark

SET @last_load =
(
SELECT last_loaded_at
FROM pipeline_metadata
WHERE table_name = 'bronze_loans'
);

-- Step 2 : Begin Transaction

START TRANSACTION;

INSERT INTO bronze_loans
(
    loan_id,
    customer_id,
    book_id,
    loan_date,
    due_date,
    return_date,
    ingested_at,
    batch_id
)

SELECT
    loan_id,
    customer_id,
    book_id,
    loan_date,
    due_date,
    return_date,
    NOW(),
    CONCAT('BATCH_', DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s'))

FROM loans

WHERE loan_date > DATE(@last_load);

UPDATE pipeline_metadata
SET
    last_loaded_at = NOW(),
    rows_loaded = ROW_COUNT(),
    status = 'SUCCESS'
WHERE table_name = 'bronze_loans';

COMMIT;
-- ==========================================================
-- Bronze Load : Reviews
-- ==========================================================

-- Step 1 : Read watermark

SET @last_load =
(
SELECT last_loaded_at
FROM pipeline_metadata
WHERE table_name = 'bronze_reviews'
);

-- Step 2 : Begin Transaction

START TRANSACTION;

INSERT INTO bronze_reviews
(
    review_id,
    customer_id,
    book_id,
    rating,
    review_text,
    created_at,
    ingested_at,
    batch_id
)

SELECT
    review_id,
    customer_id,
    book_id,
    rating,
    review_text,
    created_at,
    NOW(),
    CONCAT('BATCH_', DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s'))

FROM reviews

WHERE created_at > @last_load;

UPDATE pipeline_metadata
SET
    last_loaded_at = NOW(),
    rows_loaded = ROW_COUNT(),
    status = 'SUCCESS'
WHERE table_name = 'bronze_reviews';

COMMIT;