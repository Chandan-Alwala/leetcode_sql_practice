WITH senior_cte AS (
    SELECT 
        employee_id,
        salary,
        SUM(salary) OVER (ORDER BY salary) AS running_salary
    FROM Candidates
    WHERE experience = 'Senior'
),
filtered_seniors AS (
    SELECT *
    FROM senior_cte
    WHERE running_salary <= 70000
),
junior_cte AS (
    SELECT 
        employee_id,
        salary,
        SUM(salary) OVER (ORDER BY salary) AS running_salary
    FROM Candidates
    WHERE experience = 'Junior'
),
filtered_juniors AS (
    SELECT *
    FROM junior_cte
    WHERE running_salary <= 70000 - (
        SELECT COALESCE(MAX(running_salary), 0) FROM filtered_seniors
    )
)

SELECT employee_id FROM filtered_seniors

UNION ALL

SELECT employee_id FROM filtered_juniors;
----------------
WITH salary_ranker AS (
    SELECT
        *,
        SUM(salary) OVER(PARTITION BY experience ORDER BY salary) AS budget
    FROM candidates
)
, seniors AS(
    SELECT 
        employee_id, 
        budget 
    FROM salary_ranker where experience="senior"and budget <= 70000
)
, juniors AS(
    SELECT 
        employee_id, 
        budget
    FROM salary_ranker 
    WHERE budget <= 70000 - (SELECT IFNULL(MAX(budget), 0) FROM seniors)
)

SELECT employee_id FROM seniors
UNION
SELECT employee_id FROM juniors;
