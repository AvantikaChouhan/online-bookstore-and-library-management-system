-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 1 - Medallion Schema Design
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Create Bronze, Silver and Gold Layer Schema
-- Date     : 08-07-2026
-- ==========================================================

USE cityreads;

-- ==========================================================
-- Pipeline Metadata Table
-- Stores watermark for incremental Bronze loading
-- ==========================================================

DROP TABLE IF EXISTS pipeline_metadata;

CREATE TABLE pipeline_metadata (
    table_name     VARCHAR(100) PRIMARY KEY,
    last_loaded_at DATETIME NOT NULL DEFAULT '2000-01-01',
    rows_loaded    INT DEFAULT 0,
    status         VARCHAR(20) DEFAULT 'PENDING'
);

INSERT INTO pipeline_metadata (table_name)
VALUES
('bronze_books'),
('bronze_customers'),
('bronze_orders'),
('bronze_loans'),
('bronze_reviews');

DROP TABLE IF EXISTS bronze_books;

CREATE TABLE bronze_books (
    book_id INT,
    title VARCHAR(255),
    author VARCHAR(150),
    genre VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    published_on DATE,

    ingested_at DATETIME,
    batch_id    VARCHAR(50)
);

DROP TABLE IF EXISTS bronze_customers;

CREATE TABLE bronze_customers (
    customer_id INT,
    name VARCHAR(150),
    email VARCHAR(255),
    city VARCHAR(100),
    joined_on DATE,
    membership VARCHAR(50),

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS bronze_orders;

CREATE TABLE bronze_orders (
    order_id INT,
    customer_id INT,
    book_id INT,
    order_date DATE,
    quantity INT,
    status VARCHAR(50),

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS bronze_loans;

CREATE TABLE bronze_loans (
    loan_id INT,
    customer_id INT,
    book_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE,

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS bronze_reviews;

CREATE TABLE bronze_reviews (
    review_id INT,
    customer_id INT,
    book_id INT,
    rating INT,
    review_text TEXT,
    created_at DATETIME,

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS silver_books;

CREATE TABLE silver_books (
    book_id INT,
    title VARCHAR(255),
    author VARCHAR(150),
    genre VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    published_on DATE,
    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS silver_customers;

CREATE TABLE silver_customers (
    customer_id INT,
    name VARCHAR(150),
    email VARCHAR(255),
    city VARCHAR(100),
    joined_on DATE,
    membership VARCHAR(50),
    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS silver_orders;

CREATE TABLE silver_orders (
    order_id INT,
    customer_id INT,
    book_id INT,
    order_date DATE,
    quantity INT,
    status VARCHAR(50),

    order_value DECIMAL(10,2),

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS silver_loans;

CREATE TABLE silver_loans (
    loan_id INT,
    customer_id INT,
    book_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE,

    days_overdue INT,
    overdue_category VARCHAR(20),

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS silver_reviews;

CREATE TABLE silver_reviews (
    review_id INT,
    customer_id INT,
    book_id INT,
    rating INT,
    review_text TEXT,
    created_at DATETIME,

    ingested_at DATETIME,
    batch_id VARCHAR(50)
);

DROP TABLE IF EXISTS silver_rejected_rows;

CREATE TABLE silver_rejected_rows (
    table_name VARCHAR(100),
    source_id INT,
    rejection_reason VARCHAR(255),
    rejected_at DATETIME
);

-- ==========================================================
-- Gold Layer View Stubs
-- (Will be implemented in Task 4)
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_revenue_growth;
CREATE VIEW gold_kpi_revenue_growth AS
SELECT
NULL AS kpi_value,
NULL AS kpi_target,
NULL AS status,
NOW() AS calculated_at;

DROP VIEW IF EXISTS gold_kpi_retention_rate;
CREATE VIEW gold_kpi_retention_rate AS
SELECT
NULL AS kpi_value,
NULL AS kpi_target,
NULL AS status,
NOW() AS calculated_at;

DROP VIEW IF EXISTS gold_kpi_sell_through;
CREATE VIEW gold_kpi_sell_through AS
SELECT
NULL AS kpi_value,
NULL AS kpi_target,
NULL AS status,
NOW() AS calculated_at;

DROP VIEW IF EXISTS gold_kpi_return_compliance;
CREATE VIEW gold_kpi_return_compliance AS
SELECT
NULL AS kpi_value,
NULL AS kpi_target,
NULL AS status,
NOW() AS calculated_at;

DROP VIEW IF EXISTS gold_kpi_review_coverage;
CREATE VIEW gold_kpi_review_coverage AS
SELECT
NULL AS kpi_value,
NULL AS kpi_target,
NULL AS status,
NOW() AS calculated_at;

DROP VIEW IF EXISTS gold_top_books;

CREATE VIEW gold_top_books AS
SELECT
NULL AS book_id,
NULL AS title,
NULL AS total_revenue;

DROP VIEW IF EXISTS gold_customer_segments;

CREATE VIEW gold_customer_segments AS
SELECT
NULL AS customer_id,
NULL AS customer_name,
NULL AS segment;

-- ==========================================================
-- Indexes
-- ==========================================================

CREATE INDEX idx_silver_orders_order_date
ON silver_orders(order_date);

CREATE INDEX idx_silver_orders_customer
ON silver_orders(customer_id);

CREATE INDEX idx_silver_orders_book
ON silver_orders(book_id);

CREATE INDEX idx_silver_loans_loan_date
ON silver_loans(loan_date);

CREATE INDEX idx_silver_loans_customer
ON silver_loans(customer_id);

CREATE INDEX idx_silver_loans_book
ON silver_loans(book_id);

CREATE INDEX idx_silver_reviews_created_at
ON silver_reviews(created_at);

CREATE INDEX idx_silver_reviews_customer
ON silver_reviews(customer_id);

CREATE INDEX idx_silver_reviews_book
ON silver_reviews(book_id);

CREATE INDEX idx_silver_books_published_on
ON silver_books(published_on);

CREATE INDEX idx_silver_customers_joined_on
ON silver_customers(joined_on);