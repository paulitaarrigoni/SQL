##########################################################Financial Analysis & Web Traffic - Ecommerce#######################################################################

#The client

# You have just been hired by the online ecommerce company called “happybear” that sells super cute teddy bears. It currently has 4 models of stuffed animals.

#The problem

# As a member of the startup team, you will have to work with the CEO, the marketing director and the Web Manager to analyze certain metrics that we want to measure.

#Your objective will be to analyze the current situation of the company.
#Measure website conversion and use data to understand product sales and impact.

use ositofeliz;
#---------------------------------------------------------------- Sales Analysis----------------------------------------------------------------------------------

#1. We want to know what are the sales per year and per month in gross terms and then the absolute margin.

SELECT DISTINCT YEAR (created_at)
 FROM ositofeliz.orders;

SELECT
 YEAR (created_at) as Year,
 SUM(price_usd*items_purchased) as Sales
 FROM ositofeliz.orders
 group by YEAR (created_at);
 
 SELECT SUM((price_usd - cogs_usd)*items_purchased) AS AbsoluteMargin
  FROM ositofeliz.orders;
 
SELECT 
YEAR (created_at) AS Year,
month(created_at) AS Month,
FORMAT(SUM(price_usd*items_purchased),2,'es_ESP') AS Sale,
FORMAT(SUM((price_usd - cogs_usd)*items_purchased),2,'es_ESP') AS AbsoluteMargin
 FROM ositofeliz.orders
 group by  YEAR (created_at), month(created_at) ;
 

  
#2.What are the average gross sales for each month and year, does it return the TOP 10? What can you observe?

SELECT
 YEAR (created_at) AS Year, 
 month(created_at) AS Month,
FORMAT(SUM(price_usd*items_purchased),2,'es_ESP')  AS GrossSales ,
FORMAT(AVG(price_usd*items_purchased),2,'es_ESP')  AS AverageSales
FROM ositofeliz.orders
GROUP BY YEAR (created_at), month(created_at) 
ORDER BY grosssales, averagesales DESC
LIMIT 10;

##Conclusion: only one bear is sold in each sale

#3.What is the product that sells the most in monetary terms (gross sales)?

SELECT 
oi.product_id,
p.product_name,
FORMAT(SUM(o.price_usd* o.items_purchased),2,'es_ESP')  AS GrossSalesF,
SUM(o.price_usd* o.items_purchased) AS GrossSales
FROM ositofeliz.order_items oi 
LEFT JOIN ositofeliz.orders o ON oi.order_id=o.order_id
LEFT JOIN ositofeliz.products p ON oi.product_id=p.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY GrossSales, GrossSalesF DESC
LIMIT 1;

#4. What is the product that leaves the most margin?

SELECT
oi.product_id,
p.product_name, 
SUM((o.price_usd - o.cogs_usd)*o.items_purchased) AS AbsoluteMargin
FROM ositofeliz.order_items oi 
LEFT JOIN ositofeliz.orders o ON oi.order_id=o.order_id
LEFT JOIN ositofeliz.products p ON oi.product_id=p.product_id
GROUP BY p.product_name, oi.product_id
ORDER BY AbsoluteMargin DESC;

#5.  Can we know the release date of each product?

# THE LAUNCH MAY BE THE DATE OF PRODUCT CREATION OR WHEN THAT PRODUCT WAS FIRST SOLD

## DATE OF PRODUCT CREATION

SELECT
  product_name ,
  created_at
FROM ositofeliz.products
ORDER BY created_at;

## FIRST SOLD

SELECT
DATE(MIN(o.created_at)) AS DateSold,
p.product_name 
FROM ositofeliz.order_items oi 
LEFT JOIN ositofeliz.orders o ON oi.order_id=o.order_id
LEFT JOIN ositofeliz.products p ON oi.product_id=p.product_id
GROUP BY p.product_name;


#6. Calculate the gross sales per year as well as the numerical and percentage margin of each product and order it by product.

SELECT 
YEAR (o.created_at) AS Year,
oi.product_id,
p.product_name,
SUM(o.price_usd* o.items_purchased) AS GrossSales, 
SUM((o.price_usd - o.cogs_usd)*o.items_purchased) AS AbsoluteMargin,
CONCAT(100*(SUM(o.price_usd - o.cogs_usd)/SUM(o.price_usd* o.items_purchased)),'%') AS AbsoluteMarginPercentage
FROM ositofeliz.order_items oi 
LEFT JOIN ositofeliz.orders o ON oi.order_id=o.order_id
LEFT JOIN ositofeliz.products p ON oi.product_id=p.product_id
GROUP BY YEAR (o.created_at), oi.product_id
ORDER BY  p.product_name, oi.product_id;
  

#7. What are the months with the highest gross sales, does it return the TOP 3?

#Option 1:
SELECT  
YEAR(created_at) AS Year,
monthNAME(created_at) AS Month,
ROUND(SUM(price_usd*items_purchased),2) AS GrossSales
FROM ositofeliz.orders
GROUP BY year, monthNAME(created_at) 
ORDER BY GrossSales DESC
LIMIT 3;

#Option 2:
SELECT  
CONCAT (YEAR(created_at),"/", month(created_at)) AS Date,
ROUND(SUM(price_usd*items_purchased),2) AS GrossSales
FROM ositofeliz.orders
GROUP BY Date
ORDER BY GrossSales DESC
LIMIT 3;


#----------------------------------------------------------------- Web traffic analysis----------------------------------------------------------
    
#8. What are the ads (announcements) or contents that have attracted more sessions?

SELECT 
utm_content,
COUNT(website_session_id)
FROM ositofeliz.website_sessions
GROUP BY utm_content
ORDER BY COUNT(website_session_id)DESC;

##I would need to see these ads in what period they were and how long they were active, because it may be that the first one was a year and the second one month

#9.  Is sessions the same as users? What is the number of individual users?

SELECT
COUNT( website_session_id) AS SessionsCount,
COUNT(DISTINCT user_id) AS UsersCount,
SUM( CASE WHEN is_repeat_session = 0 THEN 1 ELSE 0 END) AS UserCounts
FROM ositofeliz.website_sessions;

## If the distinct is not set, it brings 70000 and not the number of unique users, this means that there are users who have entered more than once

#10.And by source ? Number of users and sessions?

SELECT
utm_source,
COUNT( website_session_id) AS SessionsCount,
COUNT(DISTINCT user_id) AS UserCount
FROM ositofeliz.website_sessions
GROUP BY utm_source;



#11.  What are the sources or sources that have given more sales?

SELECT 
w.utm_source,
SUM(o.price_usd* o.items_purchased) AS GrossSales
FROM ositofeliz.website_sessions w
JOIN ositofeliz.orders o ON w.website_session_id=o.website_session_id
GROUP BY utm_source
ORDER BY  GrossSales DESC;

# IF WE DO A LEFT JOIN WITHOUT THE FILTERS WE CAN SEE THAT IN THE TABLE OF ORDERS WE HAVE MANY NULL WHICH MEANS THAT THE USER ENTERED BUT DID NOT PURCHASE,
# INSTEAD WITH AN INNER JOIN BRINGS US ONLY THE USER WHO ENTERED AND PURCHASED


#12. Which are the months that have attracted the most traffic?

SELECT 
CONCAT (YEAR(created_at),"/", month(created_at)) AS Date,
COUNT(website_session_id) AS Traffic
FROM ositofeliz.website_sessions
GROUP BY Date
ORDER BY COUNT(website_session_id)DESC;


#13. Since we have seen the month that has had the most traffic, 
#could you see for that month the number of sessions that have come by mobile and the number that have come by computer?

SELECT
device_type,
COUNT(website_session_id) AS Traffic
FROM ositofeliz.website_sessions
WHERE MONTH (created_at) = 11 
GROUP BY device_type
ORDER BY  COUNT(website_session_id) DESC;

#14. ¿Which campaigns have given the most margin by product?


SELECT
w.utm_campaign AS Campaigns,
p.product_name,
SUM((o.price_usd - o.cogs_usd)*o.items_purchased) AS AbsoluteMargin
FROM ositofeliz.website_sessions w 
INNER JOIN ositofeliz.orders o ON o.website_session_id=w.website_session_id
LEFT JOIN ositofeliz.order_items oi  ON oi.order_id=o.order_id
LEFT JOIN products p ON oi.product_id=p.product_id
GROUP BY w.utm_campaign, p.product_name
ORDER BY AbsoluteMargin DESC;
