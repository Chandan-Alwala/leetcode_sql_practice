WITH daily AS (
    SELECT
        visited_on,
        SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
)

SELECT *
FROM (
    SELECT
        visited_on,
        SUM(daily_amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        ROUND(
            AVG(daily_amount) OVER (
                ORDER BY visited_on
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ),
            2
        ) AS average_amount,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM daily
) t
WHERE rn >= 7;

------------------------------------

WITH daily_sum AS (
    SELECT
        visited_on,
        SUM(amount) AS total_amount
    FROM customer
    GROUP BY visited_on
)
SELECT
    d.visited_on,
    SUM(d1.total_amount) AS amount,
    ROUND(SUM(d1.total_amount) / 7.0, 2) AS average_amount
FROM daily_sum d
JOIN daily_sum d1 
WHERE DATEDIFF(d.visited_on, d1.visited_on) BETWEEN 0 AND 6
GROUP BY d.visited_on
HAVING COUNT(d1.visited_on) = 7
ORDER BY d.visited_on;
