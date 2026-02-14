WITH spend_by_user AS(
    SELECT
        spend_date,
        user_id,
        SUM(
            CASE WHEN platform = 'desktop' THEN amount ELSE 0 END
        ) AS desktop_spend,
        SUM(
            CASE WHEN platform = 'mobile' THEN amount ELSE 0 END
        ) AS mobile_spend
    FROM spending
    GROUP BY spend_date, user_id
),
spend_allocation AS(
    SELECT
        spend_date,
        'desktop' as platform,
        SUM(CASE WHEN desktop_spend > 0 AND mobile_spend = 0 THEN desktop_spend ELSE 0 END) total_amount, 
        SUM(CASE WHEN desktop_spend > 0 AND mobile_spend = 0 THEN 1 ELSE 0 END) total_users
    FROM spend_by_user
    GROUP BY spend_date
    UNION ALL
    SELECT
        spend_date,
        'mobile' as platform,
        SUM(CASE WHEN desktop_spend = 0 AND mobile_spend > 0 THEN mobile_spend ELSE 0 END) total_amount, 
        SUM(CASE WHEN desktop_spend = 0 AND mobile_spend > 0 THEN 1 ELSE 0 END) total_users
    FROM spend_by_user
    GROUP BY spend_date
    UNION ALL
    SELECT
        spend_date,
        'both' as platform,
        SUM(CASE WHEN desktop_spend > 0 AND mobile_spend > 0 THEN desktop_spend + mobile_spend ELSE 0 END) total_amount, 
        SUM(CASE WHEN desktop_spend > 0 AND mobile_spend > 0 THEN 1 ELSE 0 END) total_users
    FROM spend_by_user
    GROUP BY spend_date
)

SELECT 
    spend_date,
    platform,
    total_amount,
    total_users
FROM spend_allocation;


-------------------------------------------


WITH user_daily AS (
    SELECT
        spend_date,
        user_id,
        SUM(CASE WHEN platform = 'mobile' THEN amount ELSE 0 END) AS mobile_amt,
        SUM(CASE WHEN platform = 'desktop' THEN amount ELSE 0 END) AS desktop_amt
    FROM Spending
    GROUP BY spend_date, user_id
),
classified AS (
    SELECT
        spend_date,
        user_id,
        CASE
            WHEN mobile_amt > 0 AND desktop_amt > 0 THEN 'both'
            WHEN mobile_amt > 0 THEN 'mobile'
            ELSE 'desktop'
        END AS platform,
        mobile_amt + desktop_amt AS total_amount
    FROM user_daily
)
SELECT
    spend_date,
    platform,
    SUM(total_amount) AS total_amount,
    COUNT(user_id) AS total_users
FROM classified
GROUP BY spend_date, platform
ORDER BY spend_date, platform;

