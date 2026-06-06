--liquibase formatted sql

--changeset author:zhianyu id:002
--Test tables
INSERT INTO netology_homework.customers (name, surname, age, phone_number)
VALUES ('Kirill', 'Petrov', 25, '+79001234567'),
       ('Oleg', 'Ivanov', 23, '+79001234568');

INSERT INTO netology_homework.orders (date, customer_id, product_name, amount)
VALUES ('2025-10-01', 1, 'Dirol', 2),
       ('2025-10-10', 2, 'Orbit', 1);

--rollback DELETE FROM netology_homework.orders WHERE customer_id IN (1, 2);
--rollback DELETE FROM netology_homework.customers WHERE name IN ('Kirill', 'Oleg');