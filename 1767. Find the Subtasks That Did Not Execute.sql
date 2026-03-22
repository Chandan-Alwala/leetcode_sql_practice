WITH RECURSIVE all_subtasks AS (
    SELECT 
        task_id,
        1 AS subtask_id,
        subtasks_count
    FROM Tasks
    
    UNION ALL
    
    SELECT 
        task_id,
        subtask_id + 1,
        subtasks_count
    FROM all_subtasks
    WHERE subtask_id < subtasks_count
)
SELECT 
    a.task_id,
    a.subtask_id
FROM all_subtasks a
WHERE NOT EXISTS (
    SELECT 1
    FROM Executed e
    WHERE e.task_id = a.task_id
      AND e.subtask_id = a.subtask_id
);
-------------------------
# Recursive query with sub-query
WITH RECURSIVE cte AS (
    SELECT task_id, subtasks_count FROM tasks
    UNION ALL
    SELECT task_id, subtasks_count - 1 AS subtasks_count FROM cte WHERE subtasks_count > 1
)
SELECT
    c.task_id,
    c.subtasks_count AS subtask_id
FROM cte c
WHERE c.subtasks_count NOT IN (
    SELECT subtask_id FROM executed e WHERE e.task_id = c.task_id
);


# Recursive query with JOIN
WITH RECURSIVE cte AS (
    SELECT task_id, subtasks_count FROM tasks
    UNION ALL
    SELECT task_id, subtasks_count - 1 AS subtasks_count FROM cte WHERE subtasks_count > 1
)

SELECT 
    c.task_id,
    c.subtasks_count AS subtask_id
FROM cte c 
LEFT JOIN executed e ON 
    c.task_id = e.task_id AND 
    c.subtasks_count = e.subtask_id 
WHERE e.subtask_id is NULL;
