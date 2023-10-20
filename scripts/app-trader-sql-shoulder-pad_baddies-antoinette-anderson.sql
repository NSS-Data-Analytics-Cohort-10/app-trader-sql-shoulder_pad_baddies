
SELECT name, genres, GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC)) AS price, ROUND(AVG(a.rating+p.rating/1000.0),2) as app_rating,

CASE WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 0 AND 1.00 THEN '10,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 1.01 AND 2.00 THEN '20,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 2.01 AND 3.00 THEN '30,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 3.01 AND 4.00 THEN '40,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 4.01 AND 5.00 THEN '50,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 5.01 AND 6.00 THEN '60,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 1.01 AND 2.00 THEN '20,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 6.01 AND 7.00 THEN '70,000'
	 WHEN  (GREATEST(a.price , CAST(REPLACE(p.price, '$', '')AS NUMERIC))) BETWEEN 7.01 AND 8.00 THEN '80,000'
ELSE 'above'
END AS purchase_price,

CASE WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)= 0 THEN '1 year'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=.5 THEN '2 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=1.0 THEN '3 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=1.5 THEN '4 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)= 2.0 THEN '5 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=2.5 THEN '6 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=3.0 THEN '7 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=3.5 THEN '8 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=4.0 THEN '9 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=4.5 THEN '10 years'
	 WHEN ROUND(AVG(a.rating+p.rating/1000.0),2)=5.0 THEN '11 years'
ELSE 'over'
END AS app_lifespan

FROM app_store_apps as a
JOIN play_store_apps as p
USING (name)
GROUP BY name, genres, a.price, p.price			
ORDER by ROUND(AVG(a.rating+p.rating/1000.0),2) DESC
LIMIT 10;



