WITH cte AS (
    SELECT 
        user_id,
        time_stamp,
        LEAD(time_stamp) OVER (
            PARTITION BY user_id 
            ORDER BY time_stamp
        ) AS next_time
    FROM Confirmations
)
SELECT DISTINCT user_id
FROM cte
WHERE TIMESTAMPDIFF(SECOND, time_stamp, next_time) <= 24 * 60 * 60;
----------------------
SELECT DISTINCT c1.user_id
FROM Confirmations c1
JOIN Confirmations c2
  ON c1.user_id = c2.user_id
 AND c1.time_stamp < c2.time_stamp
 AND TIMESTAMPDIFF(SECOND, c1.time_stamp, c2.time_stamp) <= 24 * 60 * 60;
----------------------
SELECT
    DISTINCT s.user_id
FROM confirmations s
JOIN confirmations c ON 
    s.user_id = c.user_id AND 
    s.time_stamp != c.time_stamp AND 
    s.time_stamp < c.time_stamp
WHERE s.time_stamp >= DATE_SUB(c.time_stamp, INTERVAL 24 HOUR);
