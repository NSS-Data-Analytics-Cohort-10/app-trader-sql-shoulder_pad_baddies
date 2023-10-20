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

-- Simple Notes Read ME
-- What the app trader is looking for:
-- free to $1.00 is 10,000 for purchase
-- it is an exta 10k by the dollar
-- purchase price of app if in both stores is based on the highest price
-- Apps earn 5,000 per store
-- Marketing = 1,000 per month
-- Life span of app increases a year by each half point rating
-- Ratings from both stores average to the nearest 0.5
-- App Trader- wants to work with apps located in both stores

-- Deliverables
--general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.
-- Develop a Top 10 List of the apps that App Trader should buy.


-- Work on large query in chunks

-- Query with name , genre, category price of app in both stores and avg rating of both apps
SELECT name,
     REPLACE(price, '$', '')::numeric AS play_price_numeric
     FROM play_store_apps

SELECT name, genres, category, a.price as android_app_price, MAX(CAST(REPLACE(p.price, '$', '')AS NUMERIC)) as play_app_price, ROUND(AVG(a.rating+p.rating/2.0),2) as avg_rating
FROM app_store_apps as a
JOIN play_store_apps as p
USING (name)
GROUP BY name, genres,category, a.price, p.price			
ORDER by ROUND(AVG(a.rating+p.rating/2.0),2) DESC;

-- Query to start using CASE WHEN to narrow for App Trader look-fors
SELECT name, genres, category, GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC)) AS price, ROUND(AVG(a.rating+p.rating/2.0),2) as avg_rating,
CASE WHEN (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 0 AND 1.00 THEN '10,000'
ELSE 'above'
END AS purchase_price
FROM app_store_apps as a
JOIN play_store_apps as p
USING (name)
GROUP BY name, genres,category, a.price, p.price			
ORDER by ROUND(AVG(a.rating+p.rating/2.0),2) DESC;



