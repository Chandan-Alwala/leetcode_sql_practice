WITH ranked AS (
    SELECT 
        e.Name AS Employee,
        e.Salary,
        e.DepartmentId,
        DENSE_RANK() OVER (
            PARTITION BY e.DepartmentId 
            ORDER BY e.Salary DESC
        ) AS rnk
    FROM Employee e
)
SELECT 
    d.Name AS Department,
    r.Employee,
    r.Salary
FROM ranked r
JOIN Department d
    ON r.DepartmentId = d.Id
WHERE r.rnk <= 3;
------------------------------
WITH salary_ranker AS (
    SELECT
        e.name AS Employee,
        d.name AS Department,
        e.salary,
        DENSE_RANK() OVER(PARTITION BY e.departmentId ORDER BY e.salary DESC) AS s_rank
    FROM employee e
    LEFT JOIN Department d ON e.departmentId = d.id
)

SELECT
    Department,
    Employee,
    Salary
FROM salary_ranker s
WHERE s.s_rank <= 3;
