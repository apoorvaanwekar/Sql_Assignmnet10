USE  sakila ;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT first_name,last_name FROM actor ;-- 1a
ALTER TABLE actor ADD column Actor_Name varchar(20) ;
SET SQL_SAFE_UPDATES = 0;
	UPDATE  actor 
    SET Actor_Name= CONCAT(first_name ," ",last_name)  ; -- 1B
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
SELECT actor_id,  first_name,last_name FROM actor WHERE first_name ="Joe" ; -- 2a
SELECT actor_id,  first_name,last_name FROM actor WHERE last_name like "%GEN%" ; -- 2b
SELECT last_name,first_name FROM actor WHERE last_name like "%LI%" ; -- 2c
SELECT country_id ,country FROM country WHERE country IN ("Afghanistan"," Bangladesh", "China") ; -- 2d
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER table actor
ADD column middle_name varchar(20)  AFTER first_name ;
-- 3A

ALTER TABLE actor MODIFY COLUMN middle_name  BLOB ; -- 3b

ALTER TABLE actor
DROP COLUMN middle_name ; -- 3c


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT last_name,COUNT(actor_id) FROM actor GROUP BY last_name; -- 4a
SELECT last_name,COUNT(actor_id) as count_of_actor FROM actor GROUP BY last_name HAVING count_of_actor >=2; -- 4b

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'; -- 4c


UPDATE actor
SET first_name = (CASE WHEN first_name = 'HARPO' THEN 'GROUCHO'
										ELSE 'MUCHO GROUCHO' END)
WHERE actor_id = 172; -- 4d 172 is actor_id for HARPO/GROUCHO WILLIAMS
                                        
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIBE address; -- 5a
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT A.first_name, A.last_name,  B.address FROM staff A INNER JOIN  address B 
ON A.address_id = B.address_id ; -- 6a

SELECT SUM(B.amount) ,A.staff_id FROM staff A INNER JOIN payment B 
ON A.staff_id = B.staff_id GROUP BY A.staff_id ; -- 6b

SELECT A.film_id,COUNT(actor_id) AS number_of_actors
FROM film_actor A INNER JOIN  film B
ON A.film_id = B.film_id
GROUP BY A.film_id ; -- 6c

SELECT B.title,count(A.film_id) number_of_copies
FROM inventory A INNER JOIN film B
ON A.film_id = B.film_id
WHERE B.title ="Hunchback Impossible" ;  -- 6d


SELECT B.customer_id,SUM(A.amount) amount_paid
FROM payment A INNER JOIN customer B
ON A.customer_id = B.customer_id
GROUP BY B.customer_id ;  -- 6e
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT first_name,last_name 
FROM actor WHERE  actor_id  IN 
	(SELECT actor_id FROM film_actor WHERE film_id =
		(SELECT film_id FROM film WHERE title= "Alone Trip" )) ; -- 7b
        
        
SELECT first_name,last_name,email FROM customer WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN
	(SELECT city_id FROM city WHERE country_id =
		(SELECT country_id
		FROM country
		WHERE country= "Canada"))) ; -- 7c
        
 SELECT title FROM film WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id =
	(SELECT category_id FROM category WHERE name= "family")) ; -- 7d

SELECT title, COUNT(rental_id) AS Number_of_Times_Rented
FROM
(SELECT R.rental_id AS rental_id, F.title AS title
 FROM rental R, inventory I, film F
 WHERE R.inventory_id = I.inventory_id AND F.film_id = I.film_id) Rented_Films
 GROUP BY title
 ORDER BY Number_of_Times_Rented DESC; -- 7e
 
    
SELECT  B.store_id ,SUM(A.amount)  AS total_amount FROM payment A JOIN
	(SELECT staff_id ,store_id FROM staff WHERE store_id IN
    (SELECT store_id FROM store)) B
ON A.staff_id=B.staff_id
GROUP BY B.store_id ; -- 7f

    
 SELECT A.city,A.country,B.store_id
 FROM 
		(SELECT A.city as city, B.country as country,A.city_id as city_id
			FROM city A JOIN country B
			ON A.country_id=B.country_id)  A
JOIN
 (SELECT B.store_id as store_id ,A.address_id,A.city_id FROM store B JOIN address A ON  A.address_id=B.store_id) B
 
 ON A.city_id=B.city_id ; -- 7g
 
SELECT Genre, SUM(amount) AS Revenue
FROM (
	SELECT C.name AS Genre, P.amount AS amount
	FROM
		payment AS P
		JOIN rental AS R ON P.rental_id = R.rental_id
		JOIN inventory AS I ON R.inventory_id = I.inventory_id
		JOIN film_category AS FC ON FC.film_id = I.film_id
		JOIN category AS C ON C.category_id = FC.category_id) AS T
GROUP BY Genre
ORDER BY Revenue DESC
LIMIT 5; -- 7h



 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW sakila.top_five_revenue_genres AS 
(SELECT Genre, SUM(amount) AS Revenue
FROM (
	SELECT C.name AS Genre, P.amount AS amount
	FROM
		payment AS P
		JOIN rental AS R ON P.rental_id = R.rental_id
		JOIN inventory AS I ON R.inventory_id = I.inventory_id
		JOIN film_category AS FC ON FC.film_id = I.film_id
		JOIN category AS C ON C.category_id = FC.category_id) AS T
GROUP BY Genre
ORDER BY Revenue DESC
LIMIT 5); -- 8a

SHOW CREATE VIEW top_five_revenue_genres; -- 8b
SELECT * FROM top_five_revenue_genres; -- 8b

DROP VIEW IF EXISTS top_five_revenue_genres; -- 8c

        
