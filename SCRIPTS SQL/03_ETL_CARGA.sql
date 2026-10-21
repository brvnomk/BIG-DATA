/* =====================================================================
   CERÁMICAS VALE - SCRIPT 3 de 3: ETL_CARGA
   Origen : base transaccional CERAMICAS_VALE + archivos planos de caja
   Destino: Data Mart CeramicasVale_DM
   Antes de ejecutar, copiar los archivos de la carpeta txt del proyecto
   a  C:\txt\ceramicas_vale\  (metodopago.txt y operacionVenta.txt)
   Cada paso deja su tiempo y número de filas en etl_bitacora y los
   registros descartados en etl_errores.
   ===================================================================== */
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
exec usp_registrar_paso '1. Limpieza de tablas', @t, 0
go


--Paso 2: Cargamos la dimension proveedor
declare @t datetime2 = SYSDATETIME()
insert into dim_proveedor (pk_proveedor, ruc, razon_social, ciudad)
select id_proveedor pk_proveedor,
       LTRIM(RTRIM(ruc)) ruc,
       UPPER(LTRIM(RTRIM(razon_social))) razon_social,                        -- estandarizamos texto
       ISNULL(NULLIF(UPPER(LTRIM(RTRIM(ciudad))), ''), 'NO ESPECIFICADO') ciudad -- completamos vacíos
from CERAMICAS_VALE.dbo.PROVEEDORES
declare @filas int = @@ROWCOUNT
exec usp_registrar_paso '2. dim_proveedor', @t, @filas
go

select * from dim_proveedor
go


--Paso 3: Cargamos la dimension producto
declare @t datetime2 = SYSDATETIME()

-- Calidad: los productos con precio de prueba (<= S/ 1) no se cargan, quedan registrados
insert into etl_errores (id_ejecucion, origen, clave, motivo)
select (select MAX(id_ejecucion) from etl_ejecucion), 'PRODUCTOS', codigo_interno, 'Precio <= 1 (valor de prueba)'
from CERAMICAS_VALE.dbo.PRODUCTOS where precio <= 1

insert into dim_producto (pk_producto, descripcion, categoria, marca, unidad_medida, m2_por_caja,
                          precio, costo_unitario, stock_actual, stock_minimo, estado_stock)
select P.codigo_interno pk_producto, D.descripcion,
       -- Transformación: la categoría casi nunca se registra, se deduce de la descripción
       case when P.unidad_medida in ('MTK', 'BX') and D.descripcion like '%PORCELANATO%' then 'PORCELANATOS'
            when P.unidad_medida in ('MTK', 'BX') then 'CERAMICOS'
            when D.descripcion like '%INODORO%' or D.descripcion like '%INNODORO%' or D.descripcion like '%LAVATORIO%'
              or D.descripcion like '%OVALIN%'  or D.descripcion like '%LAVADERO%' or D.descripcion like '%URINARIO%'
              or D.descripcion like '%ONE PIECE%' or D.descripcion like '%TANQUE%' then 'SANITARIOS'
            when D.descripcion like '%DUCHA%' or D.descripcion like '%MEZCLADORA%' or D.descripcion like '%PICO DE GANZO%'
              or D.descripcion like '%GRIFO%' or D.descripcion like '%LLAVE%' or D.descripcion like '%MONOCOMANDO%'
              or D.descripcion like '%GRIFERIA%' then 'GRIFERIA'
            when D.descripcion like '%PEGAMENTO%' or D.descripcion like '%FRAGUA%' or D.descripcion like '%SILICONA%'
              or D.descripcion like '%CEMENTO%' or D.descripcion like '%TEROKAL%' then 'PEGAMENTOS Y FRAGUAS'
            when D.descripcion like '%PERFIL%' or P.unidad_medida = 'MTR' or D.descripcion like '%CUÑA%'
              or D.descripcion like '%NIVELADOR%' or D.descripcion like '%CANTONERA%' then 'PERFILES Y NIVELACION'
            when D.descripcion like '%DECORADO%' or D.descripcion like '%DECO %' or D.descripcion like '%LISTELO%'
              or D.descripcion like '%PEPELMA%' or D.descripcion like '%CENEFA%' or D.descripcion like '%MOSAICO%' then 'DECORADOS'
            else 'ACCESORIOS Y OTROS' end categoria,
       UPPER(LTRIM(RTRIM(P.marca))) marca,
       P.unidad_medida, P.m2_por_caja, P.precio, P.costo_unitario,
       P.stock_actual, P.stock_minimo,
       case when P.stock_actual <= P.stock_minimo then 'CRITICO' else 'NORMAL' end estado_stock
from CERAMICAS_VALE.dbo.PRODUCTOS P
-- Limpieza: mayúsculas, sin tabulaciones ni espacios dobles
cross apply (select UPPER(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(P.descripcion, CHAR(9), ' '),
                                          '  ', ' '), '  ', ' '), '  ', ' ')))) descripcion) D
where P.precio > 1
declare @filas int = @@ROWCOUNT
exec usp_registrar_paso '3. dim_producto', @t, @filas
go

select * from dim_producto
go


--Paso 4: Cargamos la dimension cliente
declare @t datetime2 = SYSDATETIME()
-- Transformación: VIP = 10 % de clientes identificados con mayor monto comprado
;with compras as (
    select id_cliente, SUM(total) monto
    from CERAMICAS_VALE.dbo.VENTAS
    where estado = 'EMITIDO'
      and id_cliente not in (select id_cliente from CERAMICAS_VALE.dbo.CLIENTES
                             where nro_documento = '00000000')   -- sin "CLIENTES VARIOS"
    group by id_cliente),
ranking as (
    select id_cliente, PERCENT_RANK() over (order by monto desc) pr from compras)
insert into dim_cliente (pk_cliente, tipo_documento, nro_documento, nombre, distrito, tipo_cliente)
select C.id_cliente pk_cliente, C.tipo_documento, C.nro_documento,
       UPPER(LTRIM(RTRIM(REPLACE(REPLACE(C.nombre, '  ', ' '), '  ', ' ')))) nombre,
       ISNULL(NULLIF(UPPER(LTRIM(RTRIM(C.distrito))), ''), 'NO ESPECIFICADO') distrito,
       case when R.pr <= 0.10 then 'VIP' else 'REGULAR' end tipo_cliente
from CERAMICAS_VALE.dbo.CLIENTES C
left join ranking R on R.id_cliente = C.id_cliente
declare @filas int = @@ROWCOUNT
exec usp_registrar_paso '4. dim_cliente', @t, @filas
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
		SELECT @inicio fecha, DATEPART(yyyy, @inicio) anio, DATEPART(q, @inicio) trimestre,
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
exec usp_registrar_paso '5. dim_tiempo', @t, @filas
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
select distinct TRY_CAST(LTRIM(RTRIM(pk_metodoP)) as int),
       UPPER(LTRIM(RTRIM(REPLACE(nombreMetodo, CHAR(13), ''))))
from stg_metodoPago
where TRY_CAST(LTRIM(RTRIM(pk_metodoP)) as int) is not null
declare @filas int = @@ROWCOUNT
exec usp_registrar_paso '6. dim_metodoPago (txt)', @t, @filas
go

select * from dim_metodoPago
go


--Paso 7: Cargamos staging de operaciones de caja (archivo plano)
declare @t datetime2 = SYSDATETIME()
Bulk insert stg_operacion
	  from 'C:\txt\ceramicas_vale\operacionVenta.txt'
	  WITH
	  (FIRSTROW = 2,
	  FIELDTERMINATOR='|', ROWTERMINATOR = '0x0a')
declare @filas int = @@ROWCOUNT

-- Limpieza: quitamos espacios / salto de línea y marcamos duplicados
drop table if exists #operacion
select LTRIM(RTRIM(comprobante)) comprobante,
       TRY_CAST(REPLACE(metodoPago, CHAR(13), '') as int) metodo,
       -- si un comprobante viene duplicado se conserva el de menor código (regla fija)
       ROW_NUMBER() over (partition by LTRIM(RTRIM(comprobante))
                          order by TRY_CAST(REPLACE(metodoPago, CHAR(13), '') as int)) rn
into #operacion
from stg_operacion

insert into etl_errores (id_ejecucion, origen, clave, motivo)
select (select MAX(id_ejecucion) from etl_ejecucion), 'operacionVenta.txt', comprobante,
       'Comprobante duplicado en archivo de caja'
from #operacion where rn > 1
union all
select (select MAX(id_ejecucion) from etl_ejecucion), 'operacionVenta.txt', O.comprobante,
       'Método de pago inexistente: ' + ISNULL(CAST(O.metodo as varchar), 'vacío')
from #operacion O
where O.rn = 1 and not exists (select 1 from dim_metodoPago M where M.pk_metodoP = O.metodo)

exec usp_registrar_paso '7. stg_operacion (txt)', @t, @filas
go

select top 100 * from stg_operacion
go


--Paso 8: Cargamos la FAC Ventas (tabla de hechos)
declare @t datetime2 = SYSDATETIME()
declare @id_ejecucion int = (select MAX(id_ejecucion) from etl_ejecucion)

-- Calidad: líneas con precio o cantidad inválidos
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
  and not exists (select 1 from #operacion O where O.comprobante = V.serie_numero)

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
left join #operacion O on O.comprobante = V.serie_numero and O.rn = 1
left join dim_metodoPago D_MP on D_MP.pk_metodoP = O.metodo
where V.estado = 'EMITIDO'                          -- los comprobantes anulados no son venta
  and D.precio_unitario > 0 and D.cantidad > 0
group by D_CL.id_cliente, D_PR.id_producto, D_PV.id_proveedor,
         ISNULL(D_MP.id_metodoP, @id_no_registrado), cast(V.fecha as date)
declare @filas int = @@ROWCOUNT
exec usp_registrar_paso '8. fac_ventas', @t, @filas
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
exec usp_registrar_paso '9. Reconciliación', @t, @filas, @estado, @mensaje

-- Cerramos la ejecución
update etl_ejecucion
set fecha_fin = SYSDATETIME(),
    duracion_ms = DATEDIFF(MILLISECOND, fecha_inicio, SYSDATETIME()),
    filas_hechos = @filas,
    estado = 'EXITOSO'
where id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
go


--Resumen de la ejecución: tiempos por paso y registros descartados
select proceso, duracion_ms, filas_procesadas, estado, mensaje
from etl_bitacora
where id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
order by id_paso

select origen, motivo, COUNT(*) registros
from etl_errores
where id_ejecucion = (select MAX(id_ejecucion) from etl_ejecucion)
group by origen, motivo order by origen
go


/* =====================================================================
   Validación del Data Mart y consultas de KPIs
   (se ejecuta al final del ETL)
   ===================================================================== */
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
select T.anio, T.mes, T.nombreMes, SUM(F.monto_vendido) monto, SUM(F.cantidad) cantidad
from fac_ventas F join dim_tiempo T on T.fecha = F.fecha
group by T.anio, T.mes, T.nombreMes order by T.anio, T.mes
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
       CAST(100 * SUM(F.monto_vendido) / SUM(SUM(F.monto_vendido)) over () as decimal(5,2)) participacion_pct
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
