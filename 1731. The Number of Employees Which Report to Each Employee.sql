WITH report_stats AS (
    SELECT 
        reports_to AS employee_id,
        COUNT(*) AS reports_count,
        ROUND(AVG(age)) AS average_age
    FROM Employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
)
SELECT 
    e.employee_id,
    e.name,
    r.reports_count,
    r.average_age
FROM report_stats r
JOIN Employees e
    ON e.employee_id = r.employee_id
ORDER BY e.employee_id;
---------------------------
SELECT
    e1.employee_id,
    e1.name,
    COUNT(e2.reports_to) as reports_count,
    ROUND(AVG(e2.age)) AS average_age
FROM employees e1
JOIN employees e2 ON e1.employee_id = e2.reports_to
GROUP BY employee_id, name
ORDER BY employee_id;
