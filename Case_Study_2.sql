CREATE SCHEMA case_study_2;

SET search_path = case_study_2;
SHOW search_path;

CREATE TABLE IF NOT EXISTS case_study_2.pizza_names
(
    pizza_id INTEGER ,
    pizza_name TEXT,
    CONSTRAINT pizza_names_pkey PRIMARY KEY (pizza_id)
);

INSERT INTO case_study_2.pizza_names
VALUES (1, 'Meatlovers'),
	(2, 'Vegetarian');

CREATE TABLE IF NOT EXISTS case_study_2.pizza_toppings
(
    topping_id INTEGER,
    topping_name TEXT,
    CONSTRAINT pizza_toppings_pkey PRIMARY KEY (topping_id)
);

INSERT INTO case_study_2.pizza_toppings
VALUES (1, 'Chesse'),
	(2, 'Mushrooms'),
	(3, 'Tomatoes'),
	(4, 'Peperoni'),
	(5, 'Chicken');

	
CREATE TABLE IF NOT EXISTS case_study_2.pizza_recipes
(
    pizza_id INTEGER,
    toppings TEXT,
    CONSTRAINT pizza_recipes_pkey PRIMARY KEY (pizza_id)
);

INSERT INTO case_study_2.pizza_recipes
VALUES (1, '1,2,4'),
	(2, '2,5'),
	(3, '1,4,5'),
	(4, '1,3'),
	(5, '2,3');
	

CREATE TABLE IF NOT EXISTS case_study_2.runners
(
    runner_id INTEGER,
    registration_date DATE,
    CONSTRAINT runners_pkey PRIMARY KEY (runner_id)
);

INSERT INTO case_study_2.runners
VALUES (1, '2021-01-01 18:20:19'),
	(2, '2021-01-02 07:00:00'),
	(3, '2021-01-02 11:25:59'),
	(4, '2021-01-03 14:03:00'),
	(5, '2021-01-04 08:11:11'),
	(6, '2021-01-06 20:09:55'),
	(7, '2021-01-06 21:30:30');


CREATE TABLE IF NOT EXISTS case_study_2.runner_orders
(
	order_id INTEGER,
	runner_id INTEGER,
	pickup_time VARCHAR(19),
	distance VARCHAR(7),
	duration VARCHAR(10),
	cancellation VARCHAR(23),
	CONSTRAINT order_pkey PRIMARY KEY (order_id),
	CONSTRAINT runner_fkey FOREIGN KEY (runner_id) REFERENCES case_study_2.runners(runner_id)
);

INSERT INTO case_study_2.runner_orders
VALUES (1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', ''),
	(2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', ''),
	(3, 1, '2021-01-03 00:12:37', '13.4km', '20 minutes', null),
	(4, 2, '2021-01-04 13:53:03', '23.4', '40', null),
	(5, 3, '2021-01-08 21:10:57', '10', '15', null),
	(6, 3, null, null, null, 'Restaurant Cancellation'),
	(7, 2, '2021-01-08 21:30:45', '25km', '25mins', null),
	(8, 2, '2021-01-10 00:15:02', '23.4 km', '15 minute', null),
	(9, 2, null, null, null, 'Customer Cancellation'),
	(10, 1, '2021-01-11 18:50:20', '10km', '10minutes', null);

CREATE TABLE IF NOT EXISTS case_study_2.customer_orders
(
	order_id INTEGER,
	customer_id INTEGER,
	pizza_id INTEGER,
	exclusions VARCHAR(4),
	extras VARCHAR(4),
	order_date TIMESTAMP,
	CONSTRAINT order_fk FOREIGN KEY (order_id) REFERENCES case_study_2.runner_orders(order_id),
	CONSTRAINT pizza_name_fk FOREIGN KEY(pizza_id) REFERENCES case_study_2.pizza_names(pizza_id),
	CONSTRAINT pizza_recpes_fk FOREIGN KEY(pizza_id) REFERENCES case_study_2.pizza_recipes(pizza_id)
);

INSERT INTO case_study_2.customer_orders
VALUES (1, 101, 1, '', '', '2021-01-01 18:05:02.000'),
	(2, 101, 1, '', '', '2021-01-01 19:00:52.000'),
	(3, 102, 1, '', '', '2021-01-02 23:51:23.000'),
	(3, 102, 2, '', null, '2021-01-02 23:51:23.000'),
	(4, 103, 1, 4, '', '2021-01-04 13:23:46.000'),
	(4, 103, 1, 4, '', '2021-01-04 13:23:46.000'),
	(4, 103, 2, 4, '', '2021-01-04 13:23:46.000'),
	(5, 104, 1, null, 1, '2021-01-08 21:00:29.000'),
	(6, 101, 2, null, null, '2021-01-08 21:03:13.000'),
	(7, 105, 2, null, 1, '2021-01-08 21:20:29.000'),
	(8, 102, 1, null, null, '2021-01-09 23:54:33.000'),
	(9, 103, 1, 4, '1,5', '2021-01-10 11:22:59.000'),
	(10, 104, 1, null, null, '2021-01-11 18:34:49.000'),
	(10, 104, 1, '2,6', '1,4', '2021-01-09 23:54:33.000');


-- SELECT
SELECT * FROM case_study_2.pizza_names;
SELECT * FROM case_study_2.pizza_recipes;
SELECT * FROM case_study_2.pizza_toppings;
SELECT * FROM case_study_2.runners;
SELECT * FROM case_study_2.runner_orders;
SELECT * FROM case_study_2.customer_orders;

-- Create temporary table with all columns don't have values is null and if have values is null then replace with blank space ''
CREATE TEMP TABLE customer_orders_temp AS
SELECT 
	order_id,
	customer_id,
	pizza_id,
	CASE 
		WHEN exclusions IS NULL  OR exclusions LIKE 'null' THEN ''
		ELSE exclusions
	END AS exclusions,
	CASE
		WHEN extras IS NULL OR extras LIKE 'null' THEN ''
		ELSE extras
	END AS extras,
	order_date
FROM case_study_2.customer_orders;

SELECT * FROM case_study_2.customer_orders;
SELECT * FROM customer_orders_temp;


-- In pickup_time column, remove nulls and replace with blank space ''
-- In distance column, remove "km" and nulls and replace with blank space ''
-- In duration column, remove "minute" and nulls and replace with blank space ''
-- In cancellation column, remove null and replace with blank psace ''
--
SELECT 
	order_id,
	runner_id,
	CASE 
		WHEN pickup_time IS NULL OR pickup_time LIKE 'null' THEN ''
		ELSE pickup_time
	END AS pickup_time,
	CASE
		WHEN distance IS NULL OR distance LIKE 'null' THEN ''
		WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
		ELSE distance
	END AS distance,
	CASE 
		WHEN duration IS NULL OR duration LIKE 'null' THEN ''
		WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
		WHEN duration LIKE '%minute' THEN TRIM ('minute' FROM duration)
		WHEN duration LIKE '%minutes' THEN TRIM ('minutes' FROM duration)
		ELSE duration
	END AS duration,
	CASE 
		WHEN cancellation IS NULL OR LIKE 'null' THEN ''
		ELSE cancellation
	END AS cancellation
FROM case_study_2.runner_orders;

SELECT 
  runner_id, 
  COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE distance != 0
GROUP BY runner_id;

-- 1. How many pizzas were ordered ?
SELECT COUNT(1) AS count_ordered 
	FROM customer_orders_temp

-- 2. How many unique customer orders were made ?
SELECT COUNT(DISTINCT order_id) FROM 
	customer_orders_temp

-- 3. How many successful orders were delivered by each runner ?
SELECT runner_id, 
	COUNT(1) AS count_order_success
FROM case_study_2.runner_orders
WHERE distance IS NOT NULL 
	AND TRIM('km' FROM distance)::FLOAT > 0
GROUP BY runner_id
ORDER BY runner_id

-- 4. How many of each type of pizza was delivered ?
WITH pizza_delivered AS (
	SELECT co.pizza_id, 
		COUNT(ro.order_id) AS count_order_delivered 
	FROM case_study_2.runner_orders AS ro
	JOIN case_study_2.customer_orders AS co 
		ON ro.order_id = co.order_id
	WHERE ro.distance IS NOT NULL 
		AND TRIM('km' FROM ro.distance)::FLOAT > 0
	GROUP BY co.pizza_id
)
SELECT pn.pizza_name, pd.count_order_delivered FROM pizza_delivered AS pd
JOIN case_study_2.pizza_names AS pn
	ON pd.pizza_id = pn.pizza_id


-- 5. How many Vegetarian and Meatlovers were ordered by each customer ?
SELECT co.customer_id, pn.pizza_name, 
	COUNT(pn.pizza_name) 
FROM case_study_2.customer_orders AS co
JOIN case_study_2.pizza_names AS pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id


-- 6. What was the maximum number of pizzas delivered in a single order ?
WITH pizza_count_cte AS (
	SELECT c.order_id, COUNT(1) as count_order
	FROM case_study_2.customer_orders AS c
	JOIN case_study_2.runner_orders AS r
		ON c.order_id = r.order_id
	WHERE r.distance IS NOT NULL 
			AND TRIM('km' FROM r.distance)::FLOAT > 0
	GROUP BY c.order_id
)
SELECT *
FROM pizza_count_cte
ORDER BY count_order DESC
LIMIT 1


-- 7. For each customer, how many delivered pizzas had at least change and how many had no changes ?
SELECT c.customer_id,
	SUM(
		CASE WHEN c.exclusions <> '' OR c.extras <> '' THEN 1
		ELSE 0
		END
	) AS least_1_change,
	SUM(
		CASE WHEN (c.exclusions = '' OR c.exclusions IS NULL) 
					AND  
				  (c.extras = '' OR c.extras IS NULL )
			THEN 1
		ELSE 0
		END
	) AS no_change
FROM case_study_2.customer_orders AS c
JOIN case_study_2.runner_orders AS r
	ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL 
			AND TRIM('km' FROM r.distance)::FLOAT > 0
GROUP BY c.customer_id
ORDER BY c.customer_id


