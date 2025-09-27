--Netflix Project

CREATE TABLE netflix(
	show_id	VARCHAR(5),
	film_type VARCHAR(7),
	title VARCHAR(104),
	director VARCHAR(208),
	star_cast VARCHAR(771),
	country	VARCHAR(123),
	date_added	VARCHAR(19),
	release_year INT,
	rating	VARCHAR(8),
	duration VARCHAR(10),
	listed_in VARCHAR(79),
	description	VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) AS total_content FROM netflix;

SELECT DISTINCT film_type FROM netflix;



SELECT director,COUNT(*) FROM netflix
GROUP BY 1
ORDER BY 2 DESC;


-- 1. Count the number of Movies vs TV Shows
SELECT film_type,COUNT(*) FROM netflix
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows
SELECT film_type , rating
FROM(
	SELECT film_type,
		rating,COUNT(*),
		RANK() OVER(PARTITION BY film_type ORDER BY COUNT(*) DESC) AS ranking
		FROM netflix
	GROUP BY 1,2
) 
AS t1
WHERE ranking  = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix
WHERE film_type  = 'Movie'
AND 
release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT UNNEST(STRING_TO_ARRAY(country,','))AS new_country ,
		COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT *
FROM netflix
WHERE film_type = 'Movie'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) = (
      SELECT MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INT))
      FROM netflix
      WHERE film_type = 'Movie'
  );

-- 6. Find content added in the last 5 years,
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE-INTERVAL '5 years' 

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
SELECT title,film_type,duration AS seasons
FROM netflix
WHERE film_type = 'TV Show'
AND
CAST(SPLIT_PART(duration,' ',1) AS INT) >5
ORDER BY CAST(SPLIT_PART(duration,' ',1) AS INT) DESC;

-- 9. Count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')),COUNT(*) AS genre
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release

SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year,
	  COUNT(*) AS content_per_year,
	  ROUND(
	  COUNT(*)::"numeric"/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::"numeric"*100,2
	  )AS avg_content_added
FROM  netflix
WHERE country = 'India'
GROUP BY 1;

-- 11. List all movies that are documentaries
SELECT show_id,film_type,title,listed_in,release_year,date_added
FROM netflix 
WHERE film_type = 'Movie'
AND
listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT show_id,film_type,title,director
FROM netflix
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE star_cast ILIKE '%Salman Khan%'
AND film_type = 'Movie'
AND release_year >= EXTRACT(YEAR FROM NOW()) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(star_cast,',')),
		COUNT(*) AS number_of_movies
FROM netflix
WHERE film_type = 'Movie'
AND country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


WITH new_table 
AS(
	SELECT*,
	CASE 
		WHEN description ILIKE '%%KILL'
		OR description ILIKE '%VIOLENCE%' THEN 'Bad Content'
		ELSE 'Good Content'
	END category
FROM netflix
)
SELECT category,COUNT(*) AS total_content
FROM new_table
GROUP BY 1

