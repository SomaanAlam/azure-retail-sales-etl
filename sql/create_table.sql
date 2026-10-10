-- Create the destination table for the retail sales ETL project.
-- Run this in the sqldb-retail-sales database.

CREATE TABLE dbo.RetailSales (
    OrderID INT NOT NULL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    Product NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Region NVARCHAR(50) NOT NULL,
    CustomerType NVARCHAR(20) NOT NULL,
    TotalAmount AS (Quantity * UnitPrice) PERSISTED
);
