#################################################################### The client ########################################################################################

/*[LearnData] is an e-learning company dedicated to selling online data analysis courses. Its main objective is:

										- Start building a technology infrastructure to analyze your data.
										- Clean the data so that it can be consumed by the business areas.

He uses the following tools to manage his business:

- Wocommerce: It is a wordpress plugin that allows you to convert your website to an ecommerce site and sell products. 
- Stripe: It is an internet payment processing platform, just like paypal.
- Wordpress: It is a content management system (CMS), a software used to build, modify and maintain websites. 
  It is the most popular CMS on the market, as it is used by **65.2%** of the websites whose CMS we know of. 
  This translates to **42.4%** of all websites, almost half of the internet.

################################################################# The problem ##########################################################################################

[LearnData] wants to start analyzing its main financial metrics, but does not have a system in place to capture, analyze and make better decisions.

################################################################# The solution ##########################################################################################

We created a new database in MYSQL with all the data clean and ready to consume from their historical data that they downloaded to us in a CSV.
Then, in phase two of the project, it would be necessary to create the necessary pipelines to generate the data download automatically,
reusing the sql scripts to clean them.

################################################################### The process##########################################################################################

# Previous analysis of the problem

1. What data sources does the company have?

     The company uses wordpress with a wocommerce plugin as a sales platform for its online courses and
     then has stripe as a payment gateway for more than credit card payments.
     
2. In what format are the data downloaded?

    We will have the raw data in csv directly downloaded from the sources.
    
3. What data do we have?

    We have data on the products, that is, courses that are sold, the customers, the orders and the payments received by stripe.
    
4. Data model

    We have the table of orders that is related to the table of customers and products through SKU_producto and
    id_cliente and on the other hand we have the table of stripe payments that we will relate to the table of orders by order number.*/
    
  
################################################################# EXECUTION ##########################################################################

  /*1- We do an exporatory analysis of the tables downloaded to csv*/
  
  #learndata_crudo.raw_clientes_wocommerce Table

SELECT * FROM learndata_crudo.raw_clientes_wocommerce;

SELECT MIN(date_created), MAX(date_created)
FROM learndata_crudo.raw_clientes_wocommerce;

SELECT DISTINCT role
FROM learndata_crudo.raw_clientes_wocommerce;

#learndata_crudo.raw_pagos_stripe Table

SELECT * FROM learndata_crudo.raw_pagos_stripe;

SeLECT DISTINCT description
FROM learndata_crudo.raw_pagos_stripe;

SELECT DISTINCT TYPE
FROM learndata_crudo.raw_pagos_stripe;

#learndata_crudo.raw_pedidos_wocommerce Table

SELECT * FROM learndata_crudo.raw_pedidos_wocommerce;

SELECT MIN(fecha_de_pedido), MAX(fecha_de_pedido)
FROM learndata_crudo.raw_pedidos_wocommerce;

SELECT DISTINCT titulo_metodo_de_pago
FROM learndata_crudo.raw_pedidos_wocommerce;

SELECT DISTINCT nombre_del_articulo
FROM learndata_crudo.raw_pedidos_wocommerce;

#learndata_crudo.raw_productos_wocommerce Table

SELECT * FROM learndata_crudo.raw_productos_wocommerce;

/*2- We are going to create a new database and new tables with clean data and ready to consume*/

CREATE SCHEMA learndata ;

CREATE TABLE learndata.dim_clientes (
    id_cliente int,
    fecha_creacion_cliente DATE,
    nombre_cliente varchar(100),
    apellido_cliente varchar(100),
    email_cliente varchar(100),
    telefono_cliente varchar(100),
    region_cliente varchar(100),
    pais_cliente varchar(100),
    codigo_postal_cliente varchar(100),
    direccion_cliente varchar(255),
    PRIMARY KEY (id_cliente)
   );
   
   CREATE TABLE learndata.dim_producto (
  id_producto int ,
  sku_producto int,
  nombre_producto varchar(100),
  publicado_producto BOOLEAN ,
  inventario_producto varchar(100),
  precio_normal_producto INT ,
  categoria_producto varchar(100),
  PRIMARY KEY (sku_producto)
);
   
   CREATE TABLE learndata.fac_pedidos (
  id_pedido INT,
  sku_producto INT,
  estado_pedido VARCHAR(50),
  fecha_pedido DATE ,
  id_cliente INT  ,
  tipo_pago_pedido VARCHAR(50) ,
  costo_pedido INT  ,
  importe_de_descuento_pedido decimal(10,0) ,
  importe_total_pedido INT ,
  cantidad_pedido INT  ,
  codigo_cupon_pedido VARCHAR(100),
  PRIMARY KEY (id_pedido),
  FOREIGN KEY (id_cliente) REFERENCES dim_clientes (id_cliente),
  FOREIGN KEY (sku_producto) REFERENCES dim_producto (sku_producto)
);

CREATE TABLE learndata.fac_pagos_stripe (
  id_pago VARCHAR(50),
  fecha_pago datetime(6) ,
  id_pedido int ,
  importe_pago int ,
  moneda_pago VARCHAR(5),
  comision_pago decimal(10,2) ,
  neto_pago decimal(10,2) ,
  tipo_pago VARCHAR(50),
  PRIMARY KEY (id_pago),
  FOREIGN KEY (id_pedido) REFERENCES fac_pedidos (id_pedido)
);

/*3- We insert the clean data to the table*/

# learndata.dim_producto 

INSERT INTO learndata.dim_producto 
SELECT
  id AS id_producto ,
  sku AS sku_producto,
  nombre AS nombre_producto,
  publicado AS publicado_producto,
  Inventario AS inventario_producto,
  precio_normal AS precio_normal_producto,
  categorias AS categoria_producto 
FROM learndata_crudo.raw_productos_wocommerce;
/*In the products table we only change the names of the columns since the data came in a correct format*/

#learndata.dim_clientes 

INSERT INTO learndata.dim_clientes 
SELECT 
	id as id_cliente,
	STR_TO_DATE(date_created, "%d/%m/%Y %H:%i:%s") AS fecha_creacion_cliente,
    JSON_VALUE(billing,'$[0].first_name') AS nombre_cliente ,
	JSON_VALUE(billing,'$[0].last_name') AS  apellido_cliente,
	JSON_VALUE(billing,'$[0].email') AS  email_cliente ,
	JSON_VALUE(billing,'$[0].phone') AS   telefono_cliente ,
	JSON_VALUE(billing,'$[0].region') AS  region_cliente ,
	JSON_VALUE(billing,'$[0].country') AS pais_cliente ,
	JSON_VALUE(billing,'$[0].postcode') AS codigo_postal_cliente ,
	JSON_VALUE(billing,'$[0].address_1')  AS direccion_cliente 
FROM learndata_crudo.raw_clientes_wocommerce;

/*In the customer table we changed the names of the columns, we extracted the data from the billing column that came in a JSON format and
 we changed the date data that came as text to date*/
 
 #learndata.fac_pedidos
 
 SET @@SESSION.sql_mode='ALLOW_INVALID_DATES';
 INSERT INTO learndata.fac_pedidos
 SELECT
	numero_de_pedido AS  id_pedido,
	CASE WHEN pr.sku IS NULL THEN '3' ELSE pr.sku END  AS sku_producto,
	estado_de_pedido as estado_pedido,
	DATE(fecha_de_pedido) AS  fecha_pedido,
	`id cliente` AS id_cliente,
	CASE WHEN  titulo_metodo_de_pago LIKE '%Stripe%' THEN 'Stripe' 
     ELSE 'Tarjeta'
     END AS tipo_pago_pedido,
	coste_articulo AS  costo_pedido,
	importe_de_descuento_del_carrito AS importe_de_descuento_pedido,
	importe_total_pedido AS importe_total_pedido,
	cantidad AS cantidad_pedido,
	cupon_articulo AS codigo_cupon_pedido 
FROM learndata_crudo.raw_pedidos_wocommerce pe
LEFT JOIN  learndata_crudo.raw_productos_wocommerce pr ON pe.nombre_del_articulo=pr.nombre;

/*We detected a problem with the name of one of the fields when joining them by name, the value of the sku was null. 
We correct this with a CASE and we use the value of the sku from the products table and not from the orders. As an extra task,
 the area in charge must be informed that the data that is downloaded from the orders comes with the wrong sku value.*/
 
SELECT 
pe.sku AS sku_pedidos ,
pe.nombre_del_articulo AS nombre_pedido,
pr.sku AS sku_producto,
pr.nombre AS nombre_producto
FROM learndata_crudo.raw_pedidos_wocommerce pe
LEFT JOIN  learndata_crudo.raw_productos_wocommerce pr ON pe.nombre_del_articulo=pr.nombre;

#  SET @@SESSION.sql_mode='ALLOW_INVALID_DATES'; It treats the error of the dates

#Error Code: 1062. Duplicate entry '41624' for key 'fac_pedidos.PRIMARY'
SELECT*
FROM learndata_crudo.raw_pedidos_wocommerce
WHERE numero_de_pedido = '41624';

/*We detect that a primary key is duplicated, first we analyze where the error comes from and since we cannot detect it,
 we eliminate one of the duplicates and report it to the corresponding area*/
 
DELETE FROM learndata_crudo.raw_pedidos_wocommerce WHERE numero_de_pedido = 41624 and `id cliente` = 1324;

#learndata.fac_pagos_stripe

SET @@SESSION.sql_mode='ALLOW_INVALID_DATES';

INSERT INTO learndata.fac_pagos_stripe
 SELECT 
	id AS id_pago,
	DATE(created) fecha_pago,
	RIGHT(description,5)  id_pedido,
	amount AS importe_pago,
	currency  AS moneda_pago,
	CAST(REPLACE(fee,',','.')AS DECIMAL(10,2)) as comision_pago,
	CAST(REPLACE(net,',','.') AS DECIMAL(10,2))  as neto_pago,
	type AS tipo_pago
  FROM learndata_crudo.raw_pagos_stripe;
  
  /*563 row(s) affected, 563 warning(s): 1292 Truncated incorrect datetime value: '2021-07-06T08:11:58Z' 1292 Truncated incorrect*/ 
  
SET @@SESSION.sql_mode='ALLOW_INVALID_DATES';

INSERT INTO learndata.fac_pagos_stripe
 SELECT 
	id AS id_pago,
	TIMESTAMP(created) AS fecha_pago,
	RIGHT(description,5)  id_pedido,
	amount AS importe_pago,
	currency  AS moneda_pago,
	CAST(REPLACE(fee,',','.')AS DECIMAL(10,2)) as comision_pago,
	CAST(REPLACE(net,',','.') AS DECIMAL(10,2))  as neto_pago,
	type AS tipo_pago
  FROM learndata_crudo.raw_pagos_stripe;
  
  ################################################ Financial Analysis ########################################################
  use learndata;
  
  # 1- What is the total sales of the company?
  
  SELECT 
  FORMAT(SUM(importe_total_pedido),2) AS TotalSales
  FROM learndata.fac_pedidos;
  
  # 2- What is the total sales per year?
  
   SELECT 
   YEAR(fecha_pedido) AS Year,
  FORMAT(SUM(importe_total_pedido),2) AS TotalSales
  FROM learndata.fac_pedidos
  GROUP BY Year ;
  
  # 3- What is the total sales per product?
  
  SELECT 
  pr.nombre_producto AS Product,
  SUM(pe.importe_total_pedido) AS TotalSales
  FROM learndata.fac_pedidos pe
  LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto
  GROUP BY  Product
  ORDER BY TotalSales DESC;
  
  # 4- What is the total sales by product but by quantity?
  
   SELECT 
  pr.nombre_producto AS Product,
  SUM(pe.importe_total_pedido) AS TotalSales,
  SUM(cantidad_pedido) AS Quantity
  FROM learndata.fac_pedidos pe
  LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto
  GROUP BY  Product
  ORDER BY Quantity DESC;
  
  # 5- At what price has each product been sold? Could you get the unique value?
 
 SELECT 
 DISTINCT nombre_producto,
 costo_pedido
FROM learndata.fac_pedidos pe
LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto;

# 6- To what could we attribute this growth in sales? Could we see the sales by product and by year?

SELECT 
   YEAR(pe.fecha_pedido) AS Year,
  pr.nombre_producto AS Product,
  SUM(cantidad_pedido) as Quantity,
  SUM(pe.importe_total_pedido) AS TotalSales
  FROM learndata.fac_pedidos pe
  LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto
  GROUP BY  Year, Product
  ORDER BY Year DESC;
  
  # 7- What are the sales by months of the year 2021? Order the sales from highest to lowest.
  
  SELECT 
   YEAR(pe.fecha_pedido) AS Year,
   MONTH(pe.fecha_pedido) AS Month,
  pr.nombre_producto AS Product,
  SUM(cantidad_pedido) as Quantity,
  SUM(pe.importe_total_pedido) AS TotalSales
  FROM learndata.fac_pedidos pe  
  LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto
  WHERE YEAR(pe.fecha_pedido)= 2021
  GROUP BY  Month, Year, Product
  ORDER BY Year DESC;

#8- What are the top 3 customers who buy in monetary terms? We need the full name with last name to be brought in a single field.
  
  SELECT
  CONCAT(c.nombre_cliente, " ", c.apellido_cliente) AS CustomerName,
   SUM(pe.importe_total_pedido) AS TotalSales,
   pr.nombre_producto AS Product,
  SUM(cantidad_pedido) as Quantity
  FROM  learndata.fac_pedidos pe  
  LEFT JOIN learndata.dim_clientes c ON c.id_cliente=pe.id_cliente
   LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto
  GROUP BY CustomerName,  Product
  ORDER BY TotalSales DESC
  LIMIT 3;
  
# 9- What are the top 3 quantity-buying customers? We need you to bring the full name with last name

 SELECT
  CONCAT(c.nombre_cliente, " ", c.apellido_cliente) AS CustomerName,
   SUM(pe.importe_total_pedido) AS TotalSales,
   pr.nombre_producto AS Product,
  SUM(cantidad_pedido) as Quantity
  FROM  learndata.fac_pedidos pe  
  LEFT JOIN learndata.dim_clientes c ON c.id_cliente=pe.id_cliente
   LEFT JOIN learndata.dim_producto pr on pe.sku_producto=pr.sku_producto
  GROUP BY CustomerName,  Product
  ORDER BY Quantity DESC
  LIMIT 3;

# 10- What is the payment method with which customers pay the most (monetary terms)?

SELECT 
tipo_pago_pedido AS Payment,
SUM(importe_total_pedido) AS TotalSales
FROM learndata.fac_pedidos
GROUP BY tipo_pago_pedido
ORDER BY Payment DESC;

#11- What is the total amount in monetary terms used in coupons?

SELECT 
SUM(importe_de_descuento_pedido) AS AmountDiscount
FROM learndata.fac_pedidos;

#12- What is the total number of coupons used in sales in quantitative terms? Compare it to all sales and calculate the percentage in quantitative terms.

WITH cupones AS (
SELECT 
id_pedido,
codigo_cupon_pedido,
CASE WHEN codigo_cupon_pedido='' THEN 0 ELSE 1 END AS cupones
FROM learndata.fac_pedidos)


SELECT 
SUM(cupones) AS CouponsTotal,
COUNT(DISTINCT pe.id_pedido) AS Sales,
SUM(cupones)/COUNT(DISTINCT pe.id_pedido) AS Percentage
FROM learndata.fac_pedidos pe
LEFT JOIN cupones c on c.id_pedido=pe.id_pedido;
  
  #13- The same calculation but broken down by year.
  
WITH cupones AS (
SELECT
 id_pedido,
codigo_cupon_pedido,
CASE WHEN codigo_cupon_pedido='' THEN 0 ELSE 1 END AS cupones
FROM learndata.fac_pedidos)


SELECT 
YEAR(pe.fecha_pedido) AS Year,
SUM(cupones) AS CouponsTotal,
COUNT(DISTINCT pe.id_pedido) AS Sales,
SUM(cupones)/COUNT(DISTINCT pe.id_pedido) AS Percentage
FROM learndata.fac_pedidos pe
LEFT JOIN cupones c on c.id_pedido=pe.id_pedido
GROUP BY Year;

#14- What is the total commissions paid to stripe?

SELECT SUM(comision_pago) AS Commissions
 FROM learndata.fac_pagos_stripe;
 
 #15- What is the commission percentage of each order placed by Stripe?
 
 SELECT 
 pe.id_pedido,
comision_pago/importe_pago AS Percentage
FROM learndata.fac_pedidos pe
INNER JOIN learndata.fac_pagos_stripe s ON s.id_pedido=pe.id_pedido;

#16- From the previous exercise, what is the average of the total percentage rounded to two decimal digits?
 
 SELECT 
 pe.id_pedido,
ROUND(AVG(comision_pago/importe_pago),3) AS Percentage
FROM learndata.fac_pedidos pe
INNER JOIN learndata.fac_pagos_stripe s ON s.id_pedido=pe.id_pedido
GROUP BY  pe.id_pedido;

#17- Calculate total sales, non-STRIPE commission sales and STRIPE commissions per year

SELECT
year(fecha_pedido) AS Year,
sum(importe_total_pedido) AS TotalSales,
IFNULL(sum(comision_pago),0) AS Commission,
sum(importe_total_pedido) + IFNULL(sum(comision_pago),0) AS NetSales
FROM cursosdata.fac_pedidos pe
LEFT JOIN learndata.fac_pagos_stripe s on s.id_pedido=pe.id_pedido
GROUP BY year(fecha_pedido)

#Power Bi
https://app.powerbi.com/links/2XCovX1ddw?ctid=2171e36d-99d4-47fc-bdd2-dd294f064943&pbi_source=linkShare&bookmarkGuid=32137880-ddd3-40a0-b72d-c0f46211d4ed
