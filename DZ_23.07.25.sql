create table users (
	user_id int primary key identity(1, 1),
	login nvarchar(50) not null,
	password nvarchar(100) check(len(password) >= 8) not null,
	first_name nvarchar(100) not null,
	last_name nvarchar(100),
	middle_name nvarchar(100),
	email nvarchar(255) unique not null,
	phone nvarchar(20) unique,
	registration_date datetime
);


create table products (
	product_id int primary key identity(1, 1),
	title nvarchar(200) not null,
	description nvarchar(1000),
	price decimal(10, 2) check(price >= 0) not null,
	added_date datetime
);


create table warehouses (
	warehouse_id int primary key identity(1, 1),
	title nvarchar(100) not null,
	address nvarchar(500) not null
);


create table products_warhouses (
	product_id int not null,
	warehouse_id int not null,
	quantity int check(quantity >= 0),
	primary key (product_id, warehouse_id),
	foreign key (product_id) references products(product_id),
	foreign key (warehouse_id) references warehouses(warehouse_id)
);


create table categories (
	category_id int primary key identity(1, 1),
	title nvarchar(100) not null,
	description  nvarchar(100)
);


create table products_categories (
	category_id int not null,
	product_id int not null,
	primary key (category_id, product_id),
	foreign key (category_id) references categories(category_id),
	foreign key (product_id) references products(product_id)
);


create table order_statuses (
	status_id int primary key identity(1, 1),
	status_name nvarchar(50) not null,
	description nvarchar(500)
);


create table orders (
	order_id int primary key identity(1, 1),
	user_id int not null,
	order_date datetime,
	total_amount decimal(10, 2) check(total_amount > 0) not null,
	status_id int not null,
	delivery_address nvarchar(500),
	foreign key (user_id) references users(user_id),
	foreign key (status_id) references order_statuses(status_id)
);


create table order_history (
	history_id int primary key identity(1, 1),
	order_id int not null,
	previous_status_id int,
	new_status_id int not null,
	change_date datetime,
	comment nvarchar(500),
	foreign key (order_id) references orders(order_id),
	foreign key (previous_status_id) references order_statuses(status_id),
	foreign key (new_status_id) references order_statuses(status_id)
);


create table order_items (
	order_item_id int primary key identity(1, 1),
	order_id int not null,
	product_id int not null,
	quantity int check(quantity > 0),
	price decimal(10, 2)  check(price >= 0) not null,
	foreign key (order_id) references orders(order_id),
	foreign key (product_id) references products(product_id)
);