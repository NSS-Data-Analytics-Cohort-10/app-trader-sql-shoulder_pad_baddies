-- ### App Trader

-- Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store. App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchase. 

-- Unfortunately, the data for Apple App Store apps and Android Play Store Apps is located in separate tables with no referential integrity.

-- #### 1. Loading the data
-- a. Launch PgAdmin and create a new database called app_trader.  

-- b. Right-click on the app_trader database and choose `Restore...`  

-- c. Use the default values under the `Restore Options` tab. 

-- d. In the `Filename` section, browse to the backup file `app_store_backup.backup` in the data folder of this repository.  

-- e. Click `Restore` to load the database.  

-- f. Verify that you have two tables:  
--     - `app_store_apps` with 7197 rows  
--     - `play_store_apps` with 10840 rows

-- #### 2. Assumptions

-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.
    
-- - For example, an app that costs $2.00 will be purchased for $20,000.
    
-- - The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 
    
-- - If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores. 

-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.
    
-- - An app that costs $200,000 will make the same per month as an app that costs $1.00. 

-- - An app that is on both app stores will make $10,000 per month. 

-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.
    
-- - An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.
    
-- - App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.

-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.


-- #### 3. Deliverables

-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy.

-- c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report. 


--Testing-Area--------------------------------------------------------------------------------------------------
SELECT
	a.name,
	a.price,
	a.rating,
	(a.rating + p.rating)/2 AS avg_rating,
	p.name,
	p.price,
	p.rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON LOWER(TRIM(a.name)) = LOWER(TRIM(p.name))
ORDER BY avg_rating DESC, a.price, p.price;



FLOOR(((a.rating + p.rating)/2)*2.0)/2.0 AS avg_rating

select * from app_store_apps order by rating desc, price

select * from play_store_apps order by rating, price


--Work-for-exercise---------------------------------------------------------------------------------------------

--Buiding out for CTE to join tables

WITH joined AS (
SELECT
	CASE
		WHEN a.name IS NOT NULL THEN a.name
		WHEN p.name IS NOT NULL THEN p.name
		END AS joined_name,
	CASE
		WHEN a.rating IS NOT NULL AND p.rating IS NOT NULL THEN ROUND((a.rating + p.rating)/2.0, 2)
		WHEN p.rating IS NULL THEN ROUND(a.rating, 2)
		WHEN a.rating IS NULL THEN ROUND(p.rating, 2)
		END AS joined_rating,
	CASE
		WHEN p.price IS NULL OR CAST(a.price AS money) > CAST(p.price AS money) THEN CAST(a.price AS money)
		WHEN a.price IS NULL OR CAST(a.price AS money) < CAST(p.price AS money) THEN CAST(p.price AS money)
		WHEN CAST(a.price AS money) = CAST(p.price AS money) THEN CAST(a.price AS money)
		END AS joined_price,
	CASE
		WHEN  a.name IS NOT NULL AND  p.name IS NOT NULL THEN 'Both'
		WHEN a.name IS NOT NULL AND  p.name IS NULL THEN 'Store, App'
		WHEN a.name IS NULL AND  p.name IS NOT NULL THEN 'Store, Play'
		END AS joined_location,
	CASE
		WHEN  a.primary_genre IS NOT NULL AND  p.genres IS NOT NULL THEN a.primary_genre
		WHEN a.primary_genre IS NOT NULL AND  p.genres IS NULL THEN a.primary_genre
		WHEN a.primary_genre IS NULL AND  p.genres IS NOT NULL THEN p.genres
		END AS joined_genres,
	CASE
		WHEN  a.content_rating IS NOT NULL AND  p.content_rating IS NOT NULL THEN p.content_rating
		WHEN a.content_rating IS NOT NULL AND  p.content_rating IS NULL THEN a.content_rating
		WHEN a.content_rating IS NULL AND  p.content_rating IS NOT NULL THEN p.content_rating
		END AS joined_content
FROM app_store_apps AS a
FULL OUTER JOIN play_store_apps AS p
USING(name)
WHERE a.rating IS NOT NULL OR p.rating IS NOT NULL
),

--Building out CTE to create multipliers

multipliers AS(
SELECT
	*,
	CAST((joined_rating/.5) + 1 AS integer) AS lifespan_multiplier,
	CASE
		WHEN joined_location = 'Both' THEN 2
		ELSE 1 END AS location_multiplier
FROM joined
),

--Building out CTE to create price and costs

cashflow AS(
SELECT
	joined_name AS name,
	joined_location AS location,
	joined_rating AS rating,
	CAST(5000 * lifespan_multiplier * location_multiplier * 12 AS money) AS gross_profit,
	CAST(1000 * lifespan_multiplier * 12 AS money) AS upkeep_cost,
	CASE
		WHEN joined_price <= CAST(1 AS money) THEN CAST(10000 AS money)
		ELSE CAST(joined_price * 10000 AS money)
		END AS purchase_cost
FROM multipliers
),

--Building out CTE to find add on genre and content rating

genre_content AS(
SELECT
	DISTINCT(c.*),
	j.joined_genres AS genre,
	CASE
		WHEN j.joined_content = '4+' THEN 'Everyone'
		WHEN j.joined_content = '9+' THEN 'Everyone 10+'
		WHEN j.joined_content = '12+' THEN 'Teen'
		WHEN j.joined_content = '17+' THEN 'Mature 17+'
		ELSE j.joined_content END AS content_rating
FROM cashflow AS c
LEFT JOIN joined AS j
ON c.name = j.joined_name
)

--Final Select Query

SELECT
	name,
	location,
	rating,
	genre,
	content_rating,
	gross_profit - (purchase_cost + upkeep_cost) AS net_profit
FROM genre_content
ORDER BY net_profit DESC, rating DESC, location
LIMIT 10