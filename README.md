# 📚 Online Bookstore & Library Management System

### Data Engineering Capstone Project – Medallion Architecture

**Author:** Avantika Chouhan

---

# 📖 Project Overview

This project implements a complete **Medallion Data Pipeline** for an **Online Bookstore & Library Management System** using **MySQL**.

The pipeline is divided into three layers:

- 🥉 Bronze Layer – Raw data ingestion
- 🥈 Silver Layer – Data cleaning, validation, and enrichment
- 🥇 Gold Layer – Business KPIs and analytical views

The project demonstrates incremental loading, data quality validation, business transformations, KPI reporting, and pipeline health monitoring.

---

# 🏗️ Medallion Architecture

```text
                    CSV Files
                         │
                         ▼
                ┌─────────────────┐
                │  Bronze Layer   │
                │ Raw Data Load   │
                └─────────────────┘
                         │
                         ▼
                ┌─────────────────┐
                │  Silver Layer   │
                │ Clean & Validate│
                └─────────────────┘
                         │
                         ▼
                ┌─────────────────┐
                │   Gold Layer    │
                │ KPI & Analytics │
                └─────────────────┘
                         │
                         ▼
              Executive Dashboard / BI
```

---

# 🥉 Bronze Layer

- Raw data ingestion from CSV files
- Incremental loading
- Batch tracking
- Ingestion timestamp
- No transformations applied

---

# 🥈 Silver Layer

- Duplicate removal
- Data cleaning
- Data validation
- Invalid record rejection
- Business rule enforcement
- Order value calculation
- Loan overdue calculation
- Data enrichment

---

# 🥇 Gold Layer

Business-ready views for reporting.

### KPI Views

- Monthly Revenue Growth
- Customer Retention Rate
- Book Sell-Through Rate
- Library Return Compliance
- Review Coverage Rate

### Analytical Views

- Top Books by Revenue per Genre
- Customer Segments

### Pipeline Audit

- Pipeline Health View
- Overall Pipeline Health Summary

---

# 📂 Project Structure

```text
Online-Bookstore-Library-Management-System/
│
├── cityreads_dataset/
│   ├── books.csv
│   ├── customers.csv
│   ├── orders.csv
│   ├── loans.csv
│   └── reviews.csv
│
├── docs/
│   └── pipeline_design.md
│
├── sql/
│   ├── 00_source_schema.sql
│   ├── task1_schema.sql
│   ├── task2_bronze_load.sql
│   ├── task3_silver_transform.sql
│   ├── task4_gold_views.sql
│   └── task5_audit.sql
│
├── testing/
│   ├── task1_validation.sql
│   ├── task2_validation.sql
│   ├── task3_validation.sql
│   ├── task4_validation.sql
│   └── task5_validation.sql
│
├── Dataset_generator.py
├── README.md
└── .gitignore
```

---

# 🛠️ Technologies Used

- MySQL 8.0
- SQL
- Git
- GitHub
- CSV

---

# 🚀 Execution Order

Run the SQL files in the following order:

1. `00_source_schema.sql`
2. `task1_schema.sql`
3. `task2_bronze_load.sql`
4. `task3_silver_transform.sql`
5. `task3_validation.sql`
6. `task4_gold_views.sql`
7. `task4_validation.sql`
8. `task5_audit.sql`
9. `task5_validation.sql`

---

# 📊 Key Features

- Incremental Data Loading
- Duplicate Removal
- Data Validation
- Rejected Row Tracking
- Data Enrichment
- Business KPI Views
- Customer Segmentation
- Top Books Analysis
- Pipeline Health Monitoring
- Medallion Architecture Implementation

---

# 📦 Deliverables

- Bronze Layer Schema & Load Scripts
- Silver Transformation Scripts
- Gold KPI Views
- Pipeline Audit View
- Validation Scripts
- Pipeline Design Document

---

# 👩‍💻 Author

**Avantika Chouhan**


