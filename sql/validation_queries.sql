-- Validation queries for the Azure Retail Sales ETL project.
-- Run these after the ADF Copy activity completes.

-- 1. Check the number of rows and total revenue.
SELECT
    COUNT(*) AS TotalRows,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM dbo.RetailSales;

-- 2. Inspect sample rows and the computed TotalAmount column.
SELECT TOP 5
    OrderID,
    OrderDate,
    Product,
    Category,
    Quantity,
    UnitPrice,
    Region,
    CustomerType,
    TotalAmount
FROM dbo.RetailSales
ORDER BY OrderID;

-- 3. Check for duplicate order IDs (should return no rows because OrderID is a primary key).
SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM dbo.RetailSales
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- 4. Check for values that would be suspicious in a retail sales dataset.
SELECT *
FROM dbo.RetailSales
WHERE Quantity <= 0
   OR UnitPrice < 0
   OR OrderDate IS NULL
   OR Product IS NULL
   OR Category IS NULL;
