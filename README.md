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

## Data Cleaning & Preparation

The raw dataset contained 541,909 transaction records. Data quality checks were performed before creating the analytical table.

Key preparation steps included:

- Checked missing values across important columns.
- Identified 9,288 cancelled transactions using invoice numbers beginning with "C".
- Identified 2 records with negative unit prices and excluded them from sales analysis.
- Identified 1,336 negative-quantity records with zero unit price and excluded them from standard sales analysis.
- Investigated an exceptional quantity value of ±80,995 and excluded the associated records from standard sales analysis.
- Converted invoice dates into a usable datetime format using `TRY_CONVERT()`.
- Created a cleaned analytical table named `CleanOnlineRetail`.
- Calculated transaction-level revenue using `Quantity × UnitPrice`.
- Retained the raw table separately to preserve the original dataset.

## Key Results & Insights

### Overall Performance

- Total Revenue: £10.50M
- Total Orders: 20,725
- Total Units Sold: 5.58M
- Identified Customers: 4,339
- Average Order Value (AOV): £506.55

### Customer Insights

- 65.55% of identified customers were repeat customers, while 34.45% were one-time customers.
- The top 10 customers contributed 16.43% of identifiable-customer revenue.
- Customer-level analysis helped identify high-value customers based on total spending and order frequency.

### Product Insights

- The highest-revenue product generated approximately £174K in sales.
- Product-level analysis was used to identify products with strong revenue and order performance.

### Geographic Insights

- The United Kingdom generated the highest revenue among countries with identified customer records, contributing approximately £7.14M.
- International markets such as the Netherlands, Ireland, Germany, France, and Australia also showed significant revenue contribution.

### Sales Trend Insights

- November 2011 recorded the highest monthly revenue at approximately £1.51M.
- September 2011 showed strong growth, with revenue increasing by approximately 39.45% compared with the previous month.
- December 2011 experienced a significant decline compared with November.

## Tools & Technologies

- SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)

## Project Structure

```text
ecommerce-sales-customer-analytics-sql/
│
├── ECommerce_Sales_Customer_Analytics.sql
└── README.md
## Project Screenshots

### Overall Business Performance

![Overall Performance](./Screenshot%202026-09-05%20001944.png)

### Monthly Sales Performance

![Monthly Sales](./Screenshot%202026-09-05%20002510.png)

### Top Products

![Top Products](./Screenshot%202026-09-05%20002644.png)

### Customer Analysis

![Customer Analysis](./Screenshot%202026-09-05%20002759.png)
