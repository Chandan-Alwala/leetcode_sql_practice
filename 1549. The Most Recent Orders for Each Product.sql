WITH cte AS (
    SELECT 
        p.product_name,
        p.product_id,
        o.order_id,
        o.order_date,
        RANK() OVER (
            PARTITION BY p.product_id 
            ORDER BY o.order_date DESC
        ) AS rnk
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
)

SELECT product_name, product_id, order_id, order_date
FROM cte
WHERE rnk = 1
ORDER BY product_name ASC, product_id ASC, order_id ASC;
----------------------
WITH product_ranker AS (
    SELECT
        product_id,
        order_id,
        order_date,
        DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date DESC) AS p_rank
    FROM orders
    GROUP BY product_id, order_id
)
SELECT
    p.product_name,
    pr.product_id,
    pr.order_id,
    pr.order_date
FROM product_ranker pr
LEFT JOIN products p ON pr.product_id = p.product_id
WHERE pr.p_rank = 1
ORDER BY p.product_name, pr.product_id, pr.order_id;
