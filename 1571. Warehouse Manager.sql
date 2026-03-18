WITH product_volume AS (
    SELECT 
        product_id,
        Width * Length * Height AS volume_per_unit
    FROM Products
)

SELECT 
    w.name AS warehouse_name,
    SUM(w.units * p.volume_per_unit) AS volume
FROM Warehouse w
JOIN product_volume p
    ON w.product_id = p.product_id
GROUP BY w.name;
------------------------------
SELECT
    w.name AS warehouse_name,
    SUM(w.units * p.width * p.length * p.height) AS volume
FROM warehouse w
LEFT JOIN products p ON w.product_id = p.product_id
GROUP BY w.name;
