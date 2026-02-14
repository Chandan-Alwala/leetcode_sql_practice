WITH install_dates AS(
    SELECT
        player_id,
        event_date,
        RANK() OVER(PARTITION BY player_id ORDER BY event_date) as date_rank,
        LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) as next_date
    FROM activity
)

SELECT
    event_date AS install_dt,
    COUNT(DISTINCT player_id) as installs,
    ROUND(
        SUM(
            CASE WHEN ABS(DATEDIFF(event_date, next_date)) = 1 THEN 1 ELSE 0 END
        ) /
        (1.0 * COUNT(DISTINCT player_id))
    , 2) AS Day1_retention
FROM install_dates
WHERE date_rank = 1
GROUP BY event_date;
---------------------------------------------

WITH install_cte AS (
    SELECT
        player_id,
        event_date AS install_dt
    FROM Activity
    WHERE (player_id, event_date) IN (
        SELECT player_id, MIN(event_date)
        FROM Activity
        GROUP BY player_id
    )
),
retention_cte AS (
    SELECT
        i.install_dt,
        i.player_id,
        CASE 
            WHEN a.player_id IS NOT NULL THEN 1 
            ELSE 0 
        END AS retained
    FROM install_cte i
    LEFT JOIN Activity a
        ON i.player_id = a.player_id
       AND a.event_date = DATE_ADD(i.install_dt, INTERVAL 1 DAY)
)
SELECT
    install_dt,
    COUNT(player_id) AS installs,
    ROUND(SUM(retained) / COUNT(player_id), 2) AS Day1_retention
FROM retention_cte
GROUP BY install_dt;
---------------------------------------------

WITH cte AS (
    SELECT
        player_id,
        event_date,
        MIN(event_date) OVER (PARTITION BY player_id) AS install_dt
    FROM Activity
)
SELECT
    install_dt,
    COUNT(DISTINCT player_id) AS installs,
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN event_date = DATE_ADD(install_dt, INTERVAL 1 DAY)
            THEN player_id END
        ) / COUNT(DISTINCT player_id),
        2
    ) AS Day1_retention
FROM cte
GROUP BY install_dt;
