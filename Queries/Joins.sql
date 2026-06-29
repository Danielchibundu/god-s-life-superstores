/*
=============================================================
PROJECT: God's Life Superstores Database
FILE: Joins.sql

DESCRIPTION
Demonstrates how related tables are combined to answer
business questions.

SKILLS
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- Multiple Table Joins
=============================================================
*/

-------------------------------------------------------------
-- 1. Orders with customer names
-------------------------------------------------------------
SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_date
FROM CustomerOrders o
INNER JOIN Customers c
ON o.customer_id = c.customer_id;

-------------------------------------------------------------
-- 2. Products with categories
-------------------------------------------------------------
SELECT
    p.product_name,
    pc.category_name
FROM Products p
INNER JOIN ProductCategories pc
ON p.category_id = pc.category_id;

-------------------------------------------------------------
-- 3. Employees and their branches
-------------------------------------------------------------
SELECT
    e.first_name,
    e.last_name,
    b.branch_name
FROM Employees e
INNER JOIN Branches b
ON e.branch_id = b.branch_id;

-------------------------------------------------------------
-- 4. Products and inventory levels
-------------------------------------------------------------
SELECT
    b.branch_name,
    p.product_name,
    i.quantity_in_stock
FROM Inventory i
INNER JOIN Products p
ON i.product_id = p.product_id
INNER JOIN Branches b
ON i.branch_id = b.branch_id;

-------------------------------------------------------------
-- 5. Suppliers and products supplied
-------------------------------------------------------------
SELECT
    s.supplier_name,
    p.product_name
FROM Suppliers s
INNER JOIN Products p
ON s.supplier_id = p.supplier_id;