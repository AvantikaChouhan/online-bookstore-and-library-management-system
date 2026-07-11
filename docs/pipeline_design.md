# Pipeline Design Document

## Project
**Online Bookstore & Library Management System**

**Author:** Avantika Chouhan

---

# Pipeline Design

This project follows the Medallion Architecture, where data flows through Bronze, Silver, and Gold layers. The Bronze layer stores raw source data, the Silver layer performs cleaning and validation, and the Gold layer provides business-ready KPI and analytical views for reporting.

---

# 1. Watermark Strategy

The **ingested_at** column was selected as the watermark column for all Bronze tables:

- bronze_books
- bronze_customers
- bronze_orders
- bronze_loans
- bronze_reviews

### Why ingested_at?

The **ingested_at** timestamp records when each record enters the Bronze layer. During Silver transformation, duplicate records are removed using:

```sql
ROW_NUMBER() OVER (
    PARTITION BY <primary_key>
    ORDER BY ingested_at DESC
)
```

This ensures that only the most recently ingested record for each business key is promoted to the Silver layer.

Using **ingested_at** also supports incremental data loading and avoids processing older duplicate records.

The pipeline metadata table stores the last successful load timestamp, enabling idempotent incremental loading across all Bronze tables.

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

Common Table Expressions (CTEs), self joins, and date functions were used to keep the implementation modular and maintainable.

---

# Conclusion

The project successfully implements a production-style Medallion Data Pipeline using Bronze, Silver, and Gold layers.

The solution includes incremental data ingestion using watermarking, comprehensive data quality validation, rejection logging, business KPI generation, analytical Gold views, and pipeline health monitoring.

Additional business KPIs and analytical views were also implemented beyond the project requirements to demonstrate advanced SQL and business analytics capabilities for executive reporting.