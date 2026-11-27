# Automatización del ETL (propuesta)

Hoy el ETL se ejecuta a mano (F5 en SSMS). En la empresa debería correr **solo, todas las noches**,
después del cierre de caja, para que cada mañana el dashboard tenga los datos del día anterior.

## Cómo funcionaría

```
23:00  El sistema de caja deja operacionVenta.txt en C:\txt\ceramicas_vale\
23:05  Se ejecuta automáticamente 03_ETL_CARGA.sql
       → queda registrado en etl_ejecucion / etl_bitacora / etl_errores
08:00  El administrador abre Power BI → Actualizar → ve los datos del día anterior
       (con Power BI Service, la actualización también se puede programar)
```

Solo se automatiza el **script 03**: el 01 y el 02 se ejecutan una sola vez, al instalar.

## Opción 1 – Programador de tareas de Windows (funciona con cualquier edición de SQL Server)

Usa el archivo [`ejecutar_etl.bat`](ejecutar_etl.bat), que ejecuta el 03 con `sqlcmd` y guarda un registro (log).

1. Copia `ejecutar_etl.bat` en la carpeta del proyecto (junto a la carpeta `SQL SCRIPTS`).
2. Abre el **Programador de tareas** de Windows → **Crear tarea básica**.
3. Nombre: `ETL Ceramicas Vale` → Desencadenador: **Diariamente**, a las **23:05**.
4. Acción: **Iniciar un programa** → elige `ejecutar_etl.bat`.
5. Finalizar. Para probar: clic derecho en la tarea → **Ejecutar**.

Cada ejecución deja un archivo en la carpeta `logs` y una fila nueva en `etl_ejecucion`.

## Opción 2 – SQL Server Agent (ediciones Developer, Standard o Enterprise)

1. En SSMS, en el Explorador de objetos, clic derecho en **Agente SQL Server → Iniciar** (si está detenido).
2. **Trabajos → Nuevo trabajo** → Nombre: `ETL Ceramicas Vale`.
3. **Pasos → Nuevo**: Tipo **Transact-SQL**, Base de datos `CeramicasVale_DM`, y en **Comando** pega el
   contenido de `03_ETL_CARGA.sql`.
4. **Programaciones → Nueva**: Periódica, **diaria**, a las **23:05**.
5. Aceptar. Para probar: clic derecho en el trabajo → **Iniciar trabajo en el paso**.

## ¿Cómo se sabe si funcionó?

```sql
select top 5 * from CeramicasVale_DM.dbo.etl_ejecucion order by id_ejecucion desc
```
Debe aparecer una ejecución por día con estado **EXITOSO**. También se ve en la página **ETL** del dashboard.

## Mejora futura: carga incremental

Hoy el ETL hace una **carga completa** (borra y recarga todo); con 500 000 ventas tarda unos 11 s, así que
es suficiente. Si los datos crecieran mucho, se podría cargar solo las ventas nuevas desde la última
ejecución (por ejemplo, filtrando por la fecha de la última corrida guardada en `etl_ejecucion`).
