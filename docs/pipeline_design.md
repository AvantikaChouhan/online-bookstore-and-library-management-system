# Pipeline Design Document

## Project
**Online Bookstore & Library Management System**

**Author:** Avantika Chouhan

---

# Pipeline Design

This project follows the Medallion Architecture, where data flows through Bronze, Silver, and Gold layers. The Bronze layer stores raw source data, the Silver layer performs cleaning and validation, and the Gold layer provides business-ready KPI and analytical views for reporting.

---

# 1. Watermark Strategy

The pipeline uses a source-based watermark strategy to support incremental loading.

The following source timestamp columns were selected:

| Table | Watermark Column |
|--------|------------------|
| books | published_on |
| customers | joined_on |
| orders | order_date |
| loans | loan_date |
| reviews | created_at |

These columns are stored in the `pipeline_metadata` table after every successful pipeline execution.

During each run, only records with a timestamp greater than the stored watermark are loaded into the Bronze layer.

The `ingested_at` column is maintained separately as an audit column to record when data entered the Bronze layer. It is also used during Silver-layer deduplication to retain the most recently ingested record.

---

# 2. Silver Layer Trade-off

One important design decision in the Silver layer was to **reject invalid records instead of correcting them automatically**.

Examples include:

- Missing email addresses
- Invalid membership values
- Invalid order quantities
- Invalid order status
- Invalid review ratings
- Invalid loan dates

Instead of deleting these records, they are stored in the **silver_rejected_rows** table with the rejection reason and timestamp.

### Why?

This approach preserves data lineage and makes the pipeline auditable. It also allows engineers to investigate bad data without affecting clean business data stored in the Silver layer.

This design prioritizes data integrity and auditability over automatic correction, ensuring that only trusted records are promoted to the Silver layer.

---

# 3. Hardest KPI

The most challenging KPI to implement was **Customer Retention Rate**.

This KPI measures the percentage of customers who placed orders in two consecutive calendar months.

The implementation required:

- Extracting the order month from each order.
- Identifying unique customer-month combinations.
- Performing a self join to compare consecutive months.
- Using `TIMESTAMPDIFF()` to verify that the difference between two months is exactly one calendar month.
- Calculating the final retention percentage.

This KPI required more complex SQL logic than the other KPIs because it involved both date calculations and customer activity over time.

Common Table Expressions (CTEs), self joins, window functions, and date functions were used to keep the implementation modular, readable, and maintainable.

---

# Conclusion

The project successfully implements a production-style Medallion Data Pipeline using Bronze, Silver, and Gold layers.

The solution includes incremental data ingestion using watermarking, comprehensive data quality validation, rejection logging, business KPI generation, analytical Gold views, and pipeline health monitoring.

Beyond the mandatory project requirements, additional KPI views, analytical Gold views, and an Executive Power BI Dashboard were implemented to demonstrate real-world business intelligence and reporting capabilities.