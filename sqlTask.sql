CREATE DATABASE ecommerce;
USE ecommerce;
-- Create customers Table
create table customers (
id INT auto_increment primary key,
name varchar(100),
email varchar(100),
address varchar(255)

);

-- Create products Table
create table products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) ,
    price DECIMAL(10,2),
    description TEXT
);

-- Create orders Table
create table orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id)
    REFERENCES customers(id)
);

-- Insert Sample Data into customers
INSERT INTO customers (name, email, address)
VALUES
('John Doe', 'john@example.com', 'New York'),
('Jane Smith', 'jane@example.com', 'California'),
('Michael Brown', 'michael@example.com', 'Texas');

-- Insert Sample Data into products
INSERT INTO products (name, price, description)
VALUES
('Product A', 25.00, 'Wireless Mouse'),
('Product B', 75.00, 'Mechanical Keyboard'),
('Product C', 40.00, 'USB Headset'),
('Product D', 120.00, 'Gaming Monitor');

-- Insert Sample Data into orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
(1, CURDATE() - INTERVAL 10 DAY, 200.00),
(2, CURDATE() - INTERVAL 20 DAY, 150.00),
(1, CURDATE() - INTERVAL 40 DAY, 300.00),
(3, CURDATE() - INTERVAL 5 DAY, 180.00);


-- Retrieve all customers who have placed an order in the last 30 days.
SELECT *
FROM customers c
JOIN orders o
ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- Get the total amount of all orders placed by each customer.
SELECT 
    c.name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Update the price of Product C to 45.00.
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- Add a new column discount to the products table.
ALTER TABLE products
ADD discount DECIMAL(5,2) DEFAULT 0.00;

-- Retrieve the top 3 products with the highest price.
SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;

-- Get the names of customers who have ordered Product A.
-- First create order_items table for product mapping

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    
    FOREIGN KEY (order_id)
    REFERENCES orders(id),
    
    FOREIGN KEY (product_id)
    REFERENCES products(id)
);

		-- Insert sample order_items data

INSERT INTO order_items (order_id, product_id, quantity)
VALUES
(1, 1, 2),
(1, 2, 1),
(2, 1, 1),
(3, 3, 2),
(4, 4, 1);

		-- Query to find customers who ordered Product A

SELECT DISTINCT c.name
FROM customers c
JOIN orders o
ON c.id = o.customer_id
JOIN order_items oi
ON o.id = oi.order_id
JOIN products p
ON oi.product_id = p.id
WHERE p.name = 'Product A';


-- Join the orders and customers tables to retrieve the customer's name and order date for each order. 
SELECT 
    c.name AS customer_name,
    o.order_date
FROM customers c
JOIN orders o
ON c.id = o.customer_id;

-- Retrieve the orders with a total amount greater than 150.00.
SELECT *
FROM orders
WHERE total_amount > 150.00;

-- Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.
	-- already created order_items table on line 103
-- Retrieve the average total of all orders.

SELECT 
    AVG(total_amount) AS average_order_total
FROM orders;