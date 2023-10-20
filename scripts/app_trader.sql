SELECT *
FROM play_store_apps;

SELECT *
FROM app_store_apps;


--Gotta start somewhere
/*SELECT 
	a.name,
	p.name,
	ROUND(((a.rating * p.rating)/2),1) AS avg_rating,
	CAST(a.price AS money)
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name AND CAST(a.price as money) = CAST(p.price as money)
ORDER BY avg_rating DESC, a.price*/

--trying to fix the names
/*
SELECT 
	lower(TRIM(a.name)) AS app_name,
	ROUND(((a.rating * p.rating)/2),1) AS avg_rating,
	CAST(a.price AS money)
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name)) = lower(TRIM(p.name)) AND CAST(a.price as money) = CAST(p.price as money)
ORDER BY avg_rating DESC, a.price*/

--this one runs too long
/*
WITH both_name AS (SELECT 
	LOWER(TRIM(a.name)) AS app_name
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name))= lower(TRIM(p.name))
GROUP BY app_name)

SELECT 
	b.app_name,
	ROUND(((a.rating * p.rating)/2),1) AS avg_rating,
	CAST(a.price AS money)
FROM app_store_apps AS a
INNER JOIN both_name AS b
ON lower(TRIM(a.name))=b.app_name
INNER JOIN play_store_apps AS p
ON CAST(a.price as money) = CAST(p.price as money)
ORDER BY avg_rating DESC, a.price
LIMIT 20;*/

--NOPE
/*SELECT 
	LOWER(TRIM(a.name)),
	ROUND(((a.rating * p.rating)/2),1) AS avg_rating,
	CAST(a.price AS money)
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON CAST(a.price as money) = CAST(p.price as money)
WHERE LOWER(TRIM(a.name)) IN (SELECT 
					LOWER(TRIM(a.name)) AS app_name
					FROM app_store_apps AS a
					INNER JOIN play_store_apps AS p
					ON lower(TRIM(a.name))= lower(TRIM(p.name))
					GROUP BY app_name)
ORDER BY avg_rating DESC, a.price*/


/*SELECT 
	LOWER(TRIM(a.name)) AS app_name
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name))= lower(TRIM(p.name))
GROUP BY app_name*/
		  
SELECT
	(CASE WHEN p.name IS NULL THEN a.name
		  WHEN a.name IS NULL THEN p.name
	      WHEN p.name IS NOT NULL AND a.name IS NOT NULL THEN a.name ELSE 'Booger' END) AS app_name,
		  CAST(a.price AS money),
		  CAST((a.price*10000) AS money) AS app_cost,
		  ROUND(((a.rating * p.rating)/2),1) AS avg_rating,
		  ROUND((((a.rating * p.rating)/2)/.5),1) AS lifespan
FROM app_store_apps AS a
FULL JOIN play_store_apps AS p
ON lower(trim(a.name)) = lower(trim(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
WHERE CAST(a.price AS money) = CAST(p.price AS Money)
ORDER BY avg_rating DESC, a.price

--Gets the same result

SELECT
		   a.name AS app_name
		  ,CAST((a.price*10000) AS money) AS app_cost
		  ,ROUND(((a.rating * p.rating)/2),1) AS avg_rating
		  ,ROUND((((a.rating * p.rating)/2)/.5+1),1) AS lifespan
		  ,CAST(ROUND(((((a.rating * p.rating)/2)/.5+1)*120000-12000),1) AS money) AS total_income
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(trim(a.name)) = lower(trim(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
WHERE CAST(a.price AS money) = CAST(p.price AS Money)
ORDER BY avg_rating DESC, a.price



WITH num AS (
SELECT
		   a.name AS app_name
		  ,CASE WHEN a.price = 0 THEN CAST(10000 AS money)
			ELSE CAST((a.price*10000) AS money) END AS app_cost
		  ,ROUND(((a.rating + p.rating)/2),1) AS avg_rating
		  ,ROUND((((a.rating + p.rating)/2)/.5+1),1) AS lifespan
		  ,CAST(ROUND(((((a.rating + p.rating)/2)/.5+1)*120000-12000),1) AS money) AS total_income
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(trim(a.name)) = lower(trim(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
WHERE CAST(a.price AS money) = CAST(p.price AS Money)
ORDER BY avg_rating DESC, a.price)

SELECT
	num.app_name
	,num.app_cost
	,num.avg_rating
	,num.lifespan
	,num.total_income
	,num.total_income-num.app_cost AS net_income
FROM num
GROUP BY num.app_name
	,num.app_cost
	,num.avg_rating
	,num.lifespan
	,num.total_income
ORDER BY net_income DESC


--Looking at genres 

SELECT 
	LOWER(TRIM(a.name)) AS app_name
	,a.primary_genre
	,p.genres
	,ROUND(((a.rating * p.rating)/2),1) AS avg_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name)) = lower(TRIM(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
GROUP BY 
		app_name
	,a.primary_genre
	,p.genres
	,avg_rating
ORDER BY avg_rating DESC

--Games seem to be the most highly rated genre = greatest longevity. ~161 different games with 30% being rated above 4.5

SELECT 
	LOWER(TRIM(a.name)) AS app_name
	,a.primary_genre
	,p.genres
	,ROUND(((a.rating + p.rating)/2),1) AS avg_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name)) = lower(TRIM(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
WHERE ROUND(((a.rating + p.rating)/2),1) > 4.5 AND a.primary_genre ='Games' OR p.genres = 'Arcade' 
GROUP BY 
	app_name
	,a.primary_genre
	,p.genres
	,avg_rating
ORDER BY avg_rating DESC

--Games rated 4+(app store) or Everyone (Play store) tend to have the highest rating as well. Mature 17+(Play store) games tend to be less frequently 

SELECT 
	a.review_count AS app_review
	,p.review_count AS play_review
	,a.content_rating AS app_content
	,p.content_rating AS play_content
	,ROUND(((a.rating + p.rating)/2),1) AS avg_rating
	,COUNT(a.content_rating) OVER (PARTITION BY a.content_rating) AS Countapp_content
	,COUNT(p.content_rating) OVER (PARTITION BY p.content_rating) AS Countplay_content
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name)) = lower(TRIM(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
WHERE ROUND(((a.rating + p.rating)/2),1) > 4.0 AND a.primary_genre ='Games' OR p.genres = 'Arcade' 
GROUP BY 
	a.review_count
	,p.review_count
	,a.content_rating
	,p.content_rating
	,avg_rating
ORDER BY avg_rating DESC

--Play Store tends to have a higher review count as well as more 