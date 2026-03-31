WITH platforms AS (
    SELECT 'Android' AS platform
    UNION ALL SELECT 'IOS'
    UNION ALL SELECT 'Web'
),
experiments AS (
    SELECT 'Reading' AS experiment_name
    UNION ALL SELECT 'Sports'
    UNION ALL SELECT 'Programming'
),
all_combinations AS (
    -- Step 1: all 9 combinations
    SELECT 
        p.platform,
        e.experiment_name
    FROM platforms p
    CROSS JOIN experiments e
),
counts AS (
    -- Step 2: pre-aggregate actual data
    SELECT 
        platform,
        experiment_name,
        COUNT(*) AS num_experiments
    FROM Experiments
    GROUP BY platform, experiment_name
)
-- Step 3: attach counts
SELECT 
    ac.platform,
    ac.experiment_name,
    COALESCE(c.num_experiments, 0) AS num_experiments
FROM all_combinations ac
LEFT JOIN counts c
    ON ac.platform = c.platform
   AND ac.experiment_name = c.experiment_name;
-----------------------------
WITH platforms AS (
    SELECT 'Android' AS platform
    UNION ALL
    SELECT 'IOS' AS platform
    UNION ALL
    SELECT 'Web' AS platform
),
activities AS (
    SELECT 'Reading' AS activity
    UNION ALL
    SELECT 'Sports' AS activity
    UNION ALL
    SELECT 'Programming' AS activity
)

SELECT
    p.platform,
    e.activity AS experiment_name,
    SUM(CASE
        WHEN ep.experiment_name = e.activity THEN 1 ELSE 0
    END) AS num_experiments
FROM platforms p
JOIN activities e
LEFT JOIN experiments ep ON 
    p.platform = ep.platform AND 
    e.activity = ep.experiment_name
GROUP BY p.platform, e.activity;
