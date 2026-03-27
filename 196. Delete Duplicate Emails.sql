DELETE p1
FROM Person p1
JOIN Person p2
  ON p1.Email = p2.Email
 AND p1.Id > p2.Id;
-----
DELETE p1
FROM Person p1
WHERE EXISTS (
    SELECT 1
    FROM Person p2
    WHERE p1.Email = p2.Email
      AND p1.Id > p2.Id
);
--------------------------------------
# With sub-query
DELETE p1.* 
FROM person p1
WHERE p1.id NOT IN (
    SELECT * FROM 
        (SELECT min(id) FROM person GROUP BY email) as p
)


# With join
DELETE p1.* 
FROM person p1
JOIN person p2 ON p1.email = p2.email
WHERE p1.id > p2.id;
