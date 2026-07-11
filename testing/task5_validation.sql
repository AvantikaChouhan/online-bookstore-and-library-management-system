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
-- Pipeline Health View Validation
-- ==========================================================

SELECT *
FROM gold_pipeline_health;

-- ==========================================================
-- Overall Pipeline Health Summary Validation
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
-- Pipeline Status Distribution Validation
-- ==========================================================

SELECT
    pipeline_status,
    COUNT(*) AS total_tables
FROM gold_pipeline_health
GROUP BY pipeline_status;

-- ==========================================================
-- Highest Rejection Rate Validation
-- ==========================================================

SELECT *
FROM gold_pipeline_health
ORDER BY rejection_rate_pct DESC
LIMIT 1;

-- ==========================================================
-- Rejection Rate by Table Validation
-- ==========================================================

SELECT
    table_name,
    rejection_rate_pct
FROM gold_pipeline_health
ORDER BY rejection_rate_pct DESC;

-- ==========================================================
-- End of Task 5 Validation
-- ==========================================================
-- NOTE:
-- This validation confirms the Pipeline Audit and Data Quality
-- report by checking:
-- 1. Pipeline Health
-- 2. Overall Pipeline Verdict
-- 3. Pipeline Status Distribution
-- 4. Highest Rejection Rate Table
-- 5. Rejection Rate for all Pipeline Tables
-- ==========================================================
-- ==========================================================
-- Validation Result:
-- Pipeline is HEALTHY and all audit metrics are successfully generated.
-- ==========================================================