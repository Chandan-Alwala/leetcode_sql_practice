SELECT e.employee_id
FROM Employees e
WHERE e.salary < 30000
AND e.manager_id IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM Employees m
    WHERE m.employee_id = e.manager_id
)
ORDER BY e.employee_id;
-------------------------
SELECT
    e1.employee_id
FROM employees e1
WHERE e1.salary < 30000 AND 
    e1.manager_id NOT IN (SELECT employee_id from employees)
ORDER BY e1.employee_id;
