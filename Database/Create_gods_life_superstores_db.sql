/* ==========================================================
   GOD'S LIFE SUPERSTORE - RETAIL DATABASE
   SQL SERVER SCRIPT CREATED BY DANIEL CHIBUNDU ONYENWEAKU
   ========================================================== */

CREATE DATABASE GodsLifeSuperstoreDB;
GO

USE GodsLifeSuperstoreDB;
GO

/* ==========================================================
   DROP TABLES IF THEY ALREADY EXIST
   ========================================================== */

DROP TABLE IF EXISTS ReturnItems;
DROP TABLE IF EXISTS SalesReturns;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS CustomerOrders;
DROP TABLE IF EXISTS StockMovements;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS ProductCategories;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS JobRoles;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS Company;
GO

/* ==========================================================
   COMPANY TABLE
   ========================================================== */

CREATE TABLE Company (
    company_id INT IDENTITY(1,1) PRIMARY KEY,
    company_name VARCHAR(150) NOT NULL,
    registration_number VARCHAR(50),
    tax_number VARCHAR(50),
    phone VARCHAR(30),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state_name VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Nigeria',
    created_at DATETIME DEFAULT GETDATE()
);

/* ==========================================================
   BRANCHES TABLE
   ========================================================== */

CREATE TABLE Branches (
    branch_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    branch_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state_name VARCHAR(100),
    opening_date DATE,
    branch_status VARCHAR(30) DEFAULT 'Active',

    CONSTRAINT FK_Branches_Company
        FOREIGN KEY (company_id) REFERENCES Company(company_id),

    CONSTRAINT CK_Branch_Status
        CHECK (branch_status IN ('Active', 'Inactive'))
);

/* ==========================================================
   DEPARTMENTS TABLE
   ========================================================== */

CREATE TABLE Departments (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

/* ==========================================================
   JOB ROLES TABLE
   ========================================================== */

CREATE TABLE JobRoles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

/* ==========================================================
   EMPLOYEES TABLE
   ========================================================== */

CREATE TABLE Employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    department_id INT,
    role_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(20),
    phone VARCHAR(30),
    email VARCHAR(100),
    hire_date DATE NOT NULL,
    salary DECIMAL(12,2),
    employment_status VARCHAR(30) DEFAULT 'Active',

    CONSTRAINT FK_Employees_Branches
        FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),

    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (department_id) REFERENCES Departments(department_id),

    CONSTRAINT FK_Employees_JobRoles
        FOREIGN KEY (role_id) REFERENCES JobRoles(role_id),

    CONSTRAINT CK_Employee_Gender
        CHECK (gender IN ('Male', 'Female')),

    CONSTRAINT CK_Employee_Status
        CHECK (employment_status IN ('Active', 'Inactive', 'Suspended', 'Resigned'))
);

/* ==========================================================
   CUSTOMERS TABLE
   ========================================================== */

CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(20),
    phone VARCHAR(30),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state_name VARCHAR(100),
    loyalty_number VARCHAR(50) UNIQUE,
    registration_date DATE DEFAULT GETDATE(),
    customer_status VARCHAR(30) DEFAULT 'Active',

    CONSTRAINT CK_Customer_Gender
        CHECK (gender IN ('Male', 'Female')),

    CONSTRAINT CK_Customer_Status
        CHECK (customer_status IN ('Active', 'Inactive'))
);

/* ==========================================================
   SUPPLIERS TABLE
   ========================================================== */

CREATE TABLE Suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state_name VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Nigeria',
    supplier_status VARCHAR(30) DEFAULT 'Active',

    CONSTRAINT CK_Supplier_Status
        CHECK (supplier_status IN ('Active', 'Inactive'))
);

/* ==========================================================
   PRODUCT CATEGORIES TABLE
   ========================================================== */

CREATE TABLE ProductCategories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

/* ==========================================================
   PRODUCTS TABLE
   ========================================================== */

CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    supplier_id INT,
    product_name VARCHAR(150) NOT NULL,
    brand VARCHAR(100),
    barcode VARCHAR(50) UNIQUE,
    sku VARCHAR(50) UNIQUE,
    cost_price DECIMAL(12,2) NOT NULL,
    selling_price DECIMAL(12,2) NOT NULL,
    reorder_level INT DEFAULT 10,
    product_status VARCHAR(30) DEFAULT 'Active',

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (category_id) REFERENCES ProductCategories(category_id),

    CONSTRAINT FK_Products_Suppliers
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),

    CONSTRAINT CK_Product_Prices
        CHECK (selling_price >= cost_price),

    CONSTRAINT CK_Product_Status
        CHECK (product_status IN ('Active', 'Inactive'))
);

/* ==========================================================
   INVENTORY TABLE
   ========================================================== */

CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Inventory_Branches
        FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),

    CONSTRAINT FK_Inventory_Products
        FOREIGN KEY (product_id) REFERENCES Products(product_id),

    CONSTRAINT UQ_Inventory_Branch_Product
        UNIQUE (branch_id, product_id),

    CONSTRAINT CK_Inventory_Quantity
        CHECK (quantity_in_stock >= 0)
);

/* ==========================================================
   STOCK MOVEMENTS TABLE
   ========================================================== */

CREATE TABLE StockMovements (
    movement_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    product_id INT NOT NULL,
    movement_type VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    movement_date DATETIME DEFAULT GETDATE(),
    note VARCHAR(255),

    CONSTRAINT FK_StockMovements_Branches
        FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),

    CONSTRAINT FK_StockMovements_Products
        FOREIGN KEY (product_id) REFERENCES Products(product_id),

    CONSTRAINT CK_StockMovement_Type
        CHECK (movement_type IN ('Stock In', 'Stock Out', 'Adjustment', 'Return')),

    CONSTRAINT CK_StockMovement_Quantity
        CHECK (quantity > 0)
);

/* ==========================================================
   CUSTOMER ORDERS TABLE
   ========================================================== */

CREATE TABLE CustomerOrders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    branch_id INT NOT NULL,
    employee_id INT,
    order_date DATETIME DEFAULT GETDATE(),
    order_status VARCHAR(30) DEFAULT 'Completed',
    total_amount DECIMAL(12,2) DEFAULT 0,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),

    CONSTRAINT FK_Orders_Branches
        FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),

    CONSTRAINT FK_Orders_Employees
        FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),

    CONSTRAINT CK_Order_Status
        CHECK (order_status IN ('Pending', 'Completed', 'Cancelled', 'Returned'))
);

/* ==========================================================
   ORDER ITEMS TABLE
   ========================================================== */

CREATE TABLE OrderItems (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) DEFAULT 0,
    line_total DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (order_id) REFERENCES CustomerOrders(order_id),

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (product_id) REFERENCES Products(product_id),

    CONSTRAINT CK_OrderItem_Quantity
        CHECK (quantity > 0),

    CONSTRAINT CK_OrderItem_LineTotal
        CHECK (line_total >= 0)
);

/* ==========================================================
   PAYMENTS TABLE
   ========================================================== */

CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount_paid DECIMAL(12,2) NOT NULL,
    payment_reference VARCHAR(100),
    payment_date DATETIME DEFAULT GETDATE(),
    payment_status VARCHAR(30) DEFAULT 'Successful',

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (order_id) REFERENCES CustomerOrders(order_id),

    CONSTRAINT CK_Payment_Method
        CHECK (payment_method IN ('Cash', 'POS', 'Bank Transfer', 'Mobile Money')),

    CONSTRAINT CK_Payment_Status
        CHECK (payment_status IN ('Successful', 'Pending', 'Failed', 'Refunded'))
);

/* ==========================================================
   SALES RETURNS TABLE
   ========================================================== */

CREATE TABLE SalesReturns (
    return_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    customer_id INT,
    return_date DATETIME DEFAULT GETDATE(),
    reason VARCHAR(255),
    refund_amount DECIMAL(12,2),
    return_status VARCHAR(30) DEFAULT 'Processed',

    CONSTRAINT FK_Returns_Orders
        FOREIGN KEY (order_id) REFERENCES CustomerOrders(order_id),

    CONSTRAINT FK_Returns_Customers
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),

    CONSTRAINT CK_Return_Status
        CHECK (return_status IN ('Pending', 'Processed', 'Rejected'))
);

/* ==========================================================
   RETURN ITEMS TABLE
   ========================================================== */

CREATE TABLE ReturnItems (
    return_item_id INT IDENTITY(1,1) PRIMARY KEY,
    return_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    condition_status VARCHAR(50),
    refund_amount DECIMAL(12,2),

    CONSTRAINT FK_ReturnItems_Returns
        FOREIGN KEY (return_id) REFERENCES SalesReturns(return_id),

    CONSTRAINT FK_ReturnItems_Products
        FOREIGN KEY (product_id) REFERENCES Products(product_id),

    CONSTRAINT CK_ReturnItem_Quantity
        CHECK (quantity > 0)
);

/* ==========================================================
   BASIC INDEXES FOR PERFORMANCE
   ========================================================== */

CREATE INDEX IX_Employees_Branch
ON Employees(branch_id);

CREATE INDEX IX_Products_Category
ON Products(category_id);

CREATE INDEX IX_Inventory_Branch_Product
ON Inventory(branch_id, product_id);

CREATE INDEX IX_Orders_Branch
ON CustomerOrders(branch_id);

CREATE INDEX IX_Orders_Customer
ON CustomerOrders(customer_id);

CREATE INDEX IX_OrderItems_Product
ON OrderItems(product_id);

CREATE INDEX IX_Payments_Order
ON Payments(order_id);
GO

/* ==========================================================
   SAMPLE STARTER DATA
   ========================================================== */

INSERT INTO Company (
    company_name, registration_number, tax_number, phone, email, address, city, state_name
)
VALUES (
    'God''s Life Superstore',
    'GLS-NG-001',
    'TIN-GLS-2026',
    '+2348012345678',
    'info@godslifesuperstore.com',
    'Aba Road',
    'Port Harcourt',
    'Rivers State'
);

INSERT INTO Branches (
    company_id, branch_name, phone, email, address, city, state_name, opening_date
)
VALUES
(1, 'Port Harcourt Main Branch', '+2348011111111', 'ph@godslifesuperstore.com', 'Aba Road', 'Port Harcourt', 'Rivers State', '2026-01-01'),
(1, 'Lagos Branch', '+2348022222222', 'lagos@godslifesuperstore.com', 'Ikeja', 'Lagos', 'Lagos State', '2026-02-01'),
(1, 'Abuja Branch', '+2348033333333', 'abuja@godslifesuperstore.com', 'Wuse', 'Abuja', 'FCT', '2026-03-01');

INSERT INTO Departments (department_name, description)
VALUES
('Sales', 'Handles customer sales'),
('Inventory', 'Manages stock and warehouse activities'),
('Finance', 'Handles payments and records'),
('Customer Service', 'Handles complaints and returns'),
('Management', 'Manages store operations');

INSERT INTO JobRoles (role_name, description)
VALUES
('Store Manager', 'Manages branch operations'),
('Cashier', 'Processes customer payments'),
('Sales Assistant', 'Assists customers with purchases'),
('Inventory Officer', 'Manages stock records'),
('Account Officer', 'Handles financial transactions');

INSERT INTO ProductCategories (category_name, description)
VALUES
('Groceries', 'Food and household consumables'),
('Drinks', 'Soft drinks, bottled water and beverages'),
('Electronics', 'TVs, sound systems and gadgets'),
('Phones and Accessories', 'Phones, chargers and phone accessories'),
('Home Appliances', 'Fridges, freezers, microwaves and blenders'),
('Toiletries', 'Personal care and hygiene products'),
('Cleaning Products', 'Detergents, soaps and cleaning items');

INSERT INTO Suppliers (
    supplier_name, contact_person, phone, email, address, city, state_name
)
VALUES
('Chibundu Wholesale Supplies', 'Daniel Onyenweaku', '+2348044444444', 'sales@chibundusupplies.com', 'Mile 3 Market', 'Port Harcourt', 'Rivers State'),
('Lagos Mega Distributors', 'Adebayo Johnson', '+2348055555555', 'orders@lagosmega.com', 'Trade Fair Complex', 'Lagos', 'Lagos State'),
('Eastern Home Appliances Ltd', 'Chinedu Okafor', '+2348066666666', 'info@easternappliances.com', 'Ariaria Market', 'Aba', 'Abia State');

INSERT INTO Products (
    category_id, supplier_id, product_name, brand, barcode, sku, cost_price, selling_price, reorder_level
)
VALUES
(1, 1, 'Golden Penny Spaghetti', 'Golden Penny', '100000000001', 'GRO-SPA-001', 850.00, 1100.00, 20),
(2, 1, 'Coca-Cola 50cl', 'Coca-Cola', '100000000002', 'DRK-COK-001', 250.00, 350.00, 50),
(2, 1, 'Bottled Water 75cl', 'Eva', '100000000003', 'DRK-WAT-001', 150.00, 250.00, 60),
(3, 3, 'Samsung 43 Inch Smart TV', 'Samsung', '100000000004', 'ELE-TV-001', 280000.00, 350000.00, 5),
(4, 2, 'iPhone Charger USB-C', 'Apple', '100000000005', 'ACC-IPH-001', 8000.00, 12000.00, 15),
(5, 3, 'Hisense Chest Freezer', 'Hisense', '100000000006', 'APP-FRZ-001', 280000.00, 340000.00, 3),
(6, 1, 'Dettol Soap', 'Dettol', '100000000007', 'TOI-DET-001', 600.00, 850.00, 30),
(7, 1, 'Morning Fresh Dishwashing Liquid', 'Morning Fresh', '100000000008', 'CLN-MF-001', 900.00, 1300.00, 25);

INSERT INTO Employees (
    branch_id, department_id, role_id, first_name, last_name, gender, phone, email, hire_date, salary
)
VALUES
(1, 5, 1, 'Daniel', 'Onyenweaku', 'Male', '+2348077777777', 'daniel@godslifesuperstore.com', '2026-01-01', 350000.00),
(1, 1, 2, 'Chioma', 'Okafor', 'Female', '+2348088888888', 'chioma@godslifesuperstore.com', '2026-01-05', 120000.00),
(1, 2, 4, 'Chinedu', 'Nwosu', 'Male', '+2348099999999', 'chinedu@godslifesuperstore.com', '2026-01-10', 150000.00),
(2, 1, 3, 'Adebayo', 'Olawale', 'Male', '+2348010101010', 'adebayo@godslifesuperstore.com', '2026-02-01', 130000.00),
(3, 3, 5, 'Aisha', 'Bello', 'Female', '+2348020202020', 'aisha@godslifesuperstore.com', '2026-03-01', 140000.00);

INSERT INTO Customers (
    first_name, last_name, gender, phone, email, address, city, state_name, loyalty_number
)
VALUES
('Emeka', 'Okoye', 'Male', '+2348030303030', 'emeka@email.com', 'Rumuola', 'Port Harcourt', 'Rivers State', 'GLS-CUS-001'),
('Blessing', 'Afolabi', 'Female', '+2348040404040', 'blessing@email.com', 'Ikeja', 'Lagos', 'Lagos State', 'GLS-CUS-002'),
('Musa', 'Abdullahi', 'Male', '+2348050505050', 'musa@email.com', 'Wuse', 'Abuja', 'FCT', 'GLS-CUS-003');

INSERT INTO Inventory (branch_id, product_id, quantity_in_stock)
SELECT
    b.branch_id,
    p.product_id,
    30
FROM Branches b
CROSS JOIN Products p;
GO