# With sub-query JOIN
SELECT 
    distinct a.product_id,
    ifnull(temp.new_price,10) as price 
FROM products as a
LEFT JOIN
(
    SELECT 
        * 
    FROM products 
    WHERE (product_id, change_date) in (
        select 
            product_id,
            max(change_date) 
        from products 
        where change_date<="2019-08-16" 
        group by product_id
    )
) as temp on a.product_id = temp.product_id;


# Modular with two CTEs, easy to understand
WITH ids_with_no_change AS(
    SELECT
        product_id
    FROM products
    GROUP BY product_id
    HAVING MIN(change_date) > '2019-08-16'
    
)
, ids_with_change AS (
    SELECT
        product_id,
        change_date,
        new_price AS price
    FROM products
    WHERE (product_id, change_date) IN (
        SELECT 
            product_id, 
            MAX(change_date)
        FROM products
        WHERE change_date <= '2019-08-16'
        GROUP BY product_id
    )
)

SELECT product_id, 10 AS price FROM ids_with_no_change
UNION
SELECT product_id, price FROM ids_with_change;


# More modular with three CTEs, easier to understand
WITH id_with_no_change AS(
    SELECT
        product_id
    FROM products
    GROUP BY product_id
    HAVING MIN(change_date) > '2019-08-16'
)
, max_change_date AS (
    SELECT
        product_id,
        MAX(change_date) AS change_date
    FROM products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
)
, id_with_change AS (
    SELECT
        product_id,
        change_date,
        new_price
    FROM products
    WHERE (product_id, change_date) IN (
        SELECT product_id, change_date FROM max_change_date
    )
)

SELECT product_id, 10 AS price FROM id_with_no_change
UNION
SELECT product_id, new_price AS price FROM id_with_change;


---------------------------------------------------



WITH distinct_products AS (
    SELECT DISTINCT product_id
    FROM Products
),
ranked_prices AS (
    SELECT 
        dp.product_id,
        p.new_price,
        p.change_date,
        RANK() OVER (
            PARTITION BY dp.product_id
            ORDER BY p.change_date DESC
        ) AS rnk
    FROM distinct_products dp
    LEFT JOIN Products p
        ON dp.product_id = p.product_id
       AND p.change_date <= '2019-08-16'
)

SELECT 
    product_id,
    COALESCE(new_price, 10) AS price
FROM ranked_prices
WHERE rnk = 1 OR rnk IS NULL;

---------------------------------------------------

SELECT 
    p.product_id,
    COALESCE(pr.new_price, 10) AS price
FROM 
    (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN Products pr
    ON p.product_id = pr.product_id
   AND pr.change_date = (
        SELECT MAX(change_date)
        FROM Products
        WHERE product_id = p.product_id
          AND change_date <= '2019-08-16'
   );

