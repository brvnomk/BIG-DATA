-- =====================================================================
--  EXPERIMENTO BI-2 · Cursor (fila por fila) vs. consulta por conjuntos
--
--  Pregunta: ¿cuánto más tarda cargar la tabla de hechos fila por fila
--            con un CURSOR, en vez de hacerlo todo junto como el ETL?
--
--  Cómo se usa:
--   1. Ten la base cargada (scripts 01, 02 y 03).
--   2. No hace falta cambiar nada. Con 100 000 ventas tarda menos de 1 minuto.
--   3. Pulsa F5 y espera. Los resultados salen al final.
--  El script trabaja en tablas de prueba y al final las borra:
--  no cambia el Data Mart.
-- =====================================================================
use CeramicasVale_DM
go
set nocount on

declare @filas int = 1000000   -- <<< máximo de filas de la prueba (si hay menos, usa todas las de fac_ventas)

-- Tabla con las filas que hay que cargar (el mismo cálculo del paso 8 del ETL)
drop table if exists exp_origen
select top (@filas) id_cliente, id_producto, id_proveedor, id_metodoP, fecha,
       cantidad, monto_vendido, metraje_vendido, costo_inventario, descuento
into exp_origen
from fac_ventas
order by id_venta

-- Dos tablas destino vacías, iguales a fac_ventas
drop table if exists exp_destino_conjunto
drop table if exists exp_destino_cursor
select * into exp_destino_conjunto from exp_origen where 1 = 0
select * into exp_destino_cursor   from exp_origen where 1 = 0

declare @inicio datetime2, @ms_conjunto int, @ms_cursor int
-- CPU usado: SQL Server lleva la cuenta en sys.dm_exec_requests (milisegundos de procesador de esta consulta)
declare @cpu int, @cpu_conjunto int, @cpu_cursor int, @mem_conjunto int, @mem_cursor int

---------------------------------------------------------------------
-- MÉTODO A · Por conjuntos: un solo INSERT ... SELECT (así lo hace el ETL)
---------------------------------------------------------------------
set @inicio = SYSDATETIME()
select @cpu = cpu_time from sys.dm_exec_requests where session_id = @@SPID

insert into exp_destino_conjunto
select * from exp_origen

set @ms_conjunto = DATEDIFF(ms, @inicio, SYSDATETIME())
select @cpu_conjunto = cpu_time - @cpu from sys.dm_exec_requests where session_id = @@SPID
select @mem_conjunto = physical_memory_in_use_kb / 1024 from sys.dm_os_process_memory

---------------------------------------------------------------------
-- MÉTODO B · Con CURSOR: se lee una fila, se inserta, se pasa a la siguiente
---------------------------------------------------------------------
declare @cli int, @prod int, @prov int, @met int, @fec date,
        @cant decimal(14,2), @monto money, @metraje decimal(14,2), @costo money, @dcto money

set @inicio = SYSDATETIME()
select @cpu = cpu_time from sys.dm_exec_requests where session_id = @@SPID

declare c_ventas cursor for
    select id_cliente, id_producto, id_proveedor, id_metodoP, fecha,
           cantidad, monto_vendido, metraje_vendido, costo_inventario, descuento
    from exp_origen

open c_ventas
fetch next from c_ventas into @cli, @prod, @prov, @met, @fec, @cant, @monto, @metraje, @costo, @dcto

while @@FETCH_STATUS = 0
begin
    insert into exp_destino_cursor
    values (@cli, @prod, @prov, @met, @fec, @cant, @monto, @metraje, @costo, @dcto)

    fetch next from c_ventas into @cli, @prod, @prov, @met, @fec, @cant, @monto, @metraje, @costo, @dcto
end

close c_ventas
deallocate c_ventas

set @ms_cursor = DATEDIFF(ms, @inicio, SYSDATETIME())
select @cpu_cursor = cpu_time - @cpu from sys.dm_exec_requests where session_id = @@SPID
select @mem_cursor = physical_memory_in_use_kb / 1024 from sys.dm_os_process_memory

---------------------------------------------------------------------
-- RESULTADOS (esta es la tabla que va al informe)
---------------------------------------------------------------------
select SYSDATETIME() fecha_hora_prueba,
       'A. Por conjuntos (INSERT...SELECT)' metodo,
       (select COUNT(*) from exp_destino_conjunto) filas_cargadas,
       @ms_conjunto milisegundos,
       CAST((select COUNT(*) from exp_destino_conjunto) * 1000.0 / NULLIF(@ms_conjunto, 0) as int) filas_por_segundo,
       @cpu_conjunto cpu_ms,
       @mem_conjunto memoria_sql_server_mb
union all
select SYSDATETIME(),
       'B. Fila por fila (CURSOR)',
       (select COUNT(*) from exp_destino_cursor),
       @ms_cursor,
       CAST((select COUNT(*) from exp_destino_cursor) * 1000.0 / NULLIF(@ms_cursor, 0) as int),
       @cpu_cursor,
       @mem_cursor

select CAST(@ms_cursor * 1.0 / NULLIF(@ms_conjunto, 0) as decimal(10,1)) veces_mas_lento_el_cursor

-- Comprobación: los dos métodos cargaron exactamente lo mismo
select case when (select SUM(monto_vendido) from exp_destino_conjunto) = (select SUM(monto_vendido) from exp_destino_cursor)
            then 'OK: los dos métodos cargaron el mismo total'
            else 'DIFERENCIA entre los métodos' end comprobacion

-- Se borran las tablas de prueba
drop table exp_origen
drop table exp_destino_conjunto
drop table exp_destino_cursor
go
