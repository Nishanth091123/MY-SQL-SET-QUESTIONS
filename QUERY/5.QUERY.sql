CREATE DATABASE coding_five;
USE coding_five;

-- Table Creation & Data Insertion
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    registration_date DATE
);

INSERT INTO customers (customer_id, customer_name, registration_date) VALUES
(101, 'John Doe', '2022-01-15'),
(102, 'Jane Smith', '2022-02-10'),
(103, 'Alice Johnson', '2022-03-05'),
(104, 'Robert Brown', '2022-05-20'),
(105, 'Emily Davis', '2022-06-01');

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    amount DECIMAL(10,2),
    sale_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO sales (sale_id, customer_id, product_id, amount, sale_date) VALUES
(1, 101, 1, 500.00, '2023-01-15'),
(2, 101, 2, 300.00, '2023-02-15'),
(3, 102, 1, 400.00, '2023-02-10'),
(4, 102, 3, 250.00, '2023-03-05'),
(5, 103, 2, 600.00, '2023-04-20'),
(6, 104, 1, 700.00, '2023-05-10'),
(7, 105, 2, 800.00, '2023-06-15');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

INSERT INTO products (product_id, product_name, price, stock_quantity) VALUES
(1, 'Laptop', 1000.00, 5),
(2, 'Mobile', 600.00, 10),
(3, 'Tablet', 400.00, 8),
(4, 'Headphones', 150.00, 20),
(5, 'Smartwatch', 200.00, 3);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50)
);

INSERT INTO employees (employee_id, name, department) VALUES
(1, 'John', 'Sales'),
(2, 'Emily', 'Marketing'),
(3, 'Michael', 'HR'),
(4, 'Sara', 'IT'),
(5, 'David', 'Finance');

CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY,
    employee_id INT,
    promotion_date DATE
);

INSERT INTO promotions (promotion_id, employee_id, promotion_date) VALUES
(1, 1, '2023-01-10'),
(2, 1, '2023-06-12'),
(3, 2, '2023-03-15'),
(4, 3, '2022-09-30'),
(5, 3, '2023-07-01');


-- Question 1: Calculate Total Sales Per Customer
-- Calculate the total sales amount for each customer.
SELECT c.customer_name, SUM(s.amount) AS total_sales
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name;


-- Question 2: Identify Low Stock Products
-- Identify products with stock quantity less than 5 units.
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 5;


-- Question 3: Find Employees Promoted More Than Once
-- Find employees who have been promoted more than once.
SELECT e.name, COUNT(p.promotion_id) AS promotion_count
FROM employees e
JOIN promotions p ON e.employee_id = p.employee_id
GROUP BY e.name
HAVING COUNT(p.promotion_id) > 1;


-- Question 4: Calculate Monthly Sales
-- Calculate total sales for each month.
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS sale_month, SUM(amount) AS total_sales
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sale_month;


-- Question 5: Find Customers Who Purchased More Than One Product
-- Find customers who purchased more than one product.
SELECT c.customer_name, COUNT(DISTINCT s.product_id) AS product_count
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT s.product_id) > 1;
