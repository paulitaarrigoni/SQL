# 1. Create database call Movies

CREATE SCHEMA Movies;
USE Movies;

 # 2. Create Tables movies and movietheaters and insert values 

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

/*3. Select the title of all movies.*/

SELECT Title
 FROM movies;
 
/*4. Shows all unique Ratings in the database.*/

SELECT DISTINCT Rating
FROM movies;

/*5. Show all unrated movies.(Rating)*/

SELECT Title
FROM movies
WHERE Rating IS NULL;


/*6. Select all movie theaters that are not currently showing a movie.*/

SELECT Name
FROM movietheaters 
WHERE Movie  IS NULL;

/*7. Select all data for all theaters and additionally the data for the movie being shown in the theater (if one is being shown).*/

SELECT * 
FROM movietheaters mh
JOIN movies m  ON m.Code= mh.Code
WHERE mh.movie IS NOT NULL;

/*8. Select all data for all movies, and if that movie is playing in a theater, show the theater data.*/

SELECT m.Code,m.Title,m.Rating, mh.Name
FROM movies m
JOIN movietheaters mh ON mh.Code= m.Code
WHERE m.Title IS NOT NULL;

/*9. Displays the titles of movies that are not currently showing in any theater.*/


SELECT Title
FROM movies.movies m
LEFT JOIN movies.movietheaters mt on mt.Movie = m.code
WHERE Name IS NULL;

/*10. Insert to the Movies table the record of the unclassified movie "One, Two, Three".*/

INSERT INTO Movies(Code,Title,Rating) VALUES(10,'One, Two, Three',NULL);

/*11. Updates the Movies table with the rating of all unrated movies in "G".*/

UPDATE  Movies
SET Rating = 'G'
WHERE Rating IS NULL ;

SELECT * FROM Movies;

/*12. Removes movie theaters from the chart that show movies rated "NC-17".*/

DELETE FROM MovieTheaters WHERE Movie IN
   (SELECT Code FROM Movies WHERE Rating = 'NC-17');
   
   