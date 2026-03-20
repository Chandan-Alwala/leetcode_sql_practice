SELECT 
    user_id,
    MAX(DATEDIFF(
        IFNULL(next_visit, '2021-01-01'),
        visit_date
    )) AS biggest_window
FROM (
    SELECT 
        user_id,
        visit_date,
        LEAD(visit_date) OVER (
            PARTITION BY user_id 
            ORDER BY visit_date
        ) AS next_visit
    FROM UserVisits
) t
GROUP BY user_id
ORDER BY user_id;
------------------------------
WITH cte AS (
    SELECT
        user_id,
        ABS(DATEDIFF(LEAD(visit_date, 1, '2021-01-01') 
            OVER(PARTITION BY user_id ORDER BY visit_date), visit_date)) as date_diff
    FROM UserVisits
)

SELECT 
    cte.user_id, 
    MAX(cte.date_diff) as biggest_window
FROM cte
GROUP BY cte.user_id
ORDER BY cte.user_id;
-----------------------------------
-- without window functions
SELECT 
    u1.user_id,
    MAX(DATEDIFF(
        IFNULL(
            (SELECT MIN(u2.visit_date)
             FROM UserVisits u2
             WHERE u2.user_id = u1.user_id
             AND u2.visit_date > u1.visit_date),
            '2021-01-01'
        ),
        u1.visit_date
    )) AS biggest_window
FROM UserVisits u1
GROUP BY u1.user_id
ORDER BY u1.user_id;
