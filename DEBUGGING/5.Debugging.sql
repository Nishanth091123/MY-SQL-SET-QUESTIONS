CREATE DATABASE debugging_five;
USE debugging_five;

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


-- 1. Find the Average Age of Employees in the Finance Department
-- Find the average age of employees in the Finance department.

-- Incorrect Code (department_name does not exist in employees table)
SELECT AVG(age)
FROM employees
WHERE department_name = 'Finance';

-- Correct Code (Join departments table and filter on department_name)
SELECT AVG(e.age) AS average_age
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';


-- 2. Retrieve the Total Number of Sales for Each Customer
-- Retrieve the total number of sales for each customer.

-- Incorrect Code (Missing GROUP BY for aggregation)
SELECT customer_name, COUNT(amount)
FROM sales
JOIN customers ON sales.customer_id = customers.customer_id;

-- Correct Code (GROUP BY customer to count sales per customer)
SELECT c.customer_name, COUNT(s.sale_id) AS total_sales
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name;


-- 3. Find Employees Who Earn More Than the Department Average Salary
-- Find all employees who earn more than their department's average salary.

-- Incorrect Code (Aggregate function AVG() cannot be used directly in WHERE)
SELECT name, salary
FROM employees
WHERE salary > AVG(salary);

-- Correct Code (Use a correlated subquery to get each department's average)
SELECT e.name, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(salary)
                  FROM employees
                  WHERE department_id = e.department_id);


-- 4. Retrieve Department Name and Number of Employees
-- Retrieve department name and the number of employees in each department.

-- Incorrect Code (Missing GROUP BY with aggregate COUNT())
SELECT department_name, COUNT(*) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Correct Code (Use GROUP BY department_name)
SELECT d.department_name, COUNT(*) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


-- 5. Find Employees Younger Than 30
-- Find employees younger than 30.

-- Incorrect Code (=> is not a valid operator and the condition direction is wrong)
SELECT name, age
FROM employees
WHERE age => 30;

-- Correct Code (Use < operator for younger than)
SELECT name, age
FROM employees
WHERE age < 30;
