SELECT a.name, p.name, a.rating, a.price, p.price, p.rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
