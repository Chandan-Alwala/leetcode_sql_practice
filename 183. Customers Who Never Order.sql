SELECT Name AS Customers
FROM Customers
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders
    WHERE Orders.CustomerId = Customers.Id
);
-----------------
SELECT
    name AS Customers
FROM customers 
WHERE id NOT IN (
    SELECT DISTINCT customerId from orders
);
