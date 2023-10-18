SELECT name, a. price, a. rating, category, p.price , p.rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
GROUP BY name, a.price, a.rating, category, p.price, p.rating
ORDER BY a.rating*p.rating/2 DESC;
