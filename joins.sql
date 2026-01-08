
use flipkart;

-- joining more than 2 tables
select * from order_details t1
join orders t2 on t1.order_id=t2.order_id
join user_fp t3 on t2.user_id=t3.user_id;

-- find order id,buyers name and city of an order
select t1.order_id,t2.name,t2.city from orders t1
join user_fp t2 on t1.user_id=t2.user_id;

-- find order id,product categotry of an order
select t1.order_id,t2.category from order_details t1
join category t2 on t1.category_id=t2.category_id;

-- find all the order placed in pune
select t1.order_id from orders t1
join user_fp t2 on t1.user_id=t2.user_id
where t2.city='Pune';

-- find all the orders under furniture category
select t1.order_id,t2.category from order_details t1
join category t2 on t1.category_id=t2.category_id
where t2.category='Furniture';

-- find the customers who has placed maximum orders
select t2.user_id from orders t1
join user_fp t2 on t1.user_id=t2.user_id
group by t2.user_id
order by count(*) desc limit 5;

-- which is the most profitable category
select t2.category, avg(profit) as 'avg_profit' from order_details t1
join category t2 on t1.category_id=t2.category_id
group by t2.category
order by avg_profit desc limit 1;

-- which is the most profitable state
select t3.city, avg(profit) as 'avg_profit' from order_details t1
join orders t2 on t1.order_id=t2.order_id
join user_fp t3 on t2.user_id=t3.user_id
group  by t3.city
order by avg_profit desc limit 1;

-- find the categories with profit higher than 5000
select t2.category, sum(profit) as 'total_profit' from order_details t1
join category t2 on t1.category_id=t2.category_id
group by t2.category
having total_profit>5000;
