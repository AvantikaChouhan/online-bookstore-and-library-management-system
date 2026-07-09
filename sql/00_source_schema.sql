-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Author   : Avantika Chouhan
-- Database : cityreads
-- File     : 00_source_schema.sql
-- Purpose  : Create Source (OLTP) Tables
-- Date     : 08-07-2026
-- ==========================================================

DROP DATABASE IF EXISTS cityreads;
CREATE DATABASE cityreads;
USE cityreads;

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(150),
    genre VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    published_on DATE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(150),
    email VARCHAR(255),
    city VARCHAR(100),
    joined_on DATE,
    membership VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    book_id INT,
    order_date DATE,
    quantity INT,
    status VARCHAR(50),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_book
        FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    book_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE,

    CONSTRAINT fk_loans_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),

    CONSTRAINT fk_loans_book
        FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    customer_id INT,
    book_id INT,
    rating INT,
    review_text TEXT,
    created_at DATETIME,

    CONSTRAINT fk_reviews_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),

    CONSTRAINT fk_reviews_book
        FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- ==========================================================
-- End of Source Schema
-- ==========================================================