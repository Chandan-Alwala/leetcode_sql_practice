-- cte1: combine caller and callee with durations
WITH cte1 AS (
    SELECT caller_id AS person_id, duration FROM Calls
    UNION ALL
    SELECT callee_id AS person_id, duration FROM Calls
),

-- cte2: join cte1 with Person and Country to get country for each call
cte2 AS (
    SELECT co.name AS country, c1.duration
    FROM cte1 c1
    JOIN Person p ON c1.person_id = p.id
    JOIN Country co ON LEFT(p.phone_number, 3) = co.country_code
)

-- final: countries whose avg duration > global avg
SELECT country
FROM cte2
GROUP BY country
HAVING AVG(duration) > (SELECT AVG(duration) FROM cte2);
