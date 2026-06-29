-- God's Life Superstores Database
-- Business Insights Queries
-- Purpose: Analyse sales, customers, products, inventory and branch performance.


-- 1. Total sales by branch
SELECT
    b.branch_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Branches b
JOIN CustomerOrders o ON b.branch_id = o.branch_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY b.branch_name
ORDER BY total_sales DESC;


-- 2. Best-selling products
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;


-- 3. Top customers by spending
SELECT
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM Customers c
JOIN CustomerOrders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY c.first_name, c.last_name
ORDER BY total_spent DESC;


-- 4. Low stock products
SELECT
    b.branch_name,
    p.product_name,
    i.quantity_in_stock
FROM Inventory i
JOIN Branches b ON i.branch_id = b.branch_id
JOIN Products p ON i.product_id = p.product_id
WHERE i.quantity_in_stock < 20
ORDER BY i.quantity_in_stock ASC;