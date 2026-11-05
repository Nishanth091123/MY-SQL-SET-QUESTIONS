CREATE DATABASE coding_four;
USE coding_four;

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
(1, 101, 1, 200.00, '2023-01-15'),
(2, 101, 1, 250.00, '2023-02-15'),
(3, 101, 2, 300.00, '2023-03-15'),
(4, 102, 1, 150.00, '2023-01-10'),
(5, 102, 2, 180.00, '2023-02-20'),
(6, 103, 3, 350.00, '2023-04-25'),
(7, 104, 1, 400.00, '2023-05-30');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 1000.00),
(2, 'Mobile', 600.00),
(3, 'Tablet', 400.00),
(4, 'Headphones', 150.00),
(5, 'Smartwatch', 200.00);

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

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50)
);

INSERT INTO employees (employee_id, name, department) VALUES
(1, 'John', 'Finance'),
(2, 'Emily', 'Marketing'),
(3, 'Michael', 'HR'),
(4, 'Sara', 'IT'),
(5, 'David', 'Finance');


-- Question 1: Detect Customer Churn
-- Identify customers who haven't made any purchases in the last 90 days, including those who have never made a purchase.
SELECT c.customer_id, c.customer_name, MAX(s.sale_date) AS last_purchase_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING MAX(s.sale_date) IS NULL
    OR MAX(s.sale_date) < CURDATE() - INTERVAL 90 DAY;


-- Question 2: Find Inactive Products
-- List products that have not had any sales in the last 6 months.
SELECT p.product_id, p.product_name
FROM products p
WHERE p.product_id NOT IN (SELECT product_id
                           FROM sales
                           WHERE sale_date >= CURDATE() - INTERVAL 6 MONTH);


-- Question 3: Employee Promotion Tracking
-- Find employees who have been promoted more than once within the same calendar year.
SELECT e.name, YEAR(p.promotion_date) AS promotion_year, COUNT(*) AS promotion_count
FROM promotions p
JOIN employees e ON p.employee_id = e.employee_id
GROUP BY e.name, YEAR(p.promotion_date)
HAVING COUNT(*) > 1;


-- Question 4: Detect Revenue Anomalies
-- Identify products whose sales amount increased by more than 50% in a month compared to the previous month.
SELECT p.product_name,
       DATE_FORMAT(s1.sale_date, '%Y-%m') AS current_month,
       SUM(s1.amount) AS current_month_sales,
       prev.previous_month_sales,
       ROUND((SUM(s1.amount) - prev.previous_month_sales) / prev.previous_month_sales * 100, 2) AS growth_percentage
FROM sales s1
JOIN products p ON s1.product_id = p.product_id
JOIN (SELECT product_id,
             DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
             SUM(amount) AS previous_month_sales
      FROM sales
      GROUP BY product_id, DATE_FORMAT(sale_date, '%Y-%m')) prev
  ON s1.product_id = prev.product_id
 AND prev.sale_month = DATE_FORMAT(s1.sale_date - INTERVAL 1 MONTH, '%Y-%m')
GROUP BY p.product_name, DATE_FORMAT(s1.sale_date, '%Y-%m'), prev.previous_month_sales
HAVING SUM(s1.amount) > prev.previous_month_sales * 1.5;


-- Question 5: Identify Loyal Customers
-- Find customers who have made purchases in each of the last 12 months within the same calendar year.
SELECT c.customer_name, YEAR(s.sale_date) AS purchase_year
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name, YEAR(s.sale_date)
HAVING COUNT(DISTINCT MONTH(s.sale_date)) = 12;
