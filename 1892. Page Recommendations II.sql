WITH friends AS (
    -- make friendships bidirectional
    SELECT user1_id AS user_id, user2_id AS friend_id FROM Friendship
    UNION
    SELECT user2_id AS user_id, user1_id AS friend_id FROM Friendship
),

friend_likes AS (
    -- get pages liked by friends
    SELECT 
        f.user_id,
        l.page_id
    FROM friends f
    JOIN Likes l
        ON f.friend_id = l.user_id
),

filtered AS (
    -- remove pages already liked by the user
    SELECT fl.user_id, fl.page_id
    FROM friend_likes fl
    WHERE NOT EXISTS (
        SELECT 1
        FROM Likes l2
        WHERE l2.user_id = fl.user_id
          AND l2.page_id = fl.page_id
    )
)

SELECT 
    user_id,
    page_id,
    COUNT(*) AS friends_likes
FROM filtered
GROUP BY user_id, page_id;

------------------
# Solution with one CTE and sub-qeury
WITH friends AS (
    SELECT
        user1_id AS user_id,
        user2_id AS friend_id
    FROM Friendship
    UNION
    SELECT
        user2_id AS user_id,
        user1_id AS friend_id
    FROM Friendship
)

SELECT
    friends.user_id,
    FriendsLikes.page_id,
    COUNT(FriendsLikes.user_id) AS friends_likes
FROM friends
JOIN Likes AS FriendsLikes
ON friends.friend_id = FriendsLikes.user_id
LEFT JOIN Likes AS MyLikes
ON (
    friends.user_id = MyLikes.user_id
    AND
    FriendsLikes.page_id = MyLikes.page_id
)
WHERE MyLikes.user_id IS NULL
GROUP BY friends.user_id, FriendsLikes.page_id;


# Solution with two CTEs
WITH friends AS (
    SELECT
        user1_id AS user_id,
        user2_id AS friend_id
    FROM Friendship
    UNION ALL
    SELECT
        user2_id AS user_id,
        user1_id AS friend_id
    FROM Friendship
)
,friend_likes AS (
    SELECT
        f.user_id,
        f.friend_id,
        l.page_id
    FROM friends f
    JOIN likes l ON f.friend_id = l.user_id
)

SELECT
    fl.user_id,
    fl.page_id,
    COUNT(fl.friend_id) as friends_likes
FROM friend_likes fl
LEFT JOIN likes l
on fl.user_id = l.user_id and fl.page_id = l.page_id 
where l.page_id is null
group by fl.user_id, fl.page_id;
