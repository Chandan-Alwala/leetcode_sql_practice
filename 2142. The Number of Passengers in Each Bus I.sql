WITH assigned AS (
    SELECT 
        p.passenger_id,
        MIN(b.bus_id) AS bus_id
    FROM Passengers p
    JOIN Buses b
      ON b.arrival_time >= p.arrival_time
    GROUP BY p.passenger_id
)
SELECT 
    b.bus_id,
    COUNT(a.passenger_id) AS passengers_cnt
FROM Buses b
LEFT JOIN assigned a
  ON b.bus_id = a.bus_id
GROUP BY b.bus_id
ORDER BY b.bus_id;
----------------------
WITH passenger_buses AS (
	SELECT
		p.passenger_id,
		MIN(b.arrival_time) AS time_to_board
	FROM passengers p
	JOIN buses b ON p.arrival_time <= b.arrival_time
	GROUP BY passenger_id
)

SELECT
	bus_id,
	COUNT(p.time_to_board) as passengers_cnt
FROM buses b
LEFT JOIN passenger_buses p ON p.time_to_board = b.arrival_time
GROUP BY bus_id
ORDER BY bus_id;
