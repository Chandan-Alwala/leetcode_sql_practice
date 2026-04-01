SELECT COUNT(*) AS accounts_count
FROM Subscriptions s
WHERE YEAR(s.start_date) = 2021
AND NOT EXISTS (
    SELECT 1
    FROM Streams st
    WHERE st.account_id = s.account_id
      AND YEAR(st.stream_date) = 2021
);
------------
WITH registered_in_2021 AS (
    SELECT
        account_id,
        start_date,
        end_date
    FROM subscriptions
    WHERE YEAR(start_date) = 2021
)

SELECT
    COUNT(sb.account_id) AS accounts_count
FROM subscriptions sb
LEFT JOIN streams st ON sb.account_id = st.account_id
WHERE YEAR(start_date) <= 2021 AND 
    YEAR(end_date)>=2021 AND 
    YEAR(stream_date) != 2021;
