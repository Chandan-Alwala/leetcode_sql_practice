WITH invoice_total AS (
    SELECT 
        p.invoice_id,
        SUM(p.quantity * pr.price) AS total_price
    FROM Purchases p
    JOIN Products pr 
      ON p.product_id = pr.product_id
    GROUP BY p.invoice_id
),
best_invoice AS (
    SELECT invoice_id
    FROM invoice_total
    ORDER BY total_price DESC, invoice_id ASC
    LIMIT 1
)
SELECT 
    p.product_id,
    p.quantity,
    p.quantity * pr.price AS price
FROM Purchases p
JOIN Products pr 
  ON p.product_id = pr.product_id
WHERE p.invoice_id = (
    SELECT invoice_id FROM best_invoice
);
-------------------
WITH product_ranker AS(
    SELECT
        pc.invoice_id,
        SUM(pc.quantity * p.price) AS price
    FROM purchases pc
    LEFT JOIN products p ON pc.product_id = p.product_id
    GROUP BY pc.invoice_id
    ORDER BY price DESC, pc.invoice_id ASC
    LIMIT 1
)

SELECT
    p.product_id,
    p.quantity,
    p.quantity * pp.price AS price
FROM purchases p
LEFT JOIN products pp ON p.product_id = pp.product_id
RIGHT JOIN product_ranker pr ON p.invoice_id = pr.invoice_id;
