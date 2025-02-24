SELECT 
   user_id,
   COUNT(user_id) AS total_orders,
   ROUND(AVG(JULIANDAY(order_date)-JULIANDAY(prev_order_date)), 2) AS avg_days_between_orders

FROM (
  SELECT
     strftime('%Y-%m-%d', orders_sample.c3) AS order_date,
     c8 AS user_id,
     LAG(strftime('%Y-%m-%d', orders_sample.c3)) OVER 
     (PARTITION BY c8 ORDER BY strftime('%Y-%m-%d', orders_sample.c3)) AS prev_order_date
FROM orders_sample) sub_query

/*Primero genero una subquery donde obengo la fecha de la orden y la fecha previa a dicha orden, para lúego a partir de 
dicha fuente poder hacer la diferencia entre estos dos campos partiendo de la función JULIANDAY que me permitió obtener la fecha en formato numerico*/

WHERE prev_order_date IS NOT NULL

GROUP BY user_id

HAVING total_orders > 5
AND avg_days_between_orders > 5

/*Procedo a filtrar bajo el criterio de cantidad de ordenes y promedio de dias entre las ordenes*/

ORDER BY total_orders DESC;
