WITH cte_1 AS (
	SELECT
		first_player as player,
		first_score as score
	FROM matches
	UNION ALL
	SELECT
		second_player as player,
		second_score as score
	FROM matches
),
cte_2 AS (
	SELECT
		player,
		SUM(score) as total_score
	FROM cte_1
	GROUP BY player
)

SELECT
	DISTINCT p.group_id,
	FIRST_VALUE(cte_2.player) OVER(PARTITION BY p.group_id ORDER BY cte_2.total_score DESC) as player_id
FROM cte_2
LEFT JOIN players p ON p.player_id = cte_2.player;


------------------------------


WITH scores AS (
    SELECT first_player AS player_id, first_score AS score
    FROM Matches
    UNION ALL
    SELECT second_player, second_score
    FROM Matches
),
total_scores AS (
    SELECT 
        p.player_id,
        p.group_id,
        SUM(COALESCE(s.score, 0)) AS total_score
    FROM Players p
    LEFT JOIN scores s
        ON p.player_id = s.player_id
    GROUP BY p.player_id, p.group_id
)

SELECT group_id, player_id
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY group_id
               ORDER BY total_score DESC, player_id ASC
           ) AS rnk
    FROM total_scores
) t
WHERE rnk = 1;

