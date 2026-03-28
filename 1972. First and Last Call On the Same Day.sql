WITH callers AS (
    SELECT caller_id AS user1, recipient_id AS user2, call_time FROM calls
    UNION ALL
    SELECT recipient_id AS user1, caller_id AS user2, call_time FROM calls
),
find_callers AS (
    SELECT
        user1,
        DATE(call_time) AS call_date,
        FIRST_VALUE(user2) OVER (
            PARTITION BY user1, DATE(call_time)
            ORDER BY call_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS first_caller,
        FIRST_VALUE(user2) OVER (
            PARTITION BY user1, DATE(call_time)
            ORDER BY call_time DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_caller
    FROM callers
)
SELECT DISTINCT user1 AS user_id
FROM find_callers
WHERE first_caller = last_caller;
-------------------------
WITH calls_norm AS (
    -- Step 1: make calls bidirectional
    SELECT caller_id AS user_id, recipient_id AS other_id, call_time
    FROM Calls
    UNION ALL
    SELECT recipient_id AS user_id, caller_id AS other_id, call_time
    FROM Calls
),
ranked AS (
    -- Step 2: rank calls per user per day
    SELECT 
        user_id,
        other_id,
        DATE(call_time) AS call_date,
        call_time,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, DATE(call_time)
            ORDER BY call_time
        ) AS rn_asc,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, DATE(call_time)
            ORDER BY call_time DESC
        ) AS rn_desc
    FROM calls_norm
)
SELECT DISTINCT r1.user_id
FROM ranked r1
JOIN ranked r2
    ON r1.user_id = r2.user_id
   AND r1.call_date = r2.call_date
WHERE r1.rn_asc = 1     -- first call
  AND r2.rn_desc = 1    -- last call
  AND r1.other_id = r2.other_id;
-------------------------
# Solution with two CTEs and DISTINCT
WITH callers AS (
    SELECT caller_id AS user1, recipient_id AS user2, call_time FROM calls
    UNION ALL
    SELECT recipient_id AS user1, caller_id AS user2, call_time FROM calls
)
, find_callers AS (
    SELECT
        user1,
        FIRST_VALUE(user2) OVER(PARTITION BY user1, DATE(call_time) ORDER BY call_time) AS first_caller,
        FIRST_VALUE(user2) OVER(PARTITION BY user1, DATE(call_time) ORDER BY call_time DESC) AS last_caller
    FROM callers
)

SELECT
    DISTINCT user1 AS user_id
FROM find_callers
WHERE first_caller = last_caller;


# Same solution without DISTINCT(final SELECT statement)
WITH all_caller AS(
    SELECT caller_id user_id, recipient_id receiver_id, call_time FROM calls
    UNION
    SELECT recipient_id user_id, caller_id receiver_id, call_time FROM calls
),
first_last_caller AS (
    SELECT
        DISTINCT user_id,
        FIRST_VALUE(receiver_id) OVER(PARTITION BY user_id, DATE(call_time) ORDER BY call_time) first_recp_id,
        FIRST_VALUE(receiver_id) OVER(PARTITION BY user_id, DATE(call_time) ORDER BY call_time DESC) last_recp_id
    FROM all_caller
)

SELECT
    user_id
FROM first_last_caller
WHERE first_recp_id = last_recp_id
GROUP BY user_id;
