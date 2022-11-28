create database if not exists burger_bash;

use burger_bash;

select * from burger_names;
select * from burger_runner;
select * from runner_orders;
select * from customer_orders;
-------------------------------------
##.. 1. How many burgers were ordered?
select count(*) as No_of_Records
from runner_orders;

##.. 2. How many unique customer orders were made?
select count(distinct order_id) as Unique_Order
from customer_orders;

##.. 3. How many successful orders were delivered by each runner?
-- .. Wherever cancellation is NULL -> Successfull Order
select runner_id,count(order_id) as Successfull_Order
from runner_orders
where cancellation is null
group by 1
order by 2 desc;

##.. 4. How many of each type of burger was delivered?
select c.burger_name,count(a.burger_id) as delivered_burger_count
from  customer_orders as a
join  runner_orders as b
on a.order_id = b.order_id

join burger_names as c
on a.burger_id = c.burger_id
where b.distance != 0  
group by c.burger_name;

##.. 5. How many Vegetarian and Meatlovers were ordered by each customer?
select a.customer_id,b.burger_name, count(b.burger_name) as Order_Count
from customer_orders as a
join burger_names as b
on a.burger_id = b.burger_id
group by 1,2
order by 3;

##.. 6. What was the maximum number of burgers delivered in a single order?

with cte_burger_count as(
select a.order_id, count(a.burger_id) as burger_Per_Order
from customer_orders as a
join runner_orders as b
on a.order_id = b.order_id
where b.distance!= 0
group by 1
)
select max(burger_Per_Order) as burger_count 
from cte_burger_count;

-- .. OUTPUT Explanation --> For each Order the Maximum number of Burger that were Order -> 3 
-- ..........................Same Code Without CTE ...................

select max(Burger_Per_Order) as Maximum_Order
from
(select a.order_id,count(a.burger_id) as Burger_Per_Order
from customer_orders as a
join runner_orders as b
on a.order_id = b.order_id
where b.distance != 0
group by 1) a

##.. 7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?




##.. 8. What was the total volume of burgers ordered for each hour of the day?
-- .. Volume means simply count of Burger
select hour(order_time) as Hour_of_day,count(order_id) as Burger_Count
from customer_orders
group by 1;

##.. 9. How many runners signed up for each 1 week period? 
select week(registration_date) as Registration_Week,count(runner_id) as Runner_Signup
from burger_runner 
group by 1;

##.. 10.What was the average distance travelled for each customer
select a.customer_id,avg(b.distance) as Avg_Distance
from customer_orders as a
join runner_orders as b
on a.order_id = b.order_id
where b.duration != 0
group by a.customer_id;


