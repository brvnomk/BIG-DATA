@echo off
REM =====================================================================
REM  BIG DATA · PASO 0 · Exportar las tablas de CERAMICAS_VALE a CSV
REM
REM  Qué hace:
REM   1. Exporta las tablas que no cambian (proveedores, productos, clientes).
REM   2. Para cada volumen (10K, 100K, 500K y 1M) genera las ventas con
REM      sp_generar_ventas (semilla 2026) y exporta VENTAS y DETALLE_VENTAS.
REM   3. Deja la base como estaba: 100 000 ventas.
REM
REM  Cómo se usa: doble clic. Tarda unos 3 minutos (el millón es lo más lento).
REM  Los archivos quedan en C:\csv\ceramicas_vale y se suben tal cual a Databricks.
REM
REM  Si tu servidor no es el local, cambia SERVIDOR (el mismo nombre que usas
REM  para conectarte en SSMS, por ejemplo .\SQLEXPRESS).
REM =====================================================================
chcp 65001 > nul
set SERVIDOR=.
set SALIDA=C:\csv\ceramicas_vale
if not exist "%SALIDA%" mkdir "%SALIDA%"

echo.
echo === Tablas fijas ===
bcp "select id_proveedor, ruc, razon_social, telefono, ciudad from CERAMICAS_VALE.dbo.PROVEEDORES" queryout "%SALIDA%\proveedores.csv" -c -C 65001 -t "|" -S %SERVIDOR% -T
bcp "select codigo_interno, descripcion, unidad_medida, marca, precio, categoria, m2_por_caja, costo_unitario, stock_actual, stock_minimo, estado, id_proveedor from CERAMICAS_VALE.dbo.PRODUCTOS" queryout "%SALIDA%\productos.csv" -c -C 65001 -t "|" -S %SERVIDOR% -T
bcp "select id_cliente, tipo_documento, nro_documento, nombre, distrito from CERAMICAS_VALE.dbo.CLIENTES" queryout "%SALIDA%\clientes.csv" -c -C 65001 -t "|" -S %SERVIDOR% -T

for %%N in (10000 100000 500000 1000000) do (
    echo.
    echo === %%N ventas ===
    sqlcmd -S %SERVIDOR% -E -d CERAMICAS_VALE -b -Q "exec dbo.sp_generar_ventas @num_ventas = %%N, @semilla = 2026"
    bcp "select id_venta, tipo_comprobante, serie_numero, convert(varchar(19), fecha, 120), id_cliente, estado, total from CERAMICAS_VALE.dbo.VENTAS" queryout "%SALIDA%\ventas_%%N.csv" -c -C 65001 -t "|" -S %SERVIDOR% -T
    bcp "select id_venta, item, codigo_interno, cantidad, precio_unitario, descuento_pct from CERAMICAS_VALE.dbo.DETALLE_VENTAS" queryout "%SALIDA%\detalle_ventas_%%N.csv" -c -C 65001 -t "|" -S %SERVIDOR% -T
)

echo.
echo === Dejando la base con 100 000 ventas ===
sqlcmd -S %SERVIDOR% -E -d CERAMICAS_VALE -b -Q "exec dbo.sp_generar_ventas @num_ventas = 100000, @semilla = 2026"

echo.
echo Listo. Archivos en %SALIDA%:
dir /b "%SALIDA%"
echo.
echo Sube estos archivos y los .txt de TXT\ceramicas_vale al volumen de Databricks.
pause
