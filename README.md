# Cerámicas Vale: base de datos, ETL y dashboard

Proyecto final del curso **Base de Datos Avanzadas y Big Data** (UPN, 2026-2).
Los scripts crean todo desde cero, así que no hace falta tener ninguna otra base de datos.
Herramientas: SQL Server (SSMS 22) y Power BI Desktop.

---

## Contenido

- [Estructura del repositorio](#estructura-del-repositorio)
- [Cómo ejecutarlo](#cómo-ejecutarlo)
- [De dónde salen los datos](#de-dónde-salen-los-datos)
- [Modelo estrella](#modelo-estrella)
- [El ETL](#el-etl-03_etl_cargasql)
- [Dashboard](#dashboard-4-páginas)
- [Pruebas con distintos volúmenes](#pruebas-con-distintos-volúmenes)

---

## Estructura del repositorio

```
BIG-DATA/
├── SQL SCRIPTS/
│   ├── 01_base_transaccional.sql
│   ├── 02_crear_entorno_etl.sql
│   └── 03_ETL_CARGA.sql
├── TXT/ceramicas_vale/
│   ├── metodopago.txt
│   ├── operacionVenta.txt          (100K ventas)
│   ├── operacionVenta_10000.txt    (10K ventas)
│   └── operacionVenta_500000.txt   (500K ventas)
├── DATOS/
│   ├── Reporte_Items_2026-10-19 23_21_47.xlsx
│   └── catalogo_productos_2026-10-19.csv
├── VISUAL/
│   ├── POWER BI/   (modelo, dashboards y archivo .pbix)
│   └── SQL/        (diagrama del modelo estrella)
├── EVIDENCIAS/     (capturas de las pruebas de 10K, 100K y 500K)
├── Manual.docx
├── PROCEDIMIENTO DE REPLICACIÓN.docx
├── 2026-2_ISC-Informe_Proyecto_Final_BASAV.docx
└── Sistema transaccional y analítico con BI y Big Data – Cerámicas Vale.pdf
```

| Archivo | Qué hace |
|---|---|
| `SQL SCRIPTS/01_base_transaccional.sql` | Crea la base `CERAMICAS_VALE` con sus tablas, el catálogo real (2,045 productos), los proveedores, los clientes y 100,000 ventas. |
| `SQL SCRIPTS/02_crear_entorno_etl.sql` | Crea el Data Mart `CeramicasVale_DM` (modelo estrella, staging, bitácora y tabla de errores). |
| `SQL SCRIPTS/03_ETL_CARGA.sql` | El ETL paso a paso. Al final valida la calidad y calcula algunos KPIs. |
| `TXT/ceramicas_vale/` | Los archivos planos del sistema de caja que lee el ETL. |
| `DATOS/Reporte_Items_2026-10-19 23_21_47.xlsx` | El catálogo original que exportamos del sistema de la empresa (corte del 19/10/2026). |
| `DATOS/catalogo_productos_2026-10-19.csv` | El mismo catálogo pasado a CSV. De aquí sale la parte 2 del script 01. |
| `VISUAL/POWER BI/2.CeramicasVale_Mejorado.pbix` | El dashboard en Power BI. |

---

## Cómo ejecutarlo

**1. Copiar los archivos planos.** Copiar la carpeta `TXT\ceramicas_vale` dentro de `C:\txt\`. Tienen que quedar estos dos archivos:

```
C:\txt\ceramicas_vale\metodopago.txt
C:\txt\ceramicas_vale\operacionVenta.txt
```

**2. Ejecutar los scripts.** Abrir SSMS y ejecutar cada script con `F5`, en este orden:

1. `01_base_transaccional.sql`
2. `02_crear_entorno_etl.sql`
3. `03_ETL_CARGA.sql`

**3. Abrir el dashboard.** Abrir `VISUAL/POWER BI/2.CeramicasVale_Mejorado.pbix` en Power BI Desktop y actualizar los datos.

> **Para probar con 10K o 500K ventas:** el ETL siempre lee `operacionVenta.txt`. Hay que reemplazar ese archivo en `C:\txt\ceramicas_vale\` por `operacionVenta_10000.txt` o `operacionVenta_500000.txt` (renombrándolo a `operacionVenta.txt`).

---

## De dónde salen los datos

| Fuente | Tipo | Origen |
|---|---|---|
| `PRODUCTOS` | Tabla OLTP | Catálogo real de la empresa: Excel del 19/10/2026, pasado a CSV y cargado con `INSERT`. Son 2,045 productos (76 nuevos respecto al de septiembre y 3 deshabilitados). |
| `PROVEEDORES`, `CLIENTES` | Tablas OLTP | Inventados por nosotros, no hay datos personales reales. |
| `VENTAS`, `DETALLE_VENTAS` | Tablas OLTP | 100,000 ventas generadas con `sp_generar_ventas` (semilla 2026), así que siempre salen los mismos datos. |
| `metodopago.txt` | Archivo plano | Catálogo de métodos de pago del sistema de caja. |
| `operacionVenta.txt` | Archivo plano | Exportación de caja con el formato `comprobante\|metodoPago`. |

---

## Modelo estrella

| Tabla | Contenido |
|---|---|
| `fac_ventas` | Cantidad (cajas o unidades), monto vendido, metraje vendido (m²), costo de inventario y descuento. |
| `dim_producto` | Descripción, categoría, marca, unidad, m² por caja, stock y estado del stock. |
| `dim_cliente` | Documento, nombre, distrito y tipo de cliente (REGULAR o VIP). |
| `dim_tiempo` | Fecha, año, trimestre, mes, semana y día. |
| `dim_metodoPago` | Efectivo, Yape/Plin, tarjeta, transferencia, depósito y "no registrado". |
| `dim_proveedor` | RUC, razón social y ciudad. |

![Modelo estrella](VISUAL/SQL/1.Modelo%20Estrella.png)

---

## El ETL (`03_ETL_CARGA.sql`)

| Paso | Qué hace | Limpieza que aplica |
|:---:|---|---|
| 1 | Borra hechos, dimensiones y staging (`DELETE` y `RESEED`). | — |
| 2 | Carga `dim_proveedor`. | Pasa a mayúsculas. Si la ciudad viene vacía, pone NO ESPECIFICADO. |
| 3 | Carga `dim_producto`. | Mayúsculas y espacios dobles fuera. Deduce la categoría desde la descripción (venía vacía en 1,957 de los 2,045 productos), descarta los precios de prueba (S/ 1 o menos) y marca el stock crítico. |
| 4 | Carga `dim_cliente`. | Corrige nombres mal escritos, pone NO ESPECIFICADO si falta el distrito y marca como VIP al 10 % que más compra. |
| 5 | Carga `dim_tiempo`. | Genera el calendario con un `WHILE`, entre la primera y la última venta. |
| 6 | Carga `dim_metodoPago`. | `BULK INSERT` del txt, limpia espacios y minúsculas y quita duplicados. |
| 7 | Carga `stg_operacion`. | `BULK INSERT` del txt. Detecta comprobantes duplicados y métodos que no existen. |
| 8 | Carga `fac_ventas`. | Deja fuera los anulados y las líneas con precio o cantidad menor o igual a 0. Convierte los m² a cajas. |

Los tiempos y las filas de cada paso quedan en `etl_bitacora`. Lo que se descarta, con su motivo, queda en `etl_errores`.

---

## Dashboard (4 páginas)

| Página | Qué muestra |
|---|---|
| **Resumen Ejecutivo** | Ventas, crecimiento contra el año anterior, margen contra la meta del 35 %, métodos de pago, categorías y proveedores. |
| **Almacén y Rotación** | Capital inmovilizado, clasificación ABC, mapa de rotación y qué conviene liquidar o reponer. |
| **Clientes y Demanda** | Días en que más se vende, distritos, clientes VIP y estacionalidad. |
| **Monitoreo ETL** | Ejecuciones, duración por paso y registros observados según el problema de calidad. |

![Dashboard](VISUAL/POWER%20BI/3.Dashboards.png)

---

## Pruebas con distintos volúmenes

| Escenario | Ventas | Líneas de detalle | Filas en `fac_ventas` | Tiempo total del ETL | Reconciliación |
|:---:|---:|---:|---:|---:|:---:|
| E1 | 10,000 | 24,941 | 24,387 | 1.40 s | ✅ OK |
| E2 | 100,000 | 250,203 | 242,023 | 3.14 s | ✅ OK |
| E3 | 500,000 | 1,249,267 | 1,183,472 | 11.45 s | ✅ OK |

Las capturas de cada escenario (iteraciones, uso de disco, reconciliación, descartes y CPU) están en `EVIDENCIAS/10K`, `EVIDENCIAS/100K` y `EVIDENCIAS/500K`.
