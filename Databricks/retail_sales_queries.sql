-- Retail sales analysis: Databricks notebook queries
-- Assumes the CSV was uploaded as a table named retail_sales
-- (Databricks: New > Add or upload data > Create or modify table).
-- If your table lands in a different catalog/schema, change the name below,
-- e.g. workspace.default.retail_sales
-- Paste each query into its own notebook cell (language: SQL).

-- 1. Sanity check: confirm the load and the column types
SELECT * FROM retail_sales LIMIT 15;
DESCRIBE retail_sales;

-- 2. Headline KPIs
SELECT
  COUNT(DISTINCT OrderID)                                   AS orders,
  SUM(Quantity)                                             AS units_sold,
  ROUND(SUM(Quantity * UnitPrice), 2)                       AS total_revenue,
  ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT OrderID), 2) AS avg_order_value
FROM retail_sales;

-- 3. Revenue by category, with share of total
SELECT
  Category,
  SUM(Quantity)                                             AS units_sold,
  ROUND(SUM(Quantity * UnitPrice), 2)                       AS revenue,
  ROUND(100 * SUM(Quantity * UnitPrice)
        / SUM(SUM(Quantity * UnitPrice)) OVER (), 1)        AS pct_of_revenue
FROM retail_sales
GROUP BY Category
ORDER BY revenue DESC;

-- 4. Revenue by region
SELECT
  Region,
  COUNT(*)                                                  AS orders,
  ROUND(SUM(Quantity * UnitPrice), 2)                       AS revenue,
  ROUND(AVG(Quantity * UnitPrice), 2)                       AS avg_order_value
FROM retail_sales
GROUP BY Region
ORDER BY revenue DESC;

-- 5. Retail vs Business customers
SELECT
  CustomerType,
  COUNT(*)                                                  AS orders,
  SUM(Quantity)                                             AS units_sold,
  ROUND(SUM(Quantity * UnitPrice), 2)                       AS revenue,
  ROUND(AVG(Quantity * UnitPrice), 2)                       AS avg_order_value
FROM retail_sales
GROUP BY CustomerType
ORDER BY revenue DESC;

-- 6. Product ranking by revenue
SELECT
  Product,
  Category,
  SUM(Quantity)                                             AS units_sold,
  ROUND(SUM(Quantity * UnitPrice), 2)                       AS revenue,
  RANK() OVER (ORDER BY SUM(Quantity * UnitPrice) DESC)     AS revenue_rank
FROM retail_sales
GROUP BY Product, Category
ORDER BY revenue_rank;

-- 7. Daily revenue with running total (window function)
WITH daily AS (
  SELECT
    CAST(OrderDate AS DATE)                                 AS order_date,
    ROUND(SUM(Quantity * UnitPrice), 2)                     AS daily_revenue
  FROM retail_sales
  GROUP BY CAST(OrderDate AS DATE)
)
SELECT
  order_date,
  daily_revenue,
  ROUND(SUM(daily_revenue) OVER (ORDER BY order_date), 2)   AS running_total
FROM daily
ORDER BY order_date;

-- 8. Region x customer type revenue matrix
SELECT
  Region,
  ROUND(SUM(CASE WHEN CustomerType = 'Retail'   THEN Quantity * UnitPrice END), 2) AS retail_revenue,
  ROUND(SUM(CASE WHEN CustomerType = 'Business' THEN Quantity * UnitPrice END), 2) AS business_revenue,
  ROUND(SUM(Quantity * UnitPrice), 2)                                              AS total_revenue
FROM retail_sales
GROUP BY Region
ORDER BY total_revenue DESC;

-- 9. Best-selling product within each category (CTE + window function)
WITH product_rev AS (
  SELECT
    Category,
    Product,
    SUM(Quantity * UnitPrice)                               AS revenue
  FROM retail_sales
  GROUP BY Category, Product
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY revenue DESC) AS rn
  FROM product_rev
)
SELECT Category, Product, ROUND(revenue, 2) AS revenue
FROM ranked
WHERE rn = 1
ORDER BY revenue DESC;
