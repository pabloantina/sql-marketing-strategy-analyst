SELECT 
   cities_sample.c3 AS country_name,
   ROUND((JULIANDAY(orders_sample.c2)-JULIANDAY(orders_sample.c3))*60*24, 2) AS avg_delivery_time
FROM orders_sample 

LEFT JOIN cities_sample
on orders_sample.c10 = cities_sample.c1

WHERE strftime('%Y%m', orders_sample.c3) = '201903'
AND avg_delivery_time > 0
GROUP BY country_name
/*Aca utilice como condición que avg_delivery_time sea mayor a 0 dado que al observar la raw data 
encuentro que los timestamp de order y delivery date coinciden, lo cúal imagino que es un error 
de la base de datos dado que deberia haber diferencia de tiempo entre pedido y entrega, por lo 
que para no sesgar mi promedio por pais procedi a desestimar dicha información solo en este script.*/