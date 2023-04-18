CREATE SCHEMA Movies;
USE Movies;
CREATE TABLE movies (
   code INTEGER PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   rating VARCHAR(255) 
 );
 
 CREATE TABLE movietheaters (
   code INTEGER PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   movie INTEGER,  
     FOREIGN KEY (movie) REFERENCES movies(Code)
 ) ;
 INSERT INTO movies(Code,Title,Rating) VALUES(9,'Citizen King','G');
 INSERT INTO movies(Code,Title,Rating) VALUES(1,'Citizen Kane','PG');
 INSERT INTO movies(Code,Title,Rating) VALUES(2,'Singin'' in the Rain','G');
 INSERT INTO movies(Code,Title,Rating) VALUES(3,'The Wizard of Oz','G');
 INSERT INTO movies(Code,Title,Rating) VALUES(4,'The Quiet Man',NULL);
 INSERT INTO movies(Code,Title,Rating) VALUES(5,'North by Northwest',NULL);
 INSERT INTO movies(Code,Title,Rating) VALUES(6,'The Last Tango in Paris','NC-17');
 INSERT INTO movies(Code,Title,Rating) VALUES(7,'Some Like it Hot','PG-13');
 INSERT INTO movies(Code,Title,Rating) VALUES(8,'A Night at the Opera',NULL);
 
 INSERT INTO movietheaters(Code,Name,Movie) VALUES(1,'Odeon',5);
 INSERT INTO movietheaters(Code,Name,Movie) VALUES(2,'Imperial',1);
 INSERT INTO movietheaters(Code,Name,Movie) VALUES(3,'Majestic',NULL);
 INSERT INTO movietheaters(Code,Name,Movie) VALUES(4,'Royale',6);
 INSERT INTO movietheaters(Code,Name,Movie) VALUES(5,'Paraiso',3);
 INSERT INTO movietheaters(Code,Name,Movie) VALUES(6,'Nickelodeon',NULL);
 
SELECT * FROM movies;
SELECT * FROM movietheaters;

/*1. Seleccione el título de todas las películas.*/

SELECT Title
 FROM movies;
 
/*2. Muestra todas las clasificaciones (Rating) únicas en la base de datos.*/

SELECT DISTINCT Rating
FROM movies;

/*3. Mostrar todas las películas sin clasificación.(Rating)*/

SELECT Title
FROM movies
WHERE Rating IS NULL;


/*4. Seleccione todas las salas de cine que actualmente no muestran una película.*/

SELECT Name
FROM movietheaters 
WHERE Movie  IS NULL;

/*5. Seleccione todos los datos de todas las salas de cine y, adicionalmente, los datos de la película que se está mostrando en el cine (si se está mostrando una).*/

SELECT * 
FROM movietheaters mh
JOIN movies m  ON m.Code= mh.Code
WHERE mh.movie IS NOT NULL;

/*6. Seleccione todos los datos de todas las películas y, si esa película se proyecta en un cine, muestre los datos del cine.*/

SELECT m.Code,m.Title,m.Rating, mh.Name
FROM movies m
JOIN movietheaters mh ON mh.Code= m.Code
WHERE m.Title IS NOT NULL;

/*7. Muestra los títulos de las películas que no se muestran actualmente en ningún cine.*/


SELECT Title
FROM movies.movies m
LEFT JOIN movies.movietheaters mt on mt.Movie = m.code
WHERE Name IS NULL;

/*8. Inserte a la tabla Movies el registro de la película sin clasificación "One, Two, Three".*/
INSERT INTO Movies(Code,Title,Rating) VALUES(10,'One, Two, Three',NULL);

/*9. Actualiza la tabla Movies con la clasificación de todas las películas sin clasificar en "G".*/
UPDATE  Movies
SET Rating = 'G'
WHERE Rating IS NULL ;

SELECT * FROM Movies;

/*10. Elimina las salas de cine de la tabla que proyectan películas clasificadas como "NC-17".*/

DELETE FROM MovieTheaters WHERE Movie IN
   (SELECT Code FROM Movies WHERE Rating = 'NC-17');
   
   