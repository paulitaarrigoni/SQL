# 1. Create database call computer_store

CREATE SCHEMA computer_store;

 # 2. Create Tables Manufacturers and Products and insert values 

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

/*3. Select the names of all the products in the store..*/

USE computer_store;
SELECT * FROM Products;

/*4. Select the names and prices of all the products in the store.*/

SELECT Name, Price
FROM computer_store.Products;

/*5. Select the name of the products with a price less than or equal to $200.*/

SELECT Name, Price
FROM computer_store.Products
WHERE Price <= 200;

/*6. Select all products with a price between $60 and $120.*/

SELECT Name, Price
FROM computer_store.Products
WHERE Price BETWEEN 60 AND 200;

/*7. Select the name and the price multiplied by 100.*/

SELECT Name, (Price*100) AS Porcentage
FROM computer_store.Products;

/*8. Calculate the average price of all products.*/

SELECT AVG(Price) AS Average 
FROM computer_store.Products
GROUP BY Name;

/*9. Calculate the average price of all products with a manufacturer code equal to 2.*/

SELECT AVG(Price) AS Average
FROM computer_store.Products
WHERE Code = 2;

/*10. Find the number of products with a price greater than or equal to $180.*/

SELECT count(Name)
FROM computer_store.Products
WHERE Price >= 180;

#11. Select the name and price of all products with a price greater than or equal to $180 and
# sort first by price (in descending order) and then by name (in ascending order).

SELECT Name, Price
FROM computer_store.Products
WHERE Price >= 180
ORDER BY Price DESC, Name ASC;

/*12. Select all product data, including all manufacturer data for each product.*/

SELECT *
FROM computer_store.Products p
JOIN computer_store.Manufacturers  m ON p.Code = m.Code;

/*13. Select the name of the product, the price and the name of the manufacturer of all the products.*/

SELECT p.Name AS Products,  m.Name AS Manufacturers, p.Price 
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code;

/*14. Select the average price of each manufacturer's products, showing only the manufacturer's code.*/

SELECT m.Code AS Manufacturers, AVG(p.Price) AS Average
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
GROUP BY m.Code;

/*15. Select the average price of the products of each manufacturer, showing the name of the manufacturer.*/

SELECT m.Name AS Manufacturers, AVG(p.Price) AS Average
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
GROUP BY m.Code;

/*16.  Select the names of the manufacturers whose products have an average price greater than or equal to $150.*/

SELECT m.Name AS Manufacturers, AVG(p.Price) AS Average
FROM computer_store.Products p
JOIN  computer_store.Manufacturers  m ON p.Code = m.Code
WHERE p.Price >= 150
GROUP BY m.Code;

/*17. Select the cheapest product name and price.*/

SELECT name,price
  FROM Products
  ORDER BY price ASC
  LIMIT 1;


/*18. Select the name of each manufacturer that has an average price greater than $145 and contains at least 2 different products.*/

Select m.Name, Avg(p.price) as p_price, COUNT(p.Manufacturer) as m_count
FROM Manufacturers m, Products p
WHERE p.Manufacturer = m.code
GROUP BY p.Manufacturer
HAVING p_price >= 150 and m_count >= 2;


/*19. Add a new product to the product table: Speakers, $70, manufacturer 2.*/

INSERT INTO computer_store.Products(Code,Name,Price,Manufacturer) 
VALUES(11,'Altavoces',70,2);

/*20. Update the product name 8 to "Impresora láser".*/

UPDATE computer_store.Products
 SET Name = 'Impresora láser'
 WHERE Code = 8;

/*21. Update the table of products and apply a 10% discount on all products.*/

UPDATE Products
   SET Price = Price - (Price * 0.1);
   
/*22. Update the table of products Apply a 10% discount to all products with a price greater than or equal to $120.*/

UPDATE Products
   SET Price = Price - (Price * 0.1)
   WHERE Price >= 120;


SELECT* FROM 
Products





 

 
 