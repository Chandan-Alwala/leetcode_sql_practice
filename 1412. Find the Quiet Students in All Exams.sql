WITH quiet_ranker AS (
    SELECT
        exam_id,
        student_id,
        RANK() OVER(PARTITION BY exam_id ORDER BY score) AS low_rank,
        RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) AS high_rank
    FROM Exam
)
SELECT s.student_id, s.student_name
FROM Student s
WHERE EXISTS (
    SELECT 1
    FROM Exam e
    WHERE e.student_id = s.student_id
)  -- ensure student took at least one exam
AND NOT EXISTS (
    SELECT 1
    FROM quiet_ranker q
    WHERE q.student_id = s.student_id
      AND (q.low_rank = 1 OR q.high_rank = 1)
)
ORDER BY s.student_id;

----------------------------------
# Solution with two CTEs and sub-query in WHERE clause
WITH quiet_ranker AS(
    SELECT
        exam_id,
        student_id,
        RANK() OVER(PARTITION BY exam_id ORDER BY score) AS s_rank,
        RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) AS r_rank
    FROM exam
)
,rank_dist AS(
    SELECT
        DISTINCT student_id
    FROM quiet_ranker 
    WHERE s_rank = 1 OR r_rank = 1
)

SELECT
    *
FROM student
WHERE 
    student_id NOT IN (SELECT * FROM rank_dist) AND 
    student_id IN (SELECT student_id FROM EXAM);
-- if rank_dist is large, the execution time is more 

------------------------------------
# Solution with two CTEs and JOIN instead of sub-query for WHERE clause
WITH quiet_ranker AS(
    SELECT
        student_id,
        RANK() OVER(PARTITION BY exam_id ORDER BY score) AS s_rank,
        RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) AS r_rank
    FROM exam
)
,rank_dist AS(
    SELECT
        DISTINCT student_id
    FROM quiet_ranker 
    WHERE s_rank = 1 OR r_rank = 1
)
SELECT
    DISTINCT q.student_id,
    s.student_name
FROM quiet_ranker q
LEFT JOIN student s ON q.student_id = s.student_id
WHERE q.student_id NOT IN (SELECT * FROM rank_dist)
ORDER BY q.student_id;
