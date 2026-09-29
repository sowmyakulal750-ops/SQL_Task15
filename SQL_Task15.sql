use trigger_db;
CREATE TABLE vendors (
    vendor_id INT PRIMARY KEY,
    vendor_date DATE,
    vendor_name VARCHAR(70),
    description VARCHAR(100),
    debit DECIMAL(10,2),
    credit DECIMAL(10,2)
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(160) NOT NULL,
    email VARCHAR(254) UNIQUE,
    outstanding_balance DECIMAL(10,2)
);

CREATE TABLE ledger_accounts (
    ledger_id INT PRIMARY KEY,
    ledger_code VARCHAR(20) NOT NULL UNIQUE,
    ledger_name VARCHAR(120) NOT NULL,
    category VARCHAR(90)
);

CREATE TABLE purchase_bills (
    bill_id BIGINT PRIMARY KEY,
    bill_number VARCHAR(40) NOT NULL UNIQUE,
    supplier_id INT,
    bill_date DATE
);

INSERT INTO vendors
(vendor_id, vendor_date, vendor_name, description, debit, credit)
VALUES
(1, '2026-02-01', 'TechWorld Suppliers', 'Computer accessories purchased', 18000, 0),
(2, '2026-02-03', 'Prime Stationers', 'Office stationery purchased', 7500, 0),
(3, '2026-02-06', 'Metro Equipment', 'Office equipment purchased', 32000, 0),
(4, '2026-02-09', 'FreshMart Distributors', 'Cleaning materials purchased', 5600, 0),
(5, '2026-02-12', 'Global Office Solutions', 'Office furniture purchased', 22500, 0);

SELECT * FROM vendors;

INSERT INTO suppliers
(supplier_id, supplier_name, email, outstanding_balance)
VALUES
(1, 'Vertex Enterprises', 'billing@vertex.com', 680.00),
(2, 'Royal Traders', 'accounts@royaltraders.com', 925.50),
(3, 'Urban Supplies', 'finance@urbansupplies.com', 310.25),
(4, 'Elite Business Mart', 'payable@elitebusiness.com', 1450.00),
(5, 'Greenline Distributors', 'accounts@greenline.com', 575.75);

SELECT * FROM suppliers;

INSERT INTO ledger_accounts
(ledger_id, ledger_code, ledger_name, category)
VALUES
(1, '1050', 'Bank Account', 'ASSET'),
(2, '1250', 'Supplier Receivables', 'ASSET'),
(3, '2150', 'Purchase Payables', 'LIABILITY'),
(4, '4200', 'Product Revenue', 'REVENUE'),
(5, '5300', 'Administrative Expense', 'EXPENSE');

SELECT * FROM ledger_accounts;

INSERT INTO purchase_bills
(bill_id, bill_number, supplier_id, bill_date)
VALUES
(1, 'PB-2026-201', 1, '2026-02-14'),
(2, 'PB-2026-202', 2, '2026-02-18'),
(3, 'PB-2026-203', 3, '2026-03-03'),
(4, 'PB-2026-204', 4, '2026-03-11'),
(5, 'PB-2026-205', 5, '2026-03-20');

SELECT * FROM purchase_bills;

CREATE TABLE Members (
    Member_ID VARCHAR(10) PRIMARY KEY,
    Member_Name VARCHAR(50),
    Gender VARCHAR(10),
    City VARCHAR(50),
    Age INT,
    Membership_Type VARCHAR(20)
);

INSERT INTO Members VALUES
(1, 'Ananya', 'Female', 'Udupi', 21, 'Premium'),
(2, 'Kavya', 'Female', 'Bengaluru', 24, 'Standard'),
(3, 'Rahul', 'Male', 'Mysuru', 29, 'Premium'),
(4, 'Nikhil', 'Male', 'Hubballi', 35, 'Standard'),
(5, 'Meera', 'Female', 'Udupi', 27, 'Premium');

SELECT * FROM Members;

UPDATE Members
SET City = 'Mangaluru'
WHERE Member_ID = 1;

SELECT * FROM Members;

SELECT *
FROM Members
WHERE Age BETWEEN 20 AND 30;

SELECT COUNT(DISTINCT City) AS Total_Cities
FROM Members;

SELECT
    SUM(debit) AS Total_Debit,
    SUM(credit) AS Total_Credit
FROM vendors;

SELECT
    vendor_name,
    CASE
        WHEN debit > credit
        THEN debit - credit
        ELSE 0
    END AS Debit_Balance,
    CASE
        WHEN credit > debit
        THEN credit - debit
        ELSE 0
    END AS Credit_Balance
FROM vendors;

CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(60),
    contact_number BIGINT
);

CREATE TABLE Purchase (
    purchase_id INT PRIMARY KEY,
    supplier_id INT,
    purchase_amount INT,
    due_date DATE,
    FOREIGN KEY (supplier_id)
    REFERENCES Supplier(supplier_id)
);

CREATE TABLE Payment_Record (
    payment_id INT PRIMARY KEY,
    purchase_id INT,
    payment_amount DECIMAL(10,2),
    FOREIGN KEY (purchase_id)
    REFERENCES Purchase(purchase_id)
);

INSERT INTO Supplier
(supplier_id, supplier_name, contact_number)
VALUES
(1, 'Apex Traders', 9845123678),
(2, 'Bluebell Suppliers', 8765234190),
(3, 'Starline Enterprises', 9987652341);

SELECT * FROM Supplier;

INSERT INTO Purchase
(purchase_id, supplier_id, purchase_amount, due_date)
VALUES
(201, 1, 12000, '2026-05-15'),
(202, 2, 18500, '2026-05-20'),
(203, 3, 15000, '2026-05-25');

SELECT * FROM Purchase;

INSERT INTO Payment_Record
(payment_id, purchase_id, payment_amount)
VALUES
(3001, 201, 8000),
(3002, 202, 12500),
(3003, 203, 10000);

SELECT * FROM Payment_Record;

CREATE VIEW supplier_balance AS
SELECT
    s.supplier_name,
    p.purchase_amount,
    r.payment_amount,
    p.purchase_amount - r.payment_amount AS balance
FROM Supplier s
JOIN Purchase p
ON s.supplier_id = p.supplier_id
JOIN Payment_Record r
ON p.purchase_id = r.purchase_id;

SELECT * FROM supplier_balance;

CREATE VIEW supplier_overdue_balance AS
SELECT
    s.supplier_name,
    p.purchase_amount,
    r.payment_amount,
    p.purchase_amount - r.payment_amount AS balance,
    DATEDIFF(CURDATE(), p.due_date) AS days_overdue
FROM Supplier s
JOIN Purchase p
ON s.supplier_id = p.supplier_id
JOIN Payment_Record r
ON p.purchase_id = r.purchase_id;

SELECT * FROM supplier_overdue_balance;

CREATE TABLE business_transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    division VARCHAR(40),
    transaction_category VARCHAR(50),
    amount INT
);

INSERT INTO business_transactions
(transaction_id, transaction_date, division, transaction_category, amount)
VALUES
(1, '2026-01-04', 'Retail', 'Revenue', 62000),
(2, '2026-01-09', 'Operations', 'Cost', 14500),
(3, '2026-01-14', 'Human Resources', 'Cost', 9000),
(4, '2026-01-18', 'Finance', 'Revenue', 41000),
(5, '2026-01-23', 'Technology', 'Cost', 21000),
(6, '2026-02-05', 'Retail', 'Revenue', 58000),
(7, '2026-02-10', 'Operations', 'Cost', 17000),
(8, '2026-02-16', 'Human Resources', 'Cost', 8500),
(9, '2026-02-22', 'Finance', 'Revenue', 47000);

SELECT * FROM business_transactions;

SELECT
    YEAR(transaction_date) AS Year,
    MONTH(transaction_date) AS Month,
    SUM(amount) AS Total_Amount
FROM business_transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date);

CREATE TABLE monthly_revenue (
    revenue_month DATE,
    client_name VARCHAR(50),
    revenue DECIMAL(12,2)
);

INSERT INTO monthly_revenue
(revenue_month, client_name, revenue)
VALUES
('2026-01-01', 'Neha', 95000),
('2026-02-01', 'Vikram', 125000),
('2026-03-01', 'Aarav', 115000),
('2026-04-01', 'Ishita', 145000),
('2026-05-01', 'Vikram', 135000);

SELECT * FROM monthly_revenue;

SELECT
    revenue_month,
    client_name,
    revenue,
    RANK() OVER(ORDER BY revenue DESC) AS revenue_rank
FROM monthly_revenue;

SELECT
    revenue_month,
    client_name,
    revenue,
    DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_dense_rank
FROM monthly_revenue;

SELECT
    revenue_month,
    client_name,
    revenue,
    ROW_NUMBER() OVER(ORDER BY revenue DESC) AS revenue_row_number
FROM monthly_revenue;

SELECT
    revenue_month,
    revenue,
    LAG(revenue, 1) OVER(ORDER BY revenue_month) AS previous_month_revenue
FROM monthly_revenue;

SELECT
    revenue_month,
    revenue,
    LEAD(revenue, 1) OVER(ORDER BY revenue_month) AS next_month_revenue
FROM monthly_revenue;

SELECT
    revenue_month,
    revenue,
    SUM(revenue) OVER(ORDER BY revenue_month) AS running_total
FROM monthly_revenue;

SELECT
    revenue_month,
    revenue,
    LAG(revenue, 1) OVER(ORDER BY revenue_month) AS previous_month_revenue,
    (revenue - LAG(revenue, 1) OVER(ORDER BY revenue_month))
    / LAG(revenue, 1) OVER(ORDER BY revenue_month) * 100
    AS growth_percentage
FROM monthly_revenue;

CREATE TABLE quarterly_finance (
    record_id INT PRIMARY KEY,
    client_name VARCHAR(90),
    quarter_name VARCHAR(50),
    revenue DECIMAL(10,2),
    expenses DECIMAL(10,2),
    tax_rate DECIMAL(5,2)
);

INSERT INTO quarterly_finance
VALUES
(1, 'Rohan', 'Q1', 72000, 35000, 12),
(2, 'Sneha', 'Q1', 68000, 29000, 12),
(3, 'Varun', 'Q1', 55000, 24000, 12),
(4, 'Rohan', 'Q2', 81000, 39000, 12),
(5, 'Sneha', 'Q2', 76000, 34000, 12),
(6, 'Varun', 'Q2', 62000, 28000, 12),
(7, 'Rohan', 'Q3', 88000, 42000, 12),
(8, 'Sneha', 'Q3', 79000, 37000, 12),
(9, 'Varun', 'Q3', 69000, 31000, 12);

SELECT * FROM quarterly_finance;

DELIMITER //

CREATE PROCEDURE CalculateProfit(
    IN P_revenue DECIMAL(10,2),
    IN P_expenses DECIMAL(10,2)
)
BEGIN
    SELECT
        P_revenue AS Total_Revenue,
        P_expenses AS Total_Expenses,
        P_revenue - P_expenses AS Net_Profit;
END //

DELIMITER ;

CALL CalculateProfit(80000, 35000);

CALL CalculateProfit(95000, 42000);

CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY,
    ledger_name VARCHAR(90),
    transaction_category VARCHAR(60),
    amount DECIMAL(10,2),
    transaction_date DATE
);

INSERT INTO financial_transactions
VALUES
(1, 'Sales Ledger', 'Revenue', 65000, '2026-09-05'),
(2, 'Expense Ledger', 'Purchase', 18000, '2026-08-12'),
(3, 'Service Ledger', 'Income', 42000, '2026-07-18');

CREATE TABLE transaction_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT,
    ledger_name VARCHAR(90),
    transaction_category VARCHAR(60),
    amount DECIMAL(10,2),
    action_type VARCHAR(70),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER after_financial_transaction_insert
AFTER INSERT ON financial_transactions
FOR EACH ROW
BEGIN
    INSERT INTO transaction_audit
    (transaction_id, ledger_name, transaction_category, amount, action_type)
    VALUES
    (NEW.transaction_id, NEW.ledger_name,
     NEW.transaction_category, NEW.amount, 'INSERT');
END //

DELIMITER ;

INSERT INTO financial_transactions
VALUES
(4, 'Office Ledger', 'Expense', 27000, '2026-06-21');

SELECT * FROM transaction_audit;

DELIMITER //

CREATE TRIGGER after_financial_transaction_update
AFTER UPDATE ON financial_transactions
FOR EACH ROW
BEGIN
    INSERT INTO transaction_audit
    (transaction_id, ledger_name, transaction_category, amount, action_type)
    VALUES
    (NEW.transaction_id, NEW.ledger_name,
     NEW.transaction_category, NEW.amount, 'UPDATE');
END //

DELIMITER ;

UPDATE financial_transactions
SET amount = 30000
WHERE transaction_id = 4;

SELECT * FROM transaction_audit;

DELIMITER //

CREATE TRIGGER after_financial_transaction_delete
AFTER DELETE ON financial_transactions
FOR EACH ROW
BEGIN
    INSERT INTO transaction_audit
    (transaction_id, ledger_name, transaction_category, amount, action_type)
    VALUES
    (OLD.transaction_id, OLD.ledger_name,
     OLD.transaction_category, OLD.amount, 'DELETE');
END //

DELIMITER ;

DELETE FROM financial_transactions
WHERE transaction_id = 3;

SELECT * FROM transaction_audit;

CREATE DATABASE finance_security;

USE finance_security;

CREATE TABLE Client_Master (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(60),
    email VARCHAR(100)
);

CREATE TABLE Account_Transactions (
    transaction_id INT PRIMARY KEY,
    client_id INT,
    amount DECIMAL(10,2),
    transaction_date DATE,
    FOREIGN KEY(client_id)
    REFERENCES Client_Master(client_id)
);

CREATE TABLE Employee_Payroll (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(60),
    salary DECIMAL(10,2)
);

CREATE USER 'finance_manager'@'localhost'
IDENTIFIED BY 'finance@321';

CREATE USER 'accounts_officer'@'localhost'
IDENTIFIED BY 'accounts@321';

CREATE USER 'data_clerk'@'localhost'
IDENTIFIED BY 'clerk@321';

GRANT SELECT
ON finance_security.*
TO 'finance_manager'@'localhost';

GRANT SELECT, INSERT, UPDATE
ON finance_security.Account_Transactions
TO 'accounts_officer'@'localhost';

GRANT SELECT
ON finance_security.Client_Master
TO 'accounts_officer'@'localhost';

GRANT SELECT
ON finance_security.Client_Master
TO 'data_clerk'@'localhost';

GRANT DELETE
ON finance_security.Account_Transactions
TO 'accounts_officer'@'localhost';

REVOKE DELETE
ON finance_security.Account_Transactions
FROM 'accounts_officer'@'localhost';

SHOW GRANTS FOR 'finance_manager'@'localhost';