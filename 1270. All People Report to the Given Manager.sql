SELECT
    e1.employee_id
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.employee_id
JOIN Employees e3 ON e2.manager_id = e3.employee_id
WHERE e3.manager_id = 1 AND e1.employee_id != 1;

--------------------

WITH level1 AS (
    SELECT employee_id
    FROM Employees
    WHERE manager_id = 1
),

level2 AS (
    SELECT employee_id
    FROM Employees
    WHERE manager_id IN (SELECT employee_id FROM level1)
),

level3 AS (
    SELECT employee_id
    FROM Employees
    WHERE manager_id IN (SELECT employee_id FROM level2)
)

SELECT DISTINCT employee_id
FROM (
    SELECT employee_id FROM level1
    UNION ALL
    SELECT employee_id FROM level2
    UNION ALL
    SELECT employee_id FROM level3
) t;
