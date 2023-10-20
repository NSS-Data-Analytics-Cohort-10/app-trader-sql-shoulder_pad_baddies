SELECT a1.name, p1.name, (a1.rating+p1.rating)/2 AS avg_rating, p1.price
FROM app_store_apps AS a1
INNER JOIN play_store_apps AS p1
USING (name)
ORDER BY avg_rating DESC, p1.price ASC

SELECT a.name, (AVG(a.rating)+AVG(p.rating)/2) AS avg_rating
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

SELECT a.name, p.name, 
CASE WHEN a.name is NOT NULL and p.name IS NULL THEN 'app'
WHEN p.name is NOT NULL AND a.name IS NULL THEN 'play'
WHEN a.name IS NOT NULL AND p.name IS NOT NULL THEN 'both'
END AS store
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING (name)





