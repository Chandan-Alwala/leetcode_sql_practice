WITH visit_counts AS (
    SELECT member_id, COUNT(*) AS total_visits
    FROM Visits
    GROUP BY member_id
),
purchase_counts AS (
    SELECT v.member_id, COUNT(*) AS total_purchases
    FROM Visits v
    JOIN Purchases p
      ON v.visit_id = p.visit_id
    GROUP BY v.member_id
)
SELECT 
    m.member_id,
    m.name,
    CASE
        WHEN vc.total_visits IS NULL THEN 'Bronze'
        WHEN (100 * COALESCE(pc.total_purchases, 0) / vc.total_visits) >= 80 THEN 'Diamond'
        WHEN (100 * COALESCE(pc.total_purchases, 0) / vc.total_visits) >= 50 THEN 'Gold'
        ELSE 'Silver'
    END AS category
FROM Members m
LEFT JOIN visit_counts vc
    ON m.member_id = vc.member_id
LEFT JOIN purchase_counts pc
    ON m.member_id = pc.member_id;
------------------
WITH category_calc AS (
    SELECT
        m.member_id,
        m.name,
        CASE 
            WHEN COUNT(v.member_id) = 0 THEN -1
            ELSE ((100 * COUNT(p.visit_id)) / COUNT(v.member_id))
        END AS conversion_rate        
    FROM members m
    LEFT JOIN visits v ON m.member_id = v.member_id
    LEFT JOIN purchases p ON v.visit_id = p.visit_id
    GROUP BY m.member_id, m.name
)

SELECT
    member_id,
    name,
    CASE
        WHEN conversion_rate >= 80 THEN 'Diamond'
        WHEN conversion_rate >= 50 AND conversion_rate < 80 THEN 'Gold'
        WHEN conversion_rate < 50 AND conversion_rate >= 0 THEN 'Silver'
        ELSE 'Bronze'
    END category
FROM category_calc;
