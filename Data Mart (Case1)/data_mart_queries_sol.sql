use case1;

select * from weekly_sales
limit 10;

##-------------------------------------------- Data Cleasing -----------------------------------------
## We will store clean data in clean_weekly_sales from weekly_sales data
# 1.Add a week_number as the second column for each week_date value, 
-- .. for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2, etc.
CREATE TABLE clean_weekly_sales AS
SELECT week_date,
	   week(week_date) AS week_number,
       month(week_date) AS month_number,
       year(week_date) AS calendar_year,
  
		region,platform,
  
  CASE WHEN segment = 'null' THEN 'Unknown'
       ELSE segment
       END AS segment,
    
  CASE
    WHEN right(segment, 1) = '1' THEN 'Young Adults'
    WHEN right(segment, 1) = '2' THEN 'Middle Aged'
    WHEN right(segment, 1) IN ('3', '4') THEN 'Retirees'
    ELSE 'Unknown'
    END AS age_band,
    
  CASE WHEN left(segment, 1) = 'C' THEN 'Couples'
       WHEN left(segment, 1) = 'F' THEN 'Families'
       ELSE 'Unknown'
       END AS demographic,
    
  customer_type,transactions,sales,
  
  ROUND(sales / transactions,2) AS avg_transaction

FROM weekly_sales;

select * 
from clean_weekly_sales 
limit 10;

##-------------------------------------------- Data Exploration --------------------------------
## ..1.Which week numbers are missing from the dataset? 
-- .. (Create table and inserting values 1 to 100)

create table seq100(
x int not null auto_increment primary key);

insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select x + 50 from seq100;

select * from seq100;

-- .. In One Year we have total 52 Weeks. so creating 52 weeks table.
create table seq52 as (select x 
						from seq100 
						limit 52);

/* The Output we are getting after running this query Conclusion:- 
These are week days which are not present in the Dataset */
select distinct x as week_day 
from seq52 
where x not in (select distinct week_number 
								from clean_weekly_sales); 

select distinct week_number 
from clean_weekly_sales
order by 1 asc;
--------------------------------

##.. 2.How many total transactions were there for each year in the dataset?
select calendar_year,sum(transactions) as Total_Transaction
from clean_weekly_sales
group by 1
order by 2 asc;
--------------------------------

##.. 3.What are the total sales for each region for each month?
select region,month_number, sum(sales) as Total_Sales
from clean_weekly_sales
group by 2,1;
--------------------------------

##.. 4.What is the total count of transactions for each platform
select platform,sum(transactions) as Total_Transaction
from clean_weekly_sales
group by 1;
--------------------------------

##.. 5.What is the percentage of sales for Retail vs Shopify for each month?
select platform
from clean_weekly_sales;
-- .. CTE (CTE is a Temp Table)--> crearting Commom table Expression and storing Monthly sales 
with cte_monthly_platform_sales as(
select month_number,calendar_year,platform, sum(sales) as monthly_slaes
from clean_weekly_sales
group by 1,2,3)

select month_number,calendar_year,
round(100*max(case when platform = "Retail" 
			 then monthly_slaes 
			 Else null End)/sum(monthly_slaes),2) as Retail_Precentage,
round(100*max(case when platform = "Shopify"
				then monthly_slaes
                Else null End)/sum(monthly_slaes),2) as Shopify_Percentage

from cte_monthly_platform_sales
group by month_number,calendar_year;

-- .................. Without CTE......
select month_number,calendar_year,
round(100*max(case when platform = "Retail" 
			 then monthly_slaes 
			 Else null End)/sum(monthly_slaes),2) as Retail_Precentage,
round(100*max(case when platform = "Shopify"
				then monthly_slaes
                Else null End)/sum(monthly_slaes),2) as Shopify_Percentage
from
(select month_number,calendar_year,platform, sum(sales) as monthly_slaes
from clean_weekly_sales
group by 1,2,3) a
group by 1,2;

##.. 6.What is the percentage of sales by demographic for each year in the dataset?
select demographic
from clean_weekly_sales; 

select calendar_year,demographic,sum(sales) as Yearly_Sales,round(100*sum(sales)/sum(sum(sales)) 
over (partition by demographic order by calendar_year),2) as Percentage
from clean_weekly_sales
group by 1,2;
--------------------------------

##.. 7.Which age_band and demographic values contribute the most to Retail sales?
select age_band,demographic,sum(sales) as Total_Sales
from clean_weekly_sales
where platform = "Retail"
group by 1,2
order by 3 desc;


