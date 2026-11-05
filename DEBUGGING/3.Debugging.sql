CREATE DATABASE debugging_three;
USE debugging_three;

-- Creating employees table
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

-- Creating departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name) VALUES
(101, 'HR'),
(102, 'Finance'),
(103, 'IT'),
(104, 'Marketing');

-- Creating sales table
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

-- Creating customers table
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

-- Creating orders table (needed for Question 3)
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


-- 1. Get Employees in Finance Department
-- Get names and salaries of employees in the Finance department.

-- Incorrect Code (Comparing department_id with a department name)
SELECT name, salary
FROM employees
WHERE department_id = 'Finance';

-- Correct Code (Join departments table and filter on department_name)
SELECT e.name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';


-- 2. Calculate Total Sales for Each Customer
-- Calculate total sales for each customer.

-- Incorrect Code (customer_name does not exist in sales table)
SELECT customer_name, SUM(amount) AS total_sales
FROM sales
GROUP BY customer_name;

-- Correct Code (Join customers table using customer_id)
SELECT c.customer_name, SUM(s.amount) AS total_sales
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name;


-- 3. Find Customers with an Order Amount of 1000
-- Find customers who have placed orders with an amount of 1000 or more.

-- Incorrect Code (Exact match = 1000 misses higher orders)
SELECT DISTINCT customer_name
FROM orders
WHERE order_amount = 1000;

-- Correct Code (Use >= to include orders of 1000 and above)
SELECT DISTINCT customer_name
FROM orders
WHERE order_amount >= 1000;


-- 4. Find Employees with Salary Greater Than 50000
-- Find employees with a salary greater than 50000.

-- Incorrect Code (=> is not a valid comparison operator)
SELECT name, salary
FROM employees
WHERE salary => 50000;

-- Correct Code (Use > for greater than)
SELECT name, salary
FROM employees
WHERE salary > 50000;


-- 5. Find Customers Whose Name Starts with 'J'
-- Find customers whose name starts with 'J'.

-- Incorrect Code (= does not support wildcard pattern matching)
SELECT customer_name
FROM customers
WHERE customer_name = 'J%';

-- Correct Code (Use LIKE for pattern matching)
SELECT customer_name
FROM customers
WHERE customer_name LIKE 'J%';
