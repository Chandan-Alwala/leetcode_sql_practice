WITH cte AS (
    SELECT 
        Id,
        RecordDate,
        Temperature,
        LAG(Temperature) OVER (ORDER BY RecordDate) AS prev_temp,
        LAG(RecordDate) OVER (ORDER BY RecordDate) AS prev_date
    FROM Weather
)
SELECT Id
FROM cte
WHERE Temperature > prev_temp
  AND DATEDIFF(RecordDate, prev_date) = 1;
----------------------
SELECT 
    w1.id
FROM weather w1
JOIN weather w2 ON 
    w1.temperature > w2.temperature AND 
    DATEDIFF(w1.recordDate, w2.recordDate) = 1;
