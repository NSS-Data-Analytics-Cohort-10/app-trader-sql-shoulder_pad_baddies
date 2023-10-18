-- Filtering apps based on price, rating, category, and whether they are both in play and app store
SELECT name, a. price, a. rating, category, p.price , p.rating, genres
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
GROUP BY name, a.price, a.rating, category, p.price, p.rating, genres
ORDER BY a.rating*p.rating/2 DESC;

--- Top category for the apps
SELECT name, category, p. rating as play_rating, a.rating as app_rating
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name)
ORDER BY category DESC;

-- Working on deliverables a (reccomendataions)
-- What the app trader is looking for:
-- free to $1.00 is 10,000
-- it is an exta 10k by the dollar



SELECT DISTINCT








