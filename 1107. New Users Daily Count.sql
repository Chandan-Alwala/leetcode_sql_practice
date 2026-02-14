# Solution with MIN
WITH first_login AS (
    SELECT
        user_id,
        MIN(activity_date) as login_date
    FROM traffic
    WHERE activity = 'login'
    GROUP BY user_id
)

SELECT
    login_date,
    COUNT(user_id) AS user_count
FROM first_login
WHERE DATEDIFF('2019-06-30', login_date) <= 90
GROUP BY login_date;

------------------------------------------

# Solution with RANK or DENSE_RANK(both will work)
WITH login_ranker AS (
    SELECT
        user_id,
        activity,
        activity_date,
        DENSE_RANK() OVER(PARTITION BY user_id ORDER BY activity_date) AS l_rank
    FROM traffic
    WHERE activity = 'login'
)

SELECT
    activity_date AS login_date,
    COUNT(DISTINCT user_id) AS user_count
FROM login_ranker
WHERE l_rank = 1 AND DATEDIFF('2019-06-30', activity_date) <= 90
GROUP BY activity_date
ORDER BY activity_date;
------------------------------------------

WITH first_logins AS (
    SELECT
        user_id,
        MIN(activity_date) AS first_login
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
)
SELECT
    first_login AS login_date,
    COUNT(*) AS user_count
FROM first_logins
WHERE first_login >= DATE_SUB('2019-06-30', INTERVAL 90 DAY)
GROUP BY first_login
ORDER BY first_login;

