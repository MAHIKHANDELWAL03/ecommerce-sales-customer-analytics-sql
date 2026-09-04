# E-commerce Sales & Customer Analytics | SQL

## Project Overview

This project analyzes e-commerce sales data using SQL Server to evaluate sales performance, customer behavior, product performance, and geographic trends.

The analysis focuses on identifying key business metrics and patterns that can support data-driven decision-making.
## Dataset

The project uses the Online Retail Dataset containing 541,909 transaction records from an e-commerce retailer.

The dataset includes information such as:

- Invoice number
- Product code
- Product description
- Quantity
- Invoice date
- Unit price
- Customer ID
- Country

The raw dataset was imported into SQL Server and analyzed using a cleaned analytical table.
## Business Questions

The analysis was designed to answer the following business questions:

1. What is the overall revenue, order volume, customer count, and average order value?
2. How does revenue change month over month?
3. Which products generate the highest revenue?
4. Which customers contribute the most revenue?
5. What percentage of customers are one-time versus repeat customers?
6. Which countries generate the highest revenue?
7. How does monthly revenue growth change over time?
## SQL Techniques Used

The project applies the following SQL concepts:

- Data cleaning and validation
- Aggregate functions: SUM, COUNT, AVG, MIN, MAX
- GROUP BY and HAVING
- CASE WHEN statements
- Common Table Expressions (CTEs)
- Window functions
- RANK() for customer ranking
- LAG() for month-over-month analysis
- DISTINCT counts for orders and customers
- Date functions for monthly sales analysis
- NULL handling and conditional filtering
