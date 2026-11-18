# E-commerce Sales & Customer Analytics | SQL Server

A SQL Server analytics project using the Online Retail dataset (541,909 transaction records) to examine revenue, order activity, customer behavior, product performance, geographic trends, and monthly sales movement.

The project includes data-quality checks, a cleaned analytical table, business-focused T-SQL queries, and screenshots of selected query results.

## Project at a glance

- **Dataset:** Online Retail — 541,909 raw records
- **Database:** SQL Server
- **Tools:** SQL Server Management Studio (SSMS), T-SQL
- **Main source table:** `dbo.OnlineRetail`
- **Clean analytical table:** `dbo.CleanOnlineRetail`

## Business questions

1. What are total revenue, order volume, customer count, units sold, and average order value?
2. How does revenue change month over month?
3. Which products generate the highest revenue?
4. Which customers contribute the most revenue?
5. What proportion of identified customers are one-time versus repeat customers?
6. Which countries generate the most revenue?
7. How does monthly revenue growth change over time?

## Data preparation

The raw dataset was reviewed before creating the cleaned analytical table.

Preparation and validation steps included:

- Checked missing values in important fields.
- Identified 9,288 cancelled transactions using invoice numbers beginning with `C`.
- Identified and excluded 2 records with negative unit prices from standard sales analysis.
- Identified and excluded 1,336 negative-quantity records with zero unit price.
- Excluded exceptional quantity records where the absolute quantity was 80,995 or greater.
- Converted invoice dates using `TRY_CONVERT()`.
- Created `dbo.CleanOnlineRetail` while retaining the original table.
- Calculated transaction revenue as `Quantity × UnitPrice`.

The SQL script creates `dbo.CleanOnlineRetail` only when that table does not already exist. If you change or reload the raw data and want to rebuild the cleaned table, remove the existing cleaned table first, then rerun the cleaning section.

## SQL concepts demonstrated

- Data-quality checks and conditional filtering
- Aggregate functions: `SUM`, `COUNT`, `AVG`, `MIN`, and `MAX`
- `GROUP BY` and `HAVING`
- `CASE WHEN` expressions
- Common Table Expressions (CTEs)
- Window functions
- `RANK()` for customer ranking
- `LAG()` for month-over-month comparison
- Date functions and monthly aggregation
- `NULL` handling and `NULLIF()`

## Selected findings

The results documented in this project include:

### Overall performance

| Metric | Result |
|---|---:|
| Total revenue | £10.50M |
| Total orders | 20,725 |
| Total units sold | 5.58M |
| Identified customers | 4,339 |
| Average order value | £506.55 |

### Customer insights

- 65.55% of identified customers were repeat customers; 34.45% were one-time customers.
- The top 10 customers contributed 16.43% of identifiable-customer revenue.
- Customer-level queries rank customers by revenue and examine order frequency.

### Product and geographic insights

- The highest-revenue product generated approximately £174K.
- The United Kingdom generated approximately £7.14M among countries with identified customer records.

### Sales trends

- November 2011 recorded the highest monthly revenue at approximately £1.51M.
- September 2011 revenue increased by approximately 39.45% compared with the previous month.
- December 2011 recorded a substantial decline compared with November.

## How to run the project

### Prerequisites

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- The Online Retail dataset loaded into a database named `ECommerce_Analytics` as `dbo.OnlineRetail`, with the columns referenced in the script

### Steps

1. Create or open the `ECommerce_Analytics` database.
2. Import the Online Retail source data into `dbo.OnlineRetail`.
3. Open `ECommerce_Sales_Customer_Analytics.sql` in SSMS.
4. Execute the script sections in order.
5. Review the result sets for overall performance, monthly sales, products, customers, customer types, geographic performance, and monthly revenue growth.

## Repository contents

```text
ecommerce-sales-customer-analytics-sql/
├── ECommerce_Sales_Customer_Analytics.sql
├── README.md
├── Screenshot 2026-09-05 001944.png
├── Screenshot 2026-09-05 002510.png
├── Screenshot 2026-09-05 002644.png
└── Screenshot 2026-09-05 002759.png
```

## Project screenshots

### Overall business performance

![Overall Performance](./Screenshot%202026-09-05%20001944.png)

### Monthly sales performance

![Monthly Sales](./Screenshot%202026-09-05%20002510.png)

### Top products

![Top Products](./Screenshot%202026-09-05%20002644.png)

### Customer analysis

![Customer Analysis](./Screenshot%202026-09-05%20002759.png)

## Key takeaway

This project demonstrates how SQL Server can be used to prepare transactional data, answer business questions, calculate performance metrics, and communicate findings through structured query results.

**Author:** Mahi Khandelwal
