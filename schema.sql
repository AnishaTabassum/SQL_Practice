CREATE DATABASE flipkart;
USE flipkart;

CREATE TABLE user_fp (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES user_fp(user_id)
);

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category VARCHAR(50),
    vertical VARCHAR(50)
);

CREATE TABLE order_details (
    order_id INT,
    category_id INT,
    amount INT,
    quantity INT,
    profit DECIMAL(10,2),
    PRIMARY KEY (order_id, category_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);
