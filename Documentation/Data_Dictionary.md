# Data Dictionary

## Purpose

This document describes the key tables and columns used in the God's Life Superstores Database.

---

## Branches

| Column | Description |
|---|---|
| branch_id | Unique identifier for each branch |
| branch_name | Name of the supermarket branch |
| address | Branch address |
| city | City where the branch is located |
| state_name | State where the branch operates |

---

## Customers

| Column | Description |
|---|---|
| customer_id | Unique identifier for each customer |
| first_name | Customer first name |
| last_name | Customer last name |
| gender | Customer gender |
| phone | Customer phone number |
| email | Customer email address |
| address | Customer address |
| city | Customer city |
| state_name | Customer state |

---

## Products

| Column | Description |
|---|---|
| product_id | Unique identifier for each product |
| product_name | Name of the product |
| category_id | Links product to its category |
| supplier_id | Links product to its supplier |
| cost_price | Product purchase price |
| selling_price | Product selling price |

---

## Inventory

| Column | Description |
|---|---|
| inventory_id | Unique inventory record |
| branch_id | Branch where product is stocked |
| product_id | Product held in stock |
| quantity_in_stock | Available quantity |

---

## CustomerOrders

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer who placed the order |
| branch_id | Branch where the sale happened |
| employee_id | Employee who handled the sale |
| order_date | Date of transaction |

---

## OrderItems

| Column | Description |
|---|---|
| order_item_id | Unique order line |
| order_id | Related customer order |
| product_id | Product sold |
| quantity | Quantity purchased |
| unit_price | Product price at sale time |