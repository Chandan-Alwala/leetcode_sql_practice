----------------------
SELECT p.session_id
FROM Playback p
WHERE NOT EXISTS (
    SELECT 1
    FROM Ads a
    WHERE a.customer_id = p.customer_id
      AND a.timestamp BETWEEN p.start_time AND p.end_time
);
----------------------------
--wrong 
SELECT DISTINCT p.session_id
FROM Playback p
JOIN Ads a 
  ON p.customer_id = a.customer_id
 AND a.timestamp NOT BETWEEN p.start_time AND p.end_time; (***wrong)

--correct
SELECT p.session_id
FROM Playback p
LEFT JOIN Ads a
  ON p.customer_id = a.customer_id
 AND a.timestamp BETWEEN p.start_time AND p.end_time
WHERE a.ad_id IS NULL;


----------------------------
SELECT
    session_id
FROM playback
WHERE session_id NOT IN (
    SELECT
        p.session_id
    FROM playback p
    JOIN ads a ON 
        p.customer_id = a.customer_id AND 
        a.timestamp >= p.start_time AND 
        a.timestamp <= p.end_time
);
