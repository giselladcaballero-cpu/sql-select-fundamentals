# sql-select-fundamentals

Consultas básicas SELECT y alias sobre la tabla `sales` de TechStore, resueltas para el equipo de finanzas.

## Contenido

`consultas_basicas.sql` tiene tres consultas:

1. **Exploración general** — `SELECT *` sobre `sales`, para ver la estructura completa de la tabla.
2. **Selección específica** — solo `customer_id`, `product_id` y `total_amount`, que es lo que finanzas necesita.
3. **Alias en español** — `order_date`, `product_name` y `quantity` renombradas como `fecha_pedido`, `nombre_producto` y `cantidad_unidades` con `AS`.

## Resultado esperado

Resultado de cada consulta sobre los 10 registros de `sales` del enunciado (se muestran las primeras 3 filas de cada una a modo de ejemplo):

**Consulta 1 — `SELECT *`**

| order_id | order_date | customer_id | product_id | product_name | category | quantity | unit_price | total_amount |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1001 | 2024-01-05 | 201 | 301 | Laptop Pro 15 | Computación | 2 | 1200.00 | 2400.00 |
| 1002 | 2024-01-08 | 202 | 302 | Mouse Inalámbrico | Accesorios | 5 | 28.00 | 140.00 |
| 1003 | 2024-01-12 | 203 | 303 | Monitor 4K 27" | Computación | 1 | 450.00 | 450.00 |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

**Consulta 2 — columnas para finanzas**

| customer_id | product_id | total_amount |
| --- | --- | --- |
| 201 | 301 | 2400.00 |
| 202 | 302 | 140.00 |
| 203 | 303 | 450.00 |
| ... | ... | ... |

**Consulta 3 — con alias en español**

| fecha_pedido | nombre_producto | cantidad_unidades |
| --- | --- | --- |
| 2024-01-05 | Laptop Pro 15 | 2 |
| 2024-01-08 | Mouse Inalámbrico | 5 |
| 2024-01-12 | Monitor 4K 27" | 1 |
| ... | ... | ... |

Así se ve de inmediato por qué la Consulta 3 es la que finanzas realmente puede leer: ya no hace falta saber qué es `order_date` o `product_name`, los nombres de columna ya están en su propio idioma.

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
