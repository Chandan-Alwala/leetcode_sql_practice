WITH feb_orders AS (
    SELECT
        product_id,
        SUM(unit) AS total_units
    FROM Orders
    WHERE order_date >= '2020-02-01'
      AND order_date < '2020-03-01'
    GROUP BY product_id
    HAVING SUM(unit) >= 100
)

SELECT
    p.product_name,
    f.total_units AS unit
FROM feb_orders f
JOIN Products p
    ON f.product_id = p.product_id;

---------------------------

SELECT
    p.product_name,
    SUM(o.unit) AS unit
FROM products p
LEFT JOIN orders o ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_id
HAVING SUM(o.unit) >= 100;
