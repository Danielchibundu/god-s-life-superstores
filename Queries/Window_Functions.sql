/*
PROJECT: God's Life Superstores Database
FILE: Window_Functions.sql

Purpose:
Use window functions to rank, compare and analyse data without
collapsing rows.
*/

-- 1. Rank products by revenue
SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name;


-- 2. Rank customers by spending
SELECT
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS customer_rank
FROM Customers c
JOIN CustomerOrders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY c.first_name, c.last_name;


-- 3. Running sales total by order date
SELECT
    o.order_date,
    o.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_total,
    SUM(SUM(oi.quantity * oi.unit_price)) OVER (
        ORDER BY o.order_date, o.order_id
    ) AS running_sales_total
FROM CustomerOrders o
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY o.order_date, o.order_id
ORDER BY o.order_date, o.order_id;