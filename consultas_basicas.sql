-- ══════════════════════════════════════════
-- TechStore — Consultas Básicas SELECT
-- Autor: Gisella Caballero
-- Fecha: 2026-11-25
-- ══════════════════════════════════════════

-- Consulta 1: Exploración general de la tabla sales
-- SELECT * tiene sentido para explorar rápido una tabla nueva (ver qué columnas
-- tiene, qué tipo de datos trae) en desarrollo o en una consulta ad hoc.
-- No tiene sentido en producción: trae columnas de más (rendimiento), se rompe
-- si alguien agrega/renombra una columna (mantenibilidad) y puede exponer datos
-- sensibles que no hacían falta (seguridad). Ver README para el detalle.
SELECT *
FROM sales;

-- Consulta 2: Selección de columnas específicas para finanzas
SELECT
    customer_id,
    product_id,
    total_amount
FROM sales;

-- Consulta 3: Selección con alias en español para stakeholders
SELECT
    order_date   AS fecha_pedido,
    product_name AS nombre_producto,
    quantity     AS cantidad_unidades
FROM sales;
