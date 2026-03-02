WITH visit_txn AS (
    SELECT
        v.user_id,
        v.visit_date,
        COUNT(t.transaction_date) AS transactions_count
    FROM Visits v
    LEFT JOIN Transactions t
        ON v.user_id = t.user_id
       AND v.visit_date = t.transaction_date
    GROUP BY v.user_id, v.visit_date
),
max_txn AS (
    SELECT MAX(transactions_count) AS max_count
    FROM visit_txn
),
nums AS (
    SELECT 0 AS n
    UNION ALL
    SELECT n + 1
    FROM nums, max_txn
    WHERE n < max_count
)

SELECT
    nums.n AS transactions_count,
    COUNT(visit_txn.transactions_count) AS visits_count
FROM nums
LEFT JOIN visit_txn
    ON nums.n = visit_txn.transactions_count
GROUP BY nums.n
ORDER BY nums.n;

----------------------------------------------------

WITH transaction_calc AS (
    SELECT
        v.user_id,
        COUNT(t.user_id) AS total
    FROM visits v
    LEFT JOIN transactions t ON v.user_id = t.user_id AND v.visit_date = t.transaction_date
    GROUP BY v.user_id, v.visit_date
),
row_creator AS(
    SELECT 0 as trans_count
    UNION
    SELECT row_number() OVER() as trans_count FROM transactions
),
transaction_count AS(
    SELECT
        total,
        COUNT(1) as total_trans
    FROM transaction_calc
    GROUP BY total
)

SELECT
    rc.trans_count AS transactions_count,
    IFNULL(tc.total_trans, 0) AS visits_count
FROM row_creator rc
LEFT JOIN transaction_count tc ON rc.trans_count = tc.total
WHERE rc.trans_count <= (SELECT MAX(total) FROM transaction_calc);
