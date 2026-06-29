/*
===========================================================
PROJECT: God's Life Superstores Database
FILE: KPI Reporting
AUTHOR: Daniel Chibundu Onyenweaku

Purpose:
Generate executive KPIs for retail management.
===========================================================
*/

-----------------------------------------------------------
-- KPI 1: Total Revenue
-----------------------------------------------------------

SELECT
    SUM(oi.quantity * oi.unit_price) AS TotalRevenue
FROM OrderItems oi;


-----------------------------------------------------------
-- KPI 2: Total Customers
-----------------------------------------------------------

SELECT COUNT(*) AS TotalCustomers
FROM Customers;


-----------------------------------------------------------
-- KPI 3: Total Products
-----------------------------------------------------------

SELECT COUNT(*) AS TotalProducts
FROM Products;


-----------------------------------------------------------
-- KPI 4: Total Employees
-----------------------------------------------------------

SELECT COUNT(*) AS TotalEmployees
FROM Employees;


-----------------------------------------------------------
-- KPI 5: Total Branches
-----------------------------------------------------------

SELECT COUNT(*) AS TotalBranches
FROM Branches;


-----------------------------------------------------------
-- KPI 6: Average Order Value
-----------------------------------------------------------

SELECT
AVG(OrderTotal) AS AverageOrderValue
FROM
(
    SELECT
        order_id,
        SUM(quantity * unit_price) AS OrderTotal
    FROM OrderItems
    GROUP BY order_id
) AS Orders;