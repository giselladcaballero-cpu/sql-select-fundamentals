# sql-select-fundamentals

Consultas básicas SELECT y alias sobre la tabla `sales` de TechStore, resueltas para el equipo de finanzas.

## Contenido

`consultas_basicas.sql` tiene tres consultas:

1. **Exploración general** — `SELECT *` sobre `sales`, para ver la estructura completa de la tabla.
2. **Selección específica** — solo `customer_id`, `product_id` y `total_amount`, que es lo que finanzas necesita.
3. **Alias en español** — `order_date`, `product_name` y `quantity` renombradas como `fecha_pedido`, `nombre_producto` y `cantidad_unidades` con `AS`.

## ¿Por qué es mala práctica usar `SELECT *` en producción?

1. **Rendimiento.** `SELECT *` trae todas las columnas, incluso las que la consulta no necesita. En una tabla con columnas pesadas (texto largo, JSON, campos calculados) eso significa más datos viajando por la red y más memoria usada del lado del cliente, aunque solo se vaya a usar un tercio de las columnas. En `sales`, si un reporte de finanzas solo necesita `customer_id`, `product_id` y `total_amount`, traer también `product_name`, `category` y el resto es trabajo de más para el motor y para la red, sin ningún beneficio.
2. **Mantenibilidad.** Si alguien agrega una columna nueva a `sales` (por ejemplo `discount_applied`), todas las consultas con `SELECT *` empiezan a devolverla sin que nadie lo haya pedido, lo que puede romper un reporte o una integración que esperaba un número fijo de columnas en un orden determinado. Al revés, si se elimina o renombra una columna que una consulta explícita necesitaba, el error aparece inmediatamente y se sabe qué arreglar; con `SELECT *` el problema puede pasar desapercibido hasta mucho después.
3. **Seguridad.** `SELECT *` expone cualquier columna sensible que exista o que se agregue a futuro (por ejemplo, un email de cliente o un costo interno) a cualquiera que tenga acceso al reporte, aunque esa columna no tuviera nada que ver con lo que se pidió. Pedir explícitamente las columnas necesarias limita qué datos pueden terminar filtrados en un reporte, un log o una exportación.

`SELECT *` sí tiene sentido para explorar una tabla nueva en desarrollo, o para una consulta rápida y descartable en la terminal — no para algo que va a correr en un reporte, una vista o una aplicación.

## ¿Por qué son importantes los alias para un stakeholder no técnico?

El equipo de finanzas no sabe qué es `total_amount`, pero sí entiende "Monto Total". Un alias traduce el nombre técnico de la columna (pensado para que lo lea el motor de base de datos y el equipo de desarrollo) a un nombre pensado para que lo lea una persona del negocio, sin que esa persona tenga que preguntar qué significa cada columna.

**Ejemplo concreto:** la consulta

```sql
SELECT total_amount FROM sales;
```

le devuelve a finanzas una columna llamada `total_amount`, que exige saber inglés y conocer la convención de nombres interna de la base de datos. En cambio:

```sql
SELECT total_amount AS monto_total FROM sales;
```

le devuelve una columna llamada `monto_total`, que cualquier persona del área puede interpretar al toque, sin pasar por el equipo de datos para que le expliquen el nombre de la columna. En este proyecto, lo mismo pasa con `order_date AS fecha_pedido`, `product_name AS nombre_producto` y `quantity AS cantidad_unidades`: cada alias saca de en medio una traducción mental que, multiplicada por decenas de columnas y reportes, termina generando confusión y errores de interpretación.
