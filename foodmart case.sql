use foodmart;

# What are the total sales of “Potato Chips” including the quantity sold and sales
# by store? (Sort the results by Total Sales)

select c.store_name, sum(b.store_sales), sum(b.unit_sales) 
from product a, sales_fact b, store c
where a.product_id = b.product_id
and b.store_id = c.store_id
and a.product_name like '%Potato Chips%'
group by c.store_name
order by sum(b.store_sales) DESC;

# What are total sales of all products, per month, for all stores? (Sort the results by Month)
select a.the_month, sum(b.store_sales)
from time_by_day a, sales_fact b
where a.time_id = b.time_id
group by month(a.the_date)
order by month(a.the_date);


# What are the total sales of each store, by region? (Sort the results by Total Sales)
select b.store_name, c.sales_region, sum(a.store_sales) 
from sales_fact a, store b, region c
where a.store_id = b.store_id
and b.region_id = c.region_id
group by b.store_name, c.sales_region
order by sum(a.store_sales) DESC;


# Which product category sells the most?(Hint: there can only be one answer and your query must show this)
select a.product_category, sum(c.store_sales)
from product_class a, product b, sales_fact c
where a.product_class_id = b.product_class_id
and b.product_id = c.product_id
group by a.product_category
order by sum(c.store_sales) desc
limit 1;

# Which days of the week do customers prefer to go shopping? (Sort the results by Total Sales) (Hint: for this query, you will need to use the Dayname function and your query must show this)
select dayname(a.the_date), sum(b.store_sales)
from time_by_day a, sales_fact b
where a.time_id = b.time_id
group by dayname(a.the_date)
order by sum(b.store_sales) DESC;
