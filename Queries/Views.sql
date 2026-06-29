/*
PROJECT: God's Life Superstores Database
FILE: Views.sql

Purpose:
Create reusable views for business reporting.
*/

-- 1. Sales summary view
CREATE VIEW vw_SalesSummary AS
SELECT
    o.order_id,
    o.order_date,
    b.branch_name,
    c.first_name,
    c.last_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM CustomerOrders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Branches b ON o.branch_id = b.branch_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;
GO


-- 2. Inventory status view
CREATE VIEW vw_InventoryStatus AS
SELECT
    b.branch_name,
    p.product_name,
    i.quantity_in_stock,
    p.selling_price,
    (i.quantity_in_stock * p.selling_price) AS stock_value
FROM Inventory i
JOIN Branches b ON i.branch_id = b.branch_id
JOIN Products p ON i.product_id = p.product_id;
GO