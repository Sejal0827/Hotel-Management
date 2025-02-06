create database zomato;
use zomato;

create table Food(
sr_no varchar(200),
f_id varchar(200),
item varchar(200),
category varchar(200));

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\food.csv'
into table food
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

ALTER TABLE Food  
ADD CONSTRAINT pk_food PRIMARY KEY (f_id),
MODIFY item varchar(300) not null,
MODIFY category varchar(300);

create table Restaurant(
sr_no varchar(200),
r_id varchar(200),
name varchar(200),
city varchar(200),
rating varchar(200),
rating_count varchar(200),
cost varchar(200),
cuisine varchar(200),
lic_no varchar(200),
link varchar(500),
address varchar(500),
menu varchar(200)); 

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\restaurant.csv'
into table restaurant
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

alter table Restaurant
change menu menu_id text;
desc Restaurant;
update restaurant set menu_id = replace(replace(menu_id,"Menu/",""),".json","") where menu_id like '%.json%';
select * from Restaurant;

update restaurant set cost = replace(cost,"₹ ","") where cost like '₹ %';
update restaurant set cost = 50  where cost = '';
select r_id, count(r_id) from Restaurant group by r_id having count(r_id) > 1; -- o see duplicate records

ALTER TABLE Restaurant  
MODIFY r_id int primary key,
MODIFY menu_id int,
MODIFY name varchar(300) not null,
MODIFY city varchar(100),
MODIFY rating varchar(100),
MODIFY rating_count varchar(200),
MODIFY cost int,
MODIFY cuisine varchar(200),
MODIFY lic_no varchar(200),
MODIFY link varchar(500),
MODIFY address varchar(500);

alter table Restaurant
ADD CONSTRAINT fk_menu FOREIGN KEY (menu_id) REFERENCES Menu(menu_id);
Delete
FROM Restaurant 
WHERE menu_id IS NOT NULL AND menu_id NOT IN (SELECT menu_id FROM Menu);
ALTER TABLE Restaurant
DROP INDEX fk_menu;

SELECT menu_id 
FROM Restaurant 
WHERE menu_id IS NOT NULL AND menu_id NOT IN (SELECT menu_id FROM Menu);

DELETE FROM Restaurant
WHERE menu_id IS NOT NULL AND menu_id NOT IN (SELECT menu_id FROM Menu);

SELECT * FROM Menu 
WHERE r_id IN (SELECT r_id FROM Restaurant WHERE menu_id IS NOT NULL AND menu_id NOT IN (SELECT menu_id FROM Menu));

create table Menu(
sr_no varchar(200),
menu_id varchar(200),
r_id varchar(200),
f_id varchar(200),
cuisine varchar(200),
price varchar(200));

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\menu.csv'
into table menu
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

update menu set price = replace(price,"₹","") where price like '₹%';
update menu set menu_id = replace(menu_id,"mn","") where menu_id like 'mn%';

SELECT DISTINCT f_id FROM Menu
WHERE f_id IS NOT NULL AND f_id NOT IN (SELECT f_id FROM Food);

delete from menu where f_id = 'fd413746';

ALTER TABLE Menu
MODIFY menu_id int PRIMARY KEY,
MODIFY r_id int,
MODIFY f_id VARCHAR(100),
MODIFY cuisine VARCHAR(300),
MODIFY price FLOAT;

SELECT * 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'restaurant' AND TABLE_SCHEMA = 'zomato'; -- shows constraints in the specific table 

ALTER TABLE Menu
DROP FOREIGN KEY fk_restaurant;

ALTER TABLE Menu
DROP INDEX fk_restaurant;

Update Restaurant set menu_id = NULL  
WHERE menu_id IS NOT NULL AND menu_id NOT IN (SELECT menu_id FROM Menu);

Select menu_id from restaurant WHERE menu_id IS NOT NULL AND menu_id NOT IN (SELECT menu_id FROM Menu);

alter table Restaurant
ADD CONSTRAINT fk_menu FOREIGN KEY (menu_id) REFERENCES Menu(menu_id);

alter table Menu
ADD CONSTRAINT fk_restaurant FOREIGN KEY (r_id) REFERENCES Restaurant(r_id);

SELECT r_id 
FROM Menu 
WHERE r_id IS NOT NULL AND r_id NOT IN (SELECT r_id FROM Restaurant);

Delete
FROM Menu 
WHERE r_id IS NOT NULL AND r_id NOT IN (SELECT r_id FROM Restaurant);

alter table menu
ADD CONSTRAINT fk_food FOREIGN KEY (f_id) REFERENCES food(f_id);
 Drop Index fk_restaurant on Menu;


DELETE FROM Menu 
WHERE r_id IS NOT NULL AND r_id NOT IN (SELECT r_id FROM Restaurant);

CREATE TEMPORARY TABLE temp_menu_ids AS 
SELECT menu_id 
FROM Menu 
WHERE r_id IS NOT NULL AND r_id NOT IN (SELECT r_id FROM Restaurant);

DELETE FROM Restaurant 
WHERE menu_id IN (SELECT menu_id FROM temp_menu_ids);
DROP TEMPORARY TABLE temp_menu_ids;


describe Menu;

create table Users(
sr_no varchar(200),
user_id varchar(200),
name varchar(200),
email varchar(200),
password varchar(100), 
gender varchar(100));
 
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users.csv'
into table users
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

alter table Users
drop column sr_no;

ALTER TABLE Users
MODIFY user_id INT PRIMARY KEY,
MODIFY name varchar(300),
MODIFY gender varchar(25),
MODIFY password VARCHAR(100) not null;

select * from Users;
desc users;

create table Orders(
order_id varchar(200),
order_date varchar(100),
sales_qty varchar(100),
sales_amount varchar(150),
currency varchar(100),
user_id varchar(200),
r_id varchar(200));

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\orders.csv'
into table orders
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

UPDATE Orders
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y')
WHERE order_date LIKE '%/%/%';

alter table Orders
MODIFY user_id INT,
MODIFY r_id INT,
MODIFY order_date DATE,
MODIFY sales_qty INT,
MODIFY sales_amount INT,
MODIFY currency VARCHAR(100);

ALTER TABLE Orders
ADD CONSTRAINT fk_user
FOREIGN KEY (user_id) REFERENCES Users(user_id),
ADD CONSTRAINT fk_restaurant
FOREIGN KEY (r_id) REFERENCES Restaurant(r_id);

SELECT CONSTRAINT_NAME 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'Orders' AND TABLE_SCHEMA = 'zomato';

ALTER TABLE Orders 
DROP FOREIGN KEY fk_restaurant;

ALTER TABLE Orders
ADD CONSTRAINT fk_user 
FOREIGN KEY (user_id) REFERENCES Users(user_id),
ADD CONSTRAINT fk_restaurant 
FOREIGN KEY (r_id) REFERENCES Restaurant(r_id);

ALTER TABLE Orders 
DROP FOREIGN KEY fk_restaurant;

--------------------------------------------------------------------------------------------------------------------
-- Querires

INSERT INTO users (user_id,name,email,password,gender) 
VALUES (100001,'Johnson Mathew','xyz@gmail.com','Stb%bf','Male'); -- Insert a New record in User Table

UPDATE users SET name = 'Richards' WHERE  user_id = 100001; -- Update User Name

Delete from users WHERE  user_id = 100001; -- Delete a User

select * from orders where user_id= 79761; -- Get Orders by a Specific User

SELECT AVG(sales_amount) AS average_order_value from orders; -- Average Order Value

SELECT r.cuisine, SUM(o.sales_amount) AS total_revenue FROM restaurant r JOIN orders o ON r.r_id = o.r_id
GROUP BY r.cuisine
ORDER BY total_revenue DESC
LIMIT 3;  -- Top 3 Cuisines by Revenue

SELECT o.*, r.city
FROM Orders o
JOIN Restaurant r ON o.r_id = r.r_id
WHERE o.order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY r.city;  -- Select Orders placed between specific date and order them by city

select r.name, count(o.order_id) as Total_Orders 
from restaurant r JOIN Orders o on (r.r_id=o.r_id) 
group by r.name order by Total_Orders desc LIMIT 5; -- Top 5 popular restaurants based on number of orders

SELECT 'Q1 2019' AS quarter, SUM(sales_amount) AS Quarterly_Sales
FROM orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-03-31'
UNION ALL
SELECT 'Q2 2019' AS quarter, SUM(sales_amount) AS Quarterly_Sales
FROM orders
WHERE order_date BETWEEN '2019-04-01' AND '2019-06-30'
UNION ALL
SELECT 'Q3 2019' AS quarter, SUM(sales_amount) AS Quarterly_Sales
FROM orders
WHERE order_date BETWEEN '2019-07-01' AND '2019-09-30'
UNION ALL
SELECT 'Q4 2019' AS quarter, SUM(sales_amount) AS Quarterly_Sales
FROM orders
WHERE order_date BETWEEN '2019-10-01' AND '2019-12-31'
order by Quarterly_Sales desc;  -- Analysis of revenue generated by Zomato from 2019-01-01 to 2019-12-31 (Quarterwise)


SELECT users.name, orders.order_id, orders.order_date FROM users
INNER JOIN orders ON users.user_id = orders.order_id; -- Customer details and their orders

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month_year, COUNT(*) AS num_orders
FROM orders GROUP BY month_year order by month_year; -- Orders by month and year

SELECT * FROM restaurant WHERE cuisine like '%Pizza%'  having rating>3; -- Using LIKE to Find Specific Restaurants

SELECT user_id,name,email,gender  FROM users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM orders); -- Subquery to Find Customers with No Orders

SELECT o.*, u.name  FROM orders o  JOIN users u ON o.user_id = u.user_id; -- Retrieve All Orders Along with Customer Details

SELECT food.* FROM food JOIN menu ON food.f_id = menu.f_id WHERE menu.r_id = 158204; -- List all food items in a specific menu

SELECT r.r_id, r.name, AVG(r.rating) AS average_rating 
FROM restaurant r JOIN orders o ON r.r_id = o.r_id GROUP BY r.r_id, r.name; -- Get the average rating of restaurants based on orders

SELECT EXTRACT(MONTH FROM order_date) AS order_month, COUNT(*) AS total_orders 
FROM orders GROUP BY order_month ORDER BY total_orders desc; -- Identify seasonal trends in order counts

SELECT r.r_id, r.name, 
DATE(o.order_date) AS order_date, SUM(o.sales_amount) AS daily_sales 
FROM orders o
JOIN restaurant r ON o.r_id = r.r_id 
GROUP BY r.r_id, order_date  
ORDER BY daily_sales desc; -- Get the daily sales for each restaurant and it’s name

SELECT cuisine, AVG(rating) AS average_rating
FROM Restaurant  GROUP BY cuisine
ORDER BY average_rating DESC; -- How do average ratings differ across various cuisines

SELECT cuisine, AVG(price) AS average_cost
FROM Menu
GROUP BY cuisine
ORDER BY average_cost; -- How does the average cost of a meal vary across different cuisines

SELECT r_id, SUM(sales_qty * sales_amount) AS estimated_revenue
FROM Orders GROUP BY r_id; -- Can we estimate the revenue of restaurants based on order quantities and prices

SELECT  r.r_id, r.name AS restaurant_name, AVG(r.rating) AS average_rating,
SUM(o.sales_qty) AS total_sales  FROM Restaurant r
JOIN Orders o ON r.r_id = o.r_id
GROUP BY  r.r_id, r.name ORDER BY average_rating DESC; -- Is there a significant relationship between a restaurant’s rating and its sales quantities

SELECT user_id, COUNT(*) AS order_count
FROM Orders
GROUP BY user_id  ORDER BY order_count DESC  LIMIT 10; -- Who are the frequent diners and what are their preferences 

SELECT r.name, AVG(rating) AS average_rating, COUNT(Orders.r_id) AS order_count
FROM Restaurant r
LEFT JOIN Orders ON r.r_id = Orders.r_id
WHERE r.cuisine like 'Chinese' 
GROUP BY r.name; -- How does a particular restaurant perform compared to its direct competitors

SELECT SUBSTRING_INDEX(city, ',', 1) AS city_name, rating,COUNT(*) AS restaurant_count 
FROM Restaurant GROUP BY city_name, rating ORDER BY city_name, rating DESC; -- What is the distribution of restaurant ratings across different cities

SELECT r.city, r.name, r.rating FROM Restaurant r
JOIN (
SELECT city, rating FROM Restaurant
ORDER BY rating DESC LIMIT 10
) AS top_ratings ON r.city = top_ratings.city AND r.rating = top_ratings.rating
ORDER BY r.city, r.rating DESC; -- What are the top 10 highest-rated restaurants in each city

SELECT MONTH(order_date) AS month, SUM(sales_qty) AS total_sales
FROM Orders
GROUP BY month
ORDER BY month; -- How do sales quantities trend on a monthly basis

SELECT YEAR(order_date) AS year, AVG(rating) AS average_rating
FROM Restaurant
JOIN Orders ON Restaurant.r_id = Orders.r_id
GROUP BY year
ORDER BY year; -- How have restaurant ratings changed over the years

SELECT user_id, COUNT(DISTINCT r_id) AS restaurant_count, COUNT(*) AS total_orders
FROM Orders
GROUP BY user_id
HAVING restaurant_count > 1; -- What percentage of customers order from the same restaurant multiple times

SELECT  r.cuisine,  r.city, 
AVG(o.sales_qty) AS avg_sales,
AVG(r.rating) AS avg_rating
FROM Restaurant r
JOIN Orders o ON r.r_id = o.r_id
GROUP BY r.cuisine, r.city
ORDER BY avg_sales DESC
LIMIT 10; -- What characteristics do the top-performing restaurants share (e.g., location, cuisine, price)







