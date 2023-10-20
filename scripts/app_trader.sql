--WHAT I KNOW: 
--2 tables with no referential integrity
--(price of app)* 10,000= purchase cost for A.T. (even if in both stores)
--if it's in both stores purchase price is based on higher of the two prices

--all apps earn 5000/ month/ store they are on regardless of ap price 1yr=60,000

--1000/month is spent on marketing even if in both stores 1yr= 12,000

--Rating: 0=1 year and any half point added to 0 adds a year of longevity ex: (rating)/.5+1(yr)=longevity
--App store ratings dervived by taking AVG(app+play) and rounding to nearest .5

--A.T would like apps in both stores so that marketing stays at 1000 per month for both app stores (more for their money)

--WHAT I WANT TO KNOW: 
--What apps to target based on price range, genre, content rating, etc.?
---from assumptions, A.T. should target apps in both store to cut sspending costs in marketing, and purchase price
--should target apps with high ratings bc that means they have a longer longevity in the market and that A.T. has consistnet profit

--What is a the top 10 list of apps A.T. should buy?

--PLAN: case rank and over/partition can "add" columns to table: these can take care of purchase price, app earnings(from both), marketing cost, projected longevity, 
--cte/subqueries, and joins can take care of finding lowest price, highest rating, 

-------(side note from daniel) if you do anything with name trim them and then lowecase all-----

SELECT *
FROM play_store_apps
WHERE name ='Netflix'

SELECT *
FROM app_store_apps

---------------------------------------------------------------------------------------------------
--PLAYING AROUND WITH DATA TO MAKE SENSE OF IT, WILL START WORKING ON QUERYING FOR GUIDE SOON:
-- SELECT name, rating, CAST(price as money)
-- FROM play_store_apps
-- WHERE price IS NOT NULL AND rating IS NOT NULL	
-- 	OR rating >3
-- ORDER BY price;

-- SELECT name, rating, CAST(price as money)
-- FROM app_store_apps
-- WHERE price IS NOT NULL AND rating IS NOT NULL	
-- 	OR rating >3
-- ORDER BY price;

-- SELECT a.name, p.name, p.rating, a.rating, a.price, p.price
-- FROM app_store_apps AS a
-- INNER JOIN play_store_apps AS p
-- ON a.name=p.name
-- 	AND LOWER(a.primary_genre)=LOWER(p.category)
-- WHERE a.price IS NOT NULL AND a.rating IS NOT NULL
-- ORDER BY a.price;
--can maybe rank on ratings and order price acs 
--If using cast as money function, does that limit what i can do with price column as far as aggregations or comparisons?
--only app store has numeric type for price, play store has a text type, can I change that later?
--the above gets me lowest prices from individual tables
--maybe use cast to chnage data type

-- SELECT  p.name AS play_name, a.name AS ap_name , p.rating AS play_rating, a.rating AS ap_rating, CAST(p.price as money) AS play_money, CAST(a.price as money) AS ap_money
-- FROM play_store_apps AS p
-- INNER JOIN app_store_apps AS a
-- USING (name)
-- WHERE  p.price IS NOT NULL;
---second way of doing the above with simple nested query (minus the price part will figure that out later)


SELECT *
FROM play_store_apps
WHERE name IN (
			SELECT name 
			FROM app_store_apps);

----in the above the goal was to find only apps with the same name in both tables, this resulted in duplicates, why? after looking for specific  examples, play_store_apps have duplicate entries, some are exact entries and others vary in review count only
--should i include distinct names?


-- SELECT name,(a.rating * p.rating)/2 AS avg_rating
-- FROM play_store_apps as p
-- LEFT JOIN app_store_apps as a
-- USING (name)
-- WHERE p.rating IS NOT NULL
-- 	AND a.rating IS NOT NULL
-- ORDER BY avg_rating DESC;
---the above was born from team mate jeffrey emmons, this piece can be used to find avg_rating for when we have apps in both stores

-- SELECT name, (a.rating + p.rating)/2 AS avg_rating_no_r,ROUND(ROUND((a.rating + p.rating),0)/2,1) AS avg_rating
-- FROM play_store_apps as p
-- INNER JOIN app_store_apps as a
-- USING (name)
-- WHERE p.rating IS NOT NULL
-- 		AND a.rating IS NOT NULL
-- ORDER BY avg_rating DESC
--the above gets the avg of both ratings in the app store, but need to find a way to round it to nearest half point


-- SELECT name, ROUND(ROUND((a.rating + p.rating),0)/2,1) AS avg_rating
-- FROM play_store_apps as p
-- INNER JOIN app_store_apps as a
-- USING (name)
-- WHERE p.rating IS NOT NULL
-- 		AND a.rating IS NOT NULL
-- ORDER BY avg_rating DESC
--the above has the rating rounded to the nearest .5 (some of the rounding is questionable, will ask team to double check) UPDATE: asked team, and I like their way of thinking about it, will tak eout the round, and use 
--now below, I need to add on by finding the longevity, and then afterwards earnings based on longevity
-- WITH a_r_rounded AS
-- 			(SELECT name, ROUND(ROUND((a.rating + p.rating),0)/2,1) AS avg_rating
-- 			FROM play_store_apps as p
-- 			INNER JOIN app_store_apps as a
-- 			USING (name)
-- 			WHERE p.rating IS NOT NULL
-- 				AND a.rating IS NOT NULL
-- 				ORDER BY avg_rating DESC)
-- SELECT a.name, a_r_rounded.avg_rating, ROUND((a_r_rounded.avg_rating/.5),0)+1 AS longevity_years
-- FROM app_store_apps AS a
-- JOIN a_r_rounded
-- ON a.name=a_r_rounded.name
--the above found longevity
--UPDATE: after speaking with teammates, I can put rating, longevity, earnings all in one without having to use cte

SELECT name, ROUND((a.rating + p.rating)/2,2) AS avg_rating, ROUND((a.rating + p.rating)/2/.5+1,1) AS 									longevity_years, ROUND(((((a.rating + p.rating)/2)/.5+1)*12000),2) AS gross_earnings, ROUND((((((a.rating + p.rating)/2)/.5+1)*12000)-12000), 2) AS net_earings
FROM play_store_apps as p
INNER JOIN app_store_apps as a
USING (name)
WHERE p.rating IS NOT NULL
AND a.rating IS NOT NULL
ORDER BY avg_rating DESC
--the above gave me avg-rating, longevity, and eargings before and after marketing cost


-- SELECT p.name,				
-- (CASE WHEN a.price > CAST(p.price as numeric) THEN a.price
-- 	WHEN  a.price < CAST(p.price as numeric)  THEN CAST(p.price as numeric)
-- 	WHEN  a.price = CAST(p.price as numeric) THEN CAST(p.price as numeric)
-- 	 END) AS purchase_price
-- FROM play_store_apps as p
-- INNER JOIN app_store_apps as a
-- USING (name);
--the above gives me ERROR:  invalid input syntax for type numeric: "$3.99 " 
-- SELECT name,
-- REPLACE(price, '$', '')::numeric AS play_price_numeric
-- FROM play_store_apps
--the above gets rid of the dollar sign from playstore apps and 


WITH psa_num AS (	
					SELECT name,
					REPLACE(price, '$', '')::numeric AS play_price_numeric
					FROM play_store_apps)

SELECT a.name,				
	(CASE 
	 WHEN a.price = 0 THEN 1.00*10000
	 WHEN psa_num.play_price_numeric = 0 THEN 1.00* 10000
	WHEN a.price > psa_num.play_price_numeric THEN a.price * 10000
	WHEN a.price< psa_num.play_price_numeric THEN psa_num.play_price_numeric * 10000
	 WHEN a.price = psa_num.play_price_numeric THEN a.price * 10000
	END) AS purchase_price
	
FROM app_store_apps as a
INNER JOIN psa_num
ON a.name=psa_num.name;

--above is how to get purchase price, later will need to add this to something that filters rating to get longevity (USE THE ABOVE )
 