With cte as (
Select user_id, sum(distance) as travelled_distance
From Rides 
Group by 1 
)

Select 
U.name as name, coalesce(c.travelled_distance,0) as c.travelled_distance
From Users u left join cte c
On u.id = c.user_id 
Order by travelled_distance desc, name asc
-------------------------------------
SELECT
    u.name,
    IFNULL(SUM(r.distance), 0) AS travelled_distance
FROM users u
LEFT JOIN rides r ON r.user_id = u.id
GROUP BY r.user_id
ORDER BY travelled_distance DESC, u.name;
