USE ECommerce_Analytics;
GO
-- =====================================================
-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- =====================================================

-- Dataset: Online Retail Dataset
-- Database: ECommerce_Analytics
-- Main Table: dbo.OnlineRetail
-- Clean Table: dbo.CleanOnlineRetail

-- =====================================================
-- 1. DATA QUALITY & CLEANING
-- =====================================================

-- Check missing values
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Description) AS Description_Not_Null,
    COUNT(InvoiceDate) AS InvoiceDate_Not_Null,
    COUNT(CustomerID) AS CustomerID_Not_Null,
    COUNT(UnitPrice) AS UnitPrice_Not_Null
FROM dbo.OnlineRetail;


-- Check quantity range
SELECT
    MIN(Quantity) AS Minimum_Quantity,
    MAX(Quantity) AS Maximum_Quantity,
    AVG(CAST(Quantity AS DECIMAL(18,2))) AS Average_Quantity
FROM dbo.OnlineRetail;


-- Check unit price range
SELECT
    MIN(UnitPrice) AS Minimum_Price,
    MAX(UnitPrice) AS Maximum_Price,
    AVG(UnitPrice) AS Average_Price
FROM dbo.OnlineRetail;


-- Identify cancelled transactions
SELECT
    COUNT(*) AS Cancelled_Transactions
FROM dbo.OnlineRetail
WHERE InvoiceNo LIKE 'C%';


-- Identify negative price records
SELECT
    COUNT(*) AS Negative_Price_Rows
FROM dbo.OnlineRetail
WHERE UnitPrice < 0;


-- Check negative quantity adjustment records
SELECT
    COUNT(*) AS Negative_Qty_Zero_Price
FROM dbo.OnlineRetail
WHERE Quantity < 0
  AND UnitPrice = 0;


-- Create cleaned dataset only if it does not already exist
IF OBJECT_ID('dbo.CleanOnlineRetail', 'U') IS NULL
BEGIN

    SELECT
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        TRY_CONVERT(datetime2, InvoiceDate, 105) AS InvoiceDate,
        UnitPrice,
        CustomerID,
        Country,
        CAST(Quantity * UnitPrice AS DECIMAL(18,2)) AS Revenue
    INTO dbo.CleanOnlineRetail
    FROM dbo.OnlineRetail
    WHERE
        InvoiceNo NOT LIKE 'C%'
        AND UnitPrice >= 0
        AND NOT (Quantity < 0 AND UnitPrice = 0)
        AND ABS(Quantity) < 80995;

END;

-- 2. Overall Business Performance
SELECT
    SUM(Revenue) AS Total_Revenue,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    COUNT(DISTINCT CustomerID) AS Total_Customers,
    SUM(Quantity) AS Total_Units_Sold,
    CAST(
        SUM(Revenue) / NULLIF(COUNT(DISTINCT InvoiceNo), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value
FROM dbo.CleanOnlineRetail;

-- 3. Monthly Sales Performance

SELECT
    YEAR(InvoiceDate) AS Sales_Year,
    MONTH(InvoiceDate) AS Sales_Month,
    DATENAME(MONTH, InvoiceDate) AS Month_Name,
    SUM(Revenue) AS Monthly_Revenue,
    COUNT(DISTINCT InvoiceNo) AS Monthly_Orders,
    CAST(
        SUM(Revenue) / NULLIF(COUNT(DISTINCT InvoiceNo), 0)
        AS DECIMAL(18,2)
    ) AS Monthly_AOV
FROM dbo.CleanOnlineRetail
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate),
    DATENAME(MONTH, InvoiceDate)
ORDER BY
    Sales_Year,
    Sales_Month;
-- 4. Top Products by Revenue
SELECT TOP 10
    StockCode,
    Description,
    SUM(Quantity) AS Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    COUNT(DISTINCT InvoiceNo) AS Number_of_Orders
FROM dbo.CleanOnlineRetail
WHERE Description IS NOT NULL
  AND StockCode NOT IN ('POST', 'M', 'DOT')
GROUP BY
    StockCode,
    Description
ORDER BY
    Total_Revenue DESC;
-- 5. Top Customers by Revenue
SELECT TOP 10
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Number_of_Orders,
    SUM(Quantity) AS Units_Purchased,
    SUM(Revenue) AS Total_Spent,
    CAST(
        SUM(Revenue) / NULLIF(COUNT(DISTINCT InvoiceNo), 0)
        AS DECIMAL(18,2)
    ) AS Customer_AOV
FROM dbo.CleanOnlineRetail
WHERE CustomerID IS NOT NULL
GROUP BY
    CustomerID
ORDER BY
    Total_Spent DESC;
-- 6. Customer Revenue Contribution
WITH CustomerSales AS
(
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS Number_of_Orders,
        SUM(Revenue) AS Total_Spent
    FROM dbo.CleanOnlineRetail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT TOP 10
    CustomerID,
    Number_of_Orders,
    Total_Spent,
    RANK() OVER (
        ORDER BY Total_Spent DESC
    ) AS Customer_Rank,
    CAST(
        Total_Spent * 100.0 / SUM(Total_Spent) OVER ()
        AS DECIMAL(10,2)
    ) AS Revenue_Contribution_Percent
FROM CustomerSales
ORDER BY Customer_Rank;
-- 7. One-Time vs Repeat Customers
WITH CustomerOrders AS
(
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS Number_of_Orders
    FROM dbo.CleanOnlineRetail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT
    CASE
        WHEN Number_of_Orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Customer_Type,
    COUNT(*) AS Number_of_Customers,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Customer_Percentage
FROM CustomerOrders
GROUP BY
    CASE
        WHEN Number_of_Orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END;
-- 8. Geographic Performance
SELECT TOP 10
    Country,
    COUNT(DISTINCT InvoiceNo) AS Number_of_Orders,
    COUNT(DISTINCT CustomerID) AS Number_of_Customers,
    SUM(Quantity) AS Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    CAST(
        SUM(Revenue) / NULLIF(COUNT(DISTINCT InvoiceNo), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value
FROM dbo.CleanOnlineRetail
WHERE CustomerID IS NOT NULL
GROUP BY Country
ORDER BY Total_Revenue DESC;
-- 9. Monthly Revenue Growth
WITH MonthlySales AS
(
    SELECT
        YEAR(InvoiceDate) AS Sales_Year,
        MONTH(InvoiceDate) AS Sales_Month,
        DATENAME(MONTH, InvoiceDate) AS Month_Name,
        SUM(Revenue) AS Monthly_Revenue
    FROM dbo.CleanOnlineRetail
    GROUP BY
        YEAR(InvoiceDate),
        MONTH(InvoiceDate),
        DATENAME(MONTH, InvoiceDate)
),
MonthlyGrowth AS
(
    SELECT
        Sales_Year,
        Sales_Month,
        Month_Name,
        Monthly_Revenue,
        LAG(Monthly_Revenue) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) AS Previous_Month_Revenue
    FROM MonthlySales
)
SELECT
    Sales_Year,
    Sales_Month,
    Month_Name,
    Monthly_Revenue,
    Previous_Month_Revenue,
    CAST(
        (Monthly_Revenue - Previous_Month_Revenue)
        * 100.0 / NULLIF(Previous_Month_Revenue, 0)
        AS DECIMAL(10,2)
    ) AS Revenue_Growth_Percent
FROM MonthlyGrowth
ORDER BY
    Sales_Year,
    Sales_Month;
-- =============================================
-- END OF PROJECT
-- =============================================

