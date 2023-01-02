#top selling books (3) of the year
select b.ISBN_ID, sum(pd.cust_price)  
       from PURCHASE_LINE as pd, BOOK as b
       where pub_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
       and b.ISBN_ID=pd.ISBN_ID
       group by ISBN_ID
       order by sum(pd.cust_price) desc 
       limit 3;
       
#all new members this month
select mem_fname,mem_lname,mem_ID,join_date #new members this month
from members
where join_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
order by join_date desc;

#number of new members this month
select count(mem_ID) as New_Monthly_Members
from members
where mem_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

#member sales vs non-member sales 
select (count(*)-count(mem_ID)) as customer_sale_count ,count(mem_ID) as member_sale_count
from PURCHASE;


#online vs in-store sales 
select (count(*)-count(phone_number)) as online_sale_count ,count(phone_number) as instore_sale_count
from PURCHASE;

#store with the most sales 
select  l.location,count(DISTINCT  p.phone_number ) as store_sales
from LOCATION as l,PURCHASE as p
group by l.location
order by store_sales asc
limit 1;

