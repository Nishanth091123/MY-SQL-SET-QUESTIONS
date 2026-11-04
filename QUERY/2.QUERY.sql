CREATE DATABASE coding_two;
USE coding_two;

-- Table Creation & Data Insertion
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    salary INT,
    department_id INT
);

INSERT INTO employees (employee_id, name, age, salary, department_id) VALUES
(1, 'John', 30, 80000, 101),
(2, 'Emily', 25, 50000, 102),
(3, 'Michael', 40, 90000, 103),
(4, 'Sara', 35, 56000, 101),
(5, 'David', 28, 49000, 102),
(6, 'Robert', 45, 95000, 103),
(7, 'Sophia', 29, 51000, 102);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name) VALUES
(101, 'HR'),
(102, 'Finance'),
(103, 'IT');

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sales (sale_id, product_id, customer_id, amount, sale_date) VALUES
(1, 1, 101, 4500.00, '2023-03-01'),
(2, 2, 102, 5500.00, '2023-03-02'),
(3, 3, 103, 7000.00, '2023-04-01'),
(4, 1, 104, 3000.00, '2023-04-02'),
(5, 2, 105, 6000.00, '2023-05-01');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATETIME,
    order_amount INT
);

INSERT INTO orders (order_id, customer_name, order_date, order_amount) VALUES
(1, 'John', '2023-05-01 10:00:00', 500),
(2, 'Emily', '2023-05-02 10:15:00', 700),
(3, 'Michael', '2023-05-03 10:30:00', 1200),
(4, 'Sara', '2023-05-04 11:00:00', 450),
(5, 'David', '2023-05-05 10:45:00', 900),
(6, 'John', '2023-05-06 10:30:00', 600),
(7, 'Emily', '2023-05-07 10:15:00', 750);

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


-- Question 1: Find Employees with Highest Salary Per Department
-- Retrieve the employee name, department name, and salary for the highest-paid employee in each department.
SELECT e.name, d.department_name, e.salary 
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary = (SELECT MAX(salary) FROM employees WHERE department_id = e.department_id);


-- Question 2: Calculate Monthly Sales Growth Percentage
-- Calculate the month-over-month sales growth percentage for each product using the sales table.
SELECT s1.product_id, p.product_name, 
       IFNULL(((s1.amount - s2.amount) / s2.amount * 100), 0) AS sales_growth_percentage
FROM sales s1
JOIN products p ON s1.product_id = p.product_id
LEFT JOIN sales s2 ON s1.product_id = s2.product_id 
AND MONTH(s1.sale_date) = MONTH(s2.sale_date) + 1;


-- Question 3: Identify Departments with Average Salary Greater Than Company Average
-- List department names where the average salary is greater than the company's average salary.
SELECT d.department_name
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);


-- Question 4: Find Customers with Consecutive Purchases
-- Identify customers who made purchases on two or more consecutive days.
SELECT DISTINCT o1.customer_name
FROM orders o1
JOIN orders o2 ON o1.customer_name = o2.customer_name 
AND DATEDIFF(o1.order_date, o2.order_date) = 1;


-- Question 5: Detect Overlapping Orders
-- Find orders where two or more customers placed orders within the same hour, based on order_date and time.
SELECT o1.order_id AS order_1, o1.customer_name AS customer_1, 
       o2.order_id AS order_2, o2.customer_name AS customer_2
FROM orders o1
JOIN orders o2 ON o1.order_id != o2.order_id 
AND ABS(TIMESTAMPDIFF(MINUTE, o1.order_date, o2.order_date)) <= 60;