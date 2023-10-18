-- Filtering apps based on price, rating, category, and whether they are both in play and app store
SELECT name, a. price, a. rating, category, p.price , p.rating, genres
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
GROUP BY name, a.price, a.rating, category, p.price, p.rating, genres
ORDER BY a.rating*p.rating/2 DESC;

--- Top category for the apps
SELECT name, category, p. rating, a.rating
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name)
ORDER BY category DESC;

