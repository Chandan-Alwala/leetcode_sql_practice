WITH cte AS (
    SELECT 
        c.candidate_id,
        r.score
    FROM Candidates c
    JOIN Rounds r
      ON c.interview_id = r.interview_id
    WHERE c.years_of_exp >= 2
)
SELECT candidate_id
FROM cte
GROUP BY candidate_id
HAVING SUM(score) > 15;
----------------------
SELECT
    c.candidate_id
FROM candidates c
LEFT JOIN rounds r ON c.interview_id = r.interview_id
WHERE c.years_of_exp >= 2
GROUP BY c.candidate_id
HAVING SUM(r.score) > 15;
