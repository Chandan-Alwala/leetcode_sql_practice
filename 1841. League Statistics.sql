WITH all_matches AS (
    SELECT 
        home_team_id AS team_id,
        home_team_goals AS goals_for,
        away_team_goals AS goals_against
    FROM Matches
    
    UNION ALL
    
    SELECT 
        away_team_id AS team_id,
        away_team_goals AS goals_for,
        home_team_goals AS goals_against
    FROM Matches
),
team_stats AS (
    SELECT 
        team_id,
        COUNT(*) AS matches_played,
        SUM(
            CASE 
                WHEN goals_for > goals_against THEN 3
                WHEN goals_for = goals_against THEN 1
                ELSE 0
            END
        ) AS points,
        SUM(goals_for) AS goal_for,
        SUM(goals_against) AS goal_against
    FROM all_matches
    GROUP BY team_id
)

SELECT 
    t.team_name,
    ts.matches_played,
    ts.points,
    ts.goal_for,
    ts.goal_against,
    (ts.goal_for - ts.goal_against) AS goal_diff
FROM team_stats ts
JOIN Teams t
    ON t.team_id = ts.team_id
ORDER BY 
    ts.points DESC,
    goal_diff DESC,
    t.team_name;
------------------------
WITH match_pivot AS(
    SELECT home_team_id as team_id, home_team_goals, away_team_goals FROM matches
    UNION ALL
    SELECT away_team_id as team_id, away_team_goals, home_team_goals FROM matches
)

SELECT 
    team_name
    , count(*) as matches_played
    , sum(case when home_team_goals > away_team_goals then 3 when home_team_goals = away_team_goals then 1 else 0 end) as points
    , sum(home_team_goals) as goal_for
    , sum(away_team_goals) as goal_against
    , sum(home_team_goals) - sum(away_team_goals) as goal_diff
FROM match_pivot m
JOIN teams t ON m.team_id = t.team_id
GROUP BY team_name
ORDER BY points DESC, goal_diff DESC, team_name;
