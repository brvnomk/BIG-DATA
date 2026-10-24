use master
go
if DB_ID('CeramicasVale_DM') is null
    create database CeramicasVale_DM
go

use CeramicasVale_DM
go
drop table if exists fac_ventas
drop table if exists dim_producto
drop table if exists dim_cliente
drop table if exists dim_tiempo
drop table if exists dim_metodoPago
drop table if exists dim_proveedor
drop table if exists stg_operacion
drop table if exists stg_metodoPago
go

create table dim_producto
(id_producto int primary key identity,
pk_producto varchar(50),
descripcion varchar(500),
categoria varchar(40),
marca varchar(100),
unidad_medida varchar(20),
m2_por_caja decimal(6,2),
precio decimal(10,2),
costo_unitario decimal(10,2),
stock_actual int,
stock_minimo int,
estado_stock varchar(10) -- CRITICO / NORMAL
)
go

create table dim_cliente
(id_cliente int primary key identity,
pk_cliente int,
tipo_documento varchar(3),
nro_documento varchar(11),
nombre varchar(200),
distrito varchar(60),
tipo_cliente varchar(10) -- REGULAR / VIP
)
go

create table dim_tiempo
(fecha date primary key,
año smallint,
trimestre smallint,
mes smallint,
nombreMes varchar(15),
semana smallint,
diaMes smallint,
diaSemana varchar(15)
)
go

create table dim_metodoPago
(id_metodoP int primary key identity,
pk_metodoP int,
nombreMetodo varchar(50))
go

create table dim_proveedor
(id_proveedor int primary key identity,
pk_proveedor int,
ruc char(11),
razon_social varchar(150),
ciudad varchar(50))
go

create table stg_operacion
(comprobante varchar(30),
metodoPago varchar(10))
go

create table stg_metodoPago
(pk_metodoP varchar(10),
nombreMetodo varchar(60))
go

create table fac_ventas
(id_venta int primary key identity,
id_cliente int references dim_cliente,
id_producto int references dim_producto,
id_proveedor int references dim_proveedor,
id_metodoP int references dim_metodoPago,
fecha date references dim_tiempo,
cantidad decimal(14,2),
monto_vendido money,
metraje_vendido decimal(14,2),
costo_inventario money,
descuento money
)
go

if object_id('etl_ejecucion') is null
create table etl_ejecucion
(id_ejecucion int primary key identity,
escenario varchar(30),
fecha_inicio datetime2,
fecha_fin datetime2,
duracion_ms int,
filas_hechos int,
estado varchar(20),
mensaje varchar(4000))
go

if object_id('etl_bitacora') is null
create table etl_bitacora
(id_paso int primary key identity,
id_ejecucion int references etl_ejecucion,
proceso varchar(60),
hora_inicio datetime2,
hora_fin datetime2,
duracion_ms int,
filas_procesadas int,
estado varchar(20),
mensaje varchar(4000))
go

if object_id('etl_errores') is null
create table etl_errores
(id_error int primary key identity,
id_ejecucion int references etl_ejecucion,
origen varchar(40),
clave varchar(60),
motivo varchar(200))
go
