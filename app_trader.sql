SELECT a1.name, p1.name, (a1.rating*p1.rating)/2 AS avg_rating, p1.price
FROM app_store_apps AS a1
INNER JOIN play_store_apps AS p1
USING (name)
ORDER BY avg_rating DESC, p1.price ASC

SELECT a1.name, (AVG(a1.rating)*AVG(p1.rating)/2) AS avg_rating
FROM app_store_apps AS a1
INNER JOIN play_store_apps AS p1
USING (name)
GROUP BY a1.name
ORDER BY avg_rating DESC
