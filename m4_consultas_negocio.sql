-- ============================================================================
-- PROYECTO INTEGRADOR: Ventas_Tech_DB (RetailPro)
-- MÓDULO 4: Consultas SQL de Negocio
-- Archivo: m4_consultas_negocio.sql
-- ============================================================================

USE Ventas_Tech_DB;

-- ----------------------------------------------------------------------------
-- CONSULTA 1: Resumen ejecutivo mensual
-- Objetivo: Obtener total facturado, cantidad de pedidos y ticket promedio por mes.
-- ----------------------------------------------------------------------------
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes ASC;


-- ----------------------------------------------------------------------------
-- CONSULTA 2: Ranking de productos (Top 5)
-- Objetivo: Identificar los 5 productos con mayor volumen de facturación.
-- ----------------------------------------------------------------------------
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- ----------------------------------------------------------------------------
-- CONSULTA 3: Clientes recurrentes
-- Objetivo: Identificar clientes con más de una transacción y su gasto total.
-- ----------------------------------------------------------------------------
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1
ORDER BY total_gastado DESC;


-- ----------------------------------------------------------------------------
-- CONSULTA 4: Meses por encima / por debajo del promedio mensual
-- Objetivo: Etiquetar el desempeño financiero de cada mes respecto al promedio global.
-- ----------------------------------------------------------------------------
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) >= (
            SELECT AVG(total_mensual)
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS total_mensual
                FROM ventas
                GROUP BY EXTRACT(MONTH FROM fecha_venta)
            ) AS subconsulta_promedio
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS desempeño_vs_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes ASC;


-- ============================================================================
-- BLOQUE DE CIERRE: HALLAZGOS Y METRICAS DE NEGOCIO
-- ============================================================================
-- 1. Concentración de Ingresos por Producto:
--    El producto id_producto = 1 (Laptop Pro 15) es el principal motor de ingresos
--    de la empresa, acumulando $3,600.00 sobre un total general de $6,444.00,
--    lo que representa un 55.86% de la facturación total con solo 3 unidades vendidas.
--
-- 2. Retención y Recurrencia de Clientes:
--    El 100% de los clientes registrados (5 de 5) han realizado exactamente 2 compras 
--    en el período analizado. Destaca el cliente id_cliente = 1 (María López) como 
--    el de mayor Valor de Vida (LTV) acumulado, representando $2,640.00 (40.96% del total).
--
-- 3. Rendimiento en Productos Complementarios / Periféricos:
--    A pesar de que el producto id_producto = 2 (Mouse Inalámbrico) lidera ampliamente
--    en volumen de unidades físicas vendidas (13 unidades), solo genera $364.00 en total 
--    (5.64% del revenue), reflejando una alta rotación pero un bajo ticket promedio por unidad.
-- ============================================================================