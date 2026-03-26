SELECT 
    user_id,
    MAX(time_stamp) AS last_stamp
FROM Logins
WHERE YEAR(time_stamp) = 2020
GROUP BY user_id;
-----------------------
SELECT
    user_id,
    last_stamp
FROM (
    SELECT
        user_id,
        MAX(time_stamp) as last_stamp
    FROM logins
    WHERE YEAR(time_stamp) = 2020
    GROUP BY user_id
) cte;
