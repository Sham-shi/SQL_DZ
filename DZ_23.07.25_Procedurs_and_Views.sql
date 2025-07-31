-- процедура для использования в блоке catch
CREATE PROCEDURE usp_GetErrorInfo
AS
SELECT
	ERROR_NUMBER() AS ErrorNumber,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

-----------------------------------------------------------------------------------------------------------------
-- Необходимо написать функционал по добавлению пользователя,
-- продукта, категории продукта, присвоению продукту категории

-- добавление пользователя
create or alter procedure Add_user
	@login nvarchar(50),
	@password nvarchar(100),
	@first_name nvarchar(100),
	@last_name nvarchar(100),
	@middle_name nvarchar(100),
	@email nvarchar(255),
	@phone nvarchar(20)
as
begin
	begin try
		begin transaction
			INSERT INTO users (login, password, first_name, last_name, middle_name, email, phone, registration_date)
			VALUES
				(@login, @password, @first_name, @last_name, @middle_name, @email, @phone, getdate());
		commit transaction
	end try

	begin catch
		rollback transaction
		exec usp_GetErrorInfo
	end catch
end

-- добавление продукта
create or alter procedure Add_product
	@title nvarchar(200),
	@description nvarchar(1000),
	@price decimal(10, 2)
as
begin
	begin try
		begin transaction
			INSERT INTO products (title, description, price, added_date)
			VALUES
				(@title, @description, @price, getdate());
		commit transaction
	end try

	begin catch
		rollback transaction
		exec usp_GetErrorInfo
	end catch
end

-- добавление категории продукта
create or alter procedure Add_category
	@title nvarchar(200),
	@description nvarchar(1000)
as
begin
	begin try
		begin transaction
			INSERT INTO categories (title, description)
			VALUES
				(@title, @description);
		commit transaction
	end try

	begin catch
		rollback transaction
		exec usp_GetErrorInfo
	end catch
end


-- присвоение продукту категории
create or alter procedure Add_products_categories
	@product_id int,
	@category_id int
as
begin
	begin try
		begin transaction
			INSERT INTO products_categories (product_id, category_id)
			VALUES
				(@product_id, @category_id);
		commit transaction
	end try

	begin catch
		rollback transaction
		exec usp_GetErrorInfo
	end catch
end

exec Add_user 'samoilov', 'qwerty123', 'Иван', 'Самойлов', null, 'ivanov@example.com', null;
exec Add_product 'Футбольный мяч Adidas', 'Официальный мяч для профессиональных матчей, размер 5, синтетическая кожа', 2499.99;
exec Add_category 'Спорт', 'Товары для всех видов физической культуры, туризма, спортивных занятий и игр';
exec Add_products_categories 5, 1;

-----------------------------------------------------------------------------------------------------------------

-- Необходим вывод всех пользователей с количеством их заказов
create or alter view Users_by_orders_count
as
select
	login,
	first_name,
	last_name,
	email,
	phone,
	registration_date,
	count(orders.order_id) as orders_count
from users
left join orders on orders.user_id = users.user_id
group by
	login,
	first_name,
	last_name,
	email,
	phone,
	registration_date;

select * from Users_by_orders_count;

-----------------------------------------------------------------------------------------------------------------

-- Выводить топ 5 пользователей, которые совершили больше всего заказов
create or alter view Top5_users_by_orders_count
as
select top(5) * from Users_by_orders_count
order by orders_count desc;

select * from Top5_users_by_orders_count;

-----------------------------------------------------------------------------------------------------------------

-- Получение продукта по категории
create or alter procedure Get_product_by_category
	@category_id int
as
begin
	begin try
		select p.title from products as p
		join products_categories as pc on pc.product_id = p.product_id
		and pc.category_id = @category_id
	end try

	begin catch
		exec usp_GetErrorInfo
	end catch
end

exec Get_product_by_category 2;

-----------------------------------------------------------------------------------------------------------------

-- Поиск продуктов по названию и по диапазону цены
create or alter procedure Find_product_by_title_and_price_range
	@title nvarchar(200),
	@initial_price decimal(10, 2),
	@final_price decimal(10, 2)
as
begin
	begin try
		select
			title,
			description,
			price
		from products
		where title like '%' + @title + '%' and
			price between @initial_price and @final_price
	end try

	begin catch
		exec usp_GetErrorInfo
	end catch
end

exec Find_product_by_title_and_price_range 'Galaxy', 15000, 100000;

-----------------------------------------------------------------------------------------------------------------

-- Вывод всех заказов пользователя в определённый диапазоне (дат)
create or alter procedure Orders_by_user_and_date_range
	@user_id int,
	@initial_date date,
	@final_date date
as
begin
	begin try
		select
			u.last_name,
			u.first_name,
			o.order_date,
			o.total_amount,
			o.delivery_address,
			os.status_name as status,
			os.description
		from users as u
		left join orders as o on o.user_id = u.user_id
		left join order_statuses as os on os.status_id = o.status_id
		where
			u.user_id = @user_id and
			o.order_date between @initial_date and @final_date
	end try

	begin catch
		exec usp_GetErrorInfo
	end catch
end

exec Orders_by_user_and_date_range 1, '2021-07-01T12:55:00', '2022-01-01';

-----------------------------------------------------------------------------------------------------------------

-- Получение списка всех товаров (Порционно)
create or alter procedure Get_products_paginated
	@page_number int = 1,
	@page_size int = 5
as
begin
	begin try
		select
			p.title,
			p.description,
			(select sum(pw.quantity)
			from products_warehouses as pw
			where pw.product_id = p.product_id) as total_quantity
		from products as p
		order by p.product_id
		offset (@page_number - 1) * @page_size rows
		fetch next @page_size rows only;
	end try

	begin catch
		exec usp_GetErrorInfo
	end catch
end

exec Get_products_paginated;
exec Get_products_paginated 2;

-----------------------------------------------------------------------------------------------------------------

-- Представление для информации о пользователях (без паролей)

create or alter view All_users_info
as
select
	user_id,
	login,
	first_name,
	last_name,
	middle_name,
	email,
	phone,
	registration_date
from users;

select * from All_users_info;


-----------------------------------------------------------------------------------------------------------------

-- Получить кол-во продуктов по каждой категории
-- не понял как правильно делать((

-- промежуточная таблица для получения общего кол-ва каждого продукта
create or alter view Get_total_quantity_for_each_product
as
select
	c.title as category,
	p.title as product,
	(select sum(pw.quantity)
	from products_warehouses as pw
	where pw.product_id = pc.product_id) as total_quantity
from categories as c
left join products_categories as pc on pc.category_id = c.category_id
left join products as p on p.product_id = pc.product_id

create or alter view Get_products_total_quantity_for_each_category
as
select
	distinct Get_total_quantity_for_each_product.category ,
	(select sum(gtq.total_quantity)
	from Get_total_quantity_for_each_product as gtq
	where gtq.category = Get_total_quantity_for_each_product.category)
	as total_quantity
from Get_total_quantity_for_each_product

select * from Get_products_total_quantity_for_each_category;
select * from Get_total_quantity_for_each_product;

-----------------------------------------------------------------------------------------------------------------

-- Получить кол-во продуктов для двух категорий (Планшеты, Игровые консоли)
create or alter procedure Get_products_total_quantity_for_two_categories
	@first_category_id int,
	@second_category_id int
as
begin
	begin try
		select
			Gptq.category,
			Gptq.total_quantity
		from Get_products_total_quantity_for_each_category as Gptq
		join categories as c on c.title = Gptq.category
		where c.category_id in (@first_category_id, @second_category_id)
	end try

	begin catch
		exec usp_GetErrorInfo
	end catch
end

exec Get_products_total_quantity_for_two_categories 1, 2;