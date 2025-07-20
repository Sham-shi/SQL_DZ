---- 1.2 Базовые операции SQL
-- 1.2.1
select * from billing
where payer_email = 'vasya@mail.com';

-- 1.2.2
insert into billing
values (
    'pasha@mail.com',
    'katya@mail.com',
    300.00,
    'EUR',
    '2016-02-14',
    'Valentines day present)');

-- 1.2.3
update billing
set payer_email = 'igor@mail.com'
where payer_email = 'alex@mail.com';

-- 1.2.4
delete from billing
where
    payer_email is null
    or payer_email = ''
    or recipient_email is null
    or recipient_email = '';

---- 1.3 Агрегация данных
-- 1.3.1
select count(*) from project

-- 1.3.2
select
    category,
    count(*)
from store
group by category;

-- 1.3.3
select
    category,
    sum(price * sold_num) as viruchka
from store
group by category
order by viruchka desc
limit 5;

-- 1.3.4
select
    count(*),
    sum(budget),
    avg(datediff(project_finish, project_start))
from project;