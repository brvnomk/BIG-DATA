# Documento de replicación – Cerámicas Vale

## Datos del proyecto

Este documento explica cómo instalar, ejecutar y comprobar, en cualquier computadora con Windows, las soluciones del proyecto *Sistema transaccional y analítico con soluciones de Business Intelligence y Big Data para Cerámicas Vale*. Está escrito para alguien que no conoce el proyecto: basta con seguir los pasos en orden.

| Dato | Detalle |
| --- | --- |
| Curso | Base de Datos Avanzadas y Big Data (NRC 26055) |
| Universidad | Universidad Privada del Norte (UPN), ciclo 2026-2 |
| Docente | Victor Isaac Chavez Bardales |
| Equipo | Elescano Medina, Bruno Martin Kalen · Huarancca Cachique, Sebastian Victor · Huasupoma Rodas, Jimi Roger · Rojas Condorchoa, Diego Javier |
| Repositorio | github.com/brvnomk/BIG-DATA |
| Tiempo estimado | 30 a 40 minutos (la mayor parte es instalar los programas) |

## Cómo está organizado este documento

| Parte | Qué se replica | Tiempo aproximado |
| --- | --- | --- |
| I. Solución BI | Base de datos de la tienda, Data Mart, ETL y dashboard en Power BI | 30 a 40 minutos |
| II. Experimentos de la solución BI | Los 4 experimentos del informe (sección 6.7) | 10 a 20 minutos cada uno |
| III. Solución Big Data | Procesamiento en Databricks con Spark | Pendiente |
| IV. Experimentos de Big Data | Los 4 experimentos en Databricks | Pendiente |

Las partes se hacen en orden: los experimentos de BI necesitan la Parte I terminada.

# Parte I · Solución BI

## 1. Objetivo y alcance

Al terminar la Parte I tendrás funcionando, en tu computadora, la misma solución que presentamos: la base de datos del negocio, el Data Mart, el proceso ETL y el dashboard en Power BI, con los mismos números del informe.

Se arma en cuatro partes, siempre en este orden:

1. **La base de datos de la tienda**: guarda los productos, clientes y ventas.
2. **La base de datos de análisis**: una segunda base, ordenada para hacer reportes.
3. **El paso de los datos** de la primera base a la segunda, corrigiendo errores en el camino.
4. **El dashboard** en Power BI: los gráficos que muestran cómo va el negocio.

No necesitas saber programar ni cambiar nada de los archivos: solo abrirlos y presionar un botón.

```
  Archivo 01              Archivo 02                Archivo 03              Power BI
  Base de la tienda  -->  Base de análisis    -->   ETL: pasa y corrige -->  Dashboard
  (CERAMICAS_VALE)        vacía (CeramicasVale_DM)  los datos
                                                        ^
                                   Archivos de caja (C:\txt\ceramicas_vale)
```

El ETL (paso 3) toma los datos de la base del negocio y de los archivos de caja, y los deja en el Data Mart que creó el paso 2.

### Palabras que vas a leer en este documento

| Palabra | Qué significa |
| --- | --- |
| Base de datos | Un lugar donde se guarda información ordenada en tablas, como un Excel muy grande |
| SQL Server | El programa que guarda las bases de datos. Trabaja “por detrás”: no se ve una ventana |
| SSMS | El programa con ventanas que usamos para abrir los archivos y darle órdenes a SQL Server |
| Script o archivo .sql | Un archivo con instrucciones ya escritas. Solo hay que abrirlo y ejecutarlo |
| Ejecutar (F5) | Decirle al programa que haga lo que dice el archivo. Se hace presionando la tecla F5 |
| ETL | El proceso que copia los datos de la base de la tienda a la base de análisis y los corrige |
| Power BI | El programa donde se ven los gráficos |
| Dashboard | La pantalla de gráficos e indicadores del negocio |

## 2. Requisitos

Una computadora con Windows 10 u 11, 8 GB de RAM o más y unos 5 GB libres en disco es suficiente. Todos los programas son gratuitos.

| Programa | Para qué se usa | Versión usada en el proyecto |
| --- | --- | --- |
| SQL Server | Guarda las bases de datos y ejecuta el ETL | SQL Server 2022 Developer (sirve también Express) |
| SQL Server Management Studio (SSMS) | Abrir y ejecutar los scripts | SSMS 22 |
| Power BI Desktop | Ver el dashboard | Power BI Desktop (Microsoft Store, octubre 2026) |
| Navegador web | Descargar el proyecto de GitHub | Cualquiera |

Con menos de 8 GB de RAM la solución funciona, pero conviene cerrar otros programas al ejecutar el ETL: si falta memoria, SQL Server se pone lento.

## 3. Instalación de herramientas

Si ya tienes los tres programas instalados, pasa a la sección 4.

### 3.1 SQL Server

1. Entra a la página de descargas de SQL Server (https://www.microsoft.com/es-es/sql-server/sql-server-downloads) y descarga la edición **Developer** o **Express**.
2. Ejecuta el instalador y elige la instalación **Básica**. Acepta la licencia y espera a que termine.
3. Al final se muestra el **nombre de la instancia**. Anótalo, porque lo usarás para conectarte:
   - si dice `MSSQLSERVER`, tu servidor se llama `localhost`;
   - si dice `SQLEXPRESS`, tu servidor se llama `.\SQLEXPRESS`.

### 3.2 SQL Server Management Studio (SSMS)

1. Entra a la página de instalación de SSMS (https://learn.microsoft.com/es-es/ssms/install/install) y descarga el instalador (`vs_SSMS.exe`).
2. Ejecútalo, acepta el permiso de administrador y pulsa **Instalar**.
3. Abre SSMS. En la ventana **Conectar al servidor** completa:
   - **Nombre del servidor:** el nombre anotado en el paso 3.1.
   - **Autenticación:** Autenticación de Windows.
   - Marca la casilla **Confiar en el certificado del servidor**.
4. Pulsa **Conectar**. A la izquierda aparece el **Explorador de objetos** con tu servidor.

Si aparece un error de certificado (*la cadena de certificados fue emitida por una entidad que no es de confianza*), falta marcar **Confiar en el certificado del servidor**.

### 3.3 Power BI Desktop

1. Abre **Microsoft Store**, busca **Power BI Desktop** y pulsa **Obtener**. También se puede descargar desde la página de Power BI Desktop (https://www.microsoft.com/es-es/power-platform/products/power-bi/desktop).
2. Ábrelo una vez para comprobar que inicia. No hace falta iniciar sesión.

## 4. Obtener el proyecto y preparar los archivos

### 4.1 Descargar el proyecto

1. Entra al repositorio github.com/brvnomk/BIG-DATA.
2. Pulsa el botón verde **Code** y luego **Download ZIP**.
3. Descomprime el ZIP en una carpeta fácil de encontrar, por ejemplo el Escritorio.

### 4.2 Copiar los archivos de texto a C:\txt\ceramicas_vale

El ETL lee dos archivos que simulan lo que exporta el sistema de caja de la tienda. SQL Server los busca siempre en la misma ruta, por eso hay que copiarlos ahí.

1. Abre el Explorador de archivos y entra a **Disco local (C:)**.
2. Crea una carpeta llamada `txt`.
3. Dentro de `txt`, crea otra carpeta llamada `ceramicas_vale`.
4. Copia ahí los cinco archivos de la carpeta `TXT/ceramicas_vale` del proyecto.

```
C:\txt\ceramicas_vale\metodopago.txt
C:\txt\ceramicas_vale\operacionVenta.txt
C:\txt\ceramicas_vale\operacionVenta_10000.txt
C:\txt\ceramicas_vale\operacionVenta_500000.txt
C:\txt\ceramicas_vale\operacionVenta_1000000.txt
```

| Archivo | Qué contiene |
| --- | --- |
| `metodopago.txt` | Los cinco métodos de pago de la caja: Efectivo, Yape/Plin, Tarjeta, Transferencia y Depósito |
| `operacionVenta.txt` | Con qué método se pagó cada comprobante, para las 100 000 ventas del escenario normal |
| `operacionVenta_10000.txt`, `operacionVenta_500000.txt` y `operacionVenta_1000000.txt` | Lo mismo para los escenarios de prueba de 10 000, 500 000 y 1 000 000 de ventas (Parte II, sección 13) |

**¿Salió bien?** Al abrir `C:\txt\ceramicas_vale` ves los cinco archivos.

## 5. Crear la base de datos de la tienda (archivo 01)

Este paso crea la base de datos con los productos, los clientes y las ventas de la tienda. Solo vas a abrir un archivo y presionar una tecla.

1. Abre **SSMS** y pulsa **Conectar** (como en el paso 3.2).
2. Arriba a la izquierda, haz clic en **Archivo → Abrir → Archivo…**
3. Busca la carpeta del proyecto que descomprimiste, entra a **SQL SCRIPTS**, elige **01_base_transaccional.sql** y pulsa **Abrir**. Aparece mucho texto: es normal, no cambies nada.
4. Presiona la tecla **F5** (o el botón verde **▶ Ejecutar** de arriba).
5. Espera unos 10 segundos.

**¿Salió bien?** Abajo aparece una barra que dice *Consulta ejecutada correctamente* y, en la pestaña **Resultados**, una tabla con **100000** en la columna *ventas* y **250203** en la columna *lineas_detalle*.

Tus números deben ser exactamente esos: los datos de prueba se crean siempre iguales, en cualquier computadora. Si sale un mensaje en rojo, revisa la sección 11.

## 6. Crear la base de datos de análisis (archivo 02)

Este paso crea una segunda base de datos, todavía vacía. Ahí se guardará la información ordenada que usa el dashboard.

1. En SSMS, haz clic en **Archivo → Abrir → Archivo…**
2. Entra a **SQL SCRIPTS**, elige **02_crear_entorno_etl.sql** y pulsa **Abrir**.
3. Presiona **F5**.

**¿Salió bien?** Abajo, en la pestaña **Mensajes**, dice *Los comandos se han completado correctamente*. Esta vez no aparece ninguna tabla de resultados: es normal, porque la base está vacía.

Este archivo se puede ejecutar varias veces sin problema.

## 7. Pasar los datos a la base de análisis (archivo 03)

Este paso copia los datos de la base de la tienda a la base de análisis y corrige los errores que encuentra: nombres mal escritos, datos vacíos, ventas anuladas o repetidas. A este proceso se le llama **ETL**.

1. Antes, comprueba que la carpeta `C:\txt\ceramicas_vale` tiene los archivos del paso 4.2. Si no están, este paso falla.
2. En SSMS, haz clic en **Archivo → Abrir → Archivo…**
3. Entra a **SQL SCRIPTS**, elige **03_ETL_CARGA.sql** y pulsa **Abrir**.
4. Presiona **F5** y espera unos segundos.

**¿Salió bien?** En la pestaña **Resultados** aparecen varias tablas. Baja hasta la que tiene la columna *proceso*:

- Debe tener **9 filas**, todas con la palabra **EXITOSO**.
- La última fila, *9. Reconciliación*, debe decir **OK**. Significa que el total vendido es igual en las dos bases: no se perdió ni se duplicó ninguna venta.

Si quieres saber qué hace el ETL por dentro, está explicado en el Anexo B.

## 8. Ver el dashboard en Power BI

Este paso muestra los gráficos con los datos que acabas de cargar.

1. En la carpeta del proyecto, entra a **VISUAL** → **POWER BI** y haz doble clic en el archivo que termina en **.pbix**. Se abre Power BI.
2. En la barra de arriba, pestaña **Inicio**, pulsa el botón **Actualizar**.
3. Si aparece una ventana pidiendo datos de acceso: elige **Windows** a la izquierda, marca **Usar mis credenciales actuales** y pulsa **Conectar**.
4. Si aparece un aviso sobre una conexión *no cifrada*, pulsa **Aceptar**.
5. Espera a que se cierre la ventana **Cargar** (unos segundos).

**¿Salió bien?** La tarjeta **Ventas Totales** muestra **S/ 116.36 mill.** y los gráficos tienen datos.

Dos cosas importantes:

- **Usa siempre Inicio → Actualizar.** No hagas clic derecho sobre una tabla para actualizarla sola: puede salir un error de *referencia cíclica*.
- **Power BI no se actualiza solo.** Si vuelves a ejecutar el archivo 03, presiona otra vez **Inicio → Actualizar** para ver los datos nuevos.

El dashboard tiene cuatro páginas (pestañas abajo):

| Página | Qué muestra |
| --- | --- |
| Dashboard | Cuánto se vende, si crece y si se llega a la meta de margen |
| ETL | Si la carga de datos funcionó y qué errores corrigió |
| Almacén y Rotación | Qué productos ocupan espacio sin venderse y cuáles hay que reponer |
| Clientes y Demanda | Quiénes compran, dónde y qué días |

Los colores funcionan como un semáforo: **azul** es información, **verde** significa que va bien, **ámbar** que necesita atención y **rojo** es una alerta.

## 9. Comprobar que todo quedó igual que en el proyecto

Si estos números coinciden, hiciste todo bien.

| Dónde mirar | Qué debe decir |
| --- | --- |
| Paso 5, pestaña Resultados | 100000 ventas y 250203 líneas de detalle |
| Paso 7, tabla con la columna *proceso* | 9 filas EXITOSO y la última con OK |
| Paso 8, tarjeta Ventas Totales | S/ 116.36 mill. |
| Paso 8, medidor de margen | 32.16 % (en ámbar, porque no llega a la meta de 35 %) |

El tiempo que tarda cada paso depende de la computadora; eso no importa.

## 10. Opcional: automatizar el ETL

En la empresa el ETL debería correr solo cada noche, después del cierre de caja, para que el dashboard muestre cada mañana los datos del día anterior. Solo se automatiza el script 03: el 01 y el 02 se ejecutan una vez, al instalar. El detalle está en `AUTOMATIZACION/AUTOMATIZACION_ETL.md`.

**Opción 1: Programador de tareas de Windows** (funciona con cualquier edición de SQL Server). Usa el archivo `ejecutar_etl.bat` de la carpeta `AUTOMATIZACION`, que ejecuta el script 03 con `sqlcmd` y guarda un registro en la carpeta `logs`.

1. Copia `ejecutar_etl.bat` en la carpeta del proyecto, junto a `SQL SCRIPTS`.
2. Abre el **Programador de tareas** de Windows y elige **Crear tarea básica**.
3. Nombre: `ETL Ceramicas Vale`. Desencadenador: **Diariamente**, a las 23:05.
4. Acción: **Iniciar un programa** y elige `ejecutar_etl.bat`.
5. Para probarla: clic derecho en la tarea → **Ejecutar**.

**Opción 2: Agente SQL Server** (ediciones Developer, Standard o Enterprise).

1. En SSMS, clic derecho en **Agente SQL Server → Iniciar**, si está detenido.
2. **Trabajos → Nuevo trabajo**, con el nombre `ETL Ceramicas Vale`.
3. En **Pasos → Nuevo**: tipo Transact-SQL, base `CeramicasVale_DM`, y en *Comando* pega el contenido del script 03.
4. En **Programaciones → Nueva**: diaria, a las 23:05.

Para saber si funcionó, revisa que haya una fila nueva por día con estado EXITOSO:

```sql
select top 5 * from CeramicasVale_DM.dbo.etl_ejecucion order by id_ejecucion desc
```

## 11. Problemas frecuentes y soluciones

| Qué pasa | Qué hacer |
| --- | --- |
| SSMS muestra un error de certificado al conectar | Marca la casilla **Confiar en el certificado del servidor** y vuelve a pulsar Conectar |
| El archivo 03 dice que *no se puede abrir* un archivo .txt | Faltan los archivos en `C:\txt\ceramicas_vale`. Repite el paso 4.2 |
| El archivo 03 dice que un *nombre de objeto no es válido* | Faltaron los pasos 5 o 6. Ejecuta los archivos en orden: 01, 02 y 03 |
| En el paso 5 los números no son 100000 y 250203 | Se cambió algo en el archivo 01. Vuelve a descargarlo del repositorio |
| Un paso tarda mucho más de lo normal | La computadora tiene poca memoria libre. Cierra el navegador y otros programas y repite el paso |
| Power BI dice *referencia cíclica* | Se actualizó una tabla sola. Pulsa **Inicio → Actualizar** |
| Power BI muestra números viejos | Falta pulsar **Inicio → Actualizar** después del paso 7 |
| Power BI no logra conectarse | Tu servidor tiene otro nombre (paso 3.1). En Power BI ve a **Transformar datos → Configuración de origen de datos → Cambiar origen** y escribe ese nombre, por ejemplo `.\SQLEXPRESS` |
| La página ETL del dashboard muestra una sola ejecución | Se usó una versión vieja del archivo 02. Descárgalo de nuevo del repositorio |

# Parte II · Experimentos de la solución BI

Estos son los experimentos documentados en la sección 6.7 del informe. Cada uno se ejecuta con F5 en SSMS (BI-4 se hace en Power BI). Los scripts están en la carpeta `EXPERIMENTOS\BI` del repositorio. Los tiempos dependen de la computadora: los resultados de referencia sirven para comprobar que el experimento salió bien, no para obtener los mismos números.

## 12. Preparación de los experimentos

1. **Ten la Parte I terminada** (sección 9 comprobada). Si todavía no la tienes, lo mínimo es:
- Copia la carpeta `TXT\ceramicas_vale` del repositorio dentro de `C:\txt\`. Debe quedar `C:\txt\ceramicas_vale` con los 5 archivos .txt.
- Abre SSMS y ejecuta con F5, en este orden, los scripts de la carpeta `SQL SCRIPTS`: `01_base_transaccional.sql`, `02_crear_entorno_etl.sql` y `03_ETL_CARGA.sql`. Al final del 03 debe decir EXITOSO y OK.
2. **Usa los scripts del repositorio**, también el 03, que es la versión corregida. Los experimentos están en la carpeta `EXPERIMENTOS\BI`.
3. **Solo quien haga el BI-1:** revisa que en `C:\txt\ceramicas_vale` esté el archivo `operacionVenta_1000000.txt`.
4. **Cierra** Power BI, el navegador y otros programas pesados, y conecta la laptop al cargador. Si hay programas abiertos, los tiempos salen más altos.
5. **Saca los datos de tu computadora.** Abre una consulta nueva en SSMS, pega esto, pulsa F5 y toma una captura del resultado:

```sql
select cpu_count nucleos, physical_memory_kb / 1024 / 1024 memoria_gb, @@VERSION version
from sys.dm_os_sys_info
```

## 13. BI-1 · Volumen progresivo

### ¿Qué vamos a probar?

Si el negocio vende cada vez más, el ETL tiene más datos que procesar. Vamos a cargar **10 mil, 100 mil, 500 mil y 1 millón de ventas** y medir cuánto tarda el ETL con cada una. La meta del proyecto es que tarde **menos de 60 segundos**.

**Lo que esperamos:** que tarde más con más ventas, pero siempre menos de 60 s.

### Pasos

Repite los pasos 1 a 3 cuatro veces: con **10000**, **100000**, **500000** y **1000000**, en ese orden.

1. Abre `BI1_paso1_generar_ventas.sql`. En la línea `declare @ventas int = 10000` pon el volumen y pulsa **F5**. Abajo aparece el nombre del archivo de caja que corresponde.
2. Abre `03_ETL_CARGA.sql`, pulsa **Ctrl + G**, escribe **188** y Enter. En esa línea cambia el nombre del archivo por el que te dio el paso 1 (sin borrar las comillas) y guarda con **Ctrl + S**.
3. En el script 03 pulsa **F5 tres veces**, esperando a que termine cada una. Cada ejecución queda registrada con su tiempo.

Cuando termines los cuatro volúmenes:

4. Abre `BI1_paso3_resultados.sql` y pulsa **F5**. Toma la captura de las dos tablas: esos son tus resultados.
5. **Deja todo como estaba:** en el paso 1 pon `100000` y F5; en la línea 188 del script 03 pon `operacionVenta.txt`, guarda y pulsa F5 una vez.

Con 1 millón, el paso 1 tarda casi un minuto y cada ejecución del script 03 unos 25 segundos. En total son unos 10 minutos.

### Resultados de referencia

| Ventas | Filas en la tabla de hechos | Tiempo del ETL | Filas por segundo |
| --- | --- | --- | --- |
| 10 000 | 24 387 | 0.77 s | 31 836 |
| 100 000 | 242 023 | 3.49 s | 69 367 |
| 500 000 | 1 183 472 | 12.45 s | 95 088 |
| 1 000 000 | 2 327 810 | 23.06 s | 100 963 |


## 14. BI-2 · Cursor (fila por fila) vs. consulta por conjuntos

### ¿Qué vamos a probar?

Un **cursor** recorre una tabla **fila por fila**: lee una fila, hace algo con ella y pasa a la siguiente. Lo vimos en la semana 3. Una consulta **por conjuntos** (un `INSERT ... SELECT`) hace lo mismo con **todas las filas a la vez**, y es como lo hace nuestro ETL.

Es como copiar una lista de 240 mil nombres: el cursor los copia uno por uno a mano; la consulta por conjuntos saca una fotocopia de toda la lista.

El script carga las mismas filas de la tabla de hechos de las dos formas y mide cuánto tarda cada una.

**Lo que esperamos:** que el cursor sea mucho más lento.

### Pasos

1. Abre `BI2_cursor_vs_conjunto.sql`.
2. Pulsa **F5** y espera, menos de 1 minuto con 100 000 ventas.
3. Toma la captura de las tablas de resultados del final.

El script usa tablas de prueba y las borra al terminar: no cambia nada de la base.

### Resultados de referencia (100 000 ventas)

| Método | Filas cargadas | Tiempo | Filas por segundo | CPU usado |
| --- | --- | --- | --- | --- |
| A. Por conjuntos (INSERT...SELECT) | 242 023 | 0.40 s | 605 057 | 0.4 s |
| B. Fila por fila (CURSOR) | 242 023 | 26.09 s | 9 277 | 15.7 s |

**El cursor fue 65 veces más lento y usó 39 veces más procesador.** La última tabla confirma que los dos métodos cargaron el mismo total de dinero. La columna *memoria_sql_server_mb* muestra cuánta memoria usaba SQL Server al terminar cada método.


## 15. BI-3 · Transacciones: guardar día por día o todo de una vez

### ¿Qué vamos a probar?

El paso 5 del ETL arma el calendario (`dim_tiempo`) con un **WHILE** que inserta los días **uno por uno**. Cada inserción se **confirma** sola (un `COMMIT` por día): SQL Server la guarda en disco antes de pasar al siguiente día. Las transacciones las vimos en la semana 4.

El script genera un calendario de **50 años** (18 263 días) de tres formas:

- **A.** El WHILE tal como está en el ETL: un COMMIT por día.
- **B.** El mismo WHILE dentro de **una sola transacción** (`BEGIN TRAN` al inicio y un solo `COMMIT` al final, con `TRY...CATCH` y `ROLLBACK` por si algo falla).
- **C.** **Una sola consulta**, sin WHILE.

Es como escribir un documento: A es pulsar «Guardar» después de cada línea; B es escribir todo y guardar una sola vez al final.

**Lo que esperamos:** que B y C sean mucho más rápidos que A.

### Pasos

1. Abre `BI3_transacciones.sql`.
2. Pulsa **F5** y espera, unos 10 segundos. Cada forma se ejecuta 3 veces.
3. Toma la captura de las dos tablas de resultados.

El script usa una tabla de prueba y la borra al terminar: no cambia nada de la base.

### Resultados de referencia

| Forma | Días generados | Tiempo promedio | CPU usado | Veces más rápido que A |
| --- | --- | --- | --- | --- |
| A. WHILE con un COMMIT por día | 18 263 | 1 404 ms | 660 ms | 1.0 |
| B. WHILE dentro de un solo COMMIT | 18 263 | 125 ms | 127 ms | 11.2 |
| C. Una sola consulta (sin WHILE) | 18 263 | 142 ms | 124 ms | 9.9 |


## 16. BI-4 · Power BI: Importar vs. DirectQuery

### ¿Qué vamos a probar?

Cuando conectas Power BI a SQL Server te pregunta el **modo de conectividad**:

- **Importar:** Power BI copia los datos dentro del archivo `.pbix`. Para ver datos nuevos hay que pulsar *Actualizar*.
- **DirectQuery:** Power BI no copia nada; cada vez que se muestra un gráfico, le pregunta a SQL Server en ese momento.

Vamos a hacer **los mismos 4 gráficos** en dos archivos, uno con cada modo, y comparar tres cosas: qué tan rápido responden los gráficos, cuánto pesa el archivo y si los datos se ven al día.

**Lo que esperamos:** Importar responde más rápido pero pesa más; DirectQuery siempre muestra los datos al día.

**En este experimento no anotas nada:** todo se mide con capturas de pantalla.

### Pasos

**A. Archivo con Importar**

1. Abre Power BI Desktop → **Informe en blanco**.
2. **Inicio → Obtener datos → SQL Server.** Servidor: `.` (un punto). Base de datos: `CeramicasVale_DM`. Modo de conectividad: **Importar**. Aceptar. Si pide credenciales: **Windows → Usar mis credenciales actuales → Conectar**.
3. Marca `fac_ventas`, `dim_tiempo`, `dim_producto` y `dim_metodoPago`, y pulsa **Cargar**.
4. Crea estos 4 gráficos (elige el tipo en *Visualizaciones* y arrastra los campos):

| Gráfico | Campos |
| --- | --- |
| Tarjeta | `monto_vendido` (de fac_ventas) |
| Gráfico de columnas agrupadas | Eje X: `categoria` (de dim_producto) · Eje Y: `monto_vendido` |
| Gráfico de líneas | Eje X: `mes` (de dim_tiempo) · Eje Y: `monto_vendido` |
| Gráfico de anillos | Leyenda: `nombreMetodo` (de dim_metodoPago) · Valores: `monto_vendido` |

5. Guarda como `BI4_importar.pbix`.
6. Menú **Ver → Analizador de rendimiento**. En el panel que se abre pulsa **Iniciar grabación** y luego **Actualizar objetos visuales**. Aparece cada gráfico con su tiempo en milisegundos. Despliega cada uno con su flechita y toma la captura **BI4_01_importar_rendimiento.png**.

**B. Archivo con DirectQuery**

7. Repite los pasos 1 a 6, pero en el paso 2 elige **DirectQuery** y guarda como `BI4_directquery.pbix`. Captura: **BI4_02_directquery_rendimiento.png**. Aquí aparece una fila más, *Consulta directa*: es el tiempo que tardó SQL Server en responder.

**C. Tamaño de los archivos**

8. Cierra Power BI. Haz clic derecho sobre `BI4_importar.pbix` → **Propiedades** y toma la captura **BI4_03_importar_tamano.png**. Haz lo mismo con `BI4_directquery.pbix`: **BI4_04_directquery_tamano.png**.

**D. ¿Los datos se ven al día?**

9. Abre los dos archivos. En SSMS ejecuta este cambio de prueba, que suma 1 millón de soles a una venta:

```sql
update top (1) CeramicasVale_DM.dbo.fac_ventas set monto_vendido = monto_vendido + 1000000
```

10. En cada archivo pulsa **Actualizar objetos visuales** en el Analizador de rendimiento (no *Inicio → Actualizar*) y mira la tarjeta. En DirectQuery el total sube 1 millón; en Importar se queda igual. Toma la captura de cada uno: **BI4_05_importar_tarjeta.png** y **BI4_06_directquery_tarjeta.png**.
11. **Deshaz el cambio** ejecutando el script 03 una vez.

### Capturas que sirven como evidencia

| Captura | Qué se ve |
| --- | --- |
| BI4_01_importar_rendimiento | Milisegundos de cada gráfico con Importar |
| BI4_02_directquery_rendimiento | Milisegundos de cada gráfico con DirectQuery |
| BI4_03_importar_tamano | Peso del archivo con Importar |
| BI4_04_directquery_tamano | Peso del archivo con DirectQuery |
| BI4_05_importar_tarjeta | La tarjeta sin cambio, con Importar |
| BI4_06_directquery_tarjeta | La tarjeta con el millón sumado, con DirectQuery |

Este experimento no tiene resultados de referencia todavía, porque se hace a mano. Si algún paso no coincide con lo que ves en pantalla, avísalo.


## 17. Si algo sale mal en los experimentos

| Qué pasa | Qué hacer |
| --- | --- |
| El script 03 dice *no se puede abrir el archivo* | Falta el archivo en `C:\txt\ceramicas_vale` o está mal escrito en la línea 188 |
| En el BI-1 tu volumen sale como *otro volumen* | La línea 188 del script 03 tenía el archivo de otro volumen. Corrígela y ejecuta el script 03 otra vez |
| El script 03 termina en ERROR | Revisa la tabla de pasos que muestra al final: dice qué paso falló |
| Los tiempos cambian mucho entre ejecuciones | Hay programas abiertos. Ciérralos y repite |
| Aparecen muchas tablas al ejecutar el script 03 | Es normal: son los resultados de cada paso del ETL |
| Power BI no conecta | Tu servidor tiene otro nombre: en el paso 2 escribe el mismo nombre que usas al conectarte en SSMS |

# Parte III · Solución Big Data (Databricks)

**Pendiente:** esta parte se completará cuando la solución Big Data esté terminada. Incluirá, paso a paso:

- Crear una cuenta en Databricks Free Edition.
- Exportar los datos de SQL Server a archivos CSV.
- Subir los CSV a Databricks.
- Importar los notebooks y ejecutarlos en orden: carga, análisis exploratorio (EDA), limpieza y preparación, y tablas finales.
- Crear el dashboard en Databricks.
- Comprobar los resultados y resolver los problemas frecuentes.

# Parte IV · Experimentos de Big Data

**Pendiente:** se agregarán los pasos de los experimentos de Big Data más relevantes.

## Anexo A: estructura del repositorio

| Carpeta o archivo | Contenido |
| --- | --- |
| `SQL SCRIPTS/` | Los tres scripts: `01_base_transaccional.sql`, `02_crear_entorno_etl.sql` y `03_ETL_CARGA.sql` |
| `TXT/ceramicas_vale/` | Archivos del sistema de caja que lee el ETL |
| `DATOS/` | Catálogo real de la empresa: Excel original y su versión en CSV |
| `VISUAL/POWER BI/` | Dashboard (`.pbix`), imagen del modelo estrella y captura del dashboard |
| `VISUAL/SQL/` | Diagrama del modelo estrella en SQL Server |
| `EVIDENCIAS/` | Capturas de las pruebas con 10 000, 100 000 y 500 000 ventas |
| `EXPERIMENTOS/BI/` | Scripts y guía (PDF) de los experimentos de BI |
| `EVIDENCIAS/EXPERIMENTOS_BI/` | Capturas de los 4 experimentos de BI |
| `EVIDENCIAS BIG DATA/` | Notebook y capturas de la solución Big Data |
| `AUTOMATIZACION/` | `ejecutar_etl.bat` y la guía para programar el ETL |
| `DOCUMENTO_DE_REPLICACION` (.md, .docx y .pdf) | Este documento |
| `2026-2_ISC-Informe_Proyecto_Final_BASAV.docx` | Informe del proyecto |

## Anexo B: qué hace el ETL por dentro (detalle técnico)

Esta parte no es necesaria para replicar el proyecto; sirve para quien quiera entender el proceso.

La base de análisis `CeramicasVale_DM` usa un **modelo estrella**: la tabla de hechos `fac_ventas` (cantidad, monto, metraje, costo y descuento de cada venta) y cinco dimensiones (`dim_tiempo`, `dim_producto`, `dim_cliente`, `dim_proveedor` y `dim_metodoPago`). Las tablas `stg_` reciben los archivos de texto tal como llegan, y las tablas `etl_` registran cada ejecución.

| Paso | Qué hace | Corrección de datos |
| --- | --- | --- |
| 1. Limpieza | Vacía la base de análisis para cargarla de nuevo | – |
| 2. Proveedores | Carga `dim_proveedor` | Pasa a mayúsculas; ciudad vacía → NO ESPECIFICADO |
| 3. Productos | Carga `dim_producto` | Ordena el texto, deduce la categoría (vacía en 1 957 productos), descarta 17 precios de prueba y marca el stock crítico |
| 4. Clientes | Carga `dim_cliente` | Corrige nombres mal escritos, completa el distrito vacío y marca como VIP al 10 % que más compra |
| 5. Tiempo | Crea el calendario `dim_tiempo` | – |
| 6. Métodos de pago | Lee `metodopago.txt` | Quita espacios y códigos repetidos |
| 7. Caja | Lee `operacionVenta.txt` | Detecta comprobantes repetidos y métodos que no existen |
| 8. Ventas | Carga `fac_ventas` | Excluye ventas anuladas y líneas con precio 0; convierte m² a cajas |
| 9. Reconciliación | Compara el total vendido de las dos bases | Debe dar OK |

Cada paso guarda su duración en `etl_bitacora`, y lo que descarta queda en `etl_errores` con su motivo. Las ventas se generan con el procedimiento `sp_generar_ventas` a partir de un número fijo (la semilla 2026), por eso salen iguales en cualquier computadora.
