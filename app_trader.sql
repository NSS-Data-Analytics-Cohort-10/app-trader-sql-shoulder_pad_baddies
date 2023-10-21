SELECT a1.name, p1.name, (a1.rating+p1.rating),1/2 AS avg_rating, p1.price
FROM app_store_apps AS a1
INNER JOIN play_store_apps AS p1
USING (name)
ORDER BY avg_rating DESC, p1.price ASC

SELECT a.name, ((AVG(a.rating))+(AVG(p.rating))/2,1) AS avg_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
GROUP BY a.name
ORDER BY avg_rating DESC

SELECT a.name, p.name, a.rating, p.rating
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)
WHERE a.rating = 5 OR p.rating=5
ORDER by a.rating DESC

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

SELECT a.name, p.name,
ROUND(a.rating+p.rating),0/2 AS rating_both
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)
GROUP BY a.name, p.name
ORDER BY rating_both DESC

--tells the app cost
SELECT a.name, p.name, 
CASE WHEN a.price IS NULL or cast(a.price AS money) < cast(p.price AS money) THEN cast(p.price AS money)
WHEN p.price IS NULL or cast (a.price AS money) > cast(p.price AS MONEY) THEN CAST (a.price AS money)
END AS price_listed
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)
ORDER BY price_listed ASC

WITH pr as
		   (SELECT a.name, p.name, 
CASE WHEN a.price IS NULL or cast(a.price AS money) < cast(p.price AS money) THEN cast(p.price AS money)
WHEN p.price IS NULL or cast (a.price AS money) > cast(p.price AS MONEY) THEN CAST (a.price AS money)
END AS price_listed
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
			USING (name))
			SELECT a.name, p.name, ((price_listed*10000)-1000)
			FROM app_store_apps AS a
			FULL JOIN pr
			USING (name)
			ORDER BY price_listed ASC;

--both names together
SELECT 
CASE WHEN a.name IS NULL then p.name
WHEN p.name is NULL then a.name
WHEN p.name Is NOT NULL then p.name
WHEN a.name is NOT NULL then a.name
END AS app_name
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)

--avg rating
SELECT a.name, p.name,
ROUND((((a.rating+p.rating)/2)/.5+1), 1) AS longevity, CAST(ROUND(((((a.rating+p.rating)/2)/.5+1)*120000-1200),1) AS MONEY) AS income,
CASE WHEN a.name is NOT NULL and p.name IS NULL THEN 'app'
WHEN p.name is NOT NULL AND a.name IS NULL THEN 'play'
WHEN a.name IS NOT NULL AND p.name IS NOT NULL THEN 'both'
END AS store,
CASE WHEN a.price IS NULL or cast(a.price AS money) < cast(p.price AS money) THEN cast(p.price AS money)
WHEN p.price IS NULL or cast (a.price AS money) > cast(p.price AS MONEY) THEN CAST (a.price AS money)
END AS price_listed
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)
GROUP BY a.name, p.name, a.price, p.price, longevity, income, store
ORDER BY income ASC

--Tells the store
SELECT a.name, p.name, 
CASE WHEN a.name is NOT NULL and p.name IS NULL THEN 'app'
WHEN p.name is NOT NULL AND a.name IS NULL THEN 'play'
WHEN a.name IS NOT NULL AND p.name IS NOT NULL THEN 'both'
END AS store,
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)
GROUP BY a.name, p.name
