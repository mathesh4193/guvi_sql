CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(200)
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT
);

INSERT INTO customers (name, email, address) VALUES
('Alice', 'alice@example.com', 'Chennai'),
('Bob', 'bob@example.com', 'Madurai'),
('Charlie', 'charlie@example.com', 'Trichy');

INSERT INTO products (name, price, description) VALUES
('Product A', 50.00, 'Description of Product A'),
('Product B', 75.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C'),
('Product D', 120.00, 'Description of Product D');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE() - INTERVAL 10 DAY, 120.00),
(2, CURDATE() - INTERVAL 5 DAY, 200.00),
(1, CURDATE() - INTERVAL 35 DAY, 80.00);

-- Normalize: create order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),  
(2, 2, 1),   
(2, 4, 1),   
(3, 3, 1);   

-- 1. Customers who placed an order in the last 30 days
SELECT DISTINCT c.* 
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- 2. Total amount of all orders placed by each customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- 3. Update price of Product C to 45.00 (using id instead of name)
UPDATE products SET price = 45.00 WHERE id = 3;

-- 4. Add new column discount to products
ALTER TABLE products ADD discount DECIMAL(5,2);

-- 5. Top 3 products with highest price
SELECT * FROM products ORDER BY price DESC LIMIT 3;

-- 6. Names of customers who ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';


-- 7. Join orders and customers: customer name and order date
SELECT c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- 8. Orders with total amount greater than 150
SELECT * FROM orders WHERE total_amount > 150.00;

-- 9. Average total of all orders
SELECT AVG(total_amount) AS avg_order_total FROM orders;
