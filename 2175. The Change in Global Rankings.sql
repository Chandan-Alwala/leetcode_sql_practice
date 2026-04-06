WITH old_rank AS (
    SELECT 
        team_id,
        name,
        points,
        RANK() OVER (ORDER BY points DESC, name ASC) AS old_rank
    FROM TeamPoints
),
new_points AS (
    SELECT 
        t.team_id,
        t.name,
        t.points + p.points_change AS new_points
    FROM TeamPoints t
    JOIN PointsChange p
      ON t.team_id = p.team_id
),
new_rank AS (
    SELECT 
        team_id,
        name,
        new_points,
        RANK() OVER (ORDER BY new_points DESC, name ASC) AS new_rank
    FROM new_points
)
SELECT 
    o.team_id,
    o.name,
    (o.old_rank - n.new_rank) AS rank_diff
FROM old_rank o
JOIN new_rank n
  ON o.team_id = n.team_id;
----------------------------
WITH global_ranks AS (
    SELECT
        team_id,
        name,
        points,
        DENSE_RANK() OVER(ORDER BY points DESC, name) AS g_rank
    FROM teampoints
)
, changed_ranks AS (
    SELECT
        t.team_id,
        t.name,
        t.g_rank,
        DENSE_RANK() OVER(ORDER BY (t.points + p.points_change) DESC, t.name) AS c_rank
    FROM global_ranks t
    LEFT JOIN pointschange p ON t.team_id = p.team_id
)

SELECT
    team_id,
    name,
    CAST(g_rank AS DECIMAL) - CAST(c_rank AS DECIMAL) AS rank_diff
FROM changed_ranks
ORDER BY c_rank, name;
