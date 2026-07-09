-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 4 - Gold Layer KPI Views
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Build Gold KPI Views for Executive Dashboard
-- Date     : 10-07-2026
-- ==========================================================

USE cityreads;
-- ==========================================================
-- KPI 1 : Monthly Revenue Growth
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_revenue_growth;

CREATE VIEW gold_kpi_revenue_growth AS

WITH monthly_revenue AS
(
    SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS month,
        SUM(order_value) AS revenue
    FROM silver_orders
    WHERE status = 'DELIVERED'
    GROUP BY DATE_FORMAT(order_date,'%Y-%m')
),

growth AS
(
    SELECT
        month,
        revenue,
        ROUND(
            (
                (revenue - LAG(revenue) OVER (ORDER BY month))
                /
                LAG(revenue) OVER (ORDER BY month)
            ) * 100,
            2
        ) AS growth_pct
    FROM monthly_revenue
)

SELECT
MAX(growth_pct) AS kpi_value,
5 AS kpi_target,

CASE
    WHEN MAX(growth_pct) >= 5
    THEN 'PASS'
    ELSE 'FAIL'
END AS status,

NOW() AS calculated_at

FROM growth;

-- ==========================================================
-- KPI 2 : Customer Retention Rate
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_retention_rate;

CREATE VIEW gold_kpi_retention_rate AS

WITH customer_months AS
(
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(order_date,'%Y-%m') AS order_month
    FROM silver_orders
    WHERE status = 'DELIVERED'
),

retained_customers AS
(
    SELECT DISTINCT
        c1.customer_id
    FROM customer_months c1
    JOIN customer_months c2
      ON c1.customer_id = c2.customer_id
     AND TIMESTAMPDIFF
     (
         MONTH,
         STR_TO_DATE(CONCAT(c1.order_month,'-01'),'%Y-%m-%d'),
         STR_TO_DATE(CONCAT(c2.order_month,'-01'),'%Y-%m-%d')
     ) = 1
),

metrics AS
(
    SELECT
        (SELECT COUNT(*) FROM retained_customers) AS retained,
        (SELECT COUNT(DISTINCT customer_id)
         FROM silver_orders
         WHERE status = 'DELIVERED') AS total_customers
)

SELECT
ROUND((retained * 100.0) / total_customers,2) AS kpi_value,
60 AS kpi_target,

CASE
    WHEN ROUND((retained * 100.0) / total_customers,2) >= 60
    THEN 'PASS'
    ELSE 'FAIL'
END AS status,

NOW() AS calculated_at

FROM metrics;
-- ==========================================================
-- KPI 3 : Book Sell-Through Rate
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_sell_through;

CREATE VIEW gold_kpi_sell_through AS

SELECT
ROUND
(
(
COUNT(DISTINCT CASE
                 WHEN status = 'DELIVERED'
                 THEN book_id
               END)
* 100.0
/
(
SELECT COUNT(*)
FROM silver_books
)
),2
) AS kpi_value,

70 AS kpi_target,

CASE
    WHEN ROUND
    (
    (
    COUNT(DISTINCT CASE
                     WHEN status = 'DELIVERED'
                     THEN book_id
                   END)
    * 100.0
    /
    (
    SELECT COUNT(*)
    FROM silver_books
    )
    ),2
    ) >= 70
    THEN 'PASS'
    ELSE 'FAIL'
END AS status,

NOW() AS calculated_at

FROM silver_orders;
-- ==========================================================
-- KPI 4 : Library Return Compliance
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_return_compliance;

CREATE VIEW gold_kpi_return_compliance AS

SELECT
    ROUND(
        SUM(
            CASE
                WHEN return_date IS NOT NULL
                     AND return_date <= due_date
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS kpi_value,

    75 AS kpi_target,

    CASE
        WHEN ROUND(
            SUM(
                CASE
                    WHEN return_date IS NOT NULL
                         AND return_date <= due_date
                    THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) >= 75
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM silver_loans;
-- ==========================================================
-- KPI 5 : Review Coverage Rate
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_review_coverage;

CREATE VIEW gold_kpi_review_coverage AS

SELECT
    ROUND(
        (
            COUNT(DISTINCT r.review_id) * 100.0
            /
            COUNT(DISTINCT o.order_id)
        ),
        2
    ) AS kpi_value,

    40 AS kpi_target,

    CASE
        WHEN ROUND(
            (
                COUNT(DISTINCT r.review_id) * 100.0
                /
                COUNT(DISTINCT o.order_id)
            ),
            2
        ) >= 40
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM silver_orders o

LEFT JOIN silver_reviews r
       ON o.customer_id = r.customer_id
      AND o.book_id = r.book_id

WHERE o.status = 'DELIVERED';
-- ==========================================================
-- Gold View : Top 10 Books
-- ==========================================================

DROP VIEW IF EXISTS gold_top_books;

CREATE VIEW gold_top_books AS

WITH review_stats AS
(
    SELECT
        book_id,
        ROUND(AVG(rating),2) AS average_rating
    FROM silver_reviews
    GROUP BY book_id
),

book_sales AS
(
    SELECT
        b.genre,
        b.book_id,
        b.title,

        SUM(o.quantity) AS total_units_sold,

        ROUND(SUM(o.order_value),2) AS total_revenue,

        IFNULL(rs.average_rating, 0.00) AS average_rating

    FROM silver_books b

    JOIN silver_orders o
        ON b.book_id = o.book_id

    LEFT JOIN review_stats rs
        ON b.book_id = rs.book_id

    WHERE o.status = 'DELIVERED'

    GROUP BY
        b.genre,
        b.book_id,
        b.title,
        rs.average_rating
),

ranked_books AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY genre
            ORDER BY total_revenue DESC
        ) AS rn

    FROM book_sales
)

SELECT
    genre,
    book_id,
    title,
    total_units_sold,
    total_revenue,
    average_rating

FROM ranked_books

WHERE rn <= 10

ORDER BY
    genre,
    total_revenue DESC;
-- ==========================================================
-- Gold View : Customer Segments
-- ==========================================================

DROP VIEW IF EXISTS gold_customer_segments;

CREATE VIEW gold_customer_segments AS

SELECT
    c.customer_id,
    c.name AS customer_name,

    IFNULL(ROUND(SUM(o.order_value),2),0) AS total_spend,

    CASE
        WHEN IFNULL(SUM(o.order_value),0) > 20000
            THEN 'HIGH VALUE'

        WHEN IFNULL(SUM(o.order_value),0) >= 5000
            THEN 'MID VALUE'

        ELSE 'LOW VALUE'
    END AS segment

FROM silver_customers c

LEFT JOIN silver_orders o
ON c.customer_id = o.customer_id
AND o.status = 'DELIVERED'

GROUP BY
    c.customer_id,
    c.name;