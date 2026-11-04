CREATE DATABASE interview_debugging;
USE interview_debugging;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    salary INT,
    department_id INT
);

INSERT INTO employees (employee_id, name, age, salary, department_id) VALUES
(1, 'John', 30, 60000, 101),
(2, 'Emily', 25, 48000, 102),
(3, 'Michael', 40, 75000, 103),
(4, 'Sara', 35, 56000, 101),
(5, 'David', 28, 49000, 102);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 1000),
(2, 'Mobile', 500),
(3, 'Tablet', 300),
(4, 'Headphones', 100),
(5, 'Smartwatch', 200);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

INSERT INTO customers (customer_id, customer_name) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Alice Johnson'),
(104, NULL),
(105, 'Robert Brown');

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sales (sale_id, customer_id, amount, sale_date) VALUES
(1, 101, 4500.00, '2023-03-15'),
(2, 102, 5500.00, '2023-03-16'),
(3, 103, 7000.00, '2023-03-17'),
(4, 104, 3000.00, '2023-03-18'),
(5, 105, 6000.00, '2023-03-19');

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name) VALUES
(101, 'HR'),
(102, 'Finance'),
(103, 'IT'),
(104, 'Marketing');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    order_amount INT
);

INSERT INTO orders (order_id, customer_name, order_date, order_amount) VALUES
(1, 'John', '2023-05-01', 500),
(2, 'Emily', '2023-05-02', 700),
(3, 'Michael', '2023-05-03', 1200),
(4, 'Sara', '2023-05-04', 450),
(5, 'David', '2023-05-05', 900);


-- 1. Syntax Error Identification
-- Retrieve employee name and age where salary is greater than or equal to 50000.

-- Incorrect Code (Missing comma between column names)
SELECT name age FROM employees WHERE salary >= 50000;

-- Correct Code (Added comma to separate column names)
SELECT name, age 
FROM employees 
WHERE salary >= 50000;


-- 2. Logical Error Detection
-- Retrieve orders placed on either '2023-05-01' or '2023-05-02'.

-- Incorrect Code (Using AND instead of OR for mutually exclusive date conditions)
SELECT * FROM orders WHERE order_date = '2023-05-01' AND order_date = '2023-05-02';

-- Correct Code (Using OR / IN to match multiple dates)
SELECT * 
FROM orders 
WHERE order_date = '2023-05-01' OR order_date = '2023-05-02';


-- 3. Performance Optimization
-- Retrieve sales details where amount is greater than 5000.

-- Incorrect Code (Selecting all columns without optimization)
SELECT * FROM sales WHERE amount > 5000;

-- Correct Code (Create index and select only required columns)
CREATE INDEX idx_amount ON sales(amount);

SELECT sale_id, customer_id, amount, sale_date 
FROM sales 
WHERE amount > 5000;


-- 4. Data Type Mismatch
-- Find product details where price equals 100.

-- Incorrect Code (Comparing numeric data with string literal)
SELECT * FROM products WHERE price = '100';

-- Correct Code (Use numeric literal without quotes)
SELECT product_id, product_name, price 
FROM products 
WHERE price = 100;


-- 5. Incorrect Join Condition
-- Retrieve employee names along with their department names.

-- Incorrect Code (Joining department_id with department_name)
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_name;

-- Correct Code (Joining using matching foreign and primary keys)
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;


-- 6. Incorrect NULL Handling
-- Find all customers whose name is not NULL.

-- Incorrect Code (Using != NULL instead of IS NOT NULL)
SELECT * FROM customers WHERE customer_name != NULL;

-- Correct Code (Properly checking for non-null values with IS NOT NULL)
SELECT * 
FROM customers 
WHERE customer_name IS NOT NULL;


-- 7. Incorrect Use of Aggregate Functions
-- Calculate the total sales amount for each customer ID.

-- Incorrect Code (Selecting non-aggregated column without GROUP BY)
SELECT customer_id, SUM(amount)
FROM sales;

-- Correct Code (Using GROUP BY for proper aggregation)
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;


-- 8. Incorrect Column Selection
-- Retrieve order details from orders table.

-- Incorrect Code (Selecting non-existent column customer_address)
SELECT order_id, customer_address
FROM orders;

-- Correct Code (Select only existing columns)
SELECT order_id, customer_name, order_date, order_amount
FROM orders;