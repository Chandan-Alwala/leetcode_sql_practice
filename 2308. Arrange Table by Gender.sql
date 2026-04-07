WITH gender_rank AS (
    SELECT
        user_id,
        gender,
        ROW_NUMBER() OVER(PARTITION BY gender ORDER BY user_id) AS g_rank
    FROM Genders
)
SELECT 
    user_id,
    gender
FROM gender_rank
ORDER BY 
    g_rank,
    CASE 
        WHEN gender = 'female' THEN 1
        WHEN gender = 'other' THEN 2
        WHEN gender = 'male' THEN 3
    END;
-----------------

