WITH first_login AS (
    SELECT 
        player_id, 
        MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
)

SELECT 
    a.player_id, 
    a.device_id
FROM Activity a
JOIN first_login f
  ON a.player_id = f.player_id
 AND a.event_date = f.first_date;
--------------------
# With sub-qeury and MIN
SELECT
    a.player_id,
    a.device_id
FROM activity a
WHERE a.event_date = (
    SELECT 
        MIN(event_date)
    FROM activity
    WHERE player_id = a.player_id 
);


# With sub-query and RANK
SELECT player_id, device_id FROM (
    SELECT 
        player_id,
        device_id,
        RANK() OVER (PARTITION BY player_id ORDER BY event_date) as login_rank
    FROM Activity
) rank_table
WHERE rank_table.login_rank = 1;
