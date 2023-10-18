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
--------------------------------------------------------------------------------------------------------------------------------------


----------WHAT I KNOW: (price of app)* 10,000= purchase cost
----------if it's in both stores the prce stays the same for both and if it is on both stores purchase price is based on higher of the two prices
-----------all apps earn 5000/ month/ store they are on regardless of cost
---------1000/month is spent on marketing even if in both stores flat fee
---------0=1 year and any half point added to 0 adds a year of longevity ex: 0+6(.5)=3 year
---------A.T would like apps in both stores so that marketing stays at 1000 per month for both app stores (more for their money)

----------WHAT I WANT TO KNOW: 
------------how to see if apps are reflected in both stores 
-------------what is the genreal price range, genre, content rating, etc of targeted apps
-------------what are the to 10 apps A.T. shoul buy 

-------(side note from daniel) if you do anything with name trim them and then lowecase all-----





SELECT *
FROM play_store_apps

SELECT *
FROM app_store_apps
------------------------------------------------------------------------------------------------------------
---CURRENTLY PLAYING AROUND WITH DATA TO MAKE SENSE OF IT, WILL START WORKING ON QUERYING FOR GUIDE SOON
SELECT name, rating, CAST(price as money)
FROM play_store_apps
WHERE price IS NOT NULL
ORDER BY price;

SELECT name, rating, CAST(price as money)
FROM app_store_apps
WHERE price IS NOT NULL
ORDER BY price;

--the above gets me lowest prices from individual tables

SELECT  p.name AS play_name, a.name AS ap_name , p.rating AS play_rating, a.rating AS ap_rating, CAST(p.price as money) AS play_money, CAST(a.price as money) AS ap_money
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name)
WHERE  p.price IS NOT NULL
ORDER BY play_money;

----in the above the goal was to find only apps with the same name in both tables, this resulted in duplicates, why?
---moving forward, could probably stay with inner join and work up to filtering out dulpicates if they are that, and filtering for the rating on both, which the code below can be tweeked to do so



SELECT name, (a.rating * p.rating)/2 AS avg_rating
FROM play_store_apps as p
LEFT JOIN app_store_apps as a
USING (name)
WHERE p.rating IS NOT NULL
	AND a.rating IS NOT NULL
ORDER BY avg_rating DESC;
---the above was born from team mate jeffrey emmons, this piece can be used to find avg_rating for when we have apps in both stores





