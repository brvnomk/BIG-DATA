-- =====================================================================
--  EXPERIMENTO BI-3 · Transacciones: un COMMIT por fila vs. un solo COMMIT
--
--  Pregunta: el paso 5 del ETL (dim_tiempo) usa un WHILE que guarda los
--            días uno por uno. ¿Cuánto cambia el tiempo si todo el WHILE va
--            dentro de una sola transacción, o si se hace con una sola consulta?
--
--  Cómo se usa:
--   1. Ten la base creada (scripts 01 y 02).
--   2. Si quieres, cambia @anios (cuántos años de calendario se generan).
--   3. Pulsa F5 y espera. Los resultados salen al final.
--  El script trabaja en una tabla de prueba y al final la borra:
--  no cambia el Data Mart.
-- =====================================================================
use CeramicasVale_DM
go
set nocount on

declare @anios int = 50          -- <<< años de calendario (50 años = 18 263 días)
declare @repeticiones int = 3    -- cada método se ejecuta 3 veces y se promedia

declare @desde date = '2000-01-01'
declare @hasta date = DATEADD(day, -1, DATEADD(year, @anios, @desde))

-- Tabla de prueba con la misma estructura que dim_tiempo
drop table if exists exp_calendario
select * into exp_calendario from dim_tiempo where 1 = 0

declare @resultados table (metodo varchar(60), repeticion int, filas int, milisegundos int, cpu_ms int)
-- CPU usado: SQL Server lleva la cuenta en sys.dm_exec_requests (milisegundos de procesador de esta consulta)
declare @cpu int
declare @r int = 1, @dia date, @inicio datetime2

while @r <= @repeticiones
begin
    -------------------------------------------------------------
    -- MÉTODO A · WHILE sin transacción (así lo hace el ETL):
    --            cada INSERT se confirma solo (un COMMIT por día)
    -------------------------------------------------------------
    truncate table exp_calendario
    set @dia = @desde
    set @inicio = SYSDATETIME()
    select @cpu = cpu_time from sys.dm_exec_requests where session_id = @@SPID

    while @dia <= @hasta
    begin
        insert into exp_calendario
        select @dia, YEAR(@dia), DATEPART(q, @dia), MONTH(@dia), DATENAME(month, @dia),
               DATEPART(ISO_WEEK, @dia), DAY(@dia), DATENAME(weekday, @dia)
        set @dia = DATEADD(day, 1, @dia)
    end

    insert @resultados values ('A. WHILE con un COMMIT por día', @r,
                               (select COUNT(*) from exp_calendario), DATEDIFF(ms, @inicio, SYSDATETIME()),
                               (select cpu_time - @cpu from sys.dm_exec_requests where session_id = @@SPID))

    -------------------------------------------------------------
    -- MÉTODO B · El mismo WHILE dentro de UNA transacción:
    --            BEGIN TRAN al inicio, un solo COMMIT al final.
    --            Si algo falla, ROLLBACK deshace todo (control de excepciones)
    -------------------------------------------------------------
    truncate table exp_calendario
    set @dia = @desde
    set @inicio = SYSDATETIME()
    select @cpu = cpu_time from sys.dm_exec_requests where session_id = @@SPID

    begin try
        begin tran
        while @dia <= @hasta
        begin
            insert into exp_calendario
            select @dia, YEAR(@dia), DATEPART(q, @dia), MONTH(@dia), DATENAME(month, @dia),
                   DATEPART(ISO_WEEK, @dia), DAY(@dia), DATENAME(weekday, @dia)
            set @dia = DATEADD(day, 1, @dia)
        end
        commit tran
    end try
    begin catch
        rollback tran
        print 'Error en el método B: ' + ERROR_MESSAGE()
    end catch

    insert @resultados values ('B. WHILE dentro de un solo COMMIT', @r,
                               (select COUNT(*) from exp_calendario), DATEDIFF(ms, @inicio, SYSDATETIME()),
                               (select cpu_time - @cpu from sys.dm_exec_requests where session_id = @@SPID))

    -------------------------------------------------------------
    -- MÉTODO C · Una sola consulta (por conjuntos), sin WHILE:
    --            se generan todos los días de una vez
    -------------------------------------------------------------
    truncate table exp_calendario
    set @inicio = SYSDATETIME()
    select @cpu = cpu_time from sys.dm_exec_requests where session_id = @@SPID

    ;with numeros as (
        select top (DATEDIFF(day, @desde, @hasta) + 1)
               ROW_NUMBER() over (order by (select null)) - 1 n
        from sys.all_objects a cross join sys.all_objects b)
    insert into exp_calendario
    select D.dia, YEAR(D.dia), DATEPART(q, D.dia), MONTH(D.dia), DATENAME(month, D.dia),
           DATEPART(ISO_WEEK, D.dia), DAY(D.dia), DATENAME(weekday, D.dia)
    from numeros cross apply (select DATEADD(day, n, @desde) dia) D

    insert @resultados values ('C. Una sola consulta (sin WHILE)', @r,
                               (select COUNT(*) from exp_calendario), DATEDIFF(ms, @inicio, SYSDATETIME()),
                               (select cpu_time - @cpu from sys.dm_exec_requests where session_id = @@SPID))

    set @r += 1
end

---------------------------------------------------------------------
-- RESULTADOS (esta es la tabla que va al informe)
---------------------------------------------------------------------
select SYSDATETIME() fecha_hora_prueba,
       metodo,
       MAX(filas) dias_generados,
       AVG(milisegundos) ms_promedio,
       MIN(milisegundos) ms_minimo,
       MAX(milisegundos) ms_maximo,
       AVG(cpu_ms) cpu_ms_promedio,
       (select physical_memory_in_use_kb / 1024 from sys.dm_os_process_memory) memoria_sql_server_mb,
       CAST((select AVG(milisegundos * 1.0) from @resultados where metodo like 'A%')
            / NULLIF(AVG(milisegundos * 1.0), 0) as decimal(10,1)) veces_mas_rapido_que_A
from @resultados
group by metodo
order by metodo

-- Detalle de cada repetición
select metodo, repeticion, filas, milisegundos, cpu_ms from @resultados order by metodo, repeticion

drop table exp_calendario
go
