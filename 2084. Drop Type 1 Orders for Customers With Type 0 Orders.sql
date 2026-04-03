WITH flag AS (
    SELECT 
        customer_id,
        MAX(CASE WHEN order_type = 0 THEN 1 ELSE 0 END) AS has_type0
    FROM Orders
    GROUP BY customer_id
)
SELECT o.*
FROM Orders o
JOIN flag f
  ON o.customer_id = f.customer_id
WHERE o.order_type = 0
   OR f.has_type0 = 0;
--------------------------
WITH cust_with_type0 AS (
    SELECT DISTINCT customer_id
    FROM Orders
    WHERE order_type = 0
)
SELECT *
FROM Orders o
WHERE o.order_type = 0
   OR o.customer_id NOT IN (
        SELECT customer_id FROM cust_with_type0
   );
----------------------
# With CTEs and sub-query
WITH customers_with_zero_type AS (
    SELECT
        DISTINCT customer_id
    FROM orders 
    WHERE order_type = 0
)
, zero_orders_customers AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_type
    FROM orders o
    WHERE customer_id IN 
        (SELECT customer_id FROM customers_with_zero_type) AND 
        o.order_type = 0
)
, nonzero_orders_customers AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_type
    FROM orders o
    WHERE o.customer_id NOT IN 
        (SELECT customer_id FROM customers_with_zero_type)
)

SELECT * FROM zero_orders_customers
UNION
SELECT * FROM nonzero_orders_customers;


# Zero order calculation with LEFT JOIN
WITH customers_with_zero_type AS (
    SELECT
        DISTINCT customer_id
    FROM orders 
    WHERE order_type = 0
)
, zero_orders_customers AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_type
    FROM customers_with_zero_type c
    LEFT JOIN orders o ON 
        o.customer_id = c.customer_id AND 
        o.order_type = 0
)
, nonzero_orders_customers AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_type
    FROM orders o
    WHERE o.customer_id NOT IN 
        (SELECT customer_id FROM customers_with_zero_type)
)

SELECT * FROM zero_orders_customers
UNION
SELECT * FROM nonzero_orders_customers;


# Zero order calculation with RIGHT JOIN
WITH customers_with_zero_type AS (
    SELECT
        DISTINCT customer_id
    FROM orders 
    WHERE order_type = 0
)
, zero_orders_customers AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_type
    FROM orders o
    RIGHT JOIN customers_with_zero_type c ON 
        o.customer_id = c.customer_id AND 
        o.order_type = 0    
)
, nonzero_orders_customers AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_type
    FROM orders o
    WHERE o.customer_id NOT IN (SELECT customer_id FROM customers_with_zero_type)
)

SELECT * FROM zero_orders_customers
UNION
SELECT * FROM nonzero_orders_customers;
