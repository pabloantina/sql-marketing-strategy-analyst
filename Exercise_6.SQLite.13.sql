WITH january_orders AS (
SELECT 
   strftime('%Y-%m', orders_sample.c3) AS month,
   c8 AS user_id,
   COUNT(c8) AS qty_orders
FROM orders_sample
  
WHERE strftime('%Y-%m', orders_sample.c3) = '2019-01'
AND c4 = 'CONFIRMED'
  
GROUP BY 
   month,
   user_id
ORDER BY 
   qty_orders DESC),
   
/*Genero una primer sub consulta para obtener las ordenes confirmadas en enero de 2019*/
   
subsequent_orders AS (
SELECT 
   strftime('%Y-%m', orders_sample.c3) AS month,
   c8 AS user_id,
   COUNT(c8) AS qty_orders
FROM orders_sample
  
WHERE strftime('%Y-%m', orders_sample.c3) > '2019-01'
AND c4 = 'CONFIRMED'
  
GROUP BY 
   month,
   user_id
ORDER BY 
   qty_orders DESC)
   
/*Esta segunda sub consulta tiene como fin obtener los resultados de ordenes confirmadas posteriores a enero de 2019*/   
   
SELECT 
  '2019-01' AS month_2019_01, 
  subsequent_orders.month AS subsequent_month,
  COUNT(DISTINCT subsequent_orders.user_id) AS users_in_subsequent_months
FROM january_orders
JOIN subsequent_orders ON january_orders.user_id = subsequent_orders.user_id
GROUP BY subsequent_orders.month
ORDER BY subsequent_orders.month;

/*Por último uno ambas tablas bajo el criterio de user_id, creo una columna generica para 2019-01, llamo a la columna de month proveniente 
de la tabla referida a los datos posteriores a enero de 2019 y cuento los usuarios unicos que se encuentran en la tabla de los usuarios 
con fecha posterior a enero 2019.*/ 
 

