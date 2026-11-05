CREATE DATABASE debugging_four;
USE debugging_four;

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


-- 1. Calculate Average Salary for Employees Older Than 30
-- Calculate average salary for employees older than 30.

-- Incorrect Code (Using = with a string literal instead of > with a number)
SELECT AVG(salary)
FROM employees
WHERE age = '30';

-- Correct Code (Use > operator with numeric value)
SELECT AVG(salary) AS average_salary
FROM employees
WHERE age > 30;


-- 2. Find Total Sales for Customers Who Spent More Than 5000
-- Find total sales for customers who spent more than 5000.

-- Incorrect Code (Missing GROUP BY; WHERE filters single rows, not the total)
SELECT customer_name, SUM(amount)
FROM sales
JOIN customers ON sales.customer_id = customers.customer_id
WHERE amount > 5000;

-- Correct Code (GROUP BY customer and filter the total using HAVING)
SELECT c.customer_name, SUM(s.amount) AS total_sales
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING SUM(s.amount) > 5000;


-- 3. Find All Unique Department Names
-- Find all unique department names of employees.

-- Incorrect Code (department_name does not exist in employees table)
SELECT DISTINCT department_name
FROM employees;

-- Correct Code (Join departments table to get department_name)
SELECT DISTINCT d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;


-- 4. Find the Highest Salary
-- Find the highest salary from the employees table along with the employee name.

-- Incorrect Code (Non-aggregated column name used with MAX() without GROUP BY)
SELECT name, MAX(salary)
FROM employees;

-- Correct Code (Use a subquery to match the maximum salary)
SELECT name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);


-- 5. Retrieve Employees in the Finance Department
-- Retrieve employees with the same department as 'Finance'.

-- Incorrect Code (department_name does not exist in employees table)
SELECT name, department_name
FROM employees
WHERE department_name = 'Finance';

-- Correct Code (Join departments table using department_id)
SELECT e.name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';
