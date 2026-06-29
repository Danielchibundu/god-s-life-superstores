/*
=============================================================
PROJECT: God's Life Superstores Database
FILE: Basic_Queries.sql
AUTHOR: Daniel Chibundu Onyenweaku

DESCRIPTION
Basic SQL queries used to retrieve, filter and sort data.

SKILLS DEMONSTRATED
- SELECT
- DISTINCT
- WHERE
- ORDER BY
- TOP
- IN
- BETWEEN
- LIKE
=============================================================
*/

-------------------------------------------------------------
-- 1. Display all customers
-------------------------------------------------------------
SELECT *
FROM Customers;

-------------------------------------------------------------
-- 2. Display all products
-------------------------------------------------------------
SELECT *
FROM Products;

-------------------------------------------------------------
-- 3. Display all employees
-------------------------------------------------------------
SELECT *
FROM Employees;

-------------------------------------------------------------
-- 4. Display unique product categories
-------------------------------------------------------------
SELECT DISTINCT category_id
FROM Products;

-------------------------------------------------------------
-- 5. Customers from Port Harcourt
-------------------------------------------------------------
SELECT *
FROM Customers
WHERE city = 'Port Harcourt';

-------------------------------------------------------------
-- 6. Products costing more than ₦10,000
-------------------------------------------------------------
SELECT
    product_name,
    selling_price
FROM Products
WHERE selling_price > 10000;

-------------------------------------------------------------
-- 7. Products between ₦2,000 and ₦5,000
-------------------------------------------------------------
SELECT
    product_name,
    selling_price
FROM Products
WHERE selling_price BETWEEN 2000 AND 5000;

-------------------------------------------------------------
-- 8. Female customers
-------------------------------------------------------------
SELECT
    first_name,
    last_name
FROM Customers
WHERE gender = 'Female';

-------------------------------------------------------------
-- 9. Products beginning with 'C'
-------------------------------------------------------------
SELECT
    product_name
FROM Products
WHERE product_name LIKE 'C%';

-------------------------------------------------------------
-- 10. Top 10 expensive products
-------------------------------------------------------------
SELECT TOP 10
    product_name,
    selling_price
FROM Products
ORDER BY selling_price DESC;