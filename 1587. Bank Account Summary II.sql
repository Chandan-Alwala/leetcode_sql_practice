WITH balance_cte AS (
    SELECT 
        account,
        SUM(amount) AS balance
    FROM Transactions
    GROUP BY account
)

SELECT 
    u.name,
    b.balance
FROM Users u
JOIN balance_cte b
    ON u.account = b.account
WHERE b.balance > 10000;
-------------------------------
SELECT
    u.name,
    SUM(t.amount) as balance
FROM transactions t
LEFT JOIN users u on t.account = u.account
GROUP BY t.account
HAVING SUM(t.amount) > 10000;
