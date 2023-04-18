CREATE SCHEMA computer_store;

CREATE TABLE computer_store.Manufacturers (
  Code INTEGER,
  Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Code)   
);

CREATE TABLE computer_store.Products (
  Code INTEGER,
  Name VARCHAR(255) NOT NULL ,
  Price DECIMAL NOT NULL ,
  Manufacturer INTEGER NOT NULL,
  PRIMARY KEY (Code), 
  FOREIGN KEY (Manufacturer) REFERENCES Manufacturers(Code)
);

INSERT INTO computer_store.Manufacturers(Code,Name) 
VALUES (1,'Sony'),(2,'Creative Labs'),(3,'Hewlett-Packard'),(4,'Iomega'),(5,'Fujitsu'),(6,'Winchester');

INSERT INTO computer_store.Products(Code,Name,Price,Manufacturer) 
VALUES(1,'Hard drive',240,5),
(2,'Memory',120,6),
(3,'ZIP drive',150,4),
(4,'Floppy disk',5,6),
(5,'Monitor',240,1),
(6,'DVD drive',180,2),
(7,'CD drive',90,2),
(8,'Printer',270,3),
(9,'Toner cartridge',66,3),
(10,'DVD burner',180,2);

/*1. Selecciona los nombres de todos los productos de la tienda.*/

USE computer_store;
SELECT * FROM Products;

/*2. Selecciona los nombres y los precios de todos los productos de la tienda.*/

SELECT Name, Price
FROM computer_store.Products;

/*3. Selecciona el nombre de los productos con un precio menor o igual a $200.*/

SELECT Name, Price
FROM computer_store.Products
WHERE Price <= 200;

/*4. Selecciona todos los productos con un precio entre $60 y $120.*/

SELECT Name, Price
FROM computer_store.Products
WHERE Price BETWEEN 60 AND 200;

/*5. Seleccione el nombre y el precio multiplicado por 100.*/

SELECT Name, (Price*100) AS Porcentage
FROM computer_store.Products;

/*6. Calcule el precio promedio de todos los productos.*/

SELECT AVG(Price) AS Average 
FROM computer_store.Products
GROUP BY Name;

/*7. Calcule el precio promedio de todos los productos con código de fabricante igual a 2.*/

SELECT AVG(Price) AS Average
FROM computer_store.Products
WHERE Code = 2;

/*8. Calcule el número de productos con un precio mayor o igual a $180.*/

SELECT count(Name)
FROM computer_store.Products
WHERE Price >= 180;

/*9. Selecciona el nombre y el precio de todos los productos con un precio mayor o igual a $180 
y ordena primero por precio (en orden descendente) y luego por nombre (en orden ascendente).*/

SELECT Name, Price
FROM computer_store.Products
WHERE Price >= 180
ORDER BY Price DESC, Name ASC;

/*10. Seleccione todos los datos de los productos, incluidos todos los datos del fabricante de cada producto.*/

SELECT *
FROM computer_store.Products p
JOIN computer_store.Manufacturers  m ON p.Code = m.Code;

/*11. Seleccione el nombre del poducto, el precio y el nombre del fabricante de todos los productos.*/

SELECT p.Name AS Products,  m.Name AS Manufacturers, p.Price 
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code;

/*12. Seleccione el precio promedio de los productos de cada fabricante, mostrando solo el código del fabricante.*/

SELECT m.Code AS Manufacturers, AVG(p.Price) AS Average
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
GROUP BY m.Code;

/*13. Seleccione el precio promedio de los productos de cada fabricante, mostrando el nombre del fabricante.*/

SELECT m.Name AS Manufacturers, AVG(p.Price) AS Average
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
GROUP BY m.Code;

/*14. Seleccione los nombres de los fabricantes cuyos productos tienen un precio promedio mayor o igual a $150.*/

SELECT m.Name AS Manufacturers, AVG(p.Price) AS Average
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
WHERE p.Price >= 150
GROUP BY m.Code;

/*15. Seleccione el nombre y el precio del producto más barato.*/

SELECT name,price
  FROM Products
  ORDER BY price ASC
  LIMIT 1;


/*16. Seleccione el nombre de cada fabricante que tenga un precio promedio superior a $145 y contenga al menos 2 productos diferentes.*/

SELECT m.Name AS Manufacturers, AVG(p.Price) AS Average, COUNT(p.Manufacturer) as m_count
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
WHERE Average >= 145 AND m_count >= 2
GROUP BY m.Code;

/*????*/

Select m.Name, Avg(p.price) as p_price, COUNT(p.Manufacturer) as m_count
FROM Manufacturers m, Products p
WHERE p.Manufacturer = m.code
GROUP BY p.Manufacturer
HAVING p_price >= 150 and m_count >= 2;


/*17. Agregue un nuevo producto a la tabla de productos: Altavoces, $70, fabricante 2.*/

INSERT INTO computer_store.Products(Code,Name,Price,Manufacturer) 
VALUES(11,'Altavoces',70,2);

/*18. Actualice el nombre del producto 8 a "Impresora láser".*/

UPDATE computer_store.Products
 SET Name = 'Impresora láser'
 WHERE Code = 8;

/*19. Actualiza la tabla de productos y aplica un 10% de descuento en todos los productos.*/

UPDATE Products
   SET Price = Price - (Price * 0.1);
   
/*20. Actualiza la tabla de productos Aplica un 10% de descuento a todos los productos con un precio mayor o igual a $120.*/

UPDATE Products
   SET Price = Price - (Price * 0.1)
   WHERE Price >= 120;


SELECT* FROM 
Products





 

 
 