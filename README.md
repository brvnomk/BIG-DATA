# Cerámicas Vale – Solución BI (Base de datos + ETL + Dashboard)

Proyecto final del curso **Base de Datos Avanzadas y Big Data** (UPN 2026-2).
La solución **no depende de ninguna otra base de datos**: los scripts crean todo desde cero.

## Contenido de la carpeta

| Carpeta / archivo | Qué es | ¿Necesario para la demo? |
|---|---|---|
| `sql/01_base_transaccional.sql` | Crea la base transaccional `CERAMICAS_VALE`: tablas, catálogo real (2,045 productos), proveedores, clientes y 100,000 ventas | ✅ |
| `sql/02_crear_entorno_etl.sql` | Crea el Data Mart `CeramicasVale_DM` (modelo estrella, staging, bitácora y errores) | ✅ |
| `sql/03_ETL_CARGA.sql` | Proceso ETL paso a paso + validación de calidad y KPIs | ✅ |
| `txt/ceramicas_vale/` | Archivos planos del sistema de caja que lee el ETL (`metodopago.txt`, `operacionVenta.txt`) | ✅ |
| `powerbi/CeramicasVale.pbix` | Dashboard (un solo archivo) | ✅ |
| `powerbi/respaldodd/` | Respaldo del dashboard en formato proyecto (`.pbip`) | Respaldo |
| `datos/Reporte_Items_2026-10-19 23_21_47.xlsx` | Catálogo **original** exportado del sistema de la empresa (corte 19/10/2026) | Evidencia |
| `datos/catalogo_productos_2026-10-19.csv` | El mismo catálogo **convertido a CSV** (base de la Parte 2 del script 01) | Evidencia |

## Cómo ejecutarlo

1. Copiar la carpeta `txt\ceramicas_vale` dentro de `C:\txt\`, de modo que queden:
   ```
   C:\txt\ceramicas_vale\metodopago.txt
   C:\txt\ceramicas_vale\operacionVenta.txt
   ```
2. Abrir en **SSMS** y ejecutar con **F5**, en orden:
   1. `sql/01_base_transaccional.sql` (≈ 5 s)
   2. `sql/02_crear_entorno_etl.sql`
   3. `sql/03_ETL_CARGA.sql` (≈ 5 s) → al final muestra el resumen: tiempo por paso,
      registros descartados y **Reconciliación OK**.
3. Abrir `powerbi/CeramicasVale.pbix` → **Inicio → Actualizar**.
   - La primera vez: *SQL Server* → **Windows → Usar mis credenciales actuales** (y *Aceptar* si avisa de cifrado).
   - Si el servidor no es `localhost` (p. ej. `.\SQLEXPRESS`): *Transformar datos → Editar parámetros → Servidor*.

El script `03_ETL_CARGA.sql` se puede ejecutar las veces que se quiera: siempre limpia y recarga el Data Mart.

## Fuentes de datos

| Fuente | Tipo | Origen |
|---|---|---|
| `PRODUCTOS` | Tabla OLTP | **Catálogo real** de la empresa: Excel del 19/10/2026 → CSV → `INSERT` (2,045 productos, 76 nuevos respecto al de septiembre, 3 deshabilitados) |
| `PROVEEDORES`, `CLIENTES` | Tablas OLTP | Sintéticos (sin datos personales reales) |
| `VENTAS`, `DETALLE_VENTAS` | Tablas OLTP | 100,000 ventas sintéticas y reproducibles (`sp_generar_ventas`, semilla 2026) |
| `metodopago.txt` | Archivo plano | Catálogo de métodos de pago del sistema de caja |
| `operacionVenta.txt` | Archivo plano | Exportación de caja: `comprobante\|metodoPago` |

## Modelo estrella (presentado en la semana 6)

| Tabla | Contenido |
|---|---|
| `fac_ventas` | cantidad (cajas/unidades), monto_vendido, metraje_vendido (m²), costo_inventario, descuento |
| `dim_producto` | descripción, categoría, marca, unidad, m² por caja, stock y estado de stock |
| `dim_cliente` | documento, nombre, distrito, tipo de cliente (REGULAR / VIP) |
| `dim_tiempo` | fecha, año, trimestre, mes, semana, día |
| `dim_metodoPago` | Efectivo, Yape/Plin, Tarjeta, Transferencia, Depósito, No registrado |
| `dim_proveedor` | RUC, razón social, ciudad |

## Proceso ETL (`03_ETL_CARGA.sql`)

| Paso | Qué hace | Calidad de datos aplicada |
|---|---|---|
| 1 | Limpia hechos, dimensiones y staging (`DELETE` + `RESEED`) | – |
| 2 | `dim_proveedor` | Mayúsculas, ciudad vacía → `NO ESPECIFICADO` |
| 3 | `dim_producto` | Mayúsculas, quita espacios dobles, **deduce la categoría** desde la descripción (vacía en 1,957 de 2,045 productos), descarta precios de prueba (≤ S/ 1), marca stock crítico |
| 4 | `dim_cliente` | Corrige nombres mal digitados, distrito vacío → `NO ESPECIFICADO`, **clasifica VIP** (10 % que más compra) |
| 5 | `dim_tiempo` | Calendario generado con `WHILE` entre la primera y la última venta |
| 6 | `dim_metodoPago` | `BULK INSERT` del txt, limpia espacios/minúsculas, elimina duplicados |
| 7 | `stg_operacion` | `BULK INSERT` del txt, detecta comprobantes duplicados y métodos inexistentes |
| 8 | `fac_ventas` | Excluye anulados y líneas con precio/cantidad ≤ 0, convierte m² a cajas |
| 9 | Reconciliación | Compara el total vendido del OLTP con el del Data Mart |

Tiempos y filas por paso: `etl_bitacora`. Registros descartados y su motivo: `etl_errores`.

## Dashboard (4 páginas)

| Página | Qué responde |
|---|---|
| Resumen Ejecutivo | Ventas, crecimiento vs año anterior, margen vs meta 35 %, métodos de pago, categorías y proveedores |
| Almacén y Rotación | Capital inmovilizado, clasificación ABC (Pareto), mapa de rotación, qué liquidar y qué reponer |
| Clientes y Demanda | Días de mayor venta, distritos, clientes VIP, estacionalidad |
| Monitoreo ETL | Ejecuciones, duración por paso y registros observados por calidad de datos |

## Escenarios de volumen (experimento)

Se cambia `@num_ventas` al final de `01_base_transaccional.sql`, se regenera `operacionVenta.txt`
y se ejecuta el ETL. Misma semilla (2026), mismo equipo, Power BI cerrado:

| Escenario | Ventas | Líneas de detalle | Filas en `fac_ventas` | Tiempo total ETL | Reconciliación |
|---|---|---|---|---|---|
| E1 | 10,000 | 24,941 | 24,387 | 1.3 s | OK |
| E2 | 100,000 | 250,203 | 242,023 | 4.7 s | OK |
| E3 | 500,000 | 1,249,267 | 1,183,472 | 11.1 s | OK |

## Checklist para la presentación

- [ ] SQL Server + SSMS y Power BI Desktop instalados en la PC de la exposición.
- [ ] `C:\txt\ceramicas_vale\` con los 2 txt.
- [ ] Cerrar programas pesados (con poca RAM libre SQL Server se pone lento).
- [ ] Probar una vez los 3 scripts y el dashboard.
- Demo: 01 → 02 → 03 en SSMS (explicar el resumen del ETL) → Power BI **Actualizar** →
  *Resumen* (filtrar Año = 2025) → *Almacén* (Clase ABC = C: qué liquidar) → *Clientes* → *Monitoreo ETL*.
