SELECT 
   restaurant_sample.c2 as restaurant_type,
   orders_sample.c7 as amount_local_currency
FROM orders_sample

LEFT JOIN cities_sample
on orders_sample.c10 = cities_sample.c1

LEFT JOIN restaurant_sample
ON orders_sample.c5 = restaurant_sample.c1

/*Luego de haber realizado los joins necesarios, procedo a filtrar bajo las condiciones indicadas de pais, año/mes y cantidad minima vendida*/

WHERE cities_sample.c3 = 'Uruguay'
AND strftime('%Y%m', orders_sample.c3) = '201903'
AND restaurant_sample.c1 IS NOT NULL
AND orders_sample.c7 > 100

GROUP BY restaurant_type

ORDER BY restaurant_type ASC;
