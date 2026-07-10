-- ==========================================================
-- Project  : Online Bookstore & Library Management System
-- Task     : Task 5 Validation
-- Author   : Avantika Chouhan
-- Database : cityreads
-- Purpose  : Validate Pipeline Audit & Data Quality Report
-- Date     : 10-07-2026
-- ==========================================================

USE cityreads;

-- ==========================================================
-- Pipeline Health View
-- ==========================================================

SELECT *
FROM gold_pipeline_health;

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
-- Pipeline Status Summary
-- ==========================================================

SELECT
    pipeline_status,
    COUNT(*) AS total_tables
FROM gold_pipeline_health
GROUP BY pipeline_status;

-- ==========================================================
-- Rejection Rate by Table
-- ==========================================================

SELECT
    table_name,
    rejection_rate_pct
FROM gold_pipeline_health
ORDER BY rejection_rate_pct DESC;