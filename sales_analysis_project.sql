
--Sales Analysis: Analyze total sales by region, segment, or product category to identify trends and high-performing areas.

select * from superstore_orders

--1.What is the total sales revenue for all orders in the dataset?

select sum(sales) as total_sales
from superstore_orders;

--2.How many orders are there in the dataset?

select count(*) orders
from superstore_orders;

--3.What is the average discount applied to orders?

select avg(discount) as avg_discount 
from superstore_orders;

--4.How many sales are there for each product category?

select category, sum(sales)  as total_sales
from superstore_orders
group by category;

--5.Who are the top 5 customers based on total spending?

select top 5 customer_name, sum(sales) as total_spending
from superstore_orders
group by customer_name
order by total_spending desc;

--6.What is the total sales revenue for each region?

select region, sum(sales) as total_sales_revenue
from superstore_orders
group by region;

--7.What are the total sales for each month?

select month(order_date) as month, sum(sales) as total_sales
from superstore_orders
group by month(order_date)
order by month;

--8. What is the total profit generated from all orders?

select sum(profit) as total_profit
from superstore_orders;

--9.Calculate the yearly growth rate in sales from one year to the next.

with yearly_sales as
(
select
datepart(year,order_date) as year_in_general,
round(sum(sales),2) as present_yearsales,
lag(round(sum(sales),2)) over(order by datepart(year,order_date)) as previous_yearsales
from superstore_orders
group by datepart(year,order_date)
)
select year_in_general,
present_yearsales,
previous_yearsales,
round(((present_yearsales - previous_yearsales)/previous_yearsales * 100),2) as growth_rate
from yearly_sales
where previous_yearsales is not null;

--10.What percentage of customers made repeat purchases?

with customer_orders as
(
select customer_id, count(order_id) as total_orders
from superstore_orders
group by customer_id
)
select
(count(case when total_orders > 1 then 1  end ) * 100.0/ count(*)) as retention_rate
from customer_orders;

--11. Segment customers based on their total spending and frequency of orders.

select customer_name,
count(order_id) as no_of_orders,
sum(sales) as total_sales,
case
when sum(sales) > 1000 then 'High_value'
when sum(sales) between 500 and 1000 then 'Medium_value'
else 'Low_value'
end as customer_segment
from superstore_orders
group by customer_name;

--12. Identify the top 5 products by total sales and their respective profit.

select top 5 sub_category,
sum(sales) as total_sales,
sum(profit) as total_profit
from superstore_orders
group by sub_category
order by total_sales desc;

--13. Analyze the average shipping time (from order date to ship date) for each region.

select region,
avg(datediff(day,order_date, ship_date)) as avg_shipping_time
from superstore_orders
group by region;


--14. How does the total sales amount vary with different discount ranges?

select sum(sales) as total_amount,
case
when discount = 0 then 'No_discount'
when discount < 10 then '0-10%'
when discount < 20 then '10-20%'
else '20% and above'
end as discount_range
from superstore_orders
group by discount;

--15. Which cities generated the highest sales?

select top 10 city,
sum(sales) as total_sales
from superstore_orders
group by city
order by total_sales desc;

---END---








































