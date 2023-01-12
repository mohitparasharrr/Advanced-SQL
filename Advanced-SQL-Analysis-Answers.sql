--SQL Advance Case Study


--Q1--BEGIN 
select State from DIM_LOCATION as T1 inner join FACT_TRANSACTIONS as T2 	
on T1.IDLocation = T2.IDLocation
where year(date) >= 2005
group by State
--Q1--END

--Q2--BEGIN
select top 1 state,count(state) as No_of_users_of_samsung from DIM_LOCATION as T1 inner join FACT_TRANSACTIONS as T2 	
on T1.IDLocation = T2.IDLocation inner join DIM_MODEL as T3	
on T3.IDModel = T2.IDModel inner join DIM_MANUFACTURER as T4
on T4.IDManufacturer = T3.IDManufacturer
where Manufacturer_Name = 'Samsung' and country = 'US'
group by state
order by State asc
--Q2--END

--Q3--BEGIN      
select Model_Name,count(IDCustomer) as No_of_transactions,ZipCode,State from DIM_MODEL as T1 inner join FACT_TRANSACTIONS as T2	
on T1.IDModel = T2.IDModel inner join DIM_LOCATION as T3
on T2.IDLocation = T3.IDLocation
group by Model_Name,ZipCode,state
--Q3--END

--Q4--BEGIN
select top 1 Model_Name, Unit_price from DIM_MODEL
order by Unit_price asc
--Q4--END

--Q5--BEGIN
select top 5 manufacturer_name, model_name, count(Quantity) as Sales_Qty, avg(totalprice) as avg_price_of_model from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer = T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
group by Manufacturer_Name,Model_Name
order by avg_price_of_model desc
--Q5--END

--Q6--BEGIN
select Customer_Name,avg(TotalPrice) as avg_amt_spent from DIM_CUSTOMER as T1 inner join FACT_TRANSACTIONS as T2
on T1.IDCustomer = T2.IDCustomer
where year(date) = 2009
group by Customer_Name
having avg(TotalPrice) > 500
--Q6--END
	
--Q7--BEGIN  
select * from (select top 5 Model_Name from DIM_MODEL as T1 inner join FACT_TRANSACTIONS as T2	
on T1.IDModel = T2.IDModel
where year(date) = 2008
group by Model_Name
order by sum(Quantity) desc
intersect
select top 5 Model_Name from DIM_MODEL as T1 inner join FACT_TRANSACTIONS as T2	
on T1.IDModel = T2.IDModel
where year(date) = 2009
group by Model_Name
order by sum(Quantity) desc
intersect
select top 5 Model_Name from DIM_MODEL as T1 inner join FACT_TRANSACTIONS as T2	
on T1.IDModel = T2.IDModel
where year(date) = 2010
group by Model_Name
order by sum(Quantity) desc) as x
--Q7--END
	
--Q8--BEGIN
select * from (select top 1 Manufacturer_Name, sum(TotalPrice) as sales_ from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer =T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
where year(date)=2009
group by Manufacturer_Name
having max(TotalPrice) < (select max(TotalPrice) from FACT_TRANSACTIONS)
order by sales_ desc) as x 
union
select top 1 Manufacturer_Name, sum(TotalPrice) as sales_ from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer =T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
where year(date)=2010
group by Manufacturer_Name
having max(TotalPrice) < (select max(TotalPrice) from FACT_TRANSACTIONS)
order by sales_ desc 
--Q8--END

--Q9--BEGIN
select * from (select Manufacturer_Name from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2 on T1.IDManufacturer = T2.IDManufacturer
inner join FACT_TRANSACTIONS as T3 on T2.IDModel = T3.IDModel	
where year(date) = 2010 
except
select Manufacturer_Name from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2 on T1.IDManufacturer = T2.IDManufacturer
inner join FACT_TRANSACTIONS as T3 on T2.IDModel = T3.IDModel	
where year(date) = 2009) as x
--Q9--END

--Q10--BEGIN
with Top_Customers AS
					(SELECT top 100 customer_name,t1.IDCustomer, SUM(TOTALPRICE) AS Total_Spend
					 FROM FACT_TRANSACTIONS as t1 inner join  DIM_CUSTOMER as t2 on t1.IDCustomer=t2.IDCustomer
					 GROUP BY t1.IDCustomer,customer_name
					 ORDER BY Total_Spend desc),
Average AS 
					(SELECT Customer_Name, T3.IDCUSTOMER, YEAR(T3.DATE) AS [YEAR],AVG(T3.QUANTITY)  AS Average_Quantity, AVG(T3.TOTALPRICE)  as Average_Spend
					 FROM FACT_TRANSACTIONS T3
					 INNER JOIN Top_Customers T4 on T4.IDCustomer = T3.IDCustomer
					 GROUP BY Customer_Name, T3.IDCustomer,T3.Date)
SELECT Customer_Name,YEAR,Average_Quantity,Average_Spend, 
((Average_Spend - lag(Average_Spend,1) OVER (partition by idcustomer ORDER BY [year])) / Average_Spend)*100 as percentage_of_change
FROM Average
--Q10--END

select * from DIM_MANUFACTURER
select * from DIM_MODEL
select * from FACT_TRANSACTIONS
select * from DIM_CUSTOMER
select * from DIM_LOCATION
select * from DIM_DATE	






