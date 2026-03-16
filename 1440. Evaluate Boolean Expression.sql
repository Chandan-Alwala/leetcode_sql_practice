SELECT 
    e.left_operand,
    e.operator,
    e.right_operand,
    CASE e.operator
        WHEN '>' THEN CASE WHEN lv.value > rv.value THEN 'true' ELSE 'false' END
        WHEN '<' THEN CASE WHEN lv.value < rv.value THEN 'true' ELSE 'false' END
        WHEN '=' THEN CASE WHEN lv.value = rv.value THEN 'true' ELSE 'false' END
    END AS value
FROM Expressions e
JOIN Variables lv ON e.left_operand = lv.name
JOIN Variables rv ON e.right_operand = rv.name;
--------------------------------
SELECT
    left_operand,
    operator,
    right_operand,
    CASE
        WHEN operator = '>' AND v1.value > v2.value THEN 'true'
        WHEN operator = '>' AND v1.value < v2.value THEN 'false'
        WHEN operator = '<' AND v1.value < v2.value THEN 'true'
        WHEN operator = '<' AND v1.value > v2.value THEN 'false'
        WHEN operator = '=' AND v1.value = v2.value THEN 'true'
        ELSE 'false'
    END AS value
FROM expressions e
LEFT JOIN variables v1 ON v1.name = e.left_operand # x
LEFT JOIN variables v2 ON v2.name = e.right_operand; # y
