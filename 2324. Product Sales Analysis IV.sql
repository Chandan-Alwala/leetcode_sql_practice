WITH user_product AS (
    SELECT 
        user_id,
        product_id,
        SUM(quantity) AS total_qty
    FROM Sales
    GROUP BY user_id, product_id
),
spent_calc AS (
    SELECT 
        u.user_id,
        u.product_id,
        u.total_qty * p.price AS spent,
        RANK() OVER (
            PARTITION BY u.user_id 
            ORDER BY u.total_qty * p.price DESC
        ) AS rnk
    FROM user_product u
    JOIN Product p 
      ON u.product_id = p.product_id
)
SELECT 
    user_id,
    product_id
FROM spent_calc
WHERE rnk = 1;
------------------------
WITH product_ranker AS (
    SELECT
        s.user_id,
        s.product_id,
        SUM(s.quantity * p.price),
        RANK() OVER(PARTITION BY s.user_id ORDER BY SUM(s.quantity * p.price) DESC) AS p_rank
    FROM sales s
    LEFT JOIN product p ON s.product_id = p.product_id
    GROUP BY s.product_id, s.user_id
)

SELECT
    user_id,
    product_id
FROM product_ranker
WHERE p_rank = 1
ORDER BY user_id, product_id;
