WITH years AS (
    SELECT 2018 AS report_year
    UNION ALL
    SELECT 2019
    UNION ALL
    SELECT 2020
)

SELECT 
    s.product_id,
    p.product_name,
    y.report_year,
    (
        DATEDIFF(
            LEAST(s.period_end, STR_TO_DATE(CONCAT(y.report_year,'-12-31'), '%Y-%m-%d')),
            GREATEST(s.period_start, STR_TO_DATE(CONCAT(y.report_year,'-01-01'), '%Y-%m-%d'))
        ) + 1
    ) * s.average_daily_sales AS total_amount
FROM Sales s
JOIN Product p 
    ON s.product_id = p.product_id
JOIN years y
    ON s.period_start <= CONCAT(y.report_year,'-12-31')
   AND s.period_end >= CONCAT(y.report_year,'-01-01')
ORDER BY s.product_id, y.report_year;

-- -- - - - - - - - - - - - - - -  -
WITH RECURSIVE years AS (
    SELECT 2018 AS report_year
    UNION ALL
    SELECT report_year + 1
    FROM years
    WHERE report_year < 2020
) 
-- Can add as recursive CTE too 
---------------------------------------------

WITH year_unpivot AS (
	SELECT
		product_id, 
		'2018' as report_year, 
		average_daily_sales * 
		(DATEDIFF(
			LEAST('2018-12-31', period_end), 
			GREATEST('2018-01-01', period_start)
		) + 1) AS total_amount 	FROM sales
	WHERE YEAR(period_start) = 2018 OR YEAR(period_end) = 2018
	UNION ALL
	SELECT
		product_id, 
		'2019' as report_year, 
		average_daily_sales * 
		(DATEDIFF(
			LEAST('2019-12-31', period_end), 
			GREATEST('2019-01-01', period_start)
		) + 1) AS total_amount FROM sales
		WHERE YEAR(period_start) <= 2019 OR YEAR(period_end) >= 2019
	UNION ALL
	SELECT
		product_id, 
		'2020' as report_year, 
		average_daily_sales * 
		(DATEDIFF(
			LEAST('2020-12-31', period_end), 
			GREATEST('2020-01-01', period_start)
		) + 1) AS total_amount FROM sales
		WHERE YEAR(period_start) = 2020 OR YEAR(period_end) = 2020
)

SELECT 
	y.product_id, 
	p.product_name,
	y.report_year,
	y.total_amount	
FROM year_unpivot y
LEFT JOIN product p ON p.product_id = y.product_id
WHERE y.total_amount > 0
ORDER by y.product_id, y.report_year;
