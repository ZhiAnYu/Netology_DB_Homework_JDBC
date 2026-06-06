--liquibase formatted sql

--changeset author:zhianyu id:001
CREATE SCHEMA IF NOT EXISTS netology_homework;

CREATE TABLE IF NOT EXISTS netology_homework.customers (
                                                           id BIGSERIAL PRIMARY KEY,
                                                           name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 10 AND age <= 100),
    phone_number VARCHAR(20)
    );

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
--rollback DROP TABLE netology_homework.orders; DROP TABLE netology_homework.customers; DROP SCHEMA netology_homework;