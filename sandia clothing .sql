#USE CASE #3: Watermelon Clothing

----- Introduction

#Watermelon Clothing is a store that offers a streamlined range of clothing and lifestyle clothing for the adventurous.
# In this case, Watermelon Clothing has already made its database but is beginning to carry out its first analysis.

----- Problem to solve

#Alejandro, the CEO of this fashion company, has asked you to help sales teams analyze their sales performance and the business in general.
#The following questions can be considered key business questions and metrics that the Watermelon Clothing team requires for their monthly reports.

#----------------------------------------------------Sales Analysis-------------------------------------------------------------------

USE sandia_clothing;

#1. What was the total quantity sold of all products?

SELECT 
SUM(qty) AS QuantitySoldProducts
FROM sandia_clothing.ventas;
 

#2. What is the total revenue generated by all products before discounts?

SELECT 
SUM(qty*precio) AS TotalRevenue
FROM sandia_clothing.ventas;


#3. What is the average revenue generated by all products before discounts?

SELECT 
AVG(qty*precio) AS AverageRevenue
FROM sandia_clothing.ventas;
 
#4. What is the total revenue generated by each product before discounts?

SELECT p.nombre_producto AS ProductName,
 SUM(c.qty*c.precio) AS TotalRevenueProduct
 FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY nombre_producto
 ORDER BY TotalRevenueProduct DESC;
 
 
#5. What was the total amount of the discount for all products?

SELECT SUM(descuento) AS Discount
FROM sandia_clothing.ventas;

#6. What was the total amount of the discount for each product?

SELECT p.nombre_producto AS ProductName,
SUM(c.descuento) AS Discount
 FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY ProductName
 ORDER BY Discount DESC;


###---------------------------------------------------------- Transaction Analysis---------------------------------------------------------------------

#1. How many unique transactions were there? (The transactions field is the id_txn of the sales table)

SELECT COUNT( DISTINCT id_txn) AS TransactionsCount
FROM sandia_clothing.ventas;

#2.  What are the total gross sales for each transaction?

SELECT id_txn, SUM(qty*precio) AS TotalGrossSales
FROM sandia_clothing.ventas
GROUP BY id_txn
ORDER BY TotalGrossSales DESC;

#3. How many total products are purchased in each transaction?

SELECT id_txn, SUM(qty) AS TotalProducts
FROM sandia_clothing.ventas
GROUP BY id_txn ;

#4. Order the previous result from the greatest to the least number of products.

SELECT id_txn, SUM(qty) AS TotalProducts
FROM sandia_clothing.ventas
GROUP BY id_txn
ORDER BY TotalProducts DESC ;

#5. What is the average discount value per transaction?

SELECT id_txn, ROUND(AVG(descuento),2) AS AverageDiscount
FROM sandia_clothing.ventas
GROUP BY id_txn
ORDER BY AverageDiscount DESC;

#6. What is the average net income for member transactions “t”?

SELECT id_txn, ROUND (AVG(qty*precio - descuento),2) AS AverageNetIncome
FROM sandia_clothing.ventas
WHERE miembro = 't'
GROUP BY id_txn
ORDER BY AverageNetIncome DESC;

###------------------------------------------------------------- Product Analysis---------------------------------------------------------------------

#1. What are the top 3 products by total revenue before discount?

SELECT p.nombre_producto AS ProductName,
SUM(c.qty*c.precio) AS AverageNetIncome
 FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY ProductName
 ORDER BY AverageNetIncome DESC
 LIMIT 3;

#2.  What is the total quantity, revenue, and discount for each product segment?

SELECT 
p.nombre_segmento AS ProductSegment,
SUM(c.qty) AS TotalQuality,
SUM(c.qty*c.precio-descuento) AS  AverageNetIncome,
SUM(c.descuento) AS Discount
 FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY  ProductSegment
 ORDER BY AverageNetIncome DESC;

#3. What is the best selling product for each segment?

#Option 1:
SELECT 
p.nombre_segmento  AS ProductSegment,
p.nombre_producto AS ProductName,
SUM(c.qty) AS Quantity
FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY ProductSegment, ProductName
ORDER BY Quantity desc;

## Option 2:

SELECT
d.nombre_segmento AS ProductSegment,
d.nombre_producto AS ProductName,
SUM(qty*v.precio-descuento) as NetSales
FROM sandia_clothing.ventas v
lEFT JOIN sandia_clothing.producto_detalle d on d.id_producto = v.id_producto
GROUP BY ProductSegment, ProductName
ORDER BY  ProductSegment, NetSales DESC;


#4. What is the total amount, revenue, and discount for each category?

SELECT 
p.nombre_categoria AS CategoryName,
SUM(c.qty) AS Quantity,
SUM(c.qty*c.precio) AS AverageNetIncome,
SUM(c.descuento) AS Discount
 FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY CategoryName
 ORDER BY  AverageNetIncome DESC;
 
#5. What is the best-selling product in each category?

#Option 1:
SELECT
  p.nombre_categoria AS CategoryName,
  p.nombre_producto AS ProductName,
  SUM(c.qty) AS  Quantity
  FROM sandia_clothing.ventas c
  LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
  GROUP BY p.nombre_categoria, p.nombre_producto
  ORDER BY  Quantity  desc
  LIMIT 1;

#Option 2:
 SELECT
d.nombre_categoria AS CategoryName,
d.nombre_producto AS ProductName,
SUM(qty*v.precio-descuento) as NetSales
FROM sandia_clothing.ventas v
lEFT JOIN sandia_clothing.producto_detalle d on d.id_producto = v.id_producto
GROUP BY d.nombre_categoria, d.nombre_producto
ORDER BY NetSales DESC
LIMIT 2;

#6. What are the 5 products that sell the least?

#Option 1:
SELECT 
nombre_producto AS ProductName,
SUM(c.qty) AS Quantity
FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 GROUP BY nombre_producto
ORDER BY Quantity asc
LIMIT 5;

## Option 2:

SELECT
d.nombre_producto AS ProductName,
SUM(qty*v.precio-descuento) as NetSales
FROM sandia_clothing.ventas v
lEFT JOIN sandia_clothing.producto_detalle d on d.id_producto = v.id_producto
GROUP BY d.nombre_producto
ORDER BY NetSales
LIMIT 5;


#7. What is the number of products sold for the 'Women' category?

SELECT 
nombre_producto AS ProductName,
SUM(c.qty) AS Quantity
FROM sandia_clothing.ventas c
 LEFT JOIN sandia_clothing.producto_detalle p ON c.id_producto = p.id_producto
 WHERE nombre_categoria = 'Mujer'
 GROUP BY nombre_producto
ORDER BY Quantity desc;