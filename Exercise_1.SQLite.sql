SELECT
   cities_sample.c3 as country_name,
   orders_sample.c9 AS city_name,   
   strftime('%Y%m', orders_sample.c3) AS yearmonth_by_order_date,
   COUNT(cities_sample.c3) as orders_qty,
   SUM(orders_sample.c7) as amount_local_currency,
   ROUND( SUM(orders_sample.c7) / (CASE WHEN strftime('%Y%m', currency.c1) =
   strftime('%Y%m', orders_sample.c3) THEN currency.c3 ELSE 0 END), 2) AS amount_usd_currency
   
/*Redondie
dos decimales dado que el cociente entre la suma de la venta en moneda local vs la conversión a la moneda usd me arroja muchos decimales*/
   
FROM orders_sample

/*A partir de aca desarrollo los JOINS para poder traer campos de varias tablas bajo una columna en común, 
dado que las 5 tablas se conectan entre si mediante distintas columnas*/

LEFT JOIN cities_sample
on orders_sample.c10 = cities_sample.c1

LEFT JOIN country_currency_map
ON cities_sample.C2 = country_currency_map.c1

LEFT JOIN currency
ON currency.c2 = country_currency_map.c2

WHERE yearmonth_by_order_date IS NOT NULL
AND strftime('%Y%m', currency.c1) = strftime('%Y%m', orders_sample.c3)

GROUP BY
   country_name,
   city_name,
   yearmonth_by_order_date
   
ORDER BY 
   orders_qty DESC;