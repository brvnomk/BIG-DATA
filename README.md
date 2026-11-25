Cerámicas Vale: Base de datos, ETL y dashboard

Proyecto final del curso Base de Datos Avanzadas y Big Data (UPN, 2026-2).
Los scripts crean todo desde cero, así que no hace falta tener ninguna otra base de datos.
Herramientas: SQL Server (SSMS 22) y Power BI Desktop.


Contenido
1. Estructura del repositorio
2. Cómo ejecutarlo
3. De dónde salen los datos
4. Modelo estrella
5. ETL
6. Dashboard
7. Pruebas con distintos volúmenes


Estructura
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


Archivo                                           ¿Qué hace?
SQL SCRIPTS/01_base_transaccional.sql             Crea la base CERAMICAS_VALE con sus tablas, el catálogo real (2,045 productos), los proveedores, los clientes y 100,000 ventas.
SQL SCRIPTS/02_crear_entorno_etl.sql              Crea el Data Mart CeramicasVale_DM (modelo estrella, staging, bitácora y tabla de errores).
SQL SCRIPTS/03_ETL_CARGA.sql                      El ETL paso a paso. Al final valida la calidad y calcula algunos KPIs.
TXT/ceramicas_vale/                               Los archivos planos del sistema de caja que lee el ETL.
DATOS/Reporte_Items_2026-10-19 23_21_47.xlsx      El catálogo original que exportamos del sistema de la empresa (corte del 19/10/2026).
DATOS/catalogo_productos_2026-10-19.csv           El mismo catálogo pasado a CSV. De aquí sale la parte 2 del script 01.
VISUAL/POWER BI/2.CeramicasVale_Mejorado.pbix     El dashboard en Power BI.


¿Cómo ejecutarlo?
1. Copiar los archivos planos. Copiar la carpeta TXT\ceramicas_vale dentro de C:\txt\. Tienen que quedar estos dos archivos:
C:\txt\ceramicas_vale\metodopago.txt
C:\txt\ceramicas_vale\operacionVenta.txt

2. Ejecutar los scripts. Abrir SSMS y ejecutar cada script con F5, en este orden:
01_base_transaccional.sql
02_crear_entorno_etl.sql
03_ETL_CARGA.sql

3. Abrir el dashboard. Abrir VISUAL/POWER BI/2.CeramicasVale_Mejorado.pbix en Power BI Desktop y actualizar los datos.
Para probar con 10K o 500K ventas: el ETL siempre lee operacionVenta.txt. Hay que reemplazar ese archivo en C:\txt\ceramicas_vale\ por operacionVenta_10000.txt o operacionVenta_500000.txt (renombrándolo a operacionVenta.txt).


¿De dónde salen los datos?
Fuente                     Tipo               Origen
PRODUCTOS                  Tabla OLTP         Catálogo real de la empresa: Excel del 19/10/2026, pasado a CSV y cargado con INSERT. Son 2,045 productos (76 nuevos respecto al de septiembre y 3 deshabilitados).
PROVEEDORES, CLIENTES      Tablas OLTP        Inventados por nosotros, no hay datos personales reales.
VENTAS, DETALLE_VENTAS     Tablas OLTP        100,000 ventas generadas con sp_generar_ventas (semilla 2026), así que siempre salen los mismos datos.
metodopago.txt             Archivo plano      Catálogo de métodos de pago del sistema de caja.
operacionVenta.txt         Archivo plano      Exportación de caja con el formato comprobante|metodoPago.


Modelo estrella
Tabla                 Contenido 
fac_ventas            Cantidad (cajas o unidades), monto vendido, metraje vendido (m²), costo de inventario y descuento.
dim_producto          Descripción, categoría, marca, unidad, m² por caja, stock y estado del stock.
dim_cliente           Documento, nombre, distrito y tipo de cliente (REGULAR o VIP).
dim_tiempo            Fecha, año, trimestre, mes, semana y día.
dim_metodoPago        Efectivo, Yape/Plin, tarjeta, transferencia, depósito y "no registrado".
dim_proveedor         RUC, razón social y ciudad.


| Fuente | Tipo | Origen |
|---|---|---|
| `PRODUCTOS` | Tabla OLTP | Catálogo real de la empresa: Excel del 19/10/2026, pasado a CSV y cargado con `INSERT`. Son 2,045 productos (76 nuevos respecto al de septiembre y 3 deshabilitados). |
| `PROVEEDORES`, `CLIENTES` | Tablas OLTP | Inventados por nosotros, no hay datos personales reales. |
| `VENTAS`, `DETALLE_VENTAS` | Tablas OLTP | 100,000 ventas generadas con `sp_generar_ventas` (semilla 2026), así que siempre salen los mismos datos. |
| `metodopago.txt` | Archivo plano | Catálogo de métodos de pago del sistema de caja. |
| `operacionVenta.txt` | Archivo plano | Exportación de caja con el formato `comprobante\|metodoPago`. |


## Modelo estrella

| Tabla | Contenido |
|---|---|
| `fac_ventas` | Cantidad (cajas o unidades), monto vendido, metraje vendido (m²), costo de inventario y descuento. |
| `dim_producto` | Descripción, categoría, marca, unidad, m² por caja, stock y estado del stock. |
| `dim_cliente` | Documento, nombre, distrito y tipo de cliente (REGULAR o VIP). |
| `dim_tiempo` | Fecha, año, trimestre, mes, semana y día. |
| `dim_metodoPago` | Efectivo, Yape/Plin, tarjeta, transferencia, depósito y "no registrado". |
| `dim_proveedor` | RUC, razón social y ciudad. |


