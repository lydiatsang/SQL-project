use wormsley_lawncare;


# How many transactions in August 2012 had expenses larger 
# than the average for that month?
select count(Expenses)
from Transactions
where Expenses >
(select avg(Expenses) 
from Transactions
where year(TransDate) = 2012
and month(TransDate) = 08
group by year(TransDate), month(TransDate))
and year(TransDate) = 2012
and month(TransDate) = 08;


# List the Sales Representatives (Reps) according to their 
# Total Sales in the Western market over the entire two‐year period.
select RepName, sum(Sales)
from Reps, Transactions
where Reps.RepID = Transactions.RepID
and Transactions.Market = 'West'
group by Reps.RepID;


# List the Sales Representatives (Reps) according to who generated 
# the least “Total Profit” (Sales minus Expenses) over the entire two‐year period. (sort from lowest to highest)
select RepName, sum((Transactions.Sales - Transactions.Expenses)) as TotalProfit
from Reps, Transactions
where Reps.RepID = Transactions.RepID
group by Transactions.RepID
order by TotalProfit;


# List the Customers who generated the most Profit (Sales minus 
# Expenses) over the entire two‐year period for the “Mowers” category. 
# (sort highest to lowest)
select CustName, sum((Transactions.Sales - Transactions.Expenses)) as TotalProfit
from Customers join Transactions
on Customers.CustID = Transactions.CustID
where Transactions.ProductLine = 'Mowers'
group by Transactions.CustID
order by TotalProfit desc;


# Which state has the highest mower sales? Can you identify the top 
# states for the highest mower sales?
select State, sum(Sales)
from Customers join Transactions
on Customers.CustID = Transactions.CustID
where Transactions.ProductLine = 'Mowers'
group by Transactions.ProductLine, Customers.State
order by sum(Sales) desc
limit 1; 


# List the Male Sales Representative and his Sales, who generated the 
# highest individual sale for customers in Arkansas, in the year of 2012 inclusive.
select RepName, sum(Sales)
from Transactions JOIN Reps
on Transactions.RepID = Reps.RepID 
join Customers
on Transactions.CustID = Customers.CustID
WHERE Reps.Gender = 'M'
and Customers.State = 'Arkansas'
and year(TransDate) = 2012
group by Transactions.RepID
order by sum(Sales) desc
limit 1;


# Which Product Lines are doing better in Small Markets vs. Large 
# Markets? Show the result as a single query showing most Sales by 
# Product Line and Market size.

select ProductLine, MarketSize, sum(Sales) as Total
from Transactions
group by ProductLine, MarketSize
having sum(Sales) > (select sum(Sales) 
from Transactions
group by ProductLine, MarketSize
order by sum(Sales)
limit 1)
order by ProductLine desc
limit 2;


select CustName, avg(Transactions.Sales)
from Transactions join Customers
on Transactions.CustID = Customers.CustID
join Reps
on Transactions.RepID = Reps.RepID
where Customers.State = 'Texas'
and Transactions.RepID in (
select Reps.RepID 
from Reps join Transactions
on Reps.RepID = Transactions.RepID
where Gender = 'F')
and Sales> (select avg(Sales)
from Transactions
where MarketSize = 'Small Market'
and ProductType = 'Electric')
group by Customers.CustName
order by avg(Sales) desc;


## List the Customer Name and Average Sales for Texas‐based customers who 
## had a Female representative that produced Sales that exceeded the Average 
## Sales for “Electric” products in Small Markets over the entire two‐year 
## period. (sort highest to lowest)

select CustName, avg(Sales)
from Customers, Transactions , Reps
where Customers.CustID = Transactions.CustID
and Transactions.RepID = Reps.RepID
and Customers.State = 'Texas'
and Transactions.RepID in
(select Reps.RepID 
from Reps, Transactions
where Transactions.RepID = Reps.RepID
and Gender = 'F'
and Transactions.Sales >
(select avg(Sales)
from Transactions
where Transactions.ProductType = 'Electric'
and Transactions.MarketSize = 'Small Market'))
group by Customers.CustName 
order by avg(Sales) desc;
