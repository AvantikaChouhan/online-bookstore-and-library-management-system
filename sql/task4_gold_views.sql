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
                (revenue - LAG(revenue) OVER(ORDER BY month))
                /
                LAG(revenue) OVER(ORDER BY month)
            ) * 100,
            2
        ) AS kpi_value

    FROM monthly_revenue
)

SELECT

    month,

    kpi_value,

    5 AS kpi_target,

    CASE
        WHEN kpi_value >= 5
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,

    NOW() AS calculated_at

FROM growth

WHERE kpi_value IS NOT NULL

ORDER BY month;
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
         FROM silver_orders) AS total_customers
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
        (
            SUM(
                CASE
                    WHEN return_date IS NOT NULL
                         AND return_date <= due_date
                    THEN 1
                    ELSE 0
                END
            ) * 100.0
        )
        /
        COUNT(return_date),
        2
    ) AS kpi_value,

    75 AS kpi_target,

    CASE
        WHEN ROUND(
            (
                SUM(
                    CASE
                        WHEN return_date IS NOT NULL
                             AND return_date <= due_date
                        THEN 1
                        ELSE 0
                    END
                ) * 100.0
            )
            /
            COUNT(return_date),
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

-- ==========================================================
--          ADDITIONAL ANALYTICS (SELF IMPLEMENTED)
-- ==========================================================
-- NOTE:
-- The following KPIs and Gold Views are implemented
-- beyond the assignment requirements to demonstrate
-- business understanding, analytical thinking,
-- and executive dashboard design capabilities.
-- ==========================================================

-- ==========================================================
-- Additional KPI 6 : Average Order Value (AOV)
-- Business Purpose:
-- Measures the average revenue generated per delivered order.
-- Helps evaluate customer purchasing behavior.
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_average_order_value;

CREATE VIEW gold_kpi_average_order_value AS

SELECT

ROUND(
AVG(order_value),
2
) AS kpi_value,

1000 AS kpi_target,

CASE
WHEN ROUND(AVG(order_value),2) >=1000
THEN 'PASS'
ELSE 'FAIL'
END AS status,

NOW() AS calculated_at

FROM silver_orders

WHERE status='DELIVERED';

-- ==========================================================
-- Additional KPI 7 : Delivery Success Rate
-- Business Purpose :
-- Measures the percentage of successfully delivered orders.
-- Helps evaluate operational efficiency.
-- ==========================================================

DROP VIEW IF EXISTS gold_kpi_delivery_success;

CREATE VIEW gold_kpi_delivery_success AS

SELECT

ROUND(
    SUM(
        CASE
            WHEN status = 'DELIVERED' THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*)
,2) AS kpi_value,

75 AS kpi_target,

CASE
    WHEN ROUND(
        (
            SUM(
                CASE
                    WHEN status = 'DELIVERED' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*)
        ),2
    ) >= 75
    THEN 'PASS'
    ELSE 'FAIL'
END AS status,

NOW() AS calculated_at

FROM silver_orders;

-- ==========================================================
-- Additional KPI 8 : Average Customer Rating
-- Business Purpose :
-- Measures overall customer satisfaction based on reviews.
-- Helps evaluate product quality and customer experience.
-- ==========================================================
DROP VIEW IF EXISTS gold_kpi_average_rating;

CREATE VIEW gold_kpi_average_rating AS

SELECT

ROUND(
    AVG(rating),
    2
) AS kpi_value,

3.50 AS kpi_target,

CASE
    WHEN ROUND(AVG(rating),2) >= 3.5
    THEN 'PASS'
    ELSE 'FAIL'
END AS status,

NOW() AS calculated_at

FROM silver_reviews;

-- ==========================================================
-- Additional Gold View 1 : Top Customers
-- Business Purpose :
-- Identifies the highest value customers based on spending.
-- Helps management recognize VIP customers and improve
-- loyalty, retention, and personalized marketing campaigns.
-- ==========================================================

DROP VIEW IF EXISTS gold_top_customers;

CREATE VIEW gold_top_customers AS

WITH customer_summary AS
(
    SELECT

        c.customer_id,

        c.name AS customer_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        ROUND(SUM(o.order_value),2) AS total_spend,

        ROUND(AVG(o.order_value),2) AS average_order_value

    FROM silver_customers c

    JOIN silver_orders o
        ON c.customer_id = o.customer_id

    WHERE o.status = 'DELIVERED'

    GROUP BY

        c.customer_id,
        c.name
),

ranked_customers AS
(
    SELECT

        *,

        DENSE_RANK() OVER
        (
            ORDER BY total_spend DESC
        ) AS customer_rank

    FROM customer_summary
)

SELECT

    customer_id,

    customer_name,

    total_orders,

    total_spend,

    average_order_value,

    customer_rank

FROM ranked_customers

ORDER BY customer_rank;

-- ==========================================================
-- Additional Gold View 2 : Genre Performance
-- Business Purpose :
-- Provides overall performance of each book genre.
-- Helps management identify the highest revenue-generating
-- genres for inventory planning and marketing decisions.
-- ==========================================================

DROP VIEW IF EXISTS gold_genre_performance;

CREATE VIEW gold_genre_performance AS

WITH review_stats AS
(
    SELECT

        b.genre,

        ROUND(AVG(r.rating),2) AS average_rating

    FROM silver_books b

    LEFT JOIN silver_reviews r
        ON b.book_id = r.book_id

    GROUP BY b.genre
),

genre_sales AS
(
    SELECT

        b.genre,

        ROUND(SUM(o.order_value),2) AS total_revenue,

        SUM(o.quantity) AS total_units_sold,

        rs.average_rating

    FROM silver_books b

    JOIN silver_orders o
        ON b.book_id = o.book_id

    LEFT JOIN review_stats rs
        ON b.genre = rs.genre

    WHERE o.status = 'DELIVERED'

    GROUP BY

        b.genre,
        rs.average_rating
),

final_result AS
(
    SELECT

        genre,

        total_revenue,

        total_units_sold,

        average_rating,

        ROUND
        (
            total_revenue * 100.0 /
            SUM(total_revenue) OVER(),
            2
        ) AS revenue_share_pct,

        DENSE_RANK() OVER
        (
            ORDER BY total_revenue DESC
        ) AS genre_rank

    FROM genre_sales
)

SELECT *

FROM final_result

ORDER BY genre_rank;
-- ==========================================================
-- End of Task 4
-- Gold Layer Successfully Completed
--
-- Original Deliverables
-- ✔ 5 Business KPIs
-- ✔ Top Books View
-- ✔ Customer Segmentation
--
-- Additional Deliverables (Self Implemented)
-- ✔ Average Order Value KPI
-- ✔ Delivery Success KPI
-- ✔ Average Customer Rating KPI
-- ✔ Top Customers View
-- ✔ Genre Performance View
--
-- Total Gold Views Created : 12
-- ==========================================================