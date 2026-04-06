WITH win_rows AS (
    SELECT 
        player_id,
        match_day,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY match_day) AS rn_all,
        ROW_NUMBER() OVER (
            PARTITION BY player_id, result 
            ORDER BY match_day
        ) AS rn_result
    FROM Matches
),
groups AS (
    SELECT 
        player_id,
        match_day,
        result,
        (rn_all - rn_result) AS grp
    FROM win_rows
),
streaks AS (
    SELECT 
        player_id,
        grp,
        COUNT(*) AS streak
    FROM groups
    WHERE result = 'Win'
    GROUP BY player_id, grp
)
SELECT 
    m.player_id,
    COALESCE(MAX(s.streak), 0) AS longest_streak
FROM Matches m
LEFT JOIN streaks s
    ON m.player_id = s.player_id
GROUP BY m.player_id;
----------------------------
WITH win_rank AS (
    SELECT  
        player_id,
        result,
        RANK() OVER(PARTITION BY player_id ORDER BY match_day) AS RNK1,
        RANK() OVER(PARTITION BY player_id, result  ORDER BY match_day) RNK2
    FROM Matches 
)
, win_cluster AS (
    SELECT
        player_id,
        COUNT(*) AS streak
    FROM win_rank
    WHERE result = 'Win'
    GROUP BY player_id, ABS(RNK1 - RNK2)
)

SELECT 
    p.player_id,
    IFNULL(
        MAX(w.streak), 0
    ) AS longest_streak
FROM (SELECT DISTINCT player_id FROM matches) p 
LEFT JOIN win_cluster w ON p.player_id = w.player_id
GROUP BY p.player_id;
