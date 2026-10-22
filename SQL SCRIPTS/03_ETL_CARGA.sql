/* CERÁMICAS VALE - SCRIPT 3 de 3: ETL_CARGA
   Origen: CERAMICAS_VALE y archivos planos. Destino: CeramicasVale_DM.
   Antes de ejecutar, copiar metodopago.txt y operacionVenta.txt a C:\txt\ceramicas_vale\ */

use CeramicasVale_DM
go

--Paso 0: Registramos el inicio de la ejecución
insert into etl_ejecucion (escenario, fecha_inicio, estado)
values ('MANUAL', SYSDATETIME(), 'EN PROCESO')
go

--Paso 1: Limpiamos tablas
declare @t datetime2 = SYSDATETIME()
delete from fac_ventas
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ( 'fac_ventas', RESEED, 0 )
delete from dim_producto
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ( 'dim_producto', RESEED, 0 )
delete from dim_cliente
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ( 'dim_cliente', RESEED, 0 )
delete from dim_proveedor
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ( 'dim_proveedor', RESEED, 0 )
delete from dim_metodoPago
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ( 'dim_metodoPago', RESEED, 0 )
delete from dim_tiempo
truncate table stg_operacion
truncate table stg_metodoPago
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '1. Limpieza de tablas', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), 0, 'EXITOSO')
go

--Paso 2: Cargamos la dimension proveedor
declare @t datetime2 = SYSDATETIME()
insert into dim_proveedor (pk_proveedor, ruc, razon_social, ciudad)
select id_proveedor pk_proveedor,
       LTRIM(RTRIM(ruc)) ruc,
       UPPER(LTRIM(RTRIM(razon_social))) razon_social,
       ISNULL(NULLIF(UPPER(LTRIM(RTRIM(ciudad))), ''), 'NO ESPECIFICADO') ciudad
from CERAMICAS_VALE.dbo.PROVEEDORES
declare @filas int = @@ROWCOUNT
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '2. dim_proveedor', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select * from dim_proveedor
go

--Paso 3: Cargamos la dimension producto
declare @t datetime2 = SYSDATETIME()

-- Calidad: los productos con precio de prueba (<= S/ 1) no se cargan, quedan registrados
insert into etl_errores (id_ejecucion, origen, clave, motivo)
select (select MAX(id_ejecucion) from etl_ejecucion), 'PRODUCTOS', codigo_interno, 'Precio <= 1 (valor de prueba)'
from CERAMICAS_VALE.dbo.PRODUCTOS where precio <= 1

insert into dim_producto (pk_producto, descripcion, marca, unidad_medida, m2_por_caja,
                          precio, costo_unitario, stock_actual, stock_minimo, estado_stock)
select codigo_interno pk_producto, UPPER(descripcion), UPPER(LTRIM(RTRIM(marca))),
       unidad_medida, m2_por_caja, precio, costo_unitario, stock_actual, stock_minimo,
       case when stock_actual <= stock_minimo then 'CRITICO' else 'NORMAL' end estado_stock
from CERAMICAS_VALE.dbo.PRODUCTOS
where precio > 1
declare @filas int = @@ROWCOUNT

update dim_producto
set descripcion = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(descripcion, CHAR(9), ' '), '  ', ' '), '  ', ' '), '  ', ' ')))

update dim_producto
set categoria =
       case when unidad_medida in ('MTK', 'BX') and descripcion like '%PORCELANATO%' then 'PORCELANATOS'
            when unidad_medida in ('MTK', 'BX') then 'CERAMICOS'
            when descripcion like '%INODORO%' or descripcion like '%INNODORO%' or descripcion like '%LAVATORIO%'
              or descripcion like '%OVALIN%'  or descripcion like '%LAVADERO%' or descripcion like '%URINARIO%'
              or descripcion like '%ONE PIECE%' or descripcion like '%TANQUE%' then 'SANITARIOS'
            when descripcion like '%DUCHA%' or descripcion like '%MEZCLADORA%' or descripcion like '%PICO DE GANZO%'
              or descripcion like '%GRIFO%' or descripcion like '%LLAVE%' or descripcion like '%MONOCOMANDO%'
              or descripcion like '%GRIFERIA%' then 'GRIFERIA'
            when descripcion like '%PEGAMENTO%' or descripcion like '%FRAGUA%' or descripcion like '%SILICONA%'
              or descripcion like '%CEMENTO%' or descripcion like '%TEROKAL%' then 'PEGAMENTOS Y FRAGUAS'
            when descripcion like '%PERFIL%' or unidad_medida = 'MTR' or descripcion like '%CUÑA%'
              or descripcion like '%NIVELADOR%' or descripcion like '%CANTONERA%' then 'PERFILES Y NIVELACION'
            when descripcion like '%DECORADO%' or descripcion like '%DECO %' or descripcion like '%LISTELO%'
              or descripcion like '%PEPELMA%' or descripcion like '%CENEFA%' or descripcion like '%MOSAICO%' then 'DECORADOS'
            else 'ACCESORIOS Y OTROS' end
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '3. dim_producto', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select * from dim_producto
go

--Paso 4: Cargamos la dimension cliente
declare @t datetime2 = SYSDATETIME()
insert into dim_cliente (pk_cliente, tipo_documento, nro_documento, nombre, distrito, tipo_cliente)
select id_cliente pk_cliente, tipo_documento, nro_documento,
       UPPER(LTRIM(RTRIM(REPLACE(REPLACE(nombre, '  ', ' '), '  ', ' ')))) nombre,
       ISNULL(NULLIF(UPPER(LTRIM(RTRIM(distrito))), ''), 'NO ESPECIFICADO') distrito,
       'REGULAR' tipo_cliente
from CERAMICAS_VALE.dbo.CLIENTES
declare @filas int = @@ROWCOUNT

-- Transformación: VIP = 10 % de clientes identificados con mayor monto comprado
update dim_cliente
set tipo_cliente = 'VIP'
where pk_cliente in (select top 10 percent id_cliente
                     from CERAMICAS_VALE.dbo.VENTAS
                     where estado = 'EMITIDO'
                       and id_cliente not in (select id_cliente from CERAMICAS_VALE.dbo.CLIENTES
                                              where nro_documento = '00000000')   -- sin "CLIENTES VARIOS"
                     group by id_cliente
                     order by SUM(total) desc)
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '4. dim_cliente', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select * from dim_cliente
go

--Paso 5: Cargamos la dimension tiempo
declare @t datetime2 = SYSDATETIME(), @filas int = 0
Declare @inicio date, @fin date
select @inicio = Min(fecha) , @fin = Max(fecha) from CERAMICAS_VALE.dbo.VENTAS
set datefirst 7

WHILE (@inicio <= @fin)
	BEGIN

		INSERT INTO dim_tiempo
		SELECT @inicio fecha, DATEPART(yyyy, @inicio) año, DATEPART(q, @inicio) trimestre,
			DATEPART(m, @inicio) mes,
			CASE DATEPART(m, @inicio)
					WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo' WHEN 4 THEN 'Abril'
					WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio' WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto'
					WHEN 9 THEN 'Septiembre' WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' ELSE 'Diciembre'
				END AS nombreMes,
			DATEPART(ISO_WEEK, @inicio) semana,
			DATEPART(d, @inicio) diaMes,
			CASE DATEPART(dw, @inicio)
					WHEN 1 THEN 'Domingo'
					WHEN 2 THEN 'Lunes'
					WHEN 3 THEN 'Martes'
					WHEN 4 THEN 'Miércoles'
					WHEN 5 THEN 'Jueves'
					WHEN 6 THEN 'Viernes'
					WHEN 7 THEN 'Sábado'
				END AS diaSemana

		SET @filas = @filas + 1
		SET @inicio = DATEADD(d, 1, @inicio);
	end
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '5. dim_tiempo', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select * from dim_tiempo
go

--Paso 6: Cargamos la dimension metodo de pago (archivo plano)
declare @t datetime2 = SYSDATETIME()
Bulk insert stg_metodoPago
	  from 'C:\txt\ceramicas_vale\metodopago.txt'
	  WITH
	  (FIRSTROW = 1,
	  FIELDTERMINATOR=',', ROWTERMINATOR = '0x0a')

select * from stg_metodoPago    -- así llega el archivo (espacios, minúsculas, duplicados)

-- Valor por defecto para comprobantes que no tienen registro en caja
insert into dim_metodoPago (pk_metodoP, nombreMetodo) values (0, 'NO REGISTRADO')

insert into dim_metodoPago (pk_metodoP, nombreMetodo)
select distinct CAST(LTRIM(RTRIM(pk_metodoP)) as int),
       UPPER(LTRIM(RTRIM(REPLACE(nombreMetodo, CHAR(13), ''))))
from stg_metodoPago
declare @filas int = @@ROWCOUNT
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '6. dim_metodoPago (txt)', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select * from dim_metodoPago
go

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Paso 7: Cargamos staging de operaciones de caja (archivo plano)
declare @t datetime2 = SYSDATETIME()
Bulk insert stg_operacion
	  from 'C:\txt\ceramicas_vale\operacionVenta.txt'
	  WITH
	  (FIRSTROW = 2,
	  FIELDTERMINATOR='|', ROWTERMINATOR = '0x0a')
declare @filas int = @@ROWCOUNT

update stg_operacion
set comprobante = LTRIM(RTRIM(comprobante)),
    metodoPago = LTRIM(RTRIM(REPLACE(metodoPago, CHAR(13), '')))

-- Calidad: comprobantes duplicados en caja (se conserva el método de menor código)
insert into etl_errores (id_ejecucion, origen, clave, motivo)
select (select MAX(id_ejecucion) from etl_ejecucion), 'operacionVenta.txt', comprobante,
       'Comprobante duplicado en archivo de caja'
from stg_operacion
group by comprobante
having COUNT(*) > 1

insert into etl_errores (id_ejecucion, origen, clave, motivo)
select (select MAX(id_ejecucion) from etl_ejecucion), 'operacionVenta.txt', S.comprobante,
       'Método de pago inexistente: ' + S.metodoPago
from stg_operacion S
where not exists (select 1 from dim_metodoPago M where M.pk_metodoP = CAST(S.metodoPago as int))
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '7. stg_operacion (txt)', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select top 100 * from stg_operacion
go

--Paso 8: Cargamos la FAC Ventas (tabla de hechos)
declare @t datetime2 = SYSDATETIME()
declare @id_ejecucion int = (select MAX(id_ejecucion) from etl_ejecucion)

insert into etl_errores (id_ejecucion, origen, clave, motivo)
select @id_ejecucion, 'DETALLE_VENTAS', V.serie_numero + ' / ítem ' + CAST(D.item as varchar), 'Precio o cantidad <= 0'
from CERAMICAS_VALE.dbo.VENTAS V
join CERAMICAS_VALE.dbo.DETALLE_VENTAS D on D.id_venta = V.id_venta
where V.estado = 'EMITIDO' and (D.precio_unitario <= 0 or D.cantidad <= 0)

-- Comprobantes sin pago en caja: se cargan como NO REGISTRADO y quedan anotados
insert into etl_errores (id_ejecucion, origen, clave, motivo)
select @id_ejecucion, 'VENTAS', V.serie_numero, 'Comprobante sin registro de pago (se carga como NO REGISTRADO)'
from CERAMICAS_VALE.dbo.VENTAS V
where V.estado = 'EMITIDO'
  and not exists (select 1 from stg_operacion O where O.comprobante = V.serie_numero)

declare @id_no_registrado int = (select id_metodoP from dim_metodoPago where pk_metodoP = 0)

insert into fac_ventas (id_cliente, id_producto, id_proveedor, id_metodoP, fecha,
                        cantidad, monto_vendido, metraje_vendido, costo_inventario, descuento)
Select D_CL.id_cliente, D_PR.id_producto, D_PV.id_proveedor,
       ISNULL(D_MP.id_metodoP, @id_no_registrado) id_metodoP,
       cast(V.fecha as date) fecha,
       -- cerámicos: el sistema vende en m2, se convierte a cajas
       sum(case when P.unidad_medida = 'MTK' then D.cantidad / ISNULL(NULLIF(P.m2_por_caja, 0), 1)
                else D.cantidad end) cantidad,
       sum(D.cantidad * D.precio_unitario * (1 - D.descuento_pct)) monto_vendido,
       sum(case when P.unidad_medida = 'MTK' then D.cantidad
                when P.unidad_medida = 'BX'  then D.cantidad * ISNULL(P.m2_por_caja, 0)
                else 0 end) metraje_vendido,
       sum(D.cantidad * P.costo_unitario) costo_inventario,
       sum(D.cantidad * D.precio_unitario * D.descuento_pct) descuento
from CERAMICAS_VALE.dbo.VENTAS V
join CERAMICAS_VALE.dbo.DETALLE_VENTAS D on D.id_venta = V.id_venta
join CERAMICAS_VALE.dbo.PRODUCTOS P on P.codigo_interno = D.codigo_interno
Join dim_producto D_PR on D_PR.pk_producto = P.codigo_interno
Join dim_proveedor D_PV on D_PV.pk_proveedor = P.id_proveedor
Join dim_cliente D_CL on D_CL.pk_cliente = V.id_cliente
left join (select comprobante, MIN(CAST(metodoPago as int)) metodo
           from stg_operacion group by comprobante) O on O.comprobante = V.serie_numero
left join dim_metodoPago D_MP on D_MP.pk_metodoP = O.metodo
where V.estado = 'EMITIDO'                          -- los comprobantes anulados no son venta
  and D.precio_unitario > 0 and D.cantidad > 0
group by D_CL.id_cliente, D_PR.id_producto, D_PV.id_proveedor,
         ISNULL(D_MP.id_metodoP, @id_no_registrado), cast(V.fecha as date)
declare @filas int = @@ROWCOUNT
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado)
values ((select MAX(id_ejecucion) from etl_ejecucion), '8. fac_ventas', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, 'EXITOSO')
go

select top 100 * from fac_ventas
go

--Paso 9: Reconciliación (el total vendido del origen debe coincidir con el Data Mart)
declare @t datetime2 = SYSDATETIME()
declare @origen money, @destino money, @dif money

select @origen = SUM(D.cantidad * D.precio_unitario * (1 - D.descuento_pct))
from CERAMICAS_VALE.dbo.VENTAS V
join CERAMICAS_VALE.dbo.DETALLE_VENTAS D on D.id_venta = V.id_venta
join CERAMICAS_VALE.dbo.PRODUCTOS P on P.codigo_interno = D.codigo_interno
where V.estado = 'EMITIDO' and D.precio_unitario > 0 and D.cantidad > 0 and P.precio > 1

select @destino = SUM(monto_vendido) from fac_ventas
set @dif = @destino - @origen

-- Tolerancia 0.0001 %: cada fila del hecho se guarda como money (4 decimales),
-- al sumar cientos de miles de filas aparecen céntimos de redondeo.
declare @estado varchar(20) = case when ABS(@dif) <= 0.000001 * ABS(@origen) + 0.01 then 'OK' else 'DIFERENCIA' end
declare @mensaje varchar(4000) = 'Origen S/ ' + CONVERT(varchar, @origen, 1)
                               + ' | Data Mart S/ ' + CONVERT(varchar, @destino, 1)
                               + ' | Diferencia S/ ' + CONVERT(varchar, @dif, 2)
declare @filas int = (select COUNT(*) from fac_ventas)
insert into etl_bitacora (id_ejecucion, proceso, hora_inicio, hora_fin, duracion_ms, filas_procesadas, estado, mensaje)
values ((select MAX(id_ejecucion) from etl_ejecucion), '9. Reconciliación', @t, SYSDATETIME(), DATEDIFF(MILLISECOND, @t, SYSDATETIME()), @filas, @estado, @mensaje)

update etl_ejecucion
set fecha_fin = SYSDATETIME(),
    duracion_ms = DATEDIFF(MILLISECOND, fecha_inicio, SYSDATETIME()),
    filas_hechos = @filas,
    estado = 'EXITOSO'
where id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
go

select proceso, duracion_ms, filas_procesadas, estado, mensaje
from etl_bitacora
where id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
order by id_paso

select origen, motivo, COUNT(*) registros
from etl_errores
where id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
group by origen, motivo order by origen
go

use CeramicasVale_DM
go

-- 1. Última ejecución del ETL (tiempos por paso) -> evidencia del experimento
select top 1 * from etl_ejecucion order by id_ejecucion desc
select B.proceso, B.duracion_ms, B.filas_procesadas, B.estado, B.mensaje
from etl_bitacora B
where B.id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
order by B.id_paso
go

-- 2. Calidad de datos: antes (OLTP) vs después (Data Mart)
select 'Clientes con nombre en minúsculas o espacios dobles' control,
       (select COUNT(*) from CERAMICAS_VALE.dbo.CLIENTES
        where nombre COLLATE Latin1_General_CS_AS <> UPPER(nombre) or nombre like '%  %') antes,
       (select COUNT(*) from dim_cliente
        where nombre COLLATE Latin1_General_CS_AS <> UPPER(nombre) or nombre like '%  %') despues
union all
select 'Clientes sin distrito (antes NULL, después imputado como NO ESPECIFICADO)',
       (select COUNT(*) from CERAMICAS_VALE.dbo.CLIENTES where distrito is null or LTRIM(distrito) = ''),
       (select COUNT(*) from dim_cliente where distrito = 'NO ESPECIFICADO')
union all
select 'Productos sin categoría',
       (select COUNT(*) from CERAMICAS_VALE.dbo.PRODUCTOS where categoria is null),
       (select COUNT(*) from dim_producto where categoria is null)
union all
select 'Descripciones con minúsculas',
       (select COUNT(*) from CERAMICAS_VALE.dbo.PRODUCTOS where descripcion COLLATE Latin1_General_CS_AS <> UPPER(descripcion)),
       (select COUNT(*) from dim_producto where descripcion COLLATE Latin1_General_CS_AS <> UPPER(descripcion))
union all
select 'Productos con precio de prueba (<= 1)',
       (select COUNT(*) from CERAMICAS_VALE.dbo.PRODUCTOS where precio <= 1),
       (select COUNT(*) from dim_producto where precio <= 1)
go

-- 3. KPI: Monto vendido por año y mes
select T.año, T.mes, T.nombreMes, SUM(F.monto_vendido) monto, SUM(F.cantidad) cantidad
from fac_ventas F join dim_tiempo T on T.fecha = F.fecha
group by T.año, T.mes, T.nombreMes order by T.año, T.mes
go

-- 4. KPI: Ventas, metraje y margen por categoría
select P.categoria, SUM(F.monto_vendido) monto, SUM(F.metraje_vendido) m2,
       SUM(F.monto_vendido - F.costo_inventario) margen,
       CAST(100 * SUM(F.monto_vendido - F.costo_inventario) / NULLIF(SUM(F.monto_vendido), 0) as decimal(5,2)) margen_pct
from fac_ventas F join dim_producto P on P.id_producto = F.id_producto
group by P.categoria order by monto desc
go

-- 5. KPI: Top 10 productos de mayor rotación y 10 de menor rotación (cerámicos/porcelanatos)
select top 10 P.descripcion, SUM(F.cantidad) cajas, SUM(F.metraje_vendido) m2
from fac_ventas F join dim_producto P on P.id_producto = F.id_producto
where P.categoria in ('CERAMICOS', 'PORCELANATOS')
group by P.descripcion order by cajas desc
select top 10 P.descripcion, ISNULL(SUM(F.cantidad), 0) cajas, P.stock_actual
from dim_producto P left join fac_ventas F on F.id_producto = P.id_producto
where P.categoria in ('CERAMICOS', 'PORCELANATOS')
group by P.descripcion, P.stock_actual order by cajas, P.stock_actual desc
go

-- 6. KPI: Participación por método de pago
select M.nombreMetodo, SUM(F.monto_vendido) monto,
       CAST(100 * SUM(F.monto_vendido) / (select SUM(monto_vendido) from fac_ventas) as decimal(5,2)) participacion_pct
from fac_ventas F join dim_metodoPago M on M.id_metodoP = F.id_metodoP
group by M.nombreMetodo order by monto desc
go

-- 7. KPI: Compras por proveedor (marca)
select top 10 V.razon_social, SUM(F.monto_vendido) monto, SUM(F.costo_inventario) costo
from fac_ventas F join dim_proveedor V on V.id_proveedor = F.id_proveedor
group by V.razon_social order by monto desc
go

-- 8. KPI: Clientes VIP vs regulares
select C.tipo_cliente, COUNT(distinct C.id_cliente) clientes, SUM(F.monto_vendido) monto
from fac_ventas F join dim_cliente C on C.id_cliente = F.id_cliente
group by C.tipo_cliente
go

-- 9. KPI: Productos en stock crítico
select categoria, COUNT(*) productos_criticos
from dim_producto where estado_stock = 'CRITICO'
group by categoria order by productos_criticos desc
go
