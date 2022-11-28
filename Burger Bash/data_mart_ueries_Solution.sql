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


##.. 6. What was the maximum number of burgers delivered in a single order?


##.. 7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?


##.. 8. What was the total volume of burgers ordered for each hour of the day?


##.. 9. How many runners signed up for each 1 week period? 


##.. 10.What was the average distance travelled for each customer


