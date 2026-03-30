WITH max_students AS (
    SELECT 
        s.school_id,
        MAX(e.student_count) AS max_count
    FROM Schools s
    LEFT JOIN Exam e
        ON e.student_count <= s.capacity
    GROUP BY s.school_id
),
best_scores AS (
    SELECT 
        m.school_id,
        MIN(e.score) AS score
    FROM max_students m
    LEFT JOIN Exam e
        ON e.student_count = m.max_count
    GROUP BY m.school_id
)
SELECT 
    school_id,
    COALESCE(score, -1) AS score
FROM best_scores;
----------------
WITH valid_scores AS (
    SELECT 
        s.school_id,
        e.score,
        e.student_count
    FROM Schools s
    LEFT JOIN Exam e
        ON e.student_count <= s.capacity
),
ranked AS (
    SELECT 
        school_id,
        score,
        ROW_NUMBER() OVER (
            PARTITION BY school_id
            ORDER BY student_count DESC, score ASC
        ) AS rn
    FROM valid_scores
)
SELECT 
    s.school_id,
    COALESCE(r.score, -1) AS score
FROM Schools s
LEFT JOIN ranked r
    ON s.school_id = r.school_id AND r.rn = 1;
--------------
SELECT
    s.school_id,
    IFNULL(MIN(e.score), -1) AS score
FROM schools s
LEFT JOIN exam e ON s.capacity >= e.student_count
GROUP BY s.school_id, s.capacity;
