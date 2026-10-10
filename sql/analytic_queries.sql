-- Business analytics queries for the Azure Retail Sales ETL project.

-- 1. Revenue and units sold by category.
SELECT
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(TotalAmount) AS SalesRevenue
FROM dbo.RetailSales
GROUP BY Category
ORDER BY SalesRevenue DESC;

-- 2. Revenue and order count by region.
SELECT
    Region,
    COUNT(*) AS NumberOfOrders,
    SUM(TotalAmount) AS SalesRevenue
FROM dbo.RetailSales
GROUP BY Region
ORDER BY SalesRevenue DESC;

-- 3. Revenue, units, order count, and average order value by customer type.
SELECT
    CustomerType,
    COUNT(*) AS NumberOfOrders,
    SUM(Quantity) AS UnitsSold,
    SUM(TotalAmount) AS SalesRevenue,
    CAST(
        AVG(CAST(TotalAmount AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AverageOrderValue
FROM dbo.RetailSales
GROUP BY CustomerType
ORDER BY SalesRevenue DESC;

-- 4. Revenue by product.
SELECT
    Product,
    SUM(Quantity) AS UnitsSold,
    SUM(TotalAmount) AS SalesRevenue
FROM dbo.RetailSales
GROUP BY Product
ORDER BY SalesRevenue DESC;

-- 5. Revenue by order date.
SELECT
    OrderDate,
    COUNT(*) AS NumberOfOrders,
    SUM(TotalAmount) AS SalesRevenue
FROM dbo.RetailSales
GROUP BY OrderDate
ORDER BY OrderDate;
