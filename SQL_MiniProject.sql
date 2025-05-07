######---- CAFE SALES ANALYSIS ----######
# create a database ---
create database mini_project;
use mini_project;

# create tables ---
create table city (city_id int,city_name varchar(50),population int,estimated_rent int,	city_rank int);
create table customers (customer_id int,	customer_name varchar(50),	city_id int);
create table sales (sale_id int,	sale_date date,	product_id int,	customer_id int,	total int,	rating int);
create table Products (product_id int,	product_name varchar(100),	price int);

/*
import dataset sales
import dataset products
import dataset customers
import dataset city
*/

# View thw data
select * from sales;
select * from products;
select * from customers;
select * from city;

----

###### Q1. How many people in each city are estimated to consume coffee, given that 25% of the population does?
select city_name, round((population* 0.25)/1000000,2) as coffee_consumers_in_millions, city_rank from city
ORDER BY population DESC;

----

###### Q2. What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
select * from sales;
/*SELECT *,												# to get quarter data and year data
       EXTRACT(YEAR FROM sale_date) AS year,
       EXTRACT(QUARTER FROM sale_date) AS quarter
FROM sales
where
extract(year from sale_date)=2023
and
extract(quarter from sale_date)=4;
*/
/*select sum(total) as total_revenue						 # to get total sales
from sales
where
extract(year from sale_date)=2023
and
extract(quarter from sale_date)=4;
*/ 
###### Q2. What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
select ct.city_name, 
sum(sal.total) as total_revenue						 
from sales as sal
join customers as cust
on sal.customer_id = cust.customer_id
join city as ct
on cust.city_id = ct.city_id
where
extract(year from sal.sale_date)=2023
and
extract(quarter from sal.sale_date)=4
group by ct.city_name;

----

###### Q3. How many sales were made each month over the last year?
SELECT 
date_format(s.sale_date, '%Y-%m') as yearmonth,
count(*) as total_sales
from sales s
where s.sale_date >= date_sub(curdate(), interval 1 year)
group by yearmonth
order by yearmonth;

----

###### Q4. What is the average sales amount per customer in each city?
SELECT 
ct.city_name,
SUM(sal.total) / COUNT(DISTINCT cust.customer_id) AS avg_sales_per_customer
FROM sales AS sal
JOIN customers AS cust ON sal.customer_id = cust.customer_id
JOIN city AS ct ON cust.city_id = ct.city_id
GROUP BY ct.city_name
order by avg_sales_per_customer desc;

----

###### Q5. Provide a list of cities along with their populations and estimated coffee consumers  (assuming 65% consume coffee)
SELECT 
city_name,
population,
ROUND((population * 0.65)/1000000,2) AS estimated_coffee_consumers_in_millions
FROM city
order by estimated_coffee_consumers_in_millions desc;

----

###### Q6. Which customer placed the highest number of orders?
select
cust.customer_id, cust.customer_name,
count(sal.sale_id) as total_orders
from sales as sal
join customers as cust on sal.customer_id = cust.customer_id
group by cust.customer_id, cust.customer_name
order by total_orders desc
limit 5;

----

###### Q7. What is the average customer rating per city?
select
ci.city_name,
round(avg(s.rating), 2) as avg_customer_rating,
count(s.sale_id) as total_rated_sales
from sales s
join customers c on s.customer_id = c.customer_id
join city ci on c.city_id = ci.city_id
where s.rating is not null
group by ci.city_name
order by avg_customer_rating DESC;

----

###### Q8. Do customers in higher population cities spend more per order on average?
select
ci.city_name,
ci.population,
round(avg(s.total), 2) as avg_order_total
from sales s
join customers c on s.customer_id = c.customer_id
join city ci on c.city_id = ci.city_id
group by ci.city_name, ci.population
order by ci.population desc;

----

###### Q9. How often is each product sold (number of times)?
select 
p.product_id,
p.product_name,
count(s.sale_id) as times_sold
from sales s
join products p on s.product_id = p.product_id
group by p.product_id, p.product_name
order by times_sold desc;
 
----

###### Q10. Which day of the week generates the highest average sales total?
select 
dayname(s.sale_date) as day_of_week,
round(avg(s.total), 2) as avg_sales_total,
count(*) as number_of_sales
from sales s
group by day_of_week
order by avg_sales_total desc;

----














