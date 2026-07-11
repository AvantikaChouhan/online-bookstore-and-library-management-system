-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 5 - Pipeline Audit & Data Quality Report
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Monitor Pipeline Health
-- Date     : 10-07-2026
-- ==========================================================

USE cityreads;
-- ==========================================================
-- NOTE:
-- Pipeline Health Report validates the data quality and ETL
-- process from Bronze to Silver layers.
--
-- Business KPIs and analytical Gold Views are validated
-- separately in Task 4 Validation.
-- ==========================================================

-- ==========================================================
-- Gold View : Pipeline Health
-- ==========================================================

DROP VIEW IF EXISTS gold_pipeline_health;

CREATE VIEW gold_pipeline_health AS

SELECT
    pm.table_name,

    pm.last_loaded_at,

    CASE
        WHEN pm.table_name='bronze_books'
            THEN (SELECT COUNT(*) FROM bronze_books)

        WHEN pm.table_name='bronze_customers'
            THEN (SELECT COUNT(*) FROM bronze_customers)

        WHEN pm.table_name='bronze_orders'
            THEN (SELECT COUNT(*) FROM bronze_orders)

        WHEN pm.table_name='bronze_loans'
            THEN (SELECT COUNT(*) FROM bronze_loans)

        WHEN pm.table_name='bronze_reviews'
            THEN (SELECT COUNT(*) FROM bronze_reviews)
    END AS rows_in_bronze,

    CASE
        WHEN pm.table_name='bronze_books'
            THEN (SELECT COUNT(*) FROM silver_books)

        WHEN pm.table_name='bronze_customers'
            THEN (SELECT COUNT(*) FROM silver_customers)

        WHEN pm.table_name='bronze_orders'
            THEN (SELECT COUNT(*) FROM silver_orders)

        WHEN pm.table_name='bronze_loans'
            THEN (SELECT COUNT(*) FROM silver_loans)

        WHEN pm.table_name='bronze_reviews'
            THEN (SELECT COUNT(*) FROM silver_reviews)
    END AS rows_in_silver,

    (
        SELECT COUNT(*)
        FROM silver_rejected_rows r
        WHERE r.table_name = pm.table_name
    ) AS rows_rejected,

    ROUND
    (
        (
        (
            SELECT COUNT(*)
            FROM silver_rejected_rows r
            WHERE r.table_name = pm.table_name
        )

        *100.0

        /

        CASE
            WHEN pm.table_name='bronze_books'
                THEN (SELECT COUNT(*) FROM bronze_books)

            WHEN pm.table_name='bronze_customers'
                THEN (SELECT COUNT(*) FROM bronze_customers)

            WHEN pm.table_name='bronze_orders'
                THEN (SELECT COUNT(*) FROM bronze_orders)

            WHEN pm.table_name='bronze_loans'
                THEN (SELECT COUNT(*) FROM bronze_loans)

            WHEN pm.table_name='bronze_reviews'
                THEN (SELECT COUNT(*) FROM bronze_reviews)
        END

        ),
        2
    ) AS rejection_rate_pct,

    CASE

        WHEN ROUND
        (
        (
        (
            SELECT COUNT(*)
            FROM silver_rejected_rows r
            WHERE r.table_name = pm.table_name
        )

        *100.0

        /

        CASE
            WHEN pm.table_name='bronze_books'
                THEN (SELECT COUNT(*) FROM bronze_books)

            WHEN pm.table_name='bronze_customers'
                THEN (SELECT COUNT(*) FROM bronze_customers)

            WHEN pm.table_name='bronze_orders'
                THEN (SELECT COUNT(*) FROM bronze_orders)

            WHEN pm.table_name='bronze_loans'
                THEN (SELECT COUNT(*) FROM bronze_loans)

            WHEN pm.table_name='bronze_reviews'
                THEN (SELECT COUNT(*) FROM bronze_reviews)
        END

        ),
        2
        ) > 5

        THEN 'DEGRADED'

        ELSE 'HEALTHY'

    END AS pipeline_status

FROM pipeline_metadata pm;

-- ==========================================================
-- Overall Pipeline Health Summary
-- ==========================================================

SELECT
    ROUND(
        (
            SUM(rows_rejected) * 100.0
            /
            SUM(rows_in_bronze)
        ),
        2
    ) AS overall_rejection_rate,

    CASE
        WHEN ROUND(
            (
                SUM(rows_rejected) * 100.0
                /
                SUM(rows_in_bronze)
            ),
            2
        ) < 5
        THEN 'HEALTHY'

        ELSE 'DEGRADED'
    END AS pipeline_verdict

FROM gold_pipeline_health;
-- ==========================================================
-- Pipeline Status Distribution
-- ==========================================================

SELECT
    pipeline_status,
    COUNT(*) AS total_tables
FROM gold_pipeline_health
GROUP BY pipeline_status;
-- ==========================================================
-- Highest Rejection Rate Table
-- ==========================================================

SELECT *
FROM gold_pipeline_health
ORDER BY rejection_rate_pct DESC
LIMIT 1;
-- ==========================================================
-- End of Task 5
-- Pipeline Health Validation Completed
--
-- ✔ Pipeline Health View Created
-- ✔ Overall Pipeline Summary Generated
-- ✔ Pipeline Status Distribution Validated
-- ✔ Highest Rejection Rate Table Identified
-- ==========================================================