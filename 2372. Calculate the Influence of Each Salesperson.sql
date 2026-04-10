WITH sales_agg AS (
    SELECT 
        c.salesperson_id,
        SUM(s.price) AS total
    FROM Customer c
    JOIN Sales s 
      ON c.customer_id = s.customer_id
    GROUP BY c.salesperson_id
)

SELECT 
    sp.salesperson_id,
    sp.name,
    COALESCE(sa.total, 0) AS total
FROM Salesperson sp
LEFT JOIN sales_agg sa
  ON sp.salesperson_id = sa.salesperson_id;
----------------
SELECT
    sp.salesperson_id,
    sp.name,
    IFNULL(SUM(price), 0) as total
FROM salesperson sp
LEFT JOIN customer c ON sp.salesperson_id = c.salesperson_id
LEFT JOIN sales s ON s.customer_id = c.customer_id
GROUP BY sp.salesperson_id;
