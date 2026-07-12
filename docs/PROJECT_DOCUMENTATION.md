# 📚 Project Documentation

# Online Bookstore & Library Management System

### Data Engineering Capstone Project
### Medallion Architecture using MySQL & Power BI

---

# Author

**Avantika Chouhan**

---

# Table of Contents

1. Project Overview
2. Problem Statement
3. Project Objectives
4. Dataset Description
5. Technology Stack
6. Project Architecture
7. Database Design
8. Task 1 – Database & Source Layer
9. Task 2 – Bronze Layer
10. Task 3 – Silver Layer
11. Task 4 – Gold Layer
12. Task 5 – Pipeline Audit
13. Power BI Dashboard
14. Validation
15. Additional Business Enhancements
16. Project Structure
17. Assumptions & Notes
18. Future Improvements
19. Assignment Deliverables
20. Project Submission
21. Additional Enhancements Beyond Assignment
22. Conclusion
---

# 1. Project Overview

The Online Bookstore & Library Management System is a complete end-to-end Data Engineering project developed using the Medallion Architecture.

The objective is to transform raw CSV data into clean, validated and business-ready analytical datasets for executive reporting.

The project follows a layered architecture:

- Bronze Layer
- Silver Layer
- Gold Layer

Finally, the Gold layer is connected to Power BI to create an interactive executive dashboard.

---

# 2. Problem Statement

Operational systems generate large amounts of transactional data which is difficult to analyse directly.

The goal of this project is to build a scalable SQL data pipeline capable of:

- Loading raw data
- Cleaning and validating records
- Applying business rules
- Generating executive KPIs
- Supporting dashboard reporting

using Medallion Architecture.

---

# 3. Project Objectives

The project aims to:

- Design a normalized database schema
- Build Bronze, Silver and Gold layers
- Implement incremental loading
- Perform data quality validation
- Create business KPI views
- Build analytical Gold views
- Monitor pipeline health
- Develop an executive Power BI dashboard

---

# 4. Dataset Description

The project uses five CSV files.

| Dataset | Description |
|----------|-------------|
| books.csv | Book catalogue |
| customers.csv | Customer information |
| orders.csv | Customer purchase records |
| loans.csv | Library loan transactions |
| reviews.csv | Customer reviews |

---

# 5. Technology Stack

- MySQL 8.0
- MySQL Workbench
- SQL
- Python
- Power BI Desktop
- Git
- GitHub

---

# 6. Project Architecture

```
CSV Files
     │
     ▼
Bronze Layer
(Raw Data)

     │
     ▼
Silver Layer
(Clean & Validate)

     │
     ▼
Gold Layer
(Business KPIs)

     │
     ▼
Power BI Dashboard
```

The Medallion Architecture ensures clean separation between raw, transformed and analytical data.

---

# 7. Database Design

The database consists of three logical layers.

## Source Layer

Raw imported CSV data.

## Bronze Layer

Stores raw ingested records with metadata.

Features:

- Batch ID
- Load Timestamp
- Incremental Loading

---

## Silver Layer

Business-ready cleaned tables.

Features:

- Duplicate Removal
- Data Validation
- Data Enrichment
- Business Rule Enforcement

---

## Gold Layer

Executive reporting views.

Includes:

- KPI Views
- Analytical Views
- Pipeline Audit

---

# 8. Task 1 – Database & Source Layer

Completed Activities:

- Database Creation
- Source Tables
- Primary Keys
- Foreign Keys
- Constraints

Validation:

- Record counts verified
- Table structure validated

---

# 9. Task 2 – Bronze Layer

Implemented:

- Raw Data Load
- Incremental Loading
- Batch Tracking
- Load Timestamp

Validation:

- Row count verification
- Batch validation
- Duplicate prevention

---

# 10. Task 3 – Silver Layer

Implemented:

- Duplicate removal
- Data cleaning
- Invalid record filtering
- Order value calculation
- Loan overdue calculation
- Business rule enforcement

Validation:

- Clean record counts
- Data quality checks
- Business validation

---

# 11. Task 4 – Gold Layer

Business KPI Views

- Monthly Revenue Growth
- Customer Retention Rate
- Book Sell Through Rate
- Library Return Compliance
- Review Coverage Rate

Analytical Views

- Top Books
- Customer Segments
- Top Customers
- Genre Performance

Additional KPIs

- Average Order Value
- Delivery Success Rate
- Average Customer Rating

---

# 12. Task 5 – Pipeline Audit

Implemented:

- Pipeline Health View
- Layer Status Summary
- Record Count Validation
- Audit Information

Purpose:

Provide quick visibility into pipeline execution and data quality.

---

# 13. Power BI Dashboard

An interactive executive dashboard was developed using the Gold layer.

Dashboard Components:

### KPI Cards

- Revenue Growth
- Customer Retention
- Sell Through
- Return Compliance
- Review Coverage
- Delivery Success
- Average Rating
- Average Order Value

### Charts

- Monthly Revenue Growth
- Revenue by Genre
- Top Books
- Customer Segments
- Top Customers

### Filters

- Genre
- Customer Segment
- Month

---

# 14. Validation

Each task includes dedicated SQL validation scripts.

Validation includes:

- Row Counts
- Business Rules
- KPI Verification
- Analytical View Validation
- Pipeline Validation

---

# 15. Additional Business Enhancements

Beyond the original assignment requirements, the following enhancements were implemented.

### Additional KPIs

- Average Order Value
- Delivery Success Rate
- Average Customer Rating

### Additional Analytical Views

- Top Customers
- Genre Performance

### Dashboard Enhancements

- Executive KPI Cards
- Interactive Filters
- Business Visualizations

These enhancements demonstrate additional business analytics and reporting capabilities beyond the mandatory project requirements.

---

# 16. Project Structure

```
Online-Bookstore-Library-Management-System

│
├── cityreads_dataset/
├── docs/
├── powerbi/
├── screenshots/
├── sql/
├── testing/
├── Dataset_generator.py
├── README.md
└── requirements.txt
```

---

# 17. Assumptions & Notes

This project was developed using the dataset provided with the assignment.

Business KPIs are calculated dynamically from the available data. Therefore, KPI values and PASS/FAIL results depend on the underlying dataset and may change if different datasets are used.

The SQL logic, validation scripts, and dashboard are fully data-driven and automatically reflect the current state of the dataset.

Additional business KPIs and the Power BI dashboard were implemented to extend the project beyond the minimum assignment requirements and demonstrate executive reporting capabilities.

---

# 18. Future Improvements

Potential future enhancements include:

- Automated ETL Scheduling
- Slowly Changing Dimensions (SCD)
- Incremental Gold Refresh
- Stored Procedures
- Performance Optimization
- Cloud Deployment
- Data Warehouse Migration
- CI/CD Pipeline

---

# 19. Assignment Deliverables

According to the Capstone Project specification, the following deliverables were required:

| Required Deliverable | Status |
|----------------------|--------|
| task1_schema.sql | ✅ Completed |
| task2_bronze_load.sql | ✅ Completed |
| task3_silver_transform.sql | ✅ Completed |
| task4_gold_views.sql | ✅ Completed |
| task5_audit.sql | ✅ Completed |
| task1_validation.sql | ✅ Completed |
| task2_validation.sql | ✅ Completed |
| task3_validation.sql | ✅ Completed |
| task4_validation.sql | ✅ Completed |
| task5_validation.sql | ✅ Completed |
| pipeline_design.md | ✅ Completed |

---

# 20. Project Submission

The final project submission includes the following components:

## SQL Scripts

- 00_source_schema.sql
- task1_schema.sql
- task2_bronze_load.sql
- task3_silver_transform.sql
- task4_gold_views.sql
- task5_audit.sql

## Validation Scripts

- task1_validation.sql
- task2_validation.sql
- task3_validation.sql
- task4_validation.sql
- task5_validation.sql

## Documentation

- PROJECT_DOCUMENTATION.md
- pipeline_design.md

## Dataset

- books.csv
- customers.csv
- orders.csv
- loans.csv
- reviews.csv

## Power BI

- Executive Dashboard (.pbix)

## Screenshots

Screenshots are provided for:

- Source Schema
- Task 1
- Task 2
- Task 3
- Task 4
- Task 5
- Power BI Dashboard

---

# 21. Additional Enhancements

In addition to the mandatory project requirements, the following enhancements were implemented to improve business reporting and analytical capabilities:

Note: KPI calculations are fully dynamic and are derived from the available transactional dataset using the business rules defined in the project specification. Therefore, KPI values and PASS/FAIL results are data-dependent and automatically update whenever the underlying dataset changes.

### Additional KPI Views

- Average Order Value
- Delivery Success Rate
- Average Customer Rating

### Additional Analytical Views

- Top Customers
- Genre Performance

### Executive Dashboard

A fully interactive Power BI Executive Dashboard was developed using the Gold layer views. Although the dashboard was not explicitly required in the original capstone specification, it was implemented to demonstrate how business users can consume the analytical outputs generated by the Medallion Architecture.

These enhancements extend the project beyond the minimum assignment requirements while maintaining the original pipeline design.

---

# 22. Conclusion

This project demonstrates the complete implementation of a production-style Medallion Architecture using MySQL.

The solution successfully transforms raw operational data into clean, validated, and business-ready analytical datasets while following the Bronze → Silver → Gold pipeline design.

The project includes data quality validation, KPI generation, pipeline auditing, and an executive Power BI dashboard, providing an end-to-end data engineering solution for business reporting and analytics.