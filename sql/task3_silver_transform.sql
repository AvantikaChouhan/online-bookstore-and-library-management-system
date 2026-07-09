-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 3 - Silver Transformation
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Clean, Validate and Enrich Bronze Data
-- Date     : 09-07-2026
-- ==========================================================

USE cityreads;

TRUNCATE TABLE silver_rejected_rows;

-- ==========================================================
-- Silver Load : Books
-- ==========================================================

TRUNCATE TABLE silver_books;

INSERT INTO silver_books
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
    TRIM(title),
    TRIM(author),
    TRIM(genre),
    price,
    stock,
    published_on,
    ingested_at,
    batch_id

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY book_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_books
) b

WHERE rn = 1;
-- ==========================================================
-- Silver Load : Customers
-- ==========================================================

TRUNCATE TABLE silver_customers;

-- Reject Invalid Rows

INSERT INTO silver_rejected_rows
(
    table_name,
    source_id,
    rejection_reason,
    rejected_at
)

SELECT
    'bronze_customers',
    customer_id,
    CASE
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Email is NULL'
        WHEN UPPER(TRIM(membership)) NOT IN ('BASIC','PREMIUM','LIBRARY')
             THEN 'Invalid Membership'
    END,
    NOW()

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_customers
) c

WHERE rn = 1
AND
(
    email IS NULL
    OR TRIM(email) = ''
    OR UPPER(TRIM(membership)) NOT IN ('BASIC','PREMIUM','LIBRARY')
);

-- Load Valid Rows

INSERT INTO silver_customers
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
    TRIM(name),
    TRIM(email),
    TRIM(city),
    joined_on,
    UPPER(TRIM(membership)),
    ingested_at,
    batch_id

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_customers
) c

WHERE rn = 1
AND email IS NOT NULL
AND TRIM(email) <> ''
AND UPPER(TRIM(membership)) IN ('BASIC','PREMIUM','LIBRARY');
-- ==========================================================
-- Silver Load : Orders
-- ==========================================================

TRUNCATE TABLE silver_orders;

-- Reject Invalid Rows

INSERT INTO silver_rejected_rows
(
    table_name,
    source_id,
    rejection_reason,
    rejected_at
)

SELECT
    'bronze_orders',
    order_id,
    CASE
        WHEN quantity <= 0 THEN 'Invalid Quantity'
        WHEN UPPER(TRIM(status)) NOT IN
             ('PENDING','SHIPPED','DELIVERED','CANCELLED')
             THEN 'Invalid Status'
    END,
    NOW()

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY order_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_orders
) o

WHERE rn = 1
AND
(
    quantity <= 0
    OR
    UPPER(TRIM(status)) NOT IN
    ('PENDING','SHIPPED','DELIVERED','CANCELLED')
);

-- Load Valid Rows

INSERT INTO silver_orders
(
    order_id,
    customer_id,
    book_id,
    order_date,
    quantity,
    status,
    order_value,
    ingested_at,
    batch_id
)

SELECT
    o.order_id,
    o.customer_id,
    o.book_id,
    o.order_date,
    o.quantity,
    UPPER(TRIM(o.status)),
    o.quantity * b.price AS order_value,
    o.ingested_at,
    o.batch_id

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY order_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_orders
) o

JOIN silver_books b
ON o.book_id = b.book_id

WHERE o.rn = 1
AND o.quantity > 0
AND UPPER(TRIM(o.status)) IN
('PENDING','SHIPPED','DELIVERED','CANCELLED');
-- ==========================================================
-- Silver Load : Loans
-- ==========================================================

TRUNCATE TABLE silver_loans;

-- Reject Invalid Rows

INSERT INTO silver_rejected_rows
(
    table_name,
    source_id,
    rejection_reason,
    rejected_at
)

SELECT
    'bronze_loans',
    loan_id,
    'Due Date must be greater than Loan Date',
    NOW()

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY loan_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_loans
) l

WHERE rn = 1
AND due_date <= loan_date;

-- Load Valid Rows

INSERT INTO silver_loans
(
    loan_id,
    customer_id,
    book_id,
    loan_date,
    due_date,
    return_date,
    days_overdue,
    overdue_category,
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

    CASE
        WHEN return_date IS NULL
             AND CURDATE() > due_date
             THEN DATEDIFF(CURDATE(), due_date)

        WHEN return_date > due_date
             THEN DATEDIFF(return_date, due_date)

        ELSE 0
    END AS days_overdue,

    CASE
        WHEN
            (
                CASE
                    WHEN return_date IS NULL
                         AND CURDATE() > due_date
                         THEN DATEDIFF(CURDATE(), due_date)
                    WHEN return_date > due_date
                         THEN DATEDIFF(return_date, due_date)
                    ELSE 0
                END
            ) = 0
            THEN 'ON TIME'

        WHEN
            (
                CASE
                    WHEN return_date IS NULL
                         AND CURDATE() > due_date
                         THEN DATEDIFF(CURDATE(), due_date)
                    WHEN return_date > due_date
                         THEN DATEDIFF(return_date, due_date)
                    ELSE 0
                END
            ) <= 7
            THEN 'MILD'

        WHEN
            (
                CASE
                    WHEN return_date IS NULL
                         AND CURDATE() > due_date
                         THEN DATEDIFF(CURDATE(), due_date)
                    WHEN return_date > due_date
                         THEN DATEDIFF(return_date, due_date)
                    ELSE 0
                END
            ) <= 30
            THEN 'SEVERE'

        ELSE 'CRITICAL'
    END AS overdue_category,

    ingested_at,
    batch_id

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY loan_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_loans
) l

WHERE rn = 1
AND due_date > loan_date;
-- ==========================================================
-- Silver Load : Reviews
-- ==========================================================

TRUNCATE TABLE silver_reviews;

-- Reject Invalid Rows

INSERT INTO silver_rejected_rows
(
    table_name,
    source_id,
    rejection_reason,
    rejected_at
)

SELECT
    'bronze_reviews',
    review_id,
    'Rating must be between 1 and 5',
    NOW()

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY review_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_reviews
) r

WHERE rn = 1
AND rating NOT BETWEEN 1 AND 5;

-- Load Valid Rows

INSERT INTO silver_reviews
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
    TRIM(review_text),
    created_at,
    ingested_at,
    batch_id

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY review_id
               ORDER BY ingested_at DESC
           ) AS rn
    FROM bronze_reviews
) r

WHERE rn = 1
AND rating BETWEEN 1 AND 5;
-- ==========================================================
-- Summary : Accepted vs Rejected Rows
-- ==========================================================

SELECT 'books' AS table_name,
       (SELECT COUNT(*) FROM silver_books) AS accepted_rows,
       (SELECT COUNT(*) FROM silver_rejected_rows
         WHERE table_name = 'bronze_books') AS rejected_rows

UNION ALL

SELECT 'customers',
       (SELECT COUNT(*) FROM silver_customers),
       (SELECT COUNT(*) FROM silver_rejected_rows
         WHERE table_name = 'bronze_customers')

UNION ALL

SELECT 'orders',
       (SELECT COUNT(*) FROM silver_orders),
       (SELECT COUNT(*) FROM silver_rejected_rows
         WHERE table_name = 'bronze_orders')

UNION ALL

SELECT 'loans',
       (SELECT COUNT(*) FROM silver_loans),
       (SELECT COUNT(*) FROM silver_rejected_rows
         WHERE table_name = 'bronze_loans')

UNION ALL

SELECT 'reviews',
       (SELECT COUNT(*) FROM silver_reviews),
       (SELECT COUNT(*) FROM silver_rejected_rows
         WHERE table_name = 'bronze_reviews');