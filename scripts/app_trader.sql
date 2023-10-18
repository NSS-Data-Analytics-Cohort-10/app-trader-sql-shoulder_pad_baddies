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


SELECT 
	LOWER(TRIM(a.name)) AS app_name
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON lower(TRIM(a.name))= lower(TRIM(p.name))
GROUP BY app_name
		  
SELECT
	(CASE WHEN p.name IS NULL THEN a.name
		  WHEN a.name IS NULL THEN p.name
	      WHEN p.name IS NOT NULL AND a.name IS NOT NULL THEN a.name ELSE 'Booger' END) AS app_name,
		  CAST(a.price AS money),
		  ROUND(((a.rating * p.rating)/2),1) AS avg_rating
FROM app_store_apps AS a
FULL JOIN play_store_apps AS p
ON lower(trim(a.name)) = lower(trim(p.name)) AND CAST(a.price AS money) = CAST(p.price AS money)
WHERE CAST(a.price AS money) = CAST(p.price AS Money)
GROUP BY app_name, a.price, avg_rating
ORDER BY avg_rating DESC, a.price
		  