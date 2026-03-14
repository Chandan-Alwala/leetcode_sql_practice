select stock_name, 
SUM(
    case when operation = 'SELL' Then price 
    else -price
    END 
) as capital_gain_loss
from stocks 
group by stock_name ;
-----------------------------
SELECT
    stock_name,
    SUM(
        CASE WHEN operation = 'sell' THEN price ELSE 0 END
    ) - 
    SUM(
        CASE WHEN operation = 'buy' THEN price ELSE 0 END
    ) AS capital_gain_loss
FROM stocks 
GROUP BY stock_name;
