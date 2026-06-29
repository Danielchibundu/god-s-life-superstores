/*
PROJECT: God's Life Superstores Database
FILE: CTEs.sql

Purpose:
Use Common Table Expressions to break complex business queries
into readable steps.
*/

-- 1. Total revenue per order
WITH OrderTotals AS (
    SELECT
        oi.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM OrderItems oi
    GROUP BY oi.order_id
)
SELECT *
FROM OrderTotals
ORDER BY order_total DESC;


-- 2. Customers with total spending
WITH CustomerSpending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM Customers c
    JOIN CustomerOrders o ON c.customer_id = o.customer_id
    JOIN OrderItems oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM CustomerSpending
ORDER BY total_spent DESC;


-- 3. Products with total quantity sold
WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM Products p
    JOIN OrderItems oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT *
FROM ProductSales
ORDER BY total_quantity_sold DESC;