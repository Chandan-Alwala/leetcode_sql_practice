WITH transactions_cte AS (
    -- money received (positive)
    SELECT paid_to AS user_id, amount
    FROM Transaction
    
    UNION ALL
    
    -- money sent (negative)
    SELECT paid_by AS user_id, -amount
    FROM Transaction
),

balance_cte AS (
    SELECT 
        user_id,
        SUM(amount) AS net_change
    FROM transactions_cte
    GROUP BY user_id
)

SELECT 
    u.user_id,
    u.user_name,
    u.credit + COALESCE(b.net_change, 0) AS credit,
    CASE 
        WHEN u.credit + COALESCE(b.net_change, 0) < 0 THEN 'Yes'
        ELSE 'No'
    END AS credit_limit_breached
FROM Users u
LEFT JOIN balance_cte b
    ON u.user_id = b.user_id;
----------------------
WITH transaction_unpivot AS (
    SELECT paid_by AS user_id, -1 * amount AS amount FROM transactions
    UNION ALL
    SELECT paid_to AS user_id, amount FROM transactions
)

SELECT
    u.user_id,
    u.user_name,
    u.credit + IFNULL(SUM(tu.amount), 0) AS credit,
    CASE
        WHEN u.credit + IFNULL(SUM(tu.amount), 0) > 0 THEN 'No'
        ELSE 'Yes'
    END AS credit_limit_breached
FROM users u
LEFT JOIN transaction_unpivot tu ON u.user_id = tu.user_id
GROUP BY u.user_id;
