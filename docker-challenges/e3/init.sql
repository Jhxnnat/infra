CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50), 
	price FLOAT
);

INSERT INTO products (name, price) VALUES
	('Laptop 2 in 1', 789.99),
	('Laptop Ultrabook', 990.99),
	('Laptop Workstation', 1299.99),
	('Desktop Basic', 720.99),
	('Desktop Gaming', 1119.99),
	('Laptop Gaming', 998.99);


