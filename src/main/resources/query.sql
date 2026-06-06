SELECT o.product_name
FROM netology_homework.orders o
         JOIN netology_homework.customers c ON o.customer_id = c.id
WHERE LOWER(c.name) = LOWER(:name)
    LIMIT 1;