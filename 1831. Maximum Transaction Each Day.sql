SELECT t.transaction_id
FROM Transactions t
JOIN (
    SELECT 
        DATE(day) AS d,
        MAX(amount) AS max_amt
    FROM Transactions
    GROUP BY DATE(day)
) m
ON DATE(t.day) = m.d
AND t.amount = m.max_amt
ORDER BY t.transaction_id;
----------------------
WITH transaction_ranker AS(
    SELECT
        transaction_id,
        RANK() OVER(PARTITION BY DATE(day) ORDER BY amount DESC) AS t_rank
    FROM transactions
)

SELECT
    transaction_id
FROM transaction_ranker 
WHERE t_rank = 1
ORDER BY transaction_id;
