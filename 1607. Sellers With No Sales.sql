SELECT 
    s.seller_name
FROM Seller s
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.seller_id = s.seller_id
      AND YEAR(o.sale_date) = 2020
)
ORDER BY s.seller_name;
------------------------
SELECT 
    s.seller_name
FROM Seller s
LEFT JOIN Orders o
    ON s.seller_id = o.seller_id
    AND YEAR(o.sale_date) = 2020 -- shouldn't be in the where clause
WHERE o.seller_id IS NULL
ORDER BY s.seller_name;
-------------------------
SELECT
    s.seller_name
FROM seller s
WHERE s.seller_id NOT IN (
    SELECT DISTINCT seller_id FROM orders WHERE YEAR(sale_date) = 2020
)
ORDER BY s.seller_name;
