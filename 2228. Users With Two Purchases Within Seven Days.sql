WITH cte AS (
    SELECT 
        user_id,
        purchase_date,
        LEAD(purchase_date) OVER (
            PARTITION BY user_id 
            ORDER BY purchase_date
        ) AS next_date
    FROM Purchases
)
SELECT DISTINCT user_id
FROM cte
WHERE DATEDIFF(next_date, purchase_date) <= 7;
--------------------
SELECT
    DISTINCT p1.user_id
FROM purchases p1
JOIN purchases p2 ON 
    p1.user_id = p2.user_id AND 
    p1.purchase_id <> p2.purchase_id 
WHERE ABS(DATEDIFF(p1.purchase_date, p2.purchase_date)) <= 7
ORDER BY p1.user_id;
