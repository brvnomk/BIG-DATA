# Databricks notebook source
# MAGIC %md
# MAGIC # Cerámicas Vale · Solución Big Data en Databricks
# MAGIC
# MAGIC Este notebook procesa los datos de ventas de Cerámicas Vale con **Apache Spark** siguiendo la **arquitectura Medallion**:
# MAGIC
# MAGIC | Capa | Qué guarda | Tablas |
# MAGIC | --- | --- | --- |
# MAGIC | **Bronze** | Los archivos tal como llegan, sin tocar | `bronze_*` |
# MAGIC | **Silver** | Los datos limpios y validados | `silver_*` |
# MAGIC | **Gold** | El modelo estrella y los indicadores listos para el dashboard | `dim_*`, `fac_ventas`, `kpi_*` |
# MAGIC
# MAGIC **Orden:** configuración → Bronze (carga) → **EDA** (análisis exploratorio) → Silver (limpieza) → Gold (modelo e indicadores) → reconciliación → calidad antes vs. después → indicadores → resultados del experimento BD-1.
# MAGIC
# MAGIC **Cómo se usa:** elige el volumen de ventas en el cuadro de arriba (*1. Volumen de ventas*) y pulsa **Run all** (Ejecutar todo).
# MAGIC Antes, sube los archivos al volumen `workspace.ceramicas_vale.datos` (ver la guía).

# COMMAND ----------

# MAGIC %md
# MAGIC ## 1. Configuración

# COMMAND ----------

import math
import time
from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.window import Window

dbutils.widgets.dropdown("ventas", "100000", ["10000", "100000", "500000", "1000000"], "1. Volumen de ventas")
VENTAS = int(dbutils.widgets.get("ventas"))

CATALOGO = "workspace"
ESQUEMA  = "ceramicas_vale"
VOLUMEN  = "datos"
RUTA     = f"/Volumes/{CATALOGO}/{ESQUEMA}/{VOLUMEN}"

ARCHIVO_CAJA = {10000: "operacionVenta_10000.txt", 100000: "operacionVenta.txt",
                500000: "operacionVenta_500000.txt", 1000000: "operacionVenta_1000000.txt"}[VENTAS]

print(f"Volumen: {VENTAS:,} ventas | archivo de caja: {ARCHIVO_CAJA} | archivos en: {RUTA}")

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1.1 Esquema, volumen y revisión de archivos
# MAGIC La primera vez crea el esquema `ceramicas_vale` y el volumen `datos`, donde se suben los archivos. Si falta alguno, el notebook se detiene y dice cuál.

# COMMAND ----------

spark.sql(f"create schema if not exists {CATALOGO}.{ESQUEMA}")
spark.sql(f"create volume if not exists {CATALOGO}.{ESQUEMA}.{VOLUMEN}")
spark.sql(f"use catalog {CATALOGO}")
spark.sql(f"use schema {ESQUEMA}")

necesarios = ["proveedores.csv", "productos.csv", "clientes.csv",
              f"ventas_{VENTAS}.csv", f"detalle_ventas_{VENTAS}.csv",
              "metodopago.txt", ARCHIVO_CAJA]
subidos = [f.name for f in dbutils.fs.ls(RUTA)]
faltan = [a for a in necesarios if a not in subidos]
if faltan:
    raise Exception(f"Faltan estos archivos en {RUTA}: {faltan}. Súbelos al volumen (ver la guía) y vuelve a ejecutar.")
print("Todos los archivos están en", RUTA)

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1.2 Funciones de apoyo
# MAGIC - `guardar` y `leer`: guardan y leen tablas Delta de Databricks (**persistencia**: los datos quedan guardados aunque se cierre el notebook).
# MAGIC - `registrar_errores`: anota cada dato descartado o corregido con su motivo en `etl_errores`.
# MAGIC - `paso`: anota en la bitácora cuánto tardó cada paso y cuántas filas procesó.

# COMMAND ----------

bitacora = []
INICIO_ETL = datetime.now()

def tabla(nombre):
    return f"{CATALOGO}.{ESQUEMA}.{nombre}"

def guardar(df, nombre):
    df.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(tabla(nombre))
    return leer(nombre).count()

def leer(nombre):
    return spark.table(tabla(nombre))

def existe(nombre):
    return spark.catalog.tableExists(tabla(nombre))

def anexar(df, nombre):
    df.write.mode("append").saveAsTable(tabla(nombre))

ID = 1
if existe("etl_ejecucion"):
    ID = (leer("etl_ejecucion").agg(F.max("id_ejecucion")).first()[0] or 0) + 1

def registrar_errores(df):
    anexar(df.select(F.lit(ID).alias("id_ejecucion"), "origen",
                     F.col("clave").cast("string").alias("clave"), "motivo"), "etl_errores")

def paso(proceso, inicio, filas, estado="EXITOSO", mensaje=None):
    fin = datetime.now()
    ms = int((fin - inicio).total_seconds() * 1000)
    bitacora.append((ID, proceso, inicio, fin, ms, int(filas), estado, mensaje))
    print(f"{proceso:<34} {ms:>8,} ms {int(filas):>12,} filas  {estado}")

def texto(columna):
    """Quita espacios al inicio y al final, y caracteres invisibles (\\r, \\0)."""
    return F.trim(F.regexp_replace(F.col(columna), "[\\x00\\r]", ""))

def vacio_a_nulo(col):
    return F.when(col == "", None).otherwise(col)

print("Ejecución N.°", ID)

# COMMAND ----------

# MAGIC %md
# MAGIC ## 2. Capa Bronze · Carga de los archivos tal como llegan
# MAGIC Se leen los 5 CSV exportados de SQL Server y los 2 archivos de caja en **DataFrames de Spark**, con su estructura de columnas, **sin limpiar nada**.
# MAGIC Así siempre se puede volver al dato original.

# COMMAND ----------

inicio = datetime.now()
lector = spark.read.option("sep", "|").option("header", "false").option("encoding", "UTF-8")

origenes = {
    "bronze_proveedores":    ("proveedores.csv", "id_proveedor int, ruc string, razon_social string, telefono string, ciudad string"),
    "bronze_productos":      ("productos.csv", "codigo_interno string, descripcion string, unidad_medida string, marca string, "
                                               "precio decimal(10,2), categoria string, m2_por_caja decimal(6,2), "
                                               "costo_unitario decimal(10,2), stock_actual int, stock_minimo int, "
                                               "estado string, id_proveedor int"),
    "bronze_clientes":       ("clientes.csv", "id_cliente int, tipo_documento string, nro_documento string, nombre string, distrito string"),
    "bronze_ventas":         (f"ventas_{VENTAS}.csv", "id_venta int, tipo_comprobante string, serie_numero string, fecha timestamp, "
                                                      "id_cliente int, estado string, total decimal(12,2)"),
    "bronze_detalle_ventas": (f"detalle_ventas_{VENTAS}.csv", "id_venta int, item int, codigo_interno string, cantidad decimal(10,2), "
                                                              "precio_unitario decimal(10,2), descuento_pct decimal(4,2)"),
}
filas = 0
for nombre, (archivo, esquema) in origenes.items():
    df = lector.schema(esquema).option("timestampFormat", "yyyy-MM-dd HH:mm:ss").csv(f"{RUTA}/{archivo}")
    filas += guardar(df, nombre)

# Archivos del sistema de caja: se leen como texto, tal cual
filas += guardar(spark.read.option("sep", ",").option("header", "false")
                      .schema("codigo string, nombre string").csv(f"{RUTA}/metodopago.txt"), "bronze_metodopago")
filas += guardar(spark.read.option("sep", "|").option("header", "true")
                      .schema("comprobante string, metodo string").csv(f"{RUTA}/{ARCHIVO_CAJA}"), "bronze_operacion")
paso("1. Bronze: carga de archivos", inicio, filas)

display(spark.createDataFrame([(n, leer(n).count(), len(leer(n).columns)) for n in
         ["bronze_proveedores", "bronze_productos", "bronze_clientes", "bronze_ventas",
          "bronze_detalle_ventas", "bronze_metodopago", "bronze_operacion"]],
        "tabla string, filas long, columnas int"))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 3. EDA · Análisis exploratorio de los datos crudos
# MAGIC Antes de limpiar, hay que **saber qué se cargó**: cuántos registros y columnas hay, cuántos valores están vacíos o repetidos, los mínimos y máximos, y qué valores raros aparecen.
# MAGIC Todo se calcula sobre la capa **Bronze**, es decir, sobre los datos tal como llegaron.

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.1 Perfil de cada columna: nulos, vacíos y valores distintos

# COMMAND ----------

def perfil(nombre):
    df = leer(nombre)
    total = df.count()
    filas = []
    for campo in df.schema.fields:
        c = F.col(campo.name)
        es_texto = campo.dataType.simpleString() == "string"
        r = df.agg(F.sum(c.isNull().cast("int")).alias("nulos"),
                   (F.sum((F.trim(c) == "").cast("int")) if es_texto else F.lit(0)).alias("vacios"),
                   F.countDistinct(c).alias("distintos")).first()
        filas.append((nombre, campo.name, campo.dataType.simpleString(), total,
                      int(r["nulos"] or 0), int(r["vacios"] or 0), int(r["distintos"])))
    return filas

perfil_bronze = []
for nombre in ["bronze_proveedores", "bronze_productos", "bronze_clientes", "bronze_ventas", "bronze_detalle_ventas"]:
    perfil_bronze += perfil(nombre)
eda_perfil = spark.createDataFrame(perfil_bronze, "tabla string, columna string, tipo string, filas long, nulos long, vacios long, distintos long")
guardar(eda_perfil, "eda_perfil")
display(eda_perfil.withColumn("pct_nulos_o_vacios", F.round(100 * (F.col("nulos") + F.col("vacios")) / F.col("filas"), 2)))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.2 Estadística descriptiva de las columnas numéricas (`describe`)
# MAGIC Cantidad de valores, promedio, desviación estándar, mínimo y máximo.

# COMMAND ----------

display(leer("bronze_productos").select("precio", "costo_unitario", "m2_por_caja", "stock_actual", "stock_minimo").describe())
display(leer("bronze_detalle_ventas").select("cantidad", "precio_unitario", "descuento_pct").describe())
display(leer("bronze_ventas").select("total").describe())
display(leer("bronze_ventas").agg(F.min("fecha").alias("primera_venta"), F.max("fecha").alias("ultima_venta"),
                                  F.countDistinct(F.to_date("fecha")).alias("dias_con_ventas")))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.3 Valores de las columnas de categorías
# MAGIC Sirve para ver errores de escritura: espacios de más, mayúsculas y minúsculas mezcladas o códigos que no existen.

# COMMAND ----------

display(leer("bronze_ventas").groupBy("estado").count().orderBy(F.desc("count")))
display(leer("bronze_ventas").groupBy("tipo_comprobante").count().orderBy(F.desc("count")))
display(leer("bronze_productos").groupBy("unidad_medida").count().orderBy(F.desc("count")))
display(leer("bronze_proveedores").groupBy("ciudad").count().orderBy(F.desc("count")))
display(leer("bronze_metodopago"))
display(leer("bronze_operacion").groupBy("metodo").count().orderBy("metodo"))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.4 Duplicados y valores atípicos
# MAGIC Resumen de los problemas que la capa Silver tiene que corregir.

# COMMAND ----------

ventas_b, detalle_b = leer("bronze_ventas"), leer("bronze_detalle_ventas")
productos_b, clientes_b = leer("bronze_productos"), leer("bronze_clientes")
operacion_b, metodos_b = leer("bronze_operacion"), leer("bronze_metodopago")

def n(df, condicion=None):
    return (df.filter(condicion) if condicion is not None else df).count()

nombre_sucio = lambda c: (F.col(c) != F.upper(F.col(c))) | F.col(c).contains("  ") | (F.col(c) != F.trim(F.col(c)))
codigos_validos = [r[0] for r in metodos_b.select(texto("codigo")).distinct().collect()]

hallazgos = [
    ("Ventas", "Comprobantes ANULADOS", n(ventas_b, F.trim("estado") == "ANULADO")),
    ("Ventas", "Comprobantes repetidos (id_venta)", ventas_b.count() - ventas_b.dropDuplicates(["id_venta"]).count()),
    ("Detalle", "Líneas con precio o cantidad <= 0", n(detalle_b, (F.col("precio_unitario") <= 0) | (F.col("cantidad") <= 0))),
    ("Detalle", "Líneas con descuento fuera de 0 a 1", n(detalle_b, (F.col("descuento_pct") < 0) | (F.col("descuento_pct") > 1))),
    ("Productos", "Sin categoría", n(productos_b, F.col("categoria").isNull() | (F.trim("categoria") == ""))),
    ("Productos", "Precio de prueba (<= S/ 1)", n(productos_b, F.col("precio") <= 1)),
    ("Productos", "Descripción con minúsculas o espacios de más", n(productos_b, nombre_sucio("descripcion"))),
    ("Productos", "Cerámicos sin m2 por caja", n(productos_b, F.trim("unidad_medida").isin("MTK", "BX") & F.col("m2_por_caja").isNull())),
    ("Clientes", "Nombre con minúsculas o espacios de más", n(clientes_b, nombre_sucio("nombre"))),
    ("Clientes", "Sin distrito", n(clientes_b, F.col("distrito").isNull() | (F.trim("distrito") == ""))),
    ("Caja", "Comprobantes repetidos en el archivo", operacion_b.count() - operacion_b.dropDuplicates(["comprobante"]).count()),
    ("Caja", "Método de pago que no existe", n(operacion_b, ~texto("metodo").isin(codigos_validos))),
    ("Métodos de pago", "Códigos repetidos", metodos_b.count() - metodos_b.dropDuplicates(["codigo"]).count()),
]
eda_hallazgos = spark.createDataFrame(hallazgos, "tabla string, problema string, registros long")
guardar(eda_hallazgos, "eda_hallazgos")
display(eda_hallazgos)

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.5 Comportamiento de las ventas
# MAGIC ¿Cómo se reparten las ventas en el tiempo? Sirve para comprobar que los datos tienen patrones realistas (por ejemplo, el sábado es el día fuerte).

# COMMAND ----------

emitidas_b = ventas_b.filter(F.trim("estado") == "EMITIDO")
display(emitidas_b.groupBy(F.date_format("fecha", "E").alias("dia"), F.dayofweek("fecha").alias("n"))
                  .agg(F.count("*").alias("comprobantes"), F.round(F.sum("total"), 2).alias("total"))
                  .orderBy("n"))
display(emitidas_b.groupBy(F.year("fecha").alias("anio"), F.month("fecha").alias("mes"))
                  .agg(F.round(F.sum("total"), 2).alias("total")).orderBy("anio", "mes"))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 4. Capa Silver · Limpieza y preparación
# MAGIC Cada tabla se limpia con operaciones de DataFrame: `select`, `filter`, `withColumnRenamed`, `withColumn`, `na.fill`, `dropDuplicates`, `join`, `groupBy`, `cast`.
# MAGIC Lo que se descarta o corrige queda anotado en `etl_errores` con su motivo.

# COMMAND ----------

# MAGIC %md
# MAGIC ### 4.1 Proveedores
# MAGIC Texto sin espacios de más, razón social y ciudad en mayúsculas, y ciudad vacía → `NO ESPECIFICADO`.

# COMMAND ----------

inicio = datetime.now()
silver_proveedores = (leer("bronze_proveedores")
    .withColumnRenamed("id_proveedor", "pk_proveedor")
    .select("pk_proveedor",
            texto("ruc").alias("ruc"),
            F.upper(texto("razon_social")).alias("razon_social"),
            vacio_a_nulo(F.upper(texto("ciudad"))).alias("ciudad"))
    .na.fill({"ciudad": "NO ESPECIFICADO"})
    .dropDuplicates(["pk_proveedor"]))
paso("2. Silver: proveedores", inicio, guardar(silver_proveedores, "silver_proveedores"))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 4.2 Productos
# MAGIC Se descartan los precios de prueba (≤ S/ 1), se ordena el texto y se **deduce la categoría** a partir de la descripción y la unidad de medida (el catálogo la trae vacía en casi todos los productos). También se marca el stock crítico.

# COMMAND ----------

def categoria(descripcion, unidad):
    d, u = F.col(descripcion), F.col(unidad)
    def tiene(*palabras):
        cond = F.lit(False)
        for p in palabras:
            cond = cond | d.contains(p)
        return cond
    return (F.when(u.isin("MTK", "BX") & tiene("PORCELANATO"), "PORCELANATOS")
             .when(u.isin("MTK", "BX"), "CERAMICOS")
             .when(tiene("INODORO", "INNODORO", "LAVATORIO", "OVALIN", "LAVADERO", "URINARIO", "ONE PIECE", "TANQUE"), "SANITARIOS")
             .when(tiene("DUCHA", "MEZCLADORA", "PICO DE GANZO", "GRIFO", "LLAVE", "MONOCOMANDO", "GRIFERIA"), "GRIFERIA")
             .when(tiene("PEGAMENTO", "FRAGUA", "SILICONA", "CEMENTO", "TEROKAL"), "PEGAMENTOS Y FRAGUAS")
             .when(tiene("PERFIL", "CUÑA", "NIVELADOR", "CANTONERA") | (u == "MTR"), "PERFILES Y NIVELACION")
             .when(tiene("DECORADO", "DECO ", "LISTELO", "PEPELMA", "CENEFA", "MOSAICO"), "DECORADOS")
             .otherwise("ACCESORIOS Y OTROS"))

inicio = datetime.now()
productos = leer("bronze_productos")
registrar_errores(productos.filter(F.col("precio") <= 1)
                  .select(F.lit("PRODUCTOS").alias("origen"), F.col("codigo_interno").alias("clave"),
                          F.lit("Precio <= 1 (valor de prueba)").alias("motivo")))

silver_productos = (productos
    .filter(F.col("precio") > 1)
    .withColumnRenamed("codigo_interno", "pk_producto")
    .withColumnRenamed("id_proveedor", "pk_proveedor")
    .select(texto("pk_producto").alias("pk_producto"),
            F.trim(F.regexp_replace(F.upper(texto("descripcion")), "\\s+", " ")).alias("descripcion"),
            F.upper(texto("marca")).alias("marca"),
            F.upper(texto("unidad_medida")).alias("unidad_medida"),
            "m2_por_caja", "precio", "costo_unitario", "stock_actual", "stock_minimo", "pk_proveedor")
    .na.fill({"marca": "GENERICO"})
    .withColumn("categoria", categoria("descripcion", "unidad_medida"))
    .withColumn("estado_stock", F.when(F.col("stock_actual") <= F.col("stock_minimo"), "CRITICO").otherwise("NORMAL"))
    .dropDuplicates(["pk_producto"]))
paso("3. Silver: productos", inicio, guardar(silver_productos, "silver_productos"))
display(leer("silver_productos").groupBy("categoria").count().orderBy(F.desc("count")))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 4.3 Clientes
# MAGIC Nombres en mayúsculas y sin espacios dobles, y distrito vacío → `NO ESPECIFICADO`.

# COMMAND ----------

inicio = datetime.now()
silver_clientes = (leer("bronze_clientes")
    .withColumnRenamed("id_cliente", "pk_cliente")
    .select("pk_cliente",
            texto("tipo_documento").alias("tipo_documento"),
            texto("nro_documento").alias("nro_documento"),
            F.upper(F.regexp_replace(texto("nombre"), " {2,}", " ")).alias("nombre"),
            vacio_a_nulo(F.upper(texto("distrito"))).alias("distrito"))
    .na.fill({"distrito": "NO ESPECIFICADO"})
    .dropDuplicates(["pk_cliente"]))
paso("4. Silver: clientes", inicio, guardar(silver_clientes, "silver_clientes"))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 4.4 Métodos de pago y operaciones de caja
# MAGIC - Métodos de pago: sin espacios, en mayúsculas, sin códigos repetidos, más el valor `NO REGISTRADO`.
# MAGIC - Caja: un comprobante repetido se queda con un solo método (el de menor código), y se anotan los métodos que no existen.

# COMMAND ----------

inicio = datetime.now()
no_registrado = spark.createDataFrame([(0, "NO REGISTRADO")], "pk_metodoP int, nombreMetodo string")
silver_metodopago = (leer("bronze_metodopago")
    .select(texto("codigo").try_cast("int").alias("pk_metodoP"),
            F.upper(texto("nombre")).alias("nombreMetodo"))
    .filter(F.col("pk_metodoP").isNotNull())
    .dropDuplicates(["pk_metodoP"])
    .unionByName(no_registrado))
filas = guardar(silver_metodopago, "silver_metodopago")

operacion = leer("bronze_operacion").select(texto("comprobante").alias("comprobante"),
                                            texto("metodo").try_cast("int").alias("pk_metodoP"))
registrar_errores(operacion.groupBy("comprobante").count().filter(F.col("count") > 1)
                  .select(F.lit("operacionVenta.txt").alias("origen"), F.col("comprobante").alias("clave"),
                          F.lit("Comprobante duplicado en archivo de caja").alias("motivo")))
registrar_errores(operacion.join(leer("silver_metodopago"), "pk_metodoP", "left_anti")
                  .select(F.lit("operacionVenta.txt").alias("origen"), F.col("comprobante").alias("clave"),
                          F.concat(F.lit("Método de pago inexistente: "), F.col("pk_metodoP").cast("string")).alias("motivo")))
silver_operacion = (operacion
    .join(leer("silver_metodopago").select("pk_metodoP"), "pk_metodoP")      # solo métodos que existen
    .groupBy("comprobante").agg(F.min("pk_metodoP").alias("pk_metodoP")))   # un método por comprobante
filas += guardar(silver_operacion, "silver_operacion")
paso("5. Silver: métodos de pago y caja", inicio, filas)
display(leer("silver_metodopago").orderBy("pk_metodoP"))

# COMMAND ----------

# MAGIC %md
# MAGIC ### 4.5 Ventas y detalle
# MAGIC Se unen las ventas con su detalle y se quedan solo los comprobantes **EMITIDOS** con precio y cantidad mayores a 0.
# MAGIC Las ventas sin pago en caja se marcan como `NO REGISTRADO` (no se pierden).

# COMMAND ----------

inicio = datetime.now()
V = (leer("bronze_ventas")
     .withColumnRenamed("id_cliente", "pk_cliente")
     .withColumn("estado", F.upper(texto("estado")))
     .withColumn("serie_numero", texto("serie_numero")))
D = leer("bronze_detalle_ventas").withColumn("codigo_interno", texto("codigo_interno"))
VD = V.join(D, "id_venta")
emitido = F.col("estado") == "EMITIDO"
validas = (F.col("precio_unitario") > 0) & (F.col("cantidad") > 0)

registrar_errores(VD.filter(emitido & ~validas)
                  .select(F.lit("DETALLE_VENTAS").alias("origen"),
                          F.concat("serie_numero", F.lit(" / ítem "), F.col("item").cast("string")).alias("clave"),
                          F.lit("Precio o cantidad <= 0").alias("motivo")))
registrar_errores(V.filter(emitido)
                  .join(leer("silver_operacion").withColumnRenamed("comprobante", "serie_numero"), "serie_numero", "left_anti")
                  .select(F.lit("VENTAS").alias("origen"), F.col("serie_numero").alias("clave"),
                          F.lit("Comprobante sin registro de pago (se carga como NO REGISTRADO)").alias("motivo")))

silver_ventas_detalle = (VD.filter(emitido & validas)
    .join(leer("silver_operacion").withColumnRenamed("comprobante", "serie_numero"), "serie_numero", "left")
    .na.fill({"pk_metodoP": 0})
    .withColumnRenamed("codigo_interno", "pk_producto")
    .withColumn("fecha", F.to_date("fecha"))
    .select("id_venta", "item", "serie_numero", "fecha", "pk_cliente", "pk_producto", "pk_metodoP",
            "cantidad", "precio_unitario", "descuento_pct"))
paso("6. Silver: ventas y detalle", inicio, guardar(silver_ventas_detalle, "silver_ventas_detalle"))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 5. Capa Gold · Modelo estrella e indicadores
# MAGIC ### 5.1 Dimensiones
# MAGIC Las mismas cinco dimensiones del Data Mart de SQL Server: proveedor, producto, cliente (con el 10 % que más compra marcado como **VIP**), tiempo y método de pago.

# COMMAND ----------

inicio = datetime.now()
filas = 0
filas += guardar(leer("silver_proveedores")
                 .withColumn("id_proveedor", F.row_number().over(Window.orderBy("pk_proveedor")))
                 .select("id_proveedor", "pk_proveedor", "ruc", "razon_social", "ciudad"), "dim_proveedor")

filas += guardar(leer("silver_productos")
                 .withColumn("id_producto", F.row_number().over(Window.orderBy("pk_producto")))
                 .select("id_producto", "pk_producto", "descripcion", "categoria", "marca", "unidad_medida", "m2_por_caja",
                         "precio", "costo_unitario", "stock_actual", "stock_minimo", "estado_stock"), "dim_producto")

# VIP: 10 % de los clientes identificados (sin CLIENTES VARIOS) que más compran
venta_linea = F.col("cantidad") * F.col("precio_unitario") * (1 - F.col("descuento_pct"))
compras = (leer("silver_ventas_detalle")
           .join(leer("silver_clientes").filter(F.col("nro_documento") != "00000000").select("pk_cliente"), "pk_cliente")
           .groupBy("pk_cliente").agg(F.sum(venta_linea).alias("total")))
vip = (compras.orderBy(F.desc("total")).limit(math.ceil(compras.count() * 0.10))
              .select("pk_cliente", F.lit("VIP").alias("vip")))
filas += guardar(leer("silver_clientes")
                 .join(vip, "pk_cliente", "left")
                 .withColumn("tipo_cliente", F.coalesce("vip", F.lit("REGULAR")))
                 .withColumn("id_cliente", F.row_number().over(Window.orderBy("pk_cliente")))
                 .select("id_cliente", "pk_cliente", "tipo_documento", "nro_documento", "nombre", "distrito", "tipo_cliente"),
                 "dim_cliente")

MESES = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto",
         "Septiembre", "Octubre", "Noviembre", "Diciembre"]
DIAS  = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
filas += guardar(leer("silver_ventas_detalle")
                 .agg(F.min("fecha").alias("ini"), F.max("fecha").alias("fin"))
                 .select(F.explode(F.sequence("ini", "fin")).alias("fecha"))
                 .select("fecha",
                         F.year("fecha").alias("anio"),
                         F.quarter("fecha").alias("trimestre"),
                         F.month("fecha").alias("mes"),
                         F.element_at(F.array(*[F.lit(m) for m in MESES]), F.month("fecha")).alias("nombreMes"),
                         F.weekofyear("fecha").alias("semana"),
                         F.dayofmonth("fecha").alias("diaMes"),
                         F.element_at(F.array(*[F.lit(d) for d in DIAS]), F.dayofweek("fecha")).alias("diaSemana")),
                 "dim_tiempo")

filas += guardar(leer("silver_metodopago")
                 .withColumn("id_metodoP", F.row_number().over(Window.orderBy("pk_metodoP")))
                 .select("id_metodoP", "pk_metodoP", "nombreMetodo"), "dim_metodoPago")
paso("7. Gold: dimensiones", inicio, filas)

# COMMAND ----------

# MAGIC %md
# MAGIC ### 5.2 Tabla de hechos `fac_ventas` e indicadores (`kpi_*`)
# MAGIC Un registro por cliente × producto × proveedor × método de pago × día. Los cerámicos se venden en m² y se convierten a cajas.
# MAGIC Las tablas `kpi_*` quedan listas para el dashboard.

# COMMAND ----------

inicio = datetime.now()
P = leer("dim_producto").select("id_producto", "pk_producto", "unidad_medida", "m2_por_caja", "costo_unitario")
cant, m2, um = F.col("cantidad"), F.col("m2_por_caja"), F.col("unidad_medida")
precio, desc = F.col("precio_unitario"), F.col("descuento_pct")
divisor = F.when(m2.isNull() | (m2 == 0), F.lit(1)).otherwise(m2)

fac_ventas = (leer("silver_ventas_detalle")
    .join(P, "pk_producto")                                             # solo productos válidos
    .join(leer("silver_productos").select("pk_producto", "pk_proveedor"), "pk_producto")
    .join(leer("dim_proveedor").select("pk_proveedor", "id_proveedor"), "pk_proveedor")
    .join(leer("dim_cliente").select("pk_cliente", "id_cliente"), "pk_cliente")
    .join(leer("dim_metodoPago").select("pk_metodoP", "id_metodoP"), "pk_metodoP")
    .groupBy("id_cliente", "id_producto", "id_proveedor", "id_metodoP", "fecha")
    .agg(F.sum(F.when(um == "MTK", cant / divisor).otherwise(cant)).alias("cantidad"),
         F.sum(cant * precio * (1 - desc)).alias("monto_vendido"),
         F.sum(F.when(um == "MTK", cant).when(um == "BX", cant * F.coalesce(m2, F.lit(0))).otherwise(F.lit(0))).alias("metraje_vendido"),
         F.sum(cant * F.col("costo_unitario")).alias("costo_inventario"),
         F.sum(cant * precio * desc).alias("descuento")))
filas_hechos = guardar(fac_ventas, "fac_ventas")

fac = leer("fac_ventas")
kpis = {
    "kpi_ventas_mes": fac.join(leer("dim_tiempo"), "fecha")
                         .groupBy("anio", "mes", "nombreMes")
                         .agg(F.round(F.sum("monto_vendido"), 2).alias("ventas"),
                              F.round(F.sum("monto_vendido") - F.sum("costo_inventario"), 2).alias("margen"),
                              F.round(F.sum("metraje_vendido"), 2).alias("metraje_m2")),
    "kpi_categoria": fac.join(leer("dim_producto"), "id_producto")
                        .groupBy("categoria")
                        .agg(F.round(F.sum("monto_vendido"), 2).alias("ventas"),
                             F.round(F.sum("metraje_vendido"), 2).alias("metraje_m2"),
                             F.round(100 * (F.sum("monto_vendido") - F.sum("costo_inventario")) / F.sum("monto_vendido"), 2).alias("margen_pct")),
    "kpi_metodo_pago": fac.join(leer("dim_metodoPago"), "id_metodoP")
                          .groupBy("nombreMetodo").agg(F.round(F.sum("monto_vendido"), 2).alias("ventas")),
    "kpi_proveedores": fac.join(leer("dim_proveedor"), "id_proveedor")
                          .groupBy("razon_social").agg(F.round(F.sum("monto_vendido"), 2).alias("ventas")),
    "kpi_clientes": fac.join(leer("dim_cliente"), "id_cliente")
                       .groupBy("tipo_cliente", "distrito")
                       .agg(F.countDistinct("id_cliente").alias("clientes"), F.round(F.sum("monto_vendido"), 2).alias("ventas")),
    "kpi_dia_semana": fac.join(leer("dim_tiempo"), "fecha")
                         .groupBy("diaSemana", F.dayofweek("fecha").alias("n_dia"))
                         .agg(F.round(F.sum("monto_vendido"), 2).alias("ventas")),
    "kpi_stock_critico": leer("dim_producto").filter(F.col("estado_stock") == "CRITICO")
                            .groupBy("categoria").agg(F.count("*").alias("productos_criticos")),
}
for nombre, df in kpis.items():
    guardar(df, nombre)
paso("8. Gold: fac_ventas e indicadores", inicio, filas_hechos)
display(leer("fac_ventas").limit(20))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 6. Reconciliación y registro de la ejecución
# MAGIC Se compara el total vendido de los datos originales con el de `fac_ventas`. Si coinciden (con una tolerancia mínima por redondeo), no se perdió ni se duplicó ninguna venta.

# COMMAND ----------

inicio = datetime.now()
origen = (leer("bronze_ventas").filter(F.upper(texto("estado")) == "EMITIDO")
          .join(leer("bronze_detalle_ventas").withColumn("codigo_interno", texto("codigo_interno")), "id_venta")
          .filter(validas)
          .join(leer("bronze_productos").filter(F.col("precio") > 1)
                .select(texto("codigo_interno").alias("codigo_interno")), "codigo_interno")
          .agg(F.sum(cant * precio * (1 - desc))).first()[0])
destino = leer("fac_ventas").agg(F.sum("monto_vendido")).first()[0]
origen, destino = float(origen or 0), float(destino or 0)
dif = destino - origen
estado_rec = "OK" if abs(dif) <= abs(origen) * 0.000001 + 0.01 else "DIFERENCIA"
mensaje = f"Origen S/ {origen:,.2f} | Databricks S/ {destino:,.2f} | Diferencia S/ {dif:,.4f}"
paso("9. Reconciliación", inicio, filas_hechos, estado_rec, mensaje)
print(mensaje)

fin_etl = datetime.now()
pasos_ok = sum(1 for b in bitacora if b[6] == "EXITOSO" and not b[1].startswith("9."))
estado_final = "EXITOSO" if pasos_ok == 8 and estado_rec == "OK" else "ERROR"
anexar(spark.createDataFrame(bitacora, "id_ejecucion int, proceso string, hora_inicio timestamp, hora_fin timestamp, "
                                       "duracion_ms long, filas_procesadas long, estado string, mensaje string"), "etl_bitacora")
anexar(spark.createDataFrame([(ID, f"{VENTAS} ventas", VENTAS, INICIO_ETL, fin_etl,
                               int((fin_etl - INICIO_ETL).total_seconds() * 1000), filas_hechos, estado_final,
                               None if estado_final == "EXITOSO" else f"{pasos_ok} de 8 pasos exitosos; reconciliación {estado_rec}")],
                             "id_ejecucion int, escenario string, ventas int, fecha_inicio timestamp, fecha_fin timestamp, "
                             "duracion_ms long, filas_hechos long, estado string, mensaje string"), "etl_ejecucion")

print(f"Ejecución {ID}: {estado_final} en {(fin_etl - INICIO_ETL).total_seconds():.2f} s")
display(leer("etl_bitacora").filter(F.col("id_ejecucion") == ID)
        .orderBy("hora_inicio").select("proceso", "duracion_ms", "filas_procesadas", "estado", "mensaje"))
display(leer("etl_errores").filter(F.col("id_ejecucion") == ID).groupBy("origen", "motivo").count().orderBy("origen"))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 7. Calidad de datos: antes (Bronze) vs. después (Silver/Gold)

# COMMAND ----------

bronze_cli, bronze_prod = leer("bronze_clientes"), leer("bronze_productos")
gold_cli, gold_prod = leer("dim_cliente"), leer("dim_producto")
calidad = [
    ("Clientes con nombre en minúsculas o espacios de más", n(bronze_cli, nombre_sucio("nombre")), n(gold_cli, nombre_sucio("nombre"))),
    ("Clientes sin distrito (después: NO ESPECIFICADO)",
        n(bronze_cli, F.col("distrito").isNull() | (F.trim("distrito") == "")), n(gold_cli, F.col("distrito").isNull())),
    ("Productos sin categoría", n(bronze_prod, F.col("categoria").isNull() | (F.trim("categoria") == "")), n(gold_prod, F.col("categoria").isNull())),
    ("Descripciones con minúsculas o espacios de más", n(bronze_prod, nombre_sucio("descripcion")), n(gold_prod, nombre_sucio("descripcion"))),
    ("Productos con precio de prueba (<= 1)", n(bronze_prod, F.col("precio") <= 1), n(gold_prod, F.col("precio") <= 1)),
    ("Ventas ANULADAS en la tabla de hechos", n(leer("bronze_ventas"), F.trim("estado") == "ANULADO"), 0),
]
calidad_df = spark.createDataFrame(calidad, "control string, antes long, despues long")
guardar(calidad_df, "calidad_antes_despues")
display(calidad_df)

fac = leer("fac_ventas")
display(fac.select("cantidad", "monto_vendido", "metraje_vendido", "costo_inventario", "descuento").describe())
display(fac.select([F.sum(F.col(c).isNull().cast("int")).alias(c) for c in fac.columns]))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 8. Indicadores para responder al negocio
# MAGIC Las mismas preguntas del dashboard de Power BI, ahora resueltas con Spark SQL sobre la capa Gold. Con el botón **+** de cada resultado se puede crear un gráfico.

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Cuánto se vende por mes y cuánto margen deja?
# MAGIC select anio, mes, nombreMes, ventas, margen, metraje_m2 from kpi_ventas_mes order by anio, mes

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Qué categoría vende más y cuál deja más margen?
# MAGIC select categoria, ventas, metraje_m2, margen_pct from kpi_categoria order by ventas desc

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Cómo pagan los clientes?
# MAGIC select nombreMetodo, ventas, round(100 * ventas / sum(ventas) over (), 2) participacion_pct
# MAGIC from kpi_metodo_pago order by ventas desc

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Qué proveedores concentran las ventas?
# MAGIC select razon_social, ventas from kpi_proveedores order by ventas desc limit 10

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Cuánto aportan los clientes VIP?
# MAGIC select tipo_cliente, sum(clientes) clientes, sum(ventas) ventas,
# MAGIC        round(100 * sum(ventas) / (select sum(ventas) from kpi_clientes), 2) participacion_pct
# MAGIC from kpi_clientes group by tipo_cliente

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Qué días se vende más?
# MAGIC select diaSemana, ventas from kpi_dia_semana order by n_dia

# COMMAND ----------

# MAGIC %sql
# MAGIC -- ¿Qué categorías tienen más productos por agotarse?
# MAGIC select categoria, productos_criticos from kpi_stock_critico order by productos_criticos desc

# COMMAND ----------

# MAGIC %md
# MAGIC ## 9. Experimento BD-1 · Volumen progresivo
# MAGIC Ejecuta este notebook una vez por volumen (10 000, 100 000, 500 000 y 1 000 000), cambiando el cuadro *1. Volumen de ventas*. Estas consultas comparan todas las ejecuciones.

# COMMAND ----------

# MAGIC %sql
# MAGIC -- Resumen por volumen
# MAGIC select ventas, count(*) ejecuciones, max(filas_hechos) filas_hechos,
# MAGIC        round(avg(duracion_ms) / 1000, 2) promedio_s,
# MAGIC        round(min(duracion_ms) / 1000, 2) minimo_s,
# MAGIC        round(max(duracion_ms) / 1000, 2) maximo_s,
# MAGIC        round(max(filas_hechos) / (avg(duracion_ms) / 1000)) filas_por_segundo
# MAGIC from etl_ejecucion
# MAGIC where estado = 'EXITOSO'
# MAGIC group by ventas order by ventas

# COMMAND ----------

# MAGIC %sql
# MAGIC -- Tiempo promedio de cada paso por volumen
# MAGIC select E.ventas, B.proceso, round(avg(B.duracion_ms)) ms_promedio
# MAGIC from etl_bitacora B join etl_ejecucion E on E.id_ejecucion = B.id_ejecucion
# MAGIC where E.estado = 'EXITOSO'
# MAGIC group by E.ventas, B.proceso order by B.proceso, E.ventas
