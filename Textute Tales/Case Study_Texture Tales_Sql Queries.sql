create database Texture_Tales;
use Texture_Tales;

select * 
from product_details; 

select *
from product_hierarchy;

select * 
from product_prices;

select *
from sales

##..What was the total quantity sold for all products?.....

SELECT b.product_name,SUM(a.qty) AS sale_counts
FROM sales AS a
INNER JOIN product_details AS b
ON a.prod_id = b.product_id
GROUP BY 1
ORDER BY 2 DESC;

##...What is the total generated revenue for all products before discounts?...
select sum(price * qty) as Revenue
from sales;

##..What was the total discount amount for all products?...
select sum(price * qty * discount)/100 as Total_Discount
from sales;

##..How many unique transactions were there?..
select count(distinct txn_id) as Unique_Txn
from sales;

##..What are the average unique products purchased in each transaction?..
with cte_transaction_ptoduct as (
select txn_id,count(distinct prod_id) as Product_Cout
from sales
group by 1)
select avg(Product_Cout) as Avg_Uni_Pro
from cte_transaction_ptoduct;

-- ..................Same Code Without CTE........... 
select avg(Product_Cout) 
from
(select txn_id,count(distinct prod_id) as Product_Cout
from sales
group by 1) a


##..What is the average discount value per transaction?.....
with cte_transaction_dicount as(
select txn_id, sum(price * qty * discount)/100 as Total_Discount
from sales
group by 1)
select avg(Total_Discount) as Avg_Discount
from cte_transaction_dicount;
-- ..................Same Code Without CTE........... 
select avg(Total_Discount) as Avg_Disc
from
(select txn_id,sum(price * qty * discount) /100 as Total_Discount
from sales
group by 1) a

## ..What is the average revenue for member transactions and non - member transactions?..
with cte_member_revenue as(
select member,txn_id,sum(price * qty) as revenue
from sales 
group by 1,2)
select member,avg(revenue) as avg_revenue
from cte_member_revenue
group by 1;

-- ..................Same Code Without CTE........... 

select member,avg(revenue) avg_revenue
from
(select member,txn_id,sum(price * qty) as revenue
from sales
group by 1,2) a
group by 1

##..What are the top 3 products by total revenue before discount?...
select b.product_name,sum(a.qty * a.price) as no_discount_revenue
from sales as a
inner join product_details as b
on a.prod_id = b.product_id
group by 1
order by 2 desc
limit 3;

##...What are the total quantity, revenue and discount for each segment?...
select b.segment_id,b.segment_name,sum(a.qty) as Total_Quantity,
       sum(a.qty * a.price) as Revenue,
       sum(a.price * a.qty * a.discount)/100 as Total_Discount
from sales as a
inner join product_details b
on a.prod_id = b.product_id
group by b.segment_id,b.segment_name;

##..What is the top selling product for each segment?..
select b.segment_id,b.segment_name,b.product_id,b.product_name,sum(a.qty) as Product_Qty
from sales as a
inner join product_details as b
on a.prod_id = b.product_id
group by b.segment_id,b.segment_name,b.product_id,b.product_name
ORDER BY Product_Qty DESC
limit 5;

##..What are the total quantity, revenue and discount for each category?...
select b.category_id,b.category_name,sum(a.qty) as Total_Quantity,
									sum(a.qty * a.price) as Revenue,
									sum(a.price * a.qty * a.discount)/100 as Total_Discount
from sales as a
inner join product_details as b
on a.prod_id = b.product_id
group by b.category_id,b.category_name

##..What is the top selling product for each category?...-
select b.category_id,b.category_name,b.product_id,b.product_name,sum(a.qty) as Product_Qty
from sales as a
inner join product_details as b
on a.prod_id = b.product_id
group by b.category_id,b.category_name,b.product_id,b.product_name
ORDER BY Product_Qty DESC
limit 5;

