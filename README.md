Cerámicas Vale: base de datos, ETL y dashboard

Proyecto final del curso Base de Datos Avanzadas y Big Data (UPN, 2026-2).
Los scripts crean todo desde cero, no hace falta tener ninguna otra base de datos.

Qué hay en la carpeta
sql/01_base_transaccional.sql: crea la base CERAMICAS_VALE con sus tablas, el catálogo real (2,045 productos), los proveedores, los clientes y 100,000 ventas.
sql/02_crear_entorno_etl.sql: crea el Data Mart CeramicasVale_DM (modelo estrella, staging, bitácora y tabla de errores).
sql/03_ETL_CARGA.sql: el ETL paso a paso. Al final valida la calidad y calcula algunos KPIs.
txt/ceramicas_vale/: los dos archivos planos del sistema de caja que lee el ETL (metodopago.txt y operacionVenta.txt).
datos/Reporte_Items_2026-10-19 23_21_47.xlsx: el catálogo original que exportamos del sistema de la empresa (corte del 19/10/2026).
datos/catalogo_productos_2026-10-19.csv: el mismo catálogo pasado a CSV. De aquí sale la parte 2 del script 01.

Cómo ejecutarlo
Copiar la carpeta txt\ceramicas_vale dentro de C:\txt\. Tienen que quedar estos dos archivos:
   C:\txt\ceramicas_vale\metodopago.txt
   C:\txt\ceramicas_vale\operacionVenta.txt
Abrir SSMS y ejecutar con F5, en este orden:
sql/01_base_transaccional.sql
sql/02_crear_entorno_etl.sql
sql/03_ETL_CARGA.sql. 

De dónde salen los datos
Fuente	Tipo	Origen
PRODUCTOS	Tabla OLTP	Catálogo real de la empresa: Excel del 19/10/2026, pasado a CSV y cargado con INSERT. Son 2,045 productos (76 nuevos respecto al de septiembre y 3 deshabilitados).
PROVEEDORES, CLIENTES	Tablas OLTP	Inventados por nosotros, no hay datos personales reales.
VENTAS, DETALLE_VENTAS	Tablas OLTP	100,000 ventas generadas con sp_generar_ventas (semilla 2026), así que siempre salen los mismos datos.
metodopago.txt	Archivo plano	Catálogo de métodos de pago del sistema de caja.
operacionVenta.txt	Archivo plano	Exportación de caja con el formato comprobante|metodoPago.

Modelo estrella
fac_ventas: cantidad (cajas o unidades), monto vendido, metraje vendido (m²), costo de inventario y descuento.
dim_producto: descripción, categoría, marca, unidad, m² por caja, stock y estado del stock.
dim_cliente: documento, nombre, distrito y tipo de cliente (REGULAR o VIP).
dim_tiempo: fecha, año, trimestre, mes, semana y día.
dim_metodoPago: efectivo, Yape/Plin, tarjeta, transferencia, depósito y "no registrado".
dim_proveedor: RUC, razón social y ciudad.


El ETL (03_ETL_CARGA.sql)
Paso	Qué hace	Limpieza que aplica
1	Borra hechos, dimensiones y staging (DELETE y RESEED)	
2	Carga dim_proveedor	Pasa a mayúsculas. Si la ciudad viene vacía, pone NO ESPECIFICADO.
3	Carga dim_producto	Mayúsculas y espacios dobles fuera. Deduce la categoría desde la descripción (venía vacía en 1,957 de los 2,045 productos), descarta los precios de prueba (S/ 1 o menos) y marca el stock crítico.
4	Carga dim_cliente	Corrige nombres mal escritos, pone NO ESPECIFICADO si falta el distrito y marca como VIP al 10 % que más compra.
5	Carga dim_tiempo	Genera el calendario con un WHILE, entre la primera y la última venta.
6	Carga dim_metodoPago	BULK INSERT del txt, limpia espacios y minúsculas y quita duplicados.
7	Carga stg_operacion	BULK INSERT del txt. Detecta comprobantes duplicados y métodos que no existen.
8	Carga fac_ventas	Deja fuera los anulados y las líneas con precio o cantidad menor o igual a 0. Convierte los m² a cajas.

Los tiempos y las filas de cada paso quedan en etl_bitacora. Lo que se descarta, con su motivo, queda en etl_errores.

Dashboard (4 páginas)
Resumen Ejecutivo: ventas, crecimiento contra el año anterior, margen contra la meta del 35 %, métodos de pago, categorías y proveedores.
Almacén y Rotación: capital inmovilizado, clasificación ABC, mapa de rotación y qué conviene liquidar o reponer.
Clientes y Demanda: días en que más se vende, distritos, clientes VIP y estacionalidad.
Monitoreo ETL: ejecuciones, duración por paso y registros observados según el problema de calidad.
Pruebas con distintos volúmenes

Escenario	   Ventas	     Líneas de detalle	    Filas en fac_ventas	      Tiempo total del ETL	      Reconciliación
E1	            10,000	     24,941	                24,387	                  1.4 s	                     OK
E2	            100,000	     250,203	             242,023	                  3.14 s                     OK
E3	            500,000	     1,249,267	             1,183,472	               11.45 s	                  OK
