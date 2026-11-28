# Databricks notebook source
# MAGIC %md
# MAGIC # Experimento BD-4 · Función propia de Python (UDF) vs. funciones de Spark
# MAGIC
# MAGIC **Pregunta:** en la limpieza, ¿es mejor escribir la regla como una **función propia de Python** (UDF) o con las **funciones que ya trae Spark**?
# MAGIC
# MAGIC La regla de prueba es la que deduce la **categoría** de cada producto a partir de su descripción (el catálogo la trae vacía). Se aplica a todas las líneas de venta.
# MAGIC - **UDF (función propia de Python):** Spark tiene que pasar cada fila a Python, ejecutar la función y devolver el resultado. Es fácil de escribir, pero mover los datos tiene un costo.
# MAGIC - **Funciones de Spark** (`when`, `contains`, `upper`…): se ejecutan dentro del motor de Spark, sin salir a Python.
# MAGIC
# MAGIC **Qué se mide:** el tiempo de asignar la categoría a todas las líneas de venta con cada método, 3 veces cada uno, y se comprueba que los dos den el mismo resultado.
# MAGIC
# MAGIC **Cómo se usa:** elige el volumen (recomendado: 1 000 000) y pulsa **Run all**. Los archivos deben estar en el volumen `workspace.ceramicas_vale.datos`.

# COMMAND ----------

import time
from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.types import StringType

dbutils.widgets.dropdown("ventas", "1000000", ["10000", "100000", "500000", "1000000"], "1. Volumen de ventas")
VENTAS = int(dbutils.widgets.get("ventas"))
REPETICIONES = 3

CATALOGO, ESQUEMA, VOLUMEN = "workspace", "ceramicas_vale", "datos"
RUTA = f"/Volumes/{CATALOGO}/{ESQUEMA}/{VOLUMEN}"
spark.sql(f"use catalog {CATALOGO}")
spark.sql(f"use schema {ESQUEMA}")

def tabla(nombre):
    return f"{CATALOGO}.{ESQUEMA}.{nombre}"

def guardar(df, nombre):
    df.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(tabla(nombre))
    return leer(nombre).count()

def leer(nombre):
    return spark.table(tabla(nombre))

def anexar(df, nombre):
    df.write.mode("append").saveAsTable(tabla(nombre))

def leer_csv(archivo, esquema):
    return spark.read.option("sep", "|").option("header", "false").schema(esquema).csv(f"{RUTA}/{archivo}")

print(f"Experimento BD-4 con {VENTAS:,} ventas")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 1. Preparación: cada línea de venta con la descripción de su producto

# COMMAND ----------

productos = leer_csv("productos.csv", "codigo_interno string, descripcion string, unidad_medida string, marca string, "
                                      "precio decimal(10,2), categoria string, m2_por_caja decimal(6,2), costo_unitario decimal(10,2), "
                                      "stock_actual int, stock_minimo int, estado string, id_proveedor int")
detalle = leer_csv(f"detalle_ventas_{VENTAS}.csv", "id_venta int, item int, codigo_interno string, cantidad decimal(10,2), "
                                                   "precio_unitario decimal(10,2), descuento_pct decimal(4,2)")
lineas = (detalle.select(F.trim("codigo_interno").alias("codigo_interno"))
                 .join(productos.select(F.trim("codigo_interno").alias("codigo_interno"),
                                        F.upper(F.trim("descripcion")).alias("descripcion"),
                                        F.upper(F.trim("unidad_medida")).alias("unidad_medida")), "codigo_interno"))
filas = guardar(lineas, "exp_bd4_lineas")
print(f"{filas:,} líneas de venta listas")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 2. La misma regla escrita de dos formas

# COMMAND ----------

REGLAS = [  # (categoría, palabras que la identifican)
    ("SANITARIOS", ["INODORO", "INNODORO", "LAVATORIO", "OVALIN", "LAVADERO", "URINARIO", "ONE PIECE", "TANQUE"]),
    ("GRIFERIA", ["DUCHA", "MEZCLADORA", "PICO DE GANZO", "GRIFO", "LLAVE", "MONOCOMANDO", "GRIFERIA"]),
    ("PEGAMENTOS Y FRAGUAS", ["PEGAMENTO", "FRAGUA", "SILICONA", "CEMENTO", "TEROKAL"]),
    ("PERFILES Y NIVELACION", ["PERFIL", "CUÑA", "NIVELADOR", "CANTONERA"]),
    ("DECORADOS", ["DECORADO", "DECO ", "LISTELO", "PEPELMA", "CENEFA", "MOSAICO"]),
]

# A. Función propia de Python (UDF): Spark llama a esta función una vez por cada fila
def categoria_python(descripcion, unidad):
    descripcion, unidad = descripcion or "", unidad or ""
    if unidad in ("MTK", "BX"):
        return "PORCELANATOS" if "PORCELANATO" in descripcion else "CERAMICOS"
    for nombre, palabras in REGLAS:
        if nombre == "PERFILES Y NIVELACION" and unidad == "MTR":
            return nombre
        if any(p in descripcion for p in palabras):
            return nombre
    return "ACCESORIOS Y OTROS"

categoria_udf = F.udf(categoria_python, StringType())

# B. Funciones de Spark: la misma regla con when/contains, sin salir del motor
def categoria_spark(descripcion, unidad):
    d, u = F.col(descripcion), F.col(unidad)
    def tiene(palabras):
        cond = F.lit(False)
        for p in palabras:
            cond = cond | d.contains(p)
        return cond
    expr = F.when(u.isin("MTK", "BX") & d.contains("PORCELANATO"), "PORCELANATOS").when(u.isin("MTK", "BX"), "CERAMICOS")
    for nombre, palabras in REGLAS:
        cond = tiene(palabras) | (u == "MTR") if nombre == "PERFILES Y NIVELACION" else tiene(palabras)
        expr = expr.when(cond, nombre)
    return expr.otherwise("ACCESORIOS Y OTROS")

metodos = {
    "A. Función propia (UDF Python)": lambda df: df.withColumn("categoria", categoria_udf("descripcion", "unidad_medida")),
    "B. Funciones de Spark":          lambda df: df.withColumn("categoria", categoria_spark("descripcion", "unidad_medida")),
}

# COMMAND ----------

# MAGIC %md
# MAGIC ## 3. Medición (3 repeticiones de cada método)

# COMMAND ----------

mediciones, conteos = [], {}
for r in range(1, REPETICIONES + 1):
    for metodo, aplicar in metodos.items():
        t0 = time.perf_counter()
        res = aplicar(leer("exp_bd4_lineas")).groupBy("categoria").count().collect()   # obliga a calcular la categoría en cada fila
        seg = time.perf_counter() - t0
        conteos[metodo] = sorted((x["categoria"], x["count"]) for x in res)
        mediciones.append(("BD-4", metodo, VENTAS, r, round(seg, 3), filas, datetime.now()))
        print(f"Repetición {r} · {metodo:<32} {seg:7.2f} s")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 4. Resultados (esta es la tabla que va al informe)

# COMMAND ----------

esquema = "experimento string, metodo string, ventas int, repeticion int, segundos double, filas_resultado int, fecha_hora timestamp"
anexar(spark.createDataFrame(mediciones, esquema), "exp_bigdata")
med = spark.createDataFrame(mediciones, esquema)
resumen = (med.groupBy("metodo")
              .agg(F.round(F.avg("segundos"), 2).alias("segundos_promedio"),
                   F.round(F.min("segundos"), 2).alias("segundos_minimo"),
                   F.round(F.max("segundos"), 2).alias("segundos_maximo"),
                   F.max("filas_resultado").alias("lineas_procesadas"))
              .orderBy("metodo"))
display(resumen)
display(med.orderBy("repeticion", "metodo"))

prom = {r["metodo"]: r["segundos_promedio"] for r in resumen.collect()}
a, b = prom["A. Función propia (UDF Python)"], prom["B. Funciones de Spark"]
iguales = conteos["A. Función propia (UDF Python)"] == conteos["B. Funciones de Spark"]
display(spark.createDataFrame([(datetime.now(), VENTAS, a, b, round(a / b, 1) if b else None,
                                "OK: los dos métodos asignan las mismas categorías" if iguales else "DIFERENCIA entre los métodos")],
                              "fecha_hora timestamp, ventas int, udf_s double, spark_s double, veces_mas_rapido_spark double, comprobacion string"))
display(spark.createDataFrame(conteos["B. Funciones de Spark"], "categoria string, lineas long"))
