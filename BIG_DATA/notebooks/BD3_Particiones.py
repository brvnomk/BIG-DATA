# Databricks notebook source
# MAGIC %md
# MAGIC # Experimento BD-3 · Número de particiones en Spark
# MAGIC
# MAGIC **Pregunta:** ¿cómo cambia el tiempo de un cálculo cuando Spark reparte los datos en más o menos **particiones**?
# MAGIC
# MAGIC Spark trabaja en paralelo: divide los datos en pedazos llamados **particiones** y procesa varios a la vez.
# MAGIC - Con **1 partición** todo se hace en un solo pedazo: no hay trabajo en paralelo.
# MAGIC - Con **demasiadas** particiones, Spark pierde tiempo organizando muchos pedazos pequeños.
# MAGIC - Hay un punto intermedio que es el más rápido. Es el ajuste que mencionó el profesor, que puede bajar un proceso de minutos a segundos.
# MAGIC
# MAGIC **Qué se mide:** el tiempo del mismo cálculo (ventas por producto y mes) repartiendo los datos en 1, 4, 16, 64 y 200 particiones, 3 veces cada uno.
# MAGIC
# MAGIC **Cómo se usa:** elige el volumen (recomendado: 1 000 000) y pulsa **Run all**. Los archivos deben estar en el volumen `workspace.ceramicas_vale.datos`.

# COMMAND ----------

import time
from datetime import datetime
from pyspark.sql import functions as F

dbutils.widgets.dropdown("ventas", "1000000", ["10000", "100000", "500000", "1000000"], "1. Volumen de ventas")
VENTAS = int(dbutils.widgets.get("ventas"))
REPETICIONES = 3
PARTICIONES = [1, 4, 16, 64, 200]

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
    return (spark.read.option("sep", "|").option("header", "false")
                 .option("timestampFormat", "yyyy-MM-dd HH:mm:ss").schema(esquema).csv(f"{RUTA}/{archivo}"))

print(f"Experimento BD-3 con {VENTAS:,} ventas")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 1. Preparación: las líneas de venta emitidas, guardadas como tabla Delta

# COMMAND ----------

ventas = leer_csv(f"ventas_{VENTAS}.csv", "id_venta int, tipo_comprobante string, serie_numero string, fecha timestamp, "
                                          "id_cliente int, estado string, total decimal(12,2)")
detalle = leer_csv(f"detalle_ventas_{VENTAS}.csv", "id_venta int, item int, codigo_interno string, cantidad decimal(10,2), "
                                                   "precio_unitario decimal(10,2), descuento_pct decimal(4,2)")
lineas = (ventas.filter(F.trim("estado") == "EMITIDO")
                .join(detalle.filter((F.col("cantidad") > 0) & (F.col("precio_unitario") > 0)), "id_venta")
                .select("fecha", "id_cliente", F.trim("codigo_interno").alias("codigo_interno"),
                        (F.col("cantidad") * F.col("precio_unitario") * (1 - F.col("descuento_pct"))).alias("monto")))
filas = guardar(lineas, "exp_bd3_lineas")
print(f"{filas:,} líneas de venta listas")

try:
    print("Particiones de shuffle configuradas en esta sesión:", spark.conf.get("spark.sql.shuffle.partitions"))
except Exception:
    print("Esta sesión no permite leer spark.sql.shuffle.partitions")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 2. Medición
# MAGIC `repartition(n)` reparte los datos en `n` particiones antes del cálculo. Así se fuerza cuántos pedazos procesa Spark.

# COMMAND ----------

def calculo(n):
    return (leer("exp_bd3_lineas").repartition(n)
            .groupBy("codigo_interno", F.year("fecha").alias("anio"), F.month("fecha").alias("mes"))
            .agg(F.sum("monto").alias("ventas"), F.countDistinct("id_cliente").alias("clientes")))

mediciones, totales = [], {}
for r in range(1, REPETICIONES + 1):
    for n in PARTICIONES:
        t0 = time.perf_counter()
        res = calculo(n).agg(F.count("*").alias("grupos"), F.sum("ventas").alias("total")).first()
        seg = time.perf_counter() - t0
        totales[n] = round(float(res["total"]), 2)
        mediciones.append(("BD-3", f"{n:>3} particiones", VENTAS, r, round(seg, 3), int(res["grupos"]), datetime.now()))
        print(f"Repetición {r} · {n:>3} particiones  {seg:7.2f} s  ({res['grupos']:,} grupos)")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 3. Resultados (esta es la tabla que va al informe)

# COMMAND ----------

esquema = "experimento string, metodo string, ventas int, repeticion int, segundos double, filas_resultado int, fecha_hora timestamp"
anexar(spark.createDataFrame(mediciones, esquema), "exp_bigdata")
med = spark.createDataFrame(mediciones, esquema)
resumen = (med.groupBy("metodo")
              .agg(F.round(F.avg("segundos"), 2).alias("segundos_promedio"),
                   F.round(F.min("segundos"), 2).alias("segundos_minimo"),
                   F.round(F.max("segundos"), 2).alias("segundos_maximo"),
                   F.max("filas_resultado").alias("grupos"))
              .orderBy("metodo"))
display(resumen)
display(med.orderBy("repeticion", "metodo"))
display(spark.createDataFrame([(datetime.now(), VENTAS,
                                "OK: todas las configuraciones dan el mismo total" if len(set(totales.values())) == 1
                                else "DIFERENCIA entre configuraciones")],
                              "fecha_hora timestamp, ventas int, comprobacion string"))
