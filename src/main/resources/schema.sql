create schema if not exists netology_homework;
create table if not exists netology_homework.customers (
    id bigserial primary key,
    name varchar (50) not null,
    surname varchar (50) not null,
    age int check (age>=10 and age<=100),
    phone_number varchar (20)
);

create table if not exists netology_homework.orders (
    id bigserial primary key,
    date date not null,
    customer_id bigint not null ,
    product_name varchar (100) not null,
    amount int not null,
    constraint fk_orders_customer
      foreign key (customer_id)
      references netology_homework.customers (id)
);

--Test tables
insert into netology_homework.customers (name, surname, age, phone_number)
values ('Kirill', 'Petrov', 25, '+79001234567'),
       ('Oleg', 'Ivanov', 23, '+79001234568');

insert into netology_homework.orders (date, customer_id, product_name, amount)
values ('2025-10-01',1,'Dirol', 2),
       ('2025-10-10',2,'Orbit', 1);