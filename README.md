# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT film_type,COUNT(*) FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM netflix
WHERE film_type  = 'Movie'
AND 
release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT UNNEST(STRING_TO_ARRAY(country,','))AS new_country ,
		COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM netflix
WHERE film_type = 'Movie'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) = (
      SELECT MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INT))
      FROM netflix
      WHERE film_type = 'Movie'
  );
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE-INTERVAL '5 years' 
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT title,film_type,duration AS seasons
FROM netflix
WHERE film_type = 'TV Show'
AND
CAST(SPLIT_PART(duration,' ',1) AS INT) >5
ORDER BY CAST(SPLIT_PART(duration,' ',1) AS INT) DESC;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')),COUNT(*) AS genre
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year,
	  COUNT(*) AS content_per_year,
	  ROUND(
	  COUNT(*)::"numeric"/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::"numeric"*100,2
	  )AS avg_content_added
FROM  netflix
WHERE country = 'India'
GROUP BY 1;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT show_id,film_type,title,listed_in,release_year,date_added
FROM netflix 
WHERE film_type = 'Movie'
AND
listed_in ILIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * FROM netflix
WHERE star_cast ILIKE '%Salman Khan%'
AND film_type = 'Movie'
AND release_year >= EXTRACT(YEAR FROM NOW()) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT UNNEST(STRING_TO_ARRAY(star_cast,',')),
		COUNT(*) AS number_of_movies
FROM netflix
WHERE film_type = 'Movie'
AND country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/prashantjha_143/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/prashant-jha-681a912b4/)

Thank you for your support, and I look forward to connecting with you!
