WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < (SELECT MAX(customer_id) FROM Customers)
)
SELECT n AS ids
FROM nums
WHERE NOT EXISTS (
    SELECT 1
    FROM Customers c
    WHERE c.customer_id = nums.n
)
ORDER BY n;
--------------------------------
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < (SELECT MAX(customer_id) FROM Customers)
)
SELECT n AS ids
FROM nums
LEFT JOIN Customers c
ON nums.n = c.customer_id
WHERE c.customer_id IS NULL
ORDER BY n;
--------------------------------
WITH RECURSIVE nums AS (
    SELECT 1 AS value
    UNION ALL
    SELECT value + 1 AS value
    FROM nums
    WHERE nums.value < (select max(customer_id) from Customers)
)

SELECT 
    value as ids 
FROM nums 
WHERE value NOT IN (SELECT DISTINCT customer_id FROM customers)
ORDER BY value;
