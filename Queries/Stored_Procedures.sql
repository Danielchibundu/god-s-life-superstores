/*
PROJECT: God's Life Superstores Database
FILE: Stored_Procedures.sql

Purpose:
Create stored procedures for reusable business operations.
*/

-- 1. Get sales by branch
CREATE PROCEDURE sp_GetSalesByBranch
    @BranchName VARCHAR(100)
AS
BEGIN
    SELECT
        branch_name,
        SUM(line_total) AS total_sales
    FROM vw_SalesSummary
    WHERE branch_name = @BranchName
    GROUP BY branch_name;
END;
GO


-- Example:
-- EXEC sp_GetSalesByBranch @BranchName = 'Port Harcourt Branch';


-- 2. Get low stock products
CREATE PROCEDURE sp_GetLowStockProducts
    @StockLimit INT
AS
BEGIN
    SELECT
        branch_name,
        product_name,
        quantity_in_stock
    FROM vw_InventoryStatus
    WHERE quantity_in_stock < @StockLimit
    ORDER BY quantity_in_stock ASC;
END;
GO


-- Example:
-- EXEC sp_GetLowStockProducts @StockLimit = 20;