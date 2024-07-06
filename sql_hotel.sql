CREATE DATABASE pizzahut;
USE pizzahut;
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);
SELECT 
    *
FROM
    orders;

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- RETREIVE TOTAL ORDERS PLACED. task:1
SELECT 
    COUNT(order_id)
FROM
    orders;
-- GETTING THE TOTAL ORDERS PLACED FROM ALL EXHAUSTIVE DATA


SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
-- JOINING APPROPRIATELY FOR SAME PIZZA ID ROUNDED OF TO 2 DECIMAL PLACES


SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- MOST COMMON PIZZA SIZE ORDERED
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- TOTAL QUANTITY OF EACH PIZZA CATEGORY INCREASING ORDER
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity;

-- TOP 5 MOST ORDERED PIZZAS TYPES WITH THEIR RESPECTIVE QUANTITIES
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- TOTAL QUANTITY OF EACH PIZZA CATEGORY DECREASING ORDER
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- TOTAL QUANTITY OF EACH PIZZA CATEGORY INCREASING ORDER
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity;

-- FIND DISTRIBUTION OF ORDER BY HOURS OF THE DAY IN THE HOTEL
SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);

-- JOIN ALL TABLES  TO FIND CATEGORY WISE DISTRIBUTION

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- AVERAGE QUANTITY OF EACH PIZZA CATEGORY INCREASING ORDER
SELECT 
    pizza_types.category,
    avg(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity;

-- GROUP ORDERS BASED ON DATES AND CALCULATE TOTAL NUMBER OF PIZZAS ORDERED
-- EACH DAY
SELECT 
    sum(quantity)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;

-- GROUP ORDERS BASED ON DATES AND CALCULATE AVERAGE NUMBER OF PIZZAS ORDERED
-- EACH DAY
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;


-- LEAST 3 MOST ORDERED BASED COMPLETELY
-- ON REVENUE OF PIZZAS AMONG ALL THE DATA

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue 
LIMIT 3;


-- TOP 3 MOST ORDERED BASED COMPLETELY
-- ON REVENUE OF PIZZAS

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- CALCULATION OF THE PERCENTAGE CONTRIBUTION OF EACH
-- PIZZA TYPE TO THE TOTAL INCOME BASED ON CATEGORIES
SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) AS total_sales
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- ANALYZE CUMULATIVE REVENUE OVER TIME
SELECT order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(SELECT orders.order_date,
sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;

-- TOP 3 MOST ORDERED PIZZA TYPES BASED ON 
-- REVENUE FOR EACH PIZZA CATEGORY
SELECT name,revenue from 
(SELECT category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(SELECT pizza_types.category,pizza_types.name,
sum((order_details.quantity)*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b
where rn<=3



