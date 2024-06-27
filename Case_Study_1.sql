CREATE SCHEMA dannys_diner;

SET search_path TO dannys_diner;
SHOW search_path;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

--- SQL Queries
SELECT * FROM members;
SELECT * FROM menu;
SELECT * FROM sales;

-- 1. What is the total amount each customer spent at the restaurant ?
SELECT sales.customer_id, SUM(menu.price) AS total_amount
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id 
ORDER BY sales.customer_id


-- 2. How many days has each customer visited the restaurant ?
SELECT sales.customer_id, COUNT(DISTINCT sales.order_date) AS visit_count 
FROM sales
GROUP BY sales.customer_id
ORDER BY sales.customer_id
	

-- 3. What was the first item from the menu purchased by each customer ?
WITH item_purchased AS (
	SELECT sales.customer_id, sales.order_date, menu.product_name,
	dense_rank() over(
					partition by customer_id 
					order by order_date ) AS rank_product
	FROM sales
	JOIN menu ON sales.product_id = menu.product_id
)
SELECT customer_id, product_name 
FROM item_purchased 
WHERE rank_product = 1
GROUP BY customer_id, product_name
	

-- 4. What is the most purchased on the menu and how many times was it purchased by all customers ?
SELECT menu.product_name, 
	COUNT(sales.product_id) AS count_purchased
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY count_purchased DESC 
LIMIT 1
	

-- 5. Which item was the most popular for each customer
WITH most_popular AS (
	SELECT sales.customer_id, menu.product_name,
	COUNT(menu.product_id) AS order_count,
	DENSE_RANK() OVER(
					PARTITION BY sales.customer_id
					ORDER BY COUNT(sales.customer_id) DESC
	) AS rank_product
	FROM sales
	JOIN menu ON sales.product_id = menu.product_id
	GROUP BY sales.customer_id, menu.product_name
)
SELECT customer_id, product_name, order_count 
FROM most_popular
WHERE rank_product = 1

	