create database DZ_25_06_25
---------------------------------------------------
create table Employees (
	Id int primary key identity(1,1),
	Name nvarchar(100),
	Salary money,
	Department nvarchar(50)
)

---------------------------------------------------
insert into Employees (Name, Salary, Department)
values
	('Иван Петров', 75000.00, 'IT'),
	('Алексей Смирнов', 60000.00, 'Маркетинг'),
	('Мария Иванова', 55000.00, 'HR'),
	('Дмитрий Кузнецов', 80000.00, 'IT'),
	('Анна Соколова', 48000.00, 'Финансы'),
	('Сергей Васильев', 65000.00, 'IT'),
	('Ольга Морозова', 52000.00, 'HR'),
	('Александр Белов', 90000.00, 'Маркетинг'),
	('Екатерина Козлова', 43000.00, 'Финансы'),
	('Павел Новиков', 70000.00, 'IT');
	
---------------------------------------------------
select * from Employees
where Salary > 50000

---------------------------------------------------
select Name, Salary from Employees

---------------------------------------------------
select * from Employees
order by Salary desc

---------------------------------------------------
select top 3
	Id,
	Name,
	Salary
from
	Employees
order by
	Salary desc