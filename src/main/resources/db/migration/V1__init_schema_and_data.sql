-- Создание схемы
CREATE SCHEMA IF NOT EXISTS netology_homework;

-- Создание таблицы клиентов
CREATE TABLE IF NOT EXISTS netology_homework.customers (
                                                           id BIGSERIAL PRIMARY KEY,
                                                           name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 10 AND age <= 100),
    phone_number VARCHAR(20)
    );

-- Создание таблицы заказов
CREATE TABLE IF NOT EXISTS netology_homework.orders (
                                                        id BIGSERIAL PRIMARY KEY,
                                                        date DATE NOT NULL,
                                                        customer_id BIGINT NOT NULL,
                                                        product_name VARCHAR(100) NOT NULL,
    amount INT NOT NULL,
    CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES netology_homework.customers (id)
    );

-- Тестовые данные
INSERT INTO netology_homework.customers (name, surname, age, phone_number)
VALUES ('Kirill', 'Petrov', 25, '+79001234567'),
       ('Oleg', 'Ivanov', 23, '+79001234568');

INSERT INTO netology_homework.orders (date, customer_id, product_name, amount)
VALUES ('2025-10-01', 1, 'Dirol', 2),
       ('2025-10-10', 2, 'Orbit', 1);