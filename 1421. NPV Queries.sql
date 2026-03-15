SELECT 
    q.id,
    q.year,
    COALESCE(n.npv, 0) AS npv
FROM Queries q
LEFT JOIN NPV n
    ON q.id = n.id AND q.year = n.year;
---------------------
SELECT
    q.id,
    q.year,
    IFNULL(n.npv, 0) AS npv
FROM queries q
LEFT JOIN npv n ON q.id = n.id AND q.year = n.year
GROUP BY q.id, q.year; --wrong, no need of group by 
