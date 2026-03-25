WITH monthly_income AS (
    SELECT 
        account_id,
        DATE_FORMAT(day, '%Y-%m-01') AS month,
        SUM(amount) AS total_income
    FROM Transactions
    WHERE type = 'Creditor'
    GROUP BY account_id, DATE_FORMAT(day, '%Y-%m-01')
)
SELECT DISTINCT account_id
FROM (
    SELECT 
        m.account_id,
        m.month,
        CASE WHEN m.total_income > a.max_income THEN 1 ELSE 0 END AS is_exceed,
        LEAD(m.month) OVER (PARTITION BY m.account_id ORDER BY m.month) AS next_month,
        LEAD(
            CASE WHEN m.total_income > a.max_income THEN 1 ELSE 0 END
        ) OVER (PARTITION BY m.account_id ORDER BY m.month) AS next_flag
    FROM monthly_income m
    JOIN Accounts a
        ON m.account_id = a.account_id
) t
WHERE 
    is_exceed = 1
    AND next_flag = 1
    AND next_month = DATE_ADD(month, INTERVAL 1 MONTH)
ORDER BY account_id;
------------------------------------
WITH monthly_dist AS (
    SELECT
        account_id,
        transaction_id,
        MONTH(day) as month,
        SUM(
            CASE
                WHEN type = 'Creditor' THEN amount ELSE 0
            END 
        ) AS total_income
    FROM transactions 
    GROUP BY account_id, MONTH(day)
)

SELECT
    DISTINCT md1.account_id
FROM monthly_dist md1
JOIN monthly_dist md2 ON md1.account_id = md2.account_id AND ABS(md1.month - md2.month) = 1
LEFT JOIN accounts a ON md1.account_id = a.account_id
WHERE md1.total_income > a.max_income AND md2.total_income > a.max_income
ORDER BY md1.transaction_id;
