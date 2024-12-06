-- Create the customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(255)
);

-- Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create the products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    description TEXT
);

-- Insert sample data into customers table
INSERT INTO customers (name, email, address) VALUES
('Vijay', 'vijay@gmail.com', '123 Chennai Ine'),
('Viji', 'viji@gmail.com', '456 Erode Ave'),
('Ajith', 'ajith@gmail.com', '789 Kovai Ln');

-- Insert sample data into orders table
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 150.50),
(2, DATE_SUB(CURDATE(), INTERVAL 40 DAY), 200.00),
(3, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 75.00);

-- Insert sample data into products table
INSERT INTO products (name, price, description) VALUES
('Product A', 25.00, 'Description of Product A'),
('Product B', 50.00, 'Description of Product B'),
('Product C', 75.00, 'Description of Product C');

-- Query: 1  to retrieve all customers who placed an order in the last 30 days
SELECT DISTINCT c.id, c.name, c.email, c.address
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Query 2: Get the total amount of all orders placed by each customer sql


SELECT c.id AS customer_id, c.name AS customer_name, SUM(o.total_amount) AS total_order_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- -- Query 3: Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- Query 4: Add a new column discount to the products table sql

ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) DEFAULT 0.00;

-- Query 5: Retrieve the top 3 products with the highest price sql
SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 3;

-- Query 6: Get the names of customers who have ordered Product A sql

-- Assuming an order_items table exists for normalization
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- Query 7: Join the orders and customers tables to retrieve the customer's name and order date for each order sql

SELECT c.name AS customer_name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id
ORDER BY o.order_date;

-- Query 8: Retrieve the orders with a total amount greater than 150.00 

SELECT o.id AS order_id, c.name AS customer_name, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.total_amount > 150.00;

-- Query 9: Normalize the database by creating a separate table for order items and updating the orders table
-- Step 1: Create the order_items table:
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
-- Step 2: Update the orders table to remove product-related details:


-- Assuming the orders table previously held direct product references
-- No query needed unless additional cleanup is required.
-- Step 3: Insert example data into the order_items table:

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),  -- Order 1 includes 2 units of Product A
(1, 2, 1),  -- Order 1 includes 1 unit of Product B
(2, 3, 1);  -- Order 2 includes 1 unit of Product C


-- Query 10: Retrieve the average total of all orders sql

SELECT AVG(total_amount) AS average_order_total
FROM orders;