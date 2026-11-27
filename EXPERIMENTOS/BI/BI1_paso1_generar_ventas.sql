-- =====================================================================
--  EXPERIMENTO BI-1 · Volumen progresivo · PASO 1 de 3
--  Genera la cantidad de ventas del escenario que vas a probar.
--
--  Cómo se usa:
--   1. Cambia @ventas: 10000, 100000, 500000 o 1000000 (empieza por 10000).
--   2. Pulsa F5. Al final te dice qué archivo poner en la línea 188 del script 03.
--   3. Sigue con el PASO 2 de la guía (ejecutar el script 03 tres veces).
-- =====================================================================
use CERAMICAS_VALE
go

declare @ventas int = 10000      -- <<< 10000, 100000, 500000 o 1000000

exec sp_generar_ventas @num_ventas = @ventas, @semilla = 2026

select @ventas ventas_generadas,
       case @ventas
            when 10000   then 'operacionVenta_10000.txt'
            when 100000  then 'operacionVenta.txt'
            when 500000  then 'operacionVenta_500000.txt'
            when 1000000 then 'operacionVenta_1000000.txt'
            else 'ESE VOLUMEN NO TIENE ARCHIVO: usa 10000, 100000, 500000 o 1000000'
       end archivo_para_la_linea_188_del_script_03
go
