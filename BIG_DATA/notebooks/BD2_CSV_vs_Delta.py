# Databricks notebook source
# MAGIC %md
# MAGIC # Experimento BD-2 · Leer CSV vs. leer una tabla Delta
# MAGIC
# MAGIC **Pregunta:** ¿cuánto más rápido es consultar los datos guardados como **tabla Delta** de Databricks que leerlos cada vez desde los **archivos CSV**? ¿Cuánto espacio ocupa cada uno?
# MAGIC
# MAGIC - Un **CSV** es texto plano: cada vez que se consulta, Spark tiene que leer todo el archivo y convertir el texto en números y fechas.
# MAGIC - Una **tabla Delta** guarda los datos ya convertidos, comprimidos y organizados por columnas (formato Parquet). Es la persistencia que usamos en el notebook principal.
# MAGIC
# MAGIC **Qué se mide:** el tiempo de la misma consulta (ventas por mes) leyendo desde CSV y desde Delta, 3 veces cada una, y el tamaño de los datos en cada formato.
# MAGIC
# MAGIC **Cómo se usa:** elige el volumen (recomendado: 1 000 000) y pulsa **Run all**. Los archivos deben estar en el volumen `workspace.ceramicas_vale.datos`.

# COMMAND ----------

import time
from datetime import datetime
from pyspark.sql import functions as F

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

ESQ_VENTAS  = "id_venta int, tipo_comprobante string, serie_numero string, fecha timestamp, id_cliente int, estado string, total decimal(12,2)"
ESQ_DETALLE = "id_venta int, item int, codigo_interno string, cantidad decimal(10,2), precio_unitario decimal(10,2), descuento_pct decimal(4,2)"

def leer_csv(archivo, esquema):
    return (spark.read.option("sep", "|").option("header", "false")
                 .option("timestampFormat", "yyyy-MM-dd HH:mm:ss").schema(esquema).csv(f"{RUTA}/{archivo}"))

print(f"Experimento BD-2 con {VENTAS:,} ventas")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 1. Preparación: guardar los mismos datos como tablas Delta

# COMMAND ----------

filas_ventas  = guardar(leer_csv(f"ventas_{VENTAS}.csv", ESQ_VENTAS), "exp_bd2_ventas")
filas_detalle = guardar(leer_csv(f"detalle_ventas_{VENTAS}.csv", ESQ_DETALLE), "exp_bd2_detalle")
print(f"Tablas Delta listas: {filas_ventas:,} ventas y {filas_detalle:,} líneas de detalle")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 2. La consulta que se mide
# MAGIC Ventas emitidas por año y mes (une ventas con su detalle, filtra, calcula el monto de cada línea y suma). Es el indicador "ventas por mes" del dashboard.

# COMMAND ----------

def ventas_por_mes(ventas, detalle):
    return (ventas.filter(F.trim("estado") == "EMITIDO")
                  .join(detalle.filter((F.col("cantidad") > 0) & (F.col("precio_unitario") > 0)), "id_venta")
                  .groupBy(F.year("fecha").alias("anio"), F.month("fecha").alias("mes"))
                  .agg(F.round(F.sum(F.col("cantidad") * F.col("precio_unitario") * (1 - F.col("descuento_pct"))), 2).alias("ventas"))
                  .orderBy("anio", "mes"))

metodos = {
    "A. Desde archivos CSV": lambda: ventas_por_mes(leer_csv(f"ventas_{VENTAS}.csv", ESQ_VENTAS),
                                                    leer_csv(f"detalle_ventas_{VENTAS}.csv", ESQ_DETALLE)),
    "B. Desde tablas Delta": lambda: ventas_por_mes(leer("exp_bd2_ventas"), leer("exp_bd2_detalle")),
}

# COMMAND ----------

# MAGIC %md
# MAGIC ## 3. Medición (3 repeticiones de cada método)

# COMMAND ----------

mediciones, resultados = [], {}
for r in range(1, REPETICIONES + 1):
    for metodo, consulta in metodos.items():
        t0 = time.perf_counter()
        filas = consulta().collect()              # collect() obliga a Spark a ejecutar todo
        seg = time.perf_counter() - t0
        resultados[metodo] = round(sum(float(f["ventas"]) for f in filas), 2)
        mediciones.append(("BD-2", metodo, VENTAS, r, round(seg, 3), len(filas), datetime.now()))
        print(f"Repetición {r} · {metodo:<24} {seg:7.2f} s")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 4. Tamaño de los datos en cada formato

# COMMAND ----------

archivos = {f.name: f.size for f in dbutils.fs.ls(RUTA)}
mb_csv = (archivos[f"ventas_{VENTAS}.csv"] + archivos[f"detalle_ventas_{VENTAS}.csv"]) / 1024 / 1024

def mb_delta(nombre):
    try:
        return spark.sql(f"describe detail {tabla(nombre)}").first()["sizeInBytes"] / 1024 / 1024
    except Exception:
        return None                                # fuera de Databricks no existe "describe detail"

delta = [mb_delta("exp_bd2_ventas"), mb_delta("exp_bd2_detalle")]
mb_delta_total = None if None in delta else sum(delta)
print(f"CSV: {mb_csv:,.1f} MB | Delta: {mb_delta_total if mb_delta_total is None else round(mb_delta_total, 1)} MB")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 5. Resultados (esta es la tabla que va al informe)

# COMMAND ----------

anexar(spark.createDataFrame(mediciones, "experimento string, metodo string, ventas int, repeticion int, "
                                         "segundos double, filas_resultado int, fecha_hora timestamp"), "exp_bigdata")
med = spark.createDataFrame(mediciones, "experimento string, metodo string, ventas int, repeticion int, "
                                        "segundos double, filas_resultado int, fecha_hora timestamp")
resumen = (med.groupBy("metodo")
              .agg(F.round(F.avg("segundos"), 2).alias("segundos_promedio"),
                   F.round(F.min("segundos"), 2).alias("segundos_minimo"),
                   F.round(F.max("segundos"), 2).alias("segundos_maximo"))
              .orderBy("metodo"))
display(resumen)
display(med.orderBy("repeticion", "metodo"))

prom = {r["metodo"]: r["segundos_promedio"] for r in resumen.collect()}
a, b = prom["A. Desde archivos CSV"], prom["B. Desde tablas Delta"]
display(spark.createDataFrame([(datetime.now(), VENTAS, a, b, round(a / b, 1) if b else None,
                                round(mb_csv, 1), None if mb_delta_total is None else round(mb_delta_total, 1),
                                "OK: los dos métodos dan el mismo total" if resultados["A. Desde archivos CSV"] == resultados["B. Desde tablas Delta"]
                                else "DIFERENCIA entre los métodos")],
                              "fecha_hora timestamp, ventas int, csv_s double, delta_s double, veces_mas_rapido_delta double, "
                              "mb_csv double, mb_delta double, comprobacion string"))
