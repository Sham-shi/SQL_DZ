-- Выведите всю информацию о пользователе из таблицы Users,
-- кто является владельцем самого дорогого жилья (таблица Rooms).

select * from Users
where id = (select owner_id
            from Rooms
            order by price desc
            limit 1);


-- Выведите названия товаров из таблицы Goods (поле good_name),
-- которые ещё ни разу не покупались ни одним из членов семьи (таблица Payments)

select good_name from Goods
where good_id <> all (
    select good from Payments);


-- Выведите список комнат (все поля, таблица Rooms),
-- которые по своим удобствам (has_tv, has_internet, has_kitchen, has_air_con)
-- совпадают с комнатой с идентификатором "11".

select * from Rooms
where (has_tv, has_internet, has_kitchen, has_air_con)
    in (
        select
            has_tv,
            has_internet,
            has_kitchen,
            has_air_con
        from Rooms
        where id = 11);


-- С помощью коррелированного подзапроса выведите имена всех членов семьи (member_name)
-- и цену их самого дорогого купленного товара.
-- Для вывода цены самого дорогого купленного товара используйте псевдоним good_price. 
-- Если такого товара нет, выведите NULL.

select
    FamilyMembers.member_name,
    (
    select max(unit_price)
    from Payments
    where Payments.family_member = FamilyMembers.member_id
    ) as good_price
from FamilyMembers;