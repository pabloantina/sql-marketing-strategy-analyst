WITH top_restaurants as (
SELECT 
   c4 AS status,
   c5 AS restaurant_id,
   COUNT(c5) as qty_orders_r
FROM orders_sample
WHERE status = 'CONFIRMED'
GROUP BY 
   status,
   restaurant_id
ORDER BY qty_orders_r DESC
LIMIT 100),

/*Genere una primer query en la que obtengo las ordenes confirmadas y su cantidad de ordenes, 
de manera de poder ordenar de forma descendente para lúego limitar dicho resultado a 100 restaurantes*/

user_orders as (
SELECT
   c8 AS user_id,
   c5 AS restaurant_id,
   COUNT(c5) AS qty_orders_u
FROM orders_sample
WHERE c4 = 'CONFIRMED'
GROUP BY c8, c5
ORDER BY qty_orders_u DESC)

/*Aca obtengo las ordenes confirmadas y su cantidad desglozado por User ID*/

SELECT
    user_orders.user_id,
    top_restaurants.restaurant_id,
    SUM(user_orders.qty_orders_u) AS total_orders,
    SUM(CASE WHEN top_restaurants.restaurant_id IS NOT NULL THEN user_orders.qty_orders_u ELSE 0 END) AS qty_orders_in_top_100,
    ROUND((SUM(CASE WHEN top_restaurants.restaurant_id IS NOT NULL THEN user_orders.qty_orders_u ELSE 0 END) * 100.0) 
    / SUM(user_orders.qty_orders_u), 2) AS percentage_orders_in_top_100
FROM user_orders
LEFT JOIN top_restaurants ON user_orders.restaurant_id = top_restaurants.restaurant_id
GROUP BY user_orders.user_id
ORDER BY qty_orders_in_top_100 DESC

/*Por último procedo a joinear ambas consultas pbajo el parametro de de Restaurant ID para poder obtener el desgloce de user id, 
restaurants id, cantidad de ordenes de dicho usuario (seria el denominador) y la cantidadde ordenes de ese usuario cuando el restaurant
id no es nulo (númerador)*/    