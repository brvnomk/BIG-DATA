-- =====================================================================
--  EXPERIMENTO BI-1 · Volumen progresivo · PASO 3 de 3
--  Muestra los resultados del ETL agrupados por volumen. Ejecútalo al final,
--  cuando hayas probado todos los volúmenes.
--  Por cada volumen usa solo las 3 últimas ejecuciones EXITOSAS: así no se
--  mezclan pruebas viejas ni ejecuciones con el archivo de caja equivocado.
--
--  Cómo se usa: pulsa F5. No hay que cambiar nada.
-- =====================================================================
use CeramicasVale_DM
go

-- Cada volumen deja una cantidad fija de filas en fac_ventas (por la semilla 2026)
drop table if exists #corridas
select E.*,
       case E.filas_hechos
            when 24387   then '1) 10 000 ventas'
            when 242023  then '2) 100 000 ventas'
            when 1183472 then '3) 500 000 ventas'
            when 2327810 then '4) 1 000 000 ventas'
       end volumen
into #corridas
from (select *, ROW_NUMBER() over (partition by filas_hechos order by id_ejecucion desc) n
      from etl_ejecucion
      where estado = 'EXITOSO' and filas_hechos in (24387, 242023, 1183472, 2327810)) E
where E.n <= 3

-- RESULTADO 1 · Tiempo del ETL por volumen (esta es la tabla que va al informe)
select volumen,
       COUNT(*) ejecuciones,
       MAX(filas_hechos) filas_en_fac_ventas,
       CAST(AVG(duracion_ms) / 1000.0 as decimal(8,2)) segundos_promedio,
       CAST(MIN(duracion_ms) / 1000.0 as decimal(8,2)) segundos_minimo,
       CAST(MAX(duracion_ms) / 1000.0 as decimal(8,2)) segundos_maximo,
       CAST(MAX(filas_hechos) / (AVG(duracion_ms) / 1000.0) as int) filas_por_segundo,
       MAX(fecha_inicio) ultima_ejecucion
from #corridas
group by volumen
order by volumen

-- RESULTADO 2 · Tiempo de cada paso del ETL por volumen (¿qué paso crece más?)
select B.proceso,
       AVG(case when C.filas_hechos = 24387   then B.duracion_ms end) ms_10_mil,
       AVG(case when C.filas_hechos = 242023  then B.duracion_ms end) ms_100_mil,
       AVG(case when C.filas_hechos = 1183472 then B.duracion_ms end) ms_500_mil,
       AVG(case when C.filas_hechos = 2327810 then B.duracion_ms end) ms_1_millon
from etl_bitacora B
join #corridas C on C.id_ejecucion = B.id_ejecucion
group by B.proceso
order by B.proceso
go
