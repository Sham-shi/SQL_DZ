CREATE TABLE sales (
	id INT PRIMARY KEY,
	product_name VARCHAR(50),
	category VARCHAR(30),
	price DECIMAL(10, 2),
	quantity INT,
	sale_date DATE
);


INSERT INTO sales (id, product_name, category, price, quantity, sale_date) VALUES
(1, 'Ноутбук', 'Электроника', 75000.00, 2, '2024-01-15'),
(2, 'Смартфон', 'Электроника', 45000.00, 5, '2024-01-16'),
(3, 'Кофемашина', 'Бытовая техника', 32000.00, 1, '2024-01-17'),
(4, 'Наушники', 'Электроника', 8000.00, 10, '2024-01-18'),
(5, 'Микроволновка', 'Бытовая техника', 15000.00, 3, '2024-01-19'),
(6, 'Футболка', 'Одежда', 2000.00, 15, '2024-01-20'),
(7, 'Кроссовки', 'Одежда', 5000.00, 8, '2024-01-21'),
(8, 'Чайник', 'Бытовая техника', 4000.00, 7, '2024-01-22'),
(9, 'Монитор', 'Электроника', 25000.00, 4, '2024-01-23'),
(10, 'Джинсы', 'Одежда', 3500.00, 12, '2024-01-24');

-- Суммарная выручка по каждой категории товаров
select
	category,
	sum(price * quantity) as total_revenue
from sales
group by category;

-- Средний чек по каждой категории
select
	category,
	convert(decimal(10, 2), avg(price)) as avg_sale
from sales
group by category;

-- Категории товаров, у которых общая выручка превышает 100 000
select
	category,
	sum(price * quantity) as total_revenue
from sales
group by category
having sum(price * quantity) > 100000
order by total_revenue;

-- Даты, в которые было продано больше 5 товаров
select
	sale_date,
	sum(quantity) as total_quantity
from sales
group by sale_date
having sum(quantity) > 5
order by total_quantity;