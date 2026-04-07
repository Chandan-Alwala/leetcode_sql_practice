WITH ranked AS (
    SELECT 
        city_id,
        day,
        degree,
        ROW_NUMBER() OVER (
            PARTITION BY city_id
            ORDER BY degree DESC, day ASC
        ) AS rn
    FROM Weather
)
SELECT 
    city_id,
    day,
    degree
FROM ranked
WHERE rn = 1
ORDER BY city_id;
---------------
WITH max_degree AS (
    SELECT
        city_id,
        MAX(degree) AS degree
    FROM weather
    GROUP BY city_id
)

SELECT
    m.city_id,
    MIN(w.day) AS day,
    m.degree
FROM max_degree m
LEFT JOIN weather w ON m.city_id = w.city_id AND m.degree = w.degree
GROUP BY m.city_id, m.degree
ORDER BY city_id;
