# Experimentos de la solución BI

Cuatro experimentos sobre la solución de Business Intelligence, con temas del curso. Cada integrante ejecuta uno en su propia computadora. Todos los scripts se abren en SSMS y se ejecutan con **F5**.

| Código | Experimento | Tema del curso | Archivos |
|---|---|---|---|
| BI-1 | Volumen progresivo: 10 000 → 100 000 → 500 000 → 1 000 000 ventas | ETL | [`BI1_paso1_generar_ventas.sql`](BI1_paso1_generar_ventas.sql), el script 03 y [`BI1_paso3_resultados.sql`](BI1_paso3_resultados.sql) |
| BI-2 | Cursor (fila por fila) vs. consulta por conjuntos | Cursores | [`BI2_cursor_vs_conjunto.sql`](BI2_cursor_vs_conjunto.sql) |
| BI-3 | Un COMMIT por fila vs. un solo COMMIT vs. una sola consulta | WHILE y transacciones | [`BI3_transacciones.sql`](BI3_transacciones.sql) |
| BI-4 | Power BI: Importar vs. DirectQuery | Reportes y dashboards | Se hace en Power BI (ver la guía) |

Antes de empezar hay que tener la solución BI funcionando (manual de replicación). Para BI-1 también hay que copiar `TXT/ceramicas_vale/operacionVenta_1000000.txt` a `C:\txt\ceramicas_vale`.

BI-2 y BI-3 trabajan en tablas de prueba que se borran al final: no cambian el Data Mart.

La guía completa, con los pasos, qué capturar y cómo analizar cada experimento, está en la **Guía de experimentos BI**.

## Resultados de referencia (computadora de 12 núcleos, 100 000 ventas)

| Experimento | Resultado principal |
|---|---|
| BI-1 | El ETL pasa de 0.77 s (10 000 ventas) a 23.06 s (1 000 000): 100 veces más datos, 30 veces más tiempo. Cumple la meta de menos de 60 s |
| BI-2 | Cargar las 242 023 filas de la tabla de hechos con un cursor tarda 25.5 s; con un INSERT…SELECT, 0.35 s. El cursor es 72 veces más lento |
| BI-3 | Generar 50 años de calendario (18 263 días) con WHILE y un COMMIT por día tarda 1.5 s; con todo dentro de una sola transacción, 0.13 s (12 veces más rápido) |
