/* CERÁMICAS VALE - SCRIPT 1 de 3: BASE TRANSACCIONAL (OLTP)
   Crea CERAMICAS_VALE: tablas, catálogo real de 2,045 productos, proveedores, clientes y ventas.
   Orden de ejecución: 01 -> 02 -> 03 */

USE master
GO
IF DB_ID('CERAMICAS_VALE') IS NULL
    CREATE DATABASE CERAMICAS_VALE
GO
USE CERAMICAS_VALE
GO

DROP VIEW  IF EXISTS dbo.vw_export_pagos_caja
DROP TABLE IF EXISTS dbo.DETALLE_VENTAS
DROP TABLE IF EXISTS dbo.VENTAS
DROP TABLE IF EXISTS dbo.CLIENTES
DROP TABLE IF EXISTS dbo.PRODUCTOS
DROP TABLE IF EXISTS dbo.PROVEEDORES
GO

create table PROVEEDORES
(id_proveedor int primary key identity,
ruc char(11) not null,
razon_social varchar(150) not null,
telefono varchar(20),
ciudad varchar(50)
)
go

create table PRODUCTOS
(codigo_interno varchar(50) primary key,
descripcion varchar(500) not null,
unidad_medida varchar(20) not null,     -- MTK = m2, NIU = unidad, BX = caja, MTR = metro
marca varchar(100) not null,
precio decimal(10,2) not null,
categoria varchar(50) null,
m2_por_caja decimal(6,2) null,
costo_unitario decimal(10,2) null,
stock_actual int null,
stock_minimo int null,
estado varchar(15) not null default 'HABILITADO',
id_proveedor int null references PROVEEDORES
)
go

create table CLIENTES
(id_cliente int primary key identity,
tipo_documento varchar(3) not null,
nro_documento varchar(11) not null,
nombre varchar(200) not null,
distrito varchar(60) null
)
go

create table VENTAS
(id_venta int primary key,
tipo_comprobante varchar(10) not null,
serie_numero varchar(20) null,
fecha datetime not null,
id_cliente int not null references CLIENTES,
estado varchar(10) not null,            -- EMITIDO / ANULADO
total decimal(12,2) not null default 0
)
go

create table DETALLE_VENTAS
(id_venta int not null references VENTAS,
item smallint not null,
codigo_interno varchar(50) not null references PRODUCTOS,
cantidad decimal(10,2) not null,
precio_unitario decimal(10,2) not null,
descuento_pct decimal(4,2) not null default 0,
primary key (id_venta, item)
)
go

USE CERAMICAS_VALE
GO
BEGIN TRANSACTION;
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0001','PISO VALERIA 60X60 (1.80X5PZAS)','MTK','GENÉRICO',21.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0002','nacional - celima - KALI BLANCO 27x45 - kali','MTK','CELIMA',25,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0003','SABINA GRIS 25X40','MTK','GENÉRICO',19.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0004','SIGNO VERDE 25X40','MTK','GENÉRICO',20.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JIYAP0L4UR','ACUARELA CURVAS BLANCO 25X40','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0007','RUBIC LUCES PLATA 25X40','MTK','GENÉRICO',21,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0010','NAZCA BEIGE 25X40','MTK','GENÉRICO',19,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0012','ARIANNA HUESO 25X40','MTK','GENÉRICO',22.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0014','BRENDA HUESO 25X40','MTK','GENÉRICO',18.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0015','FARAH AZUL 25X40','MTK','GENÉRICO',22.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0016','CAMELIA PLATA 25X40','MTK','GENÉRICO',19,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0017','LOMAS BLANCO 25X40','MTK','GENÉRICO',21,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0018','SIGNO GRIS 25X40','MTK','GENÉRICO',21,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0019','RUBIC LUCES CELESTE 25X40','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0020','RUBIC LUCES VERDE 25X40','MTK','GENÉRICO',22,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0021','NOBLESSE ISVORI 27X45 (1.70 X CAJ) X 14 PZA','MTK','GENÉRICO',23.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0023','PISO PEPELMA AZUL 36X36 S/L (1.81X14PZAS) - SAN LORENZO','MTK','SAN LORENZO',24,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0025','PARED CHOCOLATE BEIGE 27X45 - CHOCOLATE BEIGE 27X45 (2.07 X CAJ) X 17 PZA - PARED 27.45','MTK','GENÉRICO',26.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0026','SIGNO AZUL 25X40','MTK','GENÉRICO',19.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0027','BRENDA GRIS 25X40','MTK','GENÉRICO',18.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0029','LIENZO BEIGE 25X40','MTK','GENÉRICO',19.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0032','PISO PEPELMA CELESTE 36X36 (1.81X14PZAS)','MTK','GENÉRICO',18.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0033','MARGARITA AZUL 25X40','MTK','GENÉRICO',19,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0035','BADALONA NEGRO 30X30','MTK','GENÉRICO',22.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0037','FARAH CARAMELO 30X30','MTK','GENÉRICO',21,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0040','FARAH AZUL 30X30 ( 2.34XCAJ) X 27 PZA 1RA','MTK','GENÉRICO',22.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0043','PRISMA VERDE 30X60','MTK','GENÉRICO',24.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0044','PARED FRESIA HUESO 30X60 (1.81X10PZA)COMER','MTK','GENÉRICO',22.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0045','PARED HORTENCIA PLATA 30X60 (1.81 X CAJ) X10PZA','MTK','GENÉRICO',25,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0046','FILLETI GRANITO BEIGE 30X60','MTK','GENÉRICO',26,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0047','ACUARELA CURVAS CORAL 30X60','MTK','GENÉRICO',26,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0049','nacional - FRESIA 30X60 - FRESIA GRAFITO 30X60 - CELIMA','MTK','CELIMA',31,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0050','MAYOLICA DALIA PLATA COMERCIAL 30X60 - PARED DALIA PLATA 30X60 COMERCIAL )1.81x 10PZA) - CELIMA DALIA PLATA COMERCIAL 30X60','MTK','CELIMA',25.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0051','nacional - celima dalia hueso - DALIA HUESO 30X60 SEGUNDA - dalia HUESO','MTK','CELIMA',29,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0052','FILLETI GRANITO PLUS GRIS 30X60','MTK','GENÉRICO',28.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0054','SARA PLATA 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0055','PARED SARA GRAFITO/ GRIS IMPORTADO 30X60 (1.62X9PZA)','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0056','LAR OSCURO IMPORTADO 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0057','LAR GRAFITO 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0058','SEA GRAFITO 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0060','GRECIA MARFIL 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0061','GRECIA MARRON 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0062','DECORADO CEBOLLITA 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0063','COCO CARAMELO 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0067','HOJITAS MARRON 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0068','HOJITAS BEIGE 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0069','LAR BEIGE CLARO 30X60 IMPORTADO','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0070','LAR MARRON IMPORTADO 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0071','BRIK BLACO CELIMA PRIMERA 30X60','MTK','CELIMA',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0072','SEA PLATA 30X60','MTK','GENÉRICO',33,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0073','FRESIA MARRON 30X60','MTK','GENÉRICO',24.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0074','SONOMA BEIGE 40X40','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0075','PISO SEVILLA NATURAL 45X45 (2.03XCAJ) X 10PZA','MTK','SEVILLA',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0076','ARGOS NATURAL 45X45','MTK','GENÉRICO',21,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0077','PISO MARILIA BRILLANTE 45X45 (2.03XCAJ) X 10 PZA','MTK','GENÉRICO',22,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0078','MARMOL BLANCO 45X45','MTK','GENÉRICO',22,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0080','UCAYALI NATURAL 45X45','MTK','GENÉRICO',18.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0081','QATRA NATURAL 45X45','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0083','CAIRO 45X45','MTK','GENÉRICO',21.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0086','ROBLE BEIGE 45X45','MTK','GENÉRICO',22,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0087','LAJA NEW BEIGE 45X45','MTK','GENÉRICO',23.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0088','PISO MARBELLA NATURAL 45X45 (2.44XCAJ) X12PZA','MTK','GENÉRICO',18.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0089','PISO MERIDA NATURAL 45X45 (2.44XCAJ) X 12PZA','MTK','GENÉRICO',19.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0090','PISO - PISO ACUARELA CURVAS CORAL 45X45 (2.03 XCAJ) X 10PZA','MTK','GENÉRICO',23,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0091','LAREDO NATURAL 45X45','MTK','GENÉRICO',20.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0092','THALIA PLATA 45X45 (2.08X10PZAS)','MTK','GENÉRICO',19.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0095','AVELLANA BEIGE 45X45','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0096','MOLLENDO MIX 45X45 (2.23X11PZAS)','MTK','GENÉRICO',23.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0097','JEREZ CARAMELO 45X45','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0098','KIARITA CARAMELO 45X45','MTK','GENÉRICO',21,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0099','PISO ORION BEIGE 45X45 (2.23XCAJ) X 11PZA','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0100','NATALIA MARFIL 45X45','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0102','BLANCO FORTE 45X45','MTK','GENÉRICO',20.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0103','JACARANDA 45X45','MTK','GENÉRICO',19.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0104','PISO - PISO ROBLE MIX NATURAL 1° 45X45 (2.03XCAJ) X 10PZA','MTK','GENÉRICO',23.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0105','celima - piso 45x45 natura - NATURA CARAMELO 45X45 (2.23X11PZAS)COMERCIAL - madera','MTK','CELIMA',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0107','TOLEDO 45X45','MTK','GENÉRICO',19,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0110','PISO MICHIGAN NATURAL 45X45 (2.03X CAJ) X 10PZA','MTK','GENÉRICO',28.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0111','ATENAS MARFIL 45X45','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0112','PISO LETICIA BEIGE 45X45 (2.03 XCA) X 10PZA','MTK','GENÉRICO',24.5,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0113','DAKAR 45X45 - CELIMA','MTK','CELIMA',24,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0115','SPRINGFIELD 46X46','MTK','GENÉRICO',20,'CERAMICAS','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0118','PORCELANATO NUBE 60X60','MTK','GENÉRICO',30,'PORCELANATO','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0119','PORCELANATO GRIS DOBLE CARGA 60X60 (1.44XCAJ) X 4PZA ROMASA - ROMASA GRIS 60X60','MTK','GENÉRICO',35,'PORCELANATO','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0120','PORCELANATO OXFORD MARFIL 60X60','MTK','GENÉRICO',30.5,'PORCELANATO','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0122','SUPER NEGRO 60X60 - PORCELANATO SUPER NEGRO 60X60','MTK','GENÉRICO',64,'PORCELANATO','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0124','PORCELANICO KIARA CARAMELO 60X60','MTK','GENÉRICO',28,'PORCELANATO','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0126','PORCELANICO FOREST CARAMELO 60X60','MTK','GENÉRICO',28,'PORCELANICO','HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0127','DECORADO LAR BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0128','GRECIA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0129','DECORADO ANDES ESTRELLA MAR 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0130','DECORADO SEA BAÑO 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0131','SAHARA TOALLAS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0134','SARA GRIS ESTRELLA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0135','SALDO GOTAS AZUL','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0136','HOJITAS MARFIL TOALLA BEIGE','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0138','TETERA GRIS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0139','SEA GRIS BEIGE','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0141','ROSA MARFIL','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0142','SARA PESCADITO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0143','SARA FLOR','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0144','DECORADO LADRILLO BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0145','SEA PLATA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0146','GARDENIA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0147','DECORADO PARA COSINA - DECORADO LAR COCINA 30X60 - LAR','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0148','GRECIA COFEE','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0149','DECORADO IMPORTADO ANDES TAZAS COFEE 30X60 PARA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0150','SEA COPAS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0153','SEA PLATA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0155','GRECIA MARFIL TETERA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0156','SARA GRIS TETERA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0157','PERFIL PVC CHOCOLATE 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0158','PERFIL PVC GUINDA CLARO 8.5 SUPERPLAST - SUPERPLAST','NIU','SUPERPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0159','PERFIL PVC MADERA 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0160','PERFIL PVC CUERO CLARO 8.5 USAPLAST - USAPLAST','NIU','USAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0161','PERFIL PVC BEIGE 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0162','PERFIL PVC NEGRO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0163','PERFIL PLAIN ROJO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0166','PERFIL PVC MARFIL CLARO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0167','PERFIL PVC MARMOL 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0168','PERFIL PVC BONE 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0169','PERFIL PVC NARANJA SPAY 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0172','PERFIL PVC PLAIN AZUL 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0175','PERFIL PVC MARRON OSCURO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0176','PERFIL PVC ALUMINIO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0178','PERFIL PVC ALMENDRA 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0179','PERFIL PVC CREMA 8.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0180','PERFIL PVC CHAMPAGNE 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0181','PERFIL PVC CARAMELO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0182','PERFIL PVC TABACO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0184','PERFIL PVC UVA LILA 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0185','PERFIL PVC MARRON CLARO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0186','PERFIL VERDE SPAY 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0187','PERFIL PVC TABACO 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0189','PERFIL PVC CARAMELO CLARO 11.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0190','PERFIL PVC MARRON OSCURO 11.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0195','PERFIL PVC BLANCO 11.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0196','PERFIL PVC GRIS PLATA 11.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0197','PERFIL PVC MADERA 11.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0198','PERFIL PVC CARAMELO 10.5 SUPERPLAST - SUPERPLAST','NIU','SUPERPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0201','PERFIL PVC MARMOL 11.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0202','PERFIL PVC CUERO OSCURO 11.5 - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0206','PERFIL ALUMINIO BRILLO 11,5X2.4 ROSSIPLAST - ROSSIPLAST','NIU','ROSSIPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0211','PERFIL ALUMINIO BRILLANTE 11.5 X2M USAMETAL - USAMETAL','NIU','USAMETAL',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0213','RODOPASO GRIS PLATA - BELLAPLAST','NIU','BELLAPLAST',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0214','RODOPASO CUERO CLARO - BELLAPLAST','NIU','BELLAPLAST',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0215','RODOPASO CHOCOLATE','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0216','RODOPASO NEGRO - BELLAPLAST','NIU','BELLAPLAST',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0217','RODOPASO MARRON OSCURO','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0218','LAPIZ DE ACERO GRIS 2,5 - BELLAPLAST','NIU','BELLAPLAST',12.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0221','LAPIZ DE ACERO GRIS 1,5 - BELLAPLAST','NIU','BELLAPLAST',11.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0222','LAPIZ DE ACERO GRIS 2 - BELLAPLAST','NIU','BELLAPLAST',11.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0225','PERFIL ALUMINIO BRILLANTE 12X2.40 VICEPLAST - VICEPLAST','NIU','VICEPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0226','ESQUINERO MATE 8MMX2.3M - BELLAPLAST','NIU','BELLAPLAST',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0228','LAPIZ DE ACERO GRIS 3 - BELLAPLAST','NIU','BELLAPLAST',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0229','importado - aluminio - CANTONERA 1.5" SEMIPESADA','MTR','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P003','CANTONERA DE 2" SEMIPESADA','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0231','CANTONERA 1.5" LIVIANA (5.95MT)','MTR','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0232','CANTONERA DE 2" LIVIANA IMPORTADA (5.96mt)','MTR','GENÉRICO',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0248','FRAGUA CHEMICAL HUESO - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0249','FRAGUA CHEMICAL VERDE LIMON PLAIN - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0250','FRAGUA CHEMICAL CREPUSCULO - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0251','FRAGUA CHEMICAL NEGRO - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0252','FRAGUA CHEMICAL GRIS PLATA - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0253','FRAGUA CHEMICAL CARAMELO - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0254','FRAGUA CHEMICAL MADERA - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0255','FRAGUA SANSON GRIS - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0256','FRAGUA SANSON ARENA - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0257','FRAGUA SANSON MADERA - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0258','FRAGUA SANSON MARRON - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0259','FRAGUA SANSON HUESO - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0260','FRAGUA CELIMA MADERA - CELIMA','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0261','FRAGUA CELIMA MARRON - CELIMA','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0262','FRAGUA CELIMA BEIGE - CELIMA','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0263','FRAGUA CELIMA HUESO - CELIMA','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0264','FRAGUA MAESTRO MADERA - MAESTRO','NIU','MAESTRO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0265','FRAGUA CHEMA BLANCO - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0266','FRAGUA CHEMA CASTAÑA - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0267','FRAGUA CHEMA MARFIL - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0268','FRAGUA CHEMA MADERA - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0269','FRAGUA CHEMA CUERO - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0270','FRAGUA CHEMA DUNA - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0271','FRAGUA SANSON BLANCO - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0272','FRAGUA SANSON CUERO - SANSON','NIU','SANSON',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0273','FRAGUA CELIMA GRANIZO - CELIMA','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0274','FRAGUA CHEMICAL BLANCO - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0275','FRAGUA CHEMICAL GRIS - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0276','FRAGUA CHEMICAL BEIGE - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0277','FRAGUA CHEMICAL AZUL - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0278','FRAGUA CHEMICAL ARENA - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0279','FRAGUA CHEMICAL TURQUEZA - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0280','FRAGUA CHEMICAL GUINDA - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0281','FRAGUA CHEMICAL MARRON - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0282','FRAGUA CHEMICAL CHOCOLATE - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0283','FRAGUA CHEMICAL AZUL PASTEL - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0284','FRAGUA CHEMICAL CELESTE - CHEMICAL','NIU','CHEMICAL',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0285','FRAGUA CHEMICAL CUERO - CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0286','FRAGUA CHEMA HUESO - CHEMA','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0288','OVALIN HG CUADRADO BLANCO - HG','NIU','HG',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0289','OVALIN XM RECTANGULAR BLANCO - XM','NIU','XM',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0290','OVALIN RECTANGULAR BONE XM - XM','NIU','XM',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0291','OVALIN REDONDO BLANCO XM - XM','NIU','XM',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0292','OVALIN REDONDO BONE XM SIN P/G - XM','NIU','XM',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0293','OVALIN REDONDO BLANCO XM - XM','NIU','XM',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0294','OVALIN XM PORTAGRIFERIA REDONDO BLANCO - XM','NIU','XM',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0295','OVALIN PARA EMPOTRAR BLANCO','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0296','OVALIN DE VIDRIO MARRON SIN P/G','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0297','OVALIN DE VIDRIO ROJO','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0298','OVALIN PORTAGRIFERIA REDONDO BLANCO FRATELLI - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0299','OVALIN PORTAGRIFERIA RECTANGULAR BLANCO FRATELLI - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0300','OVALIN RECTANGULAR FRATELLI BONE - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0301','OVALIN OVALADO FRATELLI BLANCO - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0302','OVALIN REDONDO MARBEL FRATELLI - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0303','OVALIN CUADRADO BLANCO FRATELLI SIN P/G - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0304','OVALIN REDONDO TAZON BLANCO FRATELLI - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0305','OVALIN FLOR FRATELLI BLANCO - FRATELLI','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0312','LAVATORIO MANCORA TREBOL BLANCO - LAVATORIO MANCORA BLANCO TREBOL - TREBOL','NIU','TREBOL',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0313','LAVATORIO MANANTIAL BLANCO TREBOL - TREBOL','NIU','TREBOL',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0314','LAVATORIO BONE FV - FV','NIU','FV',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0315','LAVATORIO BONE BARCELONA - BARCELONA','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0316','LAVATORIO BLANCO EL DORADO - EL DORADO','NIU','EL DORADO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0317','LAVATORIO Y PEDESTAL FV AZUL PASTEL - FV','NIU','FV',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0318','LAVATORIO BONE HISPANO - HISPANO','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0319','LAVATORIO BONE TREBOL - TREBOL','NIU','TREBOL',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0320','LAVATORIO BALI DACQUA BLANCO - DACQUA','NIU','DACQUA',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0321','LAVATORIO LARA BLANCO - LARA','NIU','LARA',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0322','LAVATORIO MANANTIAL BONE - MANANTIAL','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0323','LAVATORIO Y PEDESTAL FLORIDA ECONOMICO BLANCO - FLORIDA ECO','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0326','PEDESTAL BONE FV - FV','NIU','FV',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0327','PEDESTAL TREBOL BLANCO - TREBOL','NIU','TREBOL',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0328','PEDESTAL LARA BLANCO - LARA','NIU','LARA',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0329','PEDESTAL TWENTY BLANCO - TWENTY','NIU','TWENTY',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0333','LAVADERO DE 2 POZAS C/SC FRATELLI - FRATELLI','NIU','FRATELLI',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0334','LAVADERO 2 POZAS S/SC XM - XM','NIU','XM',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0335','LAVADERO 80X44 C/SC TEKA - TEKA','NIU','TEKA',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0336','LAVADERO 2POZAS 116X55 CON S/SC','NIU','GENÉRICO',170,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0339','LAVADERO 1PZA 80X52 C/SC','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0347','INNODORO FV SIFON BOTON BONE - FV','NIU','FV',200,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0348','INODORO ONE PIECE HISPANO BONE - ISPANO','NIU','HISPANO',285,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0349','INNODORO ONE PIECE DACQUA BLANCO - DACQUA','NIU','DACQUA',265,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0350','INNODORO RAPI JET PALANCA BONE TREBOL - TREBOL','NIU','TREBOL',275,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0352','INNODORO TWENTY PALANCA BLANCO HG - HG','NIU','TWENTY',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0354','INNODORO RAPI JET PALANCA TREBOL BLANCO - TREBOL','NIU','TREBOL',275,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0357','INNODORO RAPI JET PREMIUM BOTON TREBOL BLANCO - TREBOL','NIU','TREBOL',295,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0358','BAÑO ONE PIECE TWENTY BLANCO - TWENTY','NIU','TWENTY',310,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0360','INNODORO SIFON BOTON BLANCO DACQUA - DACQUA','NIU','DACQUA',215,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0361','URINARIO BONE HISPANO - HISPANO','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0362','URINARIO HISPANO BLANCO - ISPANO','NIU','HISPANO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0363','URINARIO BLANCO EL DORADO - EL DORADO','NIU','EL DORADO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0364','URINARIO BONE MILANO - MILANO','NIU','MILANO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0365','TRAMPA PAVCO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0366','TRAMPA CON REGISTRO RECORD','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0367','TRAMPA CORRUGADA PVC TREBOL - TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0368','TRAMPA CORRUGADA SEVILLA','NIU','SEVILLA',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0369','TRAMPA SPLENDY','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0370','nacional - PVC - TRAMPA P RECORD - P','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0371','TRAMPA BOTELLA PARA LAVATORIO FIORI','NIU','FIORI',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0372','TUBO DE ABASTO 1/2 X 7/8 TREBOL - TREBOL','NIU','TREBOL',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0373','TUBO DE ABASTO DE 1/2 X 1/2 SANI','NIU','SANI',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0374','TUBO DE ABASTO 1/2 X 1/2 METUSA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0375','TUBO DE ABASTO DE 1/2 X 7/8 METUSA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0378','TUBO DE ABASTO 1/2 X 1/2 TREBOL','NIU','TREBOL',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0379','CANASTILLA DE DESAGUE 3 1/2 RECORD','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0380','CANASTILLA DE DESAGUE ECONOMICO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0381','CANASTILLA DE DESAGUE 3 1/2 AMOAL','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0382','CANASTILLA DUCHAS CHINA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0383','CANASTILLAS DE POSAS CHINA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0384','DESAGUE PVC FRATELLI','NIU','FRATELLI',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0385','DESAGUE LAVATORIO COSINA DE 4 - GRFERIA - DESAGUE ACERO INOXIDABLE FRATELLI - IMPORTADO','NIU','FRATELLI',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0386','DESAGUE PLASTICO SANIFER','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0387','DESAGUE DE TINA JAMECO','NIU','JAMECO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0388','DESAGUE CROMADO DE 1/4 VENICE','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0390','DESAGUE CROMADO OVALIN APACHE','NIU','APACHE',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0391','EMPAQUE URINARIO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0392','CUÑAS - CUÑA F=3','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0393','REPUESTO DE NIVELADORES F3 DE 1MM','NIU','F3C',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0394','VALVULA CESTILLA TEKA','NIU','TEKA',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0395','REPUESTO ROSCA NIVELADOR FABREPLAST SOMBRERITO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0397','NIVELADOR ROSCA KIT FABREPLAST','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0398','REGISTRO - GRFERIA - REGISTRO DE 2" ECO BRONCE - NACIONAL','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0399','REJILLA PESADA','NIU','GENÉRICO',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0400','TEFLON ROJO','NIU','GENÉRICO',1.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0401','PERNOS DE ANCLAJE','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0402','UÑAS PARA LAVATORIO GALVANIZADAS','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0403','PERNOS DE TANQUE','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0408','nacional - REGISTRO DE 4 CROMADO - REGISTRO DE 4" CROMADO - GRIFERIA','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0409','REGISTRO DE 6" CROMADO TAMI - TAMI','NIU','TAMI',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0410','REGISTRO DE 8"','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0411','BLOCK DE VIDRIO CRUZETAS','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0413','JABONEROS ACRILICOS CHINOS','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0417','ACCESORIO DE TANQUE TREBOL EN HG - HG','NIU','TREBOL',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0418','ACCESORIO DE TANQUE PALANCA HG - HG','NIU','HG',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0419','ACCESOIO DE TANQUE PARA BAÑO ONE PIECE','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0420','REPUESTO DE TANQUE COMPLETO','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0421','TAPA SIMPLE BONE','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0422','TAPA SIMPLE AZUL PASTEL','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0423','TAPA ECONOMICA VERDE LIMON FIORI - FIORI','NIU','FIORI',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0425','TAPA ONE PIECE BONE','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0428','TAPA ECONOMICA GRIS FIORI - FIORI','NIU','FIORI',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0429','TAPA VERDE LIMON TREBOL','NIU','TREBOL',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0432','TAPA BABY BLANCO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0434','TAPA SIMPLE GUINDA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0436','TAPA SIMPLE VERDE LIMON','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0437','TAPA ECONOMICA NEGRO FIORI - FIORI','NIU','FIORI',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0438','TAPA ECONOMICO FIORI BLANCO','NIU','FIORI',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0439','TAPA NEGRO TREBOL 32','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0440','TAPA ECONOMICA BONE FIORI - FIORI','NIU','FIORI',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0442','TAPA VERDE LIMON TREBOL','NIU','TREBOL',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0443','TAPA ECONOMICA AZUL PASTEL FIORI - FIORI','NIU','FIORI',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0444','TAPA BLANCA TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0445','LAVATORIO DORADO BABY BLANCO','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0447','LLAVE DE DUCHA TIMON DE BARCO FRATELLI','NIU','FRATELLI',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0448','LLAVE DE DUCHA PERILLA CROMADA VAINSA - VAINSA','NIU','VAINSA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0449','LLAVE DE DUCHAS PALANCA VAINSA - VAINSA','NIU','VAINSA',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0451','LLAVE DE OVALIN SOBRE PONER LIVIANO','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0452','LLAVE LAVATORIO PERILLA ECO VAINSA - VAINSA','NIU','VAINSA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0453','LLAVE DE DUCHA PERILLA ACRILICA SIN MARCA - SIN MARCA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0454','LLAVE LAVATORIO TREBOL LINEA ECO - TREBOL','NIU','TREBOL',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0455','LLAVE DE LAVATORIO NACIONAL FAGRICENTER - FAGRICENTER','NIU','FAGRICENTER',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0456','LLAVE DE DUCHA ITALGRIF','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0462','LLAVE DE DUCHA MONOCOMANDO PREMIER','NIU','PREMIER',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0465','LLAVE LAVATORIO ECONOMICO','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0466','LLAVE PARA URINARIO','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0467','LLAVE DE OVALIN GIRALDI','NIU','GENÉRICO',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0468','LLAVE DE OVALIN LARGO CROMADO','NIU','GENÉRICO',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0469','DUCHA MONOCOMANDO FORTALY','NIU','FORTALY',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0470','PICO DE GANSO APACHE PERILLA ALETA','NIU','APACHE',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0471','CAÑO JARDIN DE BRONCE NACIONAL','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0476','PICO DE GANZO FLEXIBLE MODELO Z','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0477','PICO DE GANZO ECONOMICO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0478','PICO DE GANSO NACIONAL FAGRICENTER','NIU','FAGRICENTER',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0480','MESCLADORA PICO DE GANZO RUBINETO','NIU','RUBINETO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0481','MEZCLADORA DE DUCHAS','NIU','GENÉRICO',170,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0482','MEZCLADORA MONOCOMANDO PARA DUCHA - FRATELLI','NIU','FRATELLI',255,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0483','MEZCLADORAS PARA DUCHA DE 8 TREBOL','NIU','TREBOL',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0484','MESZCLADORA DE COCINA RUBINETO','NIU','RUBINETO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0485','MEZCLADORA DE DUCHA SEVILLA PERILLA ACRICLICA - SEVILLA','NIU','SEVILLA',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0486','BRAZO DE DUCHA HIDRO MASAJE VAINSA - VAINSA','NIU','VAINSA',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0487','himportado - BRAZO DUCHA - BRAZO DE DUCHA ECONOMICO REDONDA DIROFASA - DIROFASA','NIU','DIROFASA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0488','BRAZO DE DUCHAS TREBOL','NIU','TREBOL',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0489','CABEZA DE DUCHA REDONDA ECONOMICA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0490','CABEZA DE DUCHA OVALADO ECONOMICO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0491','CABEZA DE DUCHA CUADRADA ECONOMICA','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0493','KIT DE BAÑO BONE','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0494','KIT DE BAÑO MORA','NIU','GENÉRICO',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0495','KIT DE BAÑO NEGRO','NIU','GENÉRICO',105,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0496','KIT DE BAÑO FRATELLI','NIU','FRATELLI',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0497','BLOCK DE VIDIRIO ESTRELLA','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0498','BLOCK DE VIDRIO OLAS','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0499','BLOXK DE VIDRIO ESTRELLA','NIU','GENÉRICO',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0500','BLOCK DE VIDRIO ROMBO','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0501','BLOCK DE VIDRIO CUADRICULADO','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0507','PEGAMENTO TREBOL GRIS','NIU','TREBOL',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P0508','PEGAMENTO TREBOL BLANCO EXTRA.','NIU','TREBOL',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KM17ZY0CF4','BLANCO NIEVE 27X45','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VK19MNT2BG','PISO - PORCELANICO DE 60X60 - PORCELANICO AUSTIN NATURAL 60X60 - AUSTIN NATURAL','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('RMZS2ILTOJ','SABINA GRIS 27X45','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01052','SIGNO AZUL 27X45 (2.07 X CAJ) X 17 PZA','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('387VWEX05H','LLAVE DE DUCHA ALETA TREBOL','NIU','TREBOL',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01054','LLAVE DE DUCHA TREBOL LINEA ECO','NIU','TREBOL',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ZPKHV1O4ND','PORCELANATO PIEDRA GRIS 60X60','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('TFSW5XZMLN','Juego de uña delgada','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01057','RUEDA DE CORTADORA MARCA RUBÍ','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VIQYBP86FO','Uña delgada pequeña','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('BHYWJ283RS','Uña delgada grande','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01060','RUEDA DE CORTADORA MARCA JAMTEXS','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01061','ROBLE CARAMELO 45X45 (2.03x10PZAS) - Comercial','MTK','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('WU738MG12P','DALLAS BEIGE EXTRA 45X45 - Extra','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01063','DALLAS BEIGE 45X45 COMERCIAL (2.03X10PZAS) - Comercial','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EQHLVKO0GN','nacional - madera premium - MADERO PREMIUM 45x45 - celima','MTK','CELIMA',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1MAB68TPC3','SONOMA BEIGE 30X60','MTK','GENÉRICO',36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('89TLHB17EP','FRAGUA AQUIMARZA BEIGE','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QPIL21S5YJ','PISO ESPAÑOL 47X47 - GRECIA CREMA 47X47 - ESPANOL','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('OQWDE2PB0M','ISHPINGO 45X45','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6IRP9E0NLS','VENTURA NATUTAL 45x45','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01077','PARED AMAPOLA HUESO 30X60 (1.81X10PZAS)','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01078','RUBIC LUCES PLATA 27X45 (2.07 X CAJ) X 17 PZAS','MTK','GENÉRICO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01079','SIGNO GRIS 27X45 (2.07X CAJ) X 17 PZAS','MTK','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01081','DUNAS BLANCO BRILLANTE 25X40 (2.03 X CAJ) X 20 PZA','MTK','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01085','PARED CAYALTI MIX BEIGE 30X60 (1.80X10PZA)','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('OD9S0NE5GV','SONOMA GRIS 30X60','MTK','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('M2LTRDFES9','nacional - FACHALETA 30X60 - AREQUIPA GRIS MIX 30X60 - CELIMA','MTK','CELIMA',37,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01092','PARED DALIA BEIGE 30X60 1RA (1.81 X 10PZA)','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01094','FACHALETA YUNGAY GRIS 30X60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01095','PARED BLANCO BRILLANTE 30X60 (2.18XCAJ) X12PZAS','MTK','GENÉRICO',35,NULL,'DESHABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('MP1AY89EZX','HOJITAS GRIS 30X60','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('DGZQV7LKWB','ACCESORIO DE 1/2 BAÑO COMPLETO ECKOGRIF','NIU','ECKOGRIF',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7NQX4BL6R2','PORCELANICO OLIVO NATURAL 60X60','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GBC0FAZE41','piso guayacan - piso 60 - PORCELANICO GUAYACAN NATURAL 60X60 - celima','MTK','CELIMA',28.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01100','PORCELANATO HEXAGONO GRIS 60X60 (1.44 X CAJ) X4PZA','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01101','PORCELANATO SELVA NEGRO 60X60 (1.44XCAJ) X4PZA VIDRI - SELVA NEGRA VITRIFICADO','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01102','PORCELANATO DALLAS GRIS MATE 60x60 (1.44 XCAJ) X 4 PZA','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('61ISOZY8RN','PORCELANATO TABLA GRIS MATE 60X60','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GDC9F6J1SY','INNODORO RAPI JET PALANCA BONE FV','NIU','FV',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('D5EYUJLR4K','INNODORO RAPI JET PALANCA GUINDA FV','NIU','FV',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01108','LAVATORIO Y PEDESTAL FV GUINDA - FV','NIU','FV',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('RY59BS4GQC','PEDESTAL GUINDA FV','NIU','FV',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('OFHE52QLUN','INNODORO AZUL PASTEL RAPI JET BOTON TREBOL','NIU','TREBOL',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1V67QUXWK9','LAVATORIO AZUL PASTEL TREBOL','NIU','TREBOL',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7WF493QKNT','PEDESTAL AZUL PASTEL TREBOL','NIU','TREBOL',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LEO95YD1AV','PORCELANATO NEGRO VITRIFICADO 60X60','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EFJXY0RL7C','PORCELANATO VITRIFICADO DALLASGRIS 60X60','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('CAVGFS20TJ','PORCELANATO VITRIFICADO TABLA GRIS 60X60','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01118','PORCELANATO NOGAL MARRON 60X60 (1.44XCAJ) X 4PZA','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GLF2P0VR6Q','PORCELANTO SUPER NEGRO 60x60','NIU','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('L4QSOM723K','LLAVE URINARIO FAGRICENTER','NIU','FAGRICENTER',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('G569SDUT14','PICO GANZO FLEXIBLE COLORES R/U FORTALY','NIU','FORTALY',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('SX9O8ZATYJ','PICO DE GANZO FLEXIBLE','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('T3J1UFLAXP','PORCELANATO NEGRO MATE 60X60','MTK','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('3EIXP9SYLJ','TRAMPA BOTELLA SANIFER','NIU','GENÉRICO',8.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JNW2B37Q8D','INNODORO ONE PIECE BABY BLANCO','NIU','GENÉRICO',200,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('J42RPX35D0','INNODORO ONE PIECE ORANGE BLANCO','NIU','GENÉRICO',480,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ATX21JPR6U','PEDESTAL ORANGE BLANCO','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5YVDRWE3KU','LAVATORIO ORANGE BLANCO','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GYLD76JSVE','ACCESORIO TANQUE DOBLE BOTON HG','NIU','HG',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8USO53W2XG','FRAGUA AQUIMARZA CUERO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KVBW3ZXJ8Y','FRAGUA AQUIMARZA GRIS PERLA','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01138','FRAGUA AQUIMARZA CELESTE PISCINA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8RDYSFXZ3K','FRAGUA AQUIMARZA PARACAS','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01140','FRAGUA AQUIMARZA MARRON CLARO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LV3SGNKMEH','FRAGUA AQUIMARZA GRIS','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5M034FJHGS','FRAGUA AQUIMARZA CREMA','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('HE1N7TSRQW','FRAGUA AQUIMARZA CHOCOLATE','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JK8V6AXUET','FRAGUA AQUIMARZA MADERA','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('SIMC9XJ72Y','FRAGUA AQUIMARZA ROJO PLATE','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('T1VF709J5A','FRAGUA AQUIMARZA VERDE PLATE','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EV1RTBGCF7','FRAGUA AQUIMARZA AZUL','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ZR7ELSHPQA','nacional - PVC - TRAMPA SOLA TITOMACC','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('F40KOUQP97','BRAZO DE DUCHA FRATELLI','NIU','FRATELLI',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01153','REJILLA DE 2" IMPORTADO PESADO','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01154','REJILLA DE 4" CROMADO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('48OF1P5ETH','REGISTRO CON REJILLA DE 4"','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01156','LLAVE DE OVALIN CORTO PALANCA FRATELLI ZRGA Z-8 - FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01157','LLAVE DE OVALIN CORTO FRATELLI PESADO ALETA ZRGA -Z-10','NIU','FRATELLI',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01158','REGADERA DE DUCHA CUADRADA DE 8" FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01159','LLAVE DE DUCHA MONOCOMANDO FRATELLI - FRATELLI','NIU','FRATELLI',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01160','MEZCLADORA DE DUCHA MONOCOMANDO - PREMIER - PREMIER','NIU','PREMIER',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('H18IAREMQO','TRAMPA BOTELLA ECKOGRIF','NIU','ECKOGRIF',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('04JZC8B2R5','LLAVE LAVATORIO BAJO OVALIN -FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01163','LLAVE MEZCLADORA MONOCOMANDO GIRALI - GIRALI','NIU','GIRALI',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01164','PICO DE GANSO PARA COCINA VAINSA - MANIJA ACRILICA - VAINSA','NIU','VAINSA',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QCJ7R40IKN','TRAMPA P SIN REGISTRO CROMADO OROS','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('W510QZXO4R','LLAVE LAVATORIO SEMIPESADO AL-FORTALY','NIU','FORTALY',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('R1QL9TD7UP','LLAVE LAVATORIO HG','NIU','HG',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JUFWQ7MDB3','LLAVE LAVATORIO BAJO FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JLHWKED5XC','LLAVE LAVATORIO LIVIANO ALTO FRENCIA','NIU','FRENCIA',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ZLGO1F3YRP','PICO DE GANZO FLEXIBLE C&A','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('HUWM1FCDIR','PICO DE GANZO FLEXIBLE APACHE','NIU','APACHE',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01174','TRAMPA CROMADA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('R6DT9LFWN1','TRAMPA TRAMONTINA DOBLE POZA','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('L38SOJUWGD','RAKKI 45X45','MTK','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01177','CALIFORNIA CARAMELO 45X45 (2.03 X 10PZAS)','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01178','PISO ARKANSAS NATURAL 45X45 (2.44XCAJ) X12PZA','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01182','PISO DIAMANTINA HUESO 60X60 (PORCELANICO) (1.80X5PZAS)','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('HMDWTYJI30','PORCELANICO FARO CARAMELO 60X60','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01185','PORCELANICO ARCE NATURAL 60X60 (1.80X5PZAS) COM.','MTK','GENÉRICO',28.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9JD1L4PTWZ','LLAVE DE DUCHA ALETA VAINSA','NIU','VAINSA',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01187','LLAVE LAVATORIO IMPORTADO PERILLA VARIOS','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VC48GM1PJ6','PORCELANATO PULIDO BETAS BEIGE 60X60','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01190','LLAVE JARDIN NACIONAL','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01191','LLAVE DE DUCHA NACIONAL','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4HLJUI219T','TRAMPA SOLA --','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01196','URINARIO BONE EL DORADO - EL DORADO','NIU','EL DORADO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7CPBZX9GA2','CANASTILLA MONACO','NIU','MONACO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8GJB0AQPNL','LAPIZ CERAMICO MARMOLEADO GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('RG8NPD0T3X','INNODORO RAPI JET BOTON BONE TREBOL','NIU','TREBOL',370,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4SZUE3VB6Q','PEDESTAL TREBOL BONE','NIU','TREBOL',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JVSDN031PT','LOMAS BLANCO 27X45','NIU','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01206','PAR DE UÑAS PARA LAVATORIO DE FIERRO','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('MOPYN641DH','importado - 6" - BRAZO DE DUCHA REDONDA DE 6 - redondo','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01210','importado - HG - OVALIN REDONDO HG BONE SIN P/G - HG BONE','NIU','HG',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('XDO4FV2Y1U','IMPORTADO - HONDAS CREMA 30x60 - CELIMA','MTK','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('WC1E7Y8649','himportado - MARMOL BLANCO 30x60 - marmol','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01215','nacional - SAN LORENZO - TAIPE AZUL 45x45 S/L (2.08X10PZAS) - TAIPE AZUL','MTK','SAN LORENZO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('D4W8SJK1HM','LAVADERO IMPORTADO - FRATELLY - LAVADERO COSINA PARA GRANITO GRANDE 57X42 - GRANITO','NIU','FRATELLI',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6RHVMI2UTC','PISO - CELIMA - LAJAGRIS','MTK','CELIMA',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01220','CELIMA - CERAMICA - PISO IPANEMA CUERO 45X45 (2.03XCAJ) X10PZA - GEOMETRICO','MTK','CELIMA',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('MNJ0HQIDTF','himportado - cosina - PICO DE GANZO ECONOMICO - pared','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01225','nacional - PICO DE GANSO PARA COCINA TREBOL - TREBOL','NIU','TREBOL',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01226','himportado - PVC - TRAMPA BOTELLA FRATELLI - P','NIU','FRATELLI',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EDS762LNRK','DUCHA ECO - BRAZO DE DUCHA ECONOMICO CUADRADA - CUADRADA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ERP5C1QJ4Z','CROMADA - ECO - BRAZO DE DUCHA ECONOMICO REDONDA EN CAJA - CUADRADA','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01231','himportado - BRAZO DUCHA - REGADERA DE DUCHA OVALADA EN CAJA SEVILLA - SEVILLA','NIU','SEVILLA',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01233','CAÑO COSINA IMPORATADO - MANGUERAS - PICO DE GANSO AL MUEBLE CON MANGUERA DE COLORES SIN MARCA - CORRUGADA','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01236','CERAMICA - PORCELANICO - PISO BRISTOL CARAMELO DE 60X60 (1.80X5PZAS) - CELIMA','MTK','CELIMA',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FUT75VKZ1G','nacional 24X40 - CERAMICA - MAVI AZUL SAN LORENSO - SAN LORENSO','MTK','SAN LORENZO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('AP0JFDU9R5','nacional 24X40 - CERAMICA - LARIZA TURQUEZA - SAN LORENSO','MTK','SAN LORENZO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('AW27V81UQM','PICO DE GANZO SOBRE PONER F.','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('NHZXLR7CP3','URINARIO PLUS - LLAVE URINARIO - LLAVE URINARIO PLUS FRATELLI - FRATELLY','NIU','FRATELLI',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01244','LLAVE PLUS - LLAVE PLUS URINARIO - LLAVE URINARIO PLUS FORTALY - FORTALY','NIU','FORTALY',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('51VQDCYGIL','VALVULA DE INGRESO FRATELLI DE 1/2','NIU','FRATELLI',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('PE9G4AJN0Y','TRAMPA P CON REGISTRO RECORD - GRIFERIA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EHBKUQ3WGM','LLAVE LAVATORIO FRATELLI PEQUEÑO C/N','NIU','FRATELLI',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('YH4EL968MQ','LLAVE LAVATORIO GRANDE DE FLUJO - FRATELLI','NIU','FRATELLI',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('E839LBN0HQ','DESAGUE PUSH- FRATELLI','NIU','FRATELLI',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6DU9RQOTE1','DESAGUE APACHE','NIU','APACHE',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('3R7ALKUPQ2','JABONERA ACRILICA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01256','MEZCLADORA DE DUCHA DE 8 RUBINETO - RUBINETO','NIU','RUBINETO',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01257','TRAMPA BOTELLA PARA LAVATORIO ECKOGRIF - ECKOGRIF','NIU','ECKOGRIF',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('WSACJ1PMIU','OVALIN MONOCOMANDO PESADO','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01261','CAÑO PARA LAVADORA MIXTO - APACHE - APACHE','NIU','APACHE',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JEUXC1VWLR','CAÑO BOTADERO JARDIN- BRONCE','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('SUMYELCXVO','DESAGUE PLUSH COMANDO-FRATELLI','NIU','FRATELLI',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6ZBK98U0DX','CAÑO BOTADERO','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('19VDJC3B57','DESAGUE PLUSH OVALIN CROMADO APACHE','NIU','APACHE',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1ICFA2ZWL4','TRAMPA RECORD CAJA','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8WLDM21C4R','ACCESORIO PLUS 2 HG','NIU','HG',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('NC6K2SD4OA','TAPA REDONDO BONE-TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('2YQ1G8LWFS','TAPA REDONDO BLANCO-TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('24JSRX89ZV','NIVELADOR MIXTO F3 AZUL','NIU','F3C',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('XTJ2E1GKLS','TAPA CAIDA LENTA ALMENDRA-TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VL892YAJ5B','NIVELADOR FABER PLASMIXTO','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('501G9OHDZW','REPUESTO FAVER PLAS 1','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('0VF7TZ9CPN','REPUESTO FAVER PLAS 2','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('0LYU52PSKH','TAPA CAIDA LENTA AZUL PASTEL-TREBO','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01283','TAPA ECONOMICA BLANCA AMERICAN','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01288','TOALLERO A GRUÑA DE ALUMINIO DE 2"','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01289','TOALLERO DE ALUMINIO DE 1/2 A PRESION','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LBKH0NUO1J','LAVADERO DE 2 POZAS- TROTAMONTINA','NIU','GENÉRICO',410,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('982ZJX0MAE','LAVADERO DE 1 POZA ONDO C/E CODIFER','NIU','GENÉRICO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01297','LAVADERO DE 1 POZA CHICO TRATAMONTINA','NIU','GENÉRICO',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('XPFCK7VMG5','DECORADO PARA COSINA - DECORADO ANDES COFFY COSINA 30X60 - ANDES COFI','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LHAMF7UQKX','DECORADO PARA COSINA - DECORADO SEA COSINA 30X60 - SEA COSINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('URYA2K3QDS','DECORADO PARA COSINA - DECORADO COFFI LATE COSINA 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('98K3X4LTRM','DECORADO PARA COSINA - DECORADO TETERA GRIS COSINA 30X60 - TETERA GRIS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('3MY72WJBSI','DECORADO PARA BAÑO - DECORADO SEA PLATA BAÑO 30X60 - SEA PLATA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01305','DECORADO IMPORTADO GRESIA PEZ BAÑO 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9IKQWVY34A','DECORADO PARA BAÑO - DECORADO SAHARA TOALLA BAÑO - SAHARA TOALLA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('U724DLBZTY','DECORADO PARA BAÑO - DECORADO TOALLA BEIGE COSINA 30X60 - TOALLA BEIGE','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9GHFI5CASR','DECORADO PARA BAÑO - DECORADO TOALLA AZUL 30X60 - TOALLA AZUL','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('MGPIK9VC47','DECORADO PARA COSINA - DECORADO DONAS COSINA 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01310','DECORADO PARA COCINA - DECORADO SARA PLATA COCINA - SARA PLATA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6WLNUX8Y5Q','DECORADO PARA COSINA - DECORADO PLATOS AZUL 30X60 - PLATOS AZUL','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6NEL3UB9GS','DECORADO PARA COSINA - DECORADO COCO COSINA 30X60 - COCO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('RHUP0LQNGA','DECORADO PARA COSINA - DECORADO FLOR GRIS FRESIA 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('2Z35WHF0VL','DECORADO COCO MARFIL COSINA 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1OL5CG7ETS','DECORADO PARA BAÑO - DECORADO CEBOLLA BAÑO 30X60 - CEBOLLA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('3V4CD25Q8U','DECORADO PARA - DECORADO ROSAS COCO MARFIL 30X60 - ROSAS COCO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('NHDCY5F3I8','DECORADO ROSAS COCO MARFIL 30X60 - ROSAS COCO MARFIL','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KFSWUA3VJT','DECORADO PARA BAÑO - DECORADO GARDENIA BAÑO 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('UOI2PX01TL','MISHIGAN NATURAL 45X45','NIU','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01321','PARED AMAPOLA PLATA 30X60 PRIMERA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8AQTZI6MJX','ANDES MARFIL 30X60','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01323','PARED ANDES TABACO 30X60 (1.62XCAJ) X9 PZA','NIU','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('CGLXST2I3B','AMERICA BLANCO 30X30','NIU','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01326','PISO ANDREA AZUL 45X45 PRIMERA (2.23 X 11 PZAS)','NIU','GENÉRICO',21,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01330','PISO ARIANA PLATA 45X45 /2.03XCAJ) X 10PZA','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01331','PISO AUSTIN NATURAL 45X45 (2.23XCAJ) X 11PZA','NIU','GENÉRICO',21,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01333','PICO AL MUEBLE - GRIFERIA - LLAVE PARA COCINA CORRUGADO AL MUEBLE -FRATELLI - MUEBLE','NIU','FRATELLI',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4I1D3TKQFE','IMPORTADO - INNIDORO BLANCO TWENTY - INNODORO BLANCO TWENTY ONE PEACE - ONE PEACE','NIU','TWENTY',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8K5014HLX7','nacional - PORCELANICO DE 60X60 - PORCELANICO OXFOR GRAFITO DE 60X60 - SAN LORENSO','MTK','SAN LORENZO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KPQG7XSZE5','himportado - PORCELANATO DALLAS BEIGE - PORCELANATO DALLAS BEIGE 60X60 VIDRI - BEIGE 60X60','MTK','GENÉRICO',58,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01341','nacional - CELIMA 30X60 - PARED DALIA HUESO 30X60 PRIMERA - DALIA HUESO 1','NIU','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VALD6SQ4KX','nacional - PISO 45X45 ARIANA - ARIANA HUESO 45X45 - CELIMA','MTK','CELIMA',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JO5NRIV9ES','TAZA Y TANQ OMEGA - INODORO ECO - INODORO OMEGA ECO BOTON - BOTON','NIU','GENÉRICO',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('U3FP2M85OW','RODOPASO ESCALERA HUESO - CATONERA CON JEBE - RODOPASO HUESO - ALUMI','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('W8AZFYUDLT','DALIA GRIS 30X60 - CELIMA','MTK','CELIMA',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01347','PARED FRESIA PLUS GRIS 30X60 (2.18 X 12PZ) - CELIMA','NIU','CELIMA',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01350','PARED ABSOLUT BLANCO 30X60 (1.81X CAJ) X 1OPZAS - CELIMA','MTK','CELIMA',33.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01352','LLAVE URINARIO PLUSH VAINSA - VAINSA','NIU','VAINSA',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01353','PERFIL PVC IMPORTADO MARFIL #10 - IMPORTADO','NIU','GENÉRICO',4.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01355','PERFIL PVC IMPORTADO 10 MARMOL ROSSIPLAST - ROSSIPLAST','NIU','ROSSIPLAST',4.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01356','DALLAS GRIS VIDRIF 60X60 - PORCELANATO 60X60 VIDRIF GRIS - PORCELANATO DALLAS GRIS 60X60 (1.44XCAJ) X 4PZA VIDRI - DALLAS','MTK','GENÉRICO',58,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6PX4H3TM8N','GEOMETRICO 60 X60 MADERA BLANCA - VIDRIF 60X60 MADERA BLANCA - PORCELANATO MADERA BLANCA VIDRF 60X60 - MADERA BLANCA 60X60','MTK','GENÉRICO',63,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01358','PORCELANATO MATE RAYAS BEIGE 60X60 (1.44 X CAJ) X 4PZAS','MTK','GENÉRICO',49,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01359','PORCELANATO MARMOL BEIGE VIDRIF 60X60 (1.44XCAJ) X 4 PZA - VIDRIFICADO BEIGE 60X60','MTK','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JS40PNL3TR','PORCELANATO SAL Y PIMIENTA 60X60 GRANITO BLANCO - SAL Y PIMIENTA DE 60X60','MTK','GENÉRICO',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01362','MADERO CARAMELO 60X60 - MADERO 60X60 - PORCELANATO MADERO CARAMELO 60X60 (1.44XCAJ) X 4PZA VIDRIFI - VIDRFI','MTK','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('SXW8VF4BKO','CELIMA BETON GRIS 60X60 - PORCELANICO 60X60 BETON GRIS PRIMER - CELIMA 60X60','MTK','CELIMA',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01365','PORCELANATO TERRASO MATE 60X60 /1.44XCAJ) X 4 PZA','MTK','GENÉRICO',58,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EJVG5R8CID','IVORY BEIGE 27X45 S/L','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('V30JSDCAUN','LARIZA NARANJA S/L','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LHW6F1BY8P','INODORO BONE FV - fv bone','NIU','FV',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('2NU5PCI4GE','FV BONE LV Y PE - LAVATORIO Y PEDESTAL BONE FV - FV BONE','NIU','FV',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8X36TYF1GR','URINARIO NEGRO','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9HSOM1674V','TENASA PARA NIVELADORES CUÑA','NIU','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ST1KVJ9EN8','MADERA SECHURA 45X45 - PISO SECHURA 45X45 - SECHURA CELIMA 45X45 - MADERA','MTK','CELIMA',24.5,NULL,'DESHABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01377','CELIMA LEGNO 45X45 - PISO LEGNO 45X45 - PISO LEGNO CARAMELO COMER 45X45 (2.03 X CAJ) X 10PZA - MADERA','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5XD1AC4FIE','FRAGUA AQUIMARSA MARRON','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9BP4O52IDQ','BRAZO DE DUCHA ECO TREBOL - TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('OFX6NG0Y19','LARIZA BLANCO','MTK','GENÉRICO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01383','TAZA Y TANQ TREBOL BLANCO - INODORO RAPIDJET BLANCO ECO TREBOL (TAZA Y TANQUE) - RAPIDJET','NIU','TREBOL',210,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LUJ1TIMX0C','INODORO TWENTY BLANCO ONEPIZ - ONEPIZ TWENTY','NIU','TWENTY',330,NULL,'DESHABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('0X4M2T9EZA','INODORO ORANGE BLANCO ONEPIZ - ONEPIZ','NIU','ONEPIZ',345,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('X7PVE0TISC','INODORO FV BLANCO - FV','NIU','FV',210,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01394','PISO COLONIA GRIS COMERCIAL 60X60 (1.80X5PZA) - CELIMA 60X60','MTK','CELIMA',33.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('27Z193RFLJ','DESAGUE DE OVALIN COLA LARGA FAGRISUR - FAGRISUR','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('G6PKW5C12N','DESAGUE AUTOMATICO PARA OVALIN LARGO - DESAGUE LARGO IMPORTADO OVALIN CROMADO - IMPORTADO','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('A4TOFL6X3M','LAVADERO COSINA PARA GRATITO MEDIANO 44X39 - FRATELLY','NIU','FRATELLI',165,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01398','LAVADERO COCINA PARA GRANITO CHICO 39X37 FRATELLI - FRATELLY M','NIU','FRATELLI',145,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01399','PICO DE GANSO PARA COCINA VAINSA - MANIJA CROMADA - VAINSA','NIU','VAINSA',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ZF9N4GTKJC','RROLLOS DE CALE INDECO 14','NIU','GENÉRICO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('XN7L9TY3OH','RROLLO DE CALE INDECO 12','NIU','GENÉRICO',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01406','INODORO FRENCIA BONE ONE PIECE - FRENCIA','NIU','FRENCIA',235,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01407','PORCELANATO NEGRO DE 1.20X60','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KZGFMSB20L','PORCELANATO UNICOLOR GRIS 60X60','MTK','GENÉRICO',78,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('TYQOMP2S47','MAYOLICA CELIMA BLANO BRILLANTE DE 30X60 - CELIMA','MTK','CELIMA',32.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01412','PARED WALLCONCRET PLATA 30X60 (1.81X10PZAS) - CELIMA','MTK','CELIMA',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('DBTOEM597X','SET DE BAÑO FRENCIA - SET DE BAÑO ALUMINIO X 6PIEZAS ALUMINIO - FRENCIA','NIU','FRENCIA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01415','OVALIN BARQUITO BONE FRATELLI - BARQUITO','NIU','FRATELLI',145,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('3WF9EQSUPL','LAVATORIO Y PEDESTAL CELITE CLANCO IMPOR','NIU','GENÉRICO',145,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01417','PISO ATLANTA NATURAL 45X45 (2.23XCAJ) X 11PZA - ATLANTA NATURAL','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01418','PISO CIPRES MADERA BEIGE MIX COMERCIAL 60X60 (1.80 X CAJ) X5PZA - CELIMA 60X60','MTK','CELIMA',28.9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('BZVA8UYW65','PISO CELIMA MAPLE MADERA NATURAL 60X60 - CELIMA','MTK','CELIMA',27.9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GB1C75OYD6','PISO CELIMA COLCA NATURAL MAD SLM BRILLANTE 45X45 - CELIMA','MTK','CELIMA',25.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('J8L7Q3NSXT','MAYOLICA CELIMA BLANCO BRILLANTE LISO II 30X60 - CELIMA','MTK','CELIMA',33.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9QNTZDYL1C','PISO CELIMA ANDREA GRIS BRILLANTE MRM SLM 45X45 - CELIMA','MTK','CELIMA',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JB1M5TKXDQ','CELIMA - MAYOLICA C ELIMA EMPORIIO PERLA MRM II 30X60','NIU','CELIMA',32.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01427','PARED WALLCONCRET HEXAGONAL 30X60 MAYOLICA CELIMA (1.81X10PZAS) - CELIMA','MTK','CELIMA',33.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01428','SIGNO BEIGE 27X45 (2.07 X CAJ) X 17 PZA CELIMA - CELIMA','MTK','CELIMA',25.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01429','LAVATORIO Y PEDESTAL BONE TARRACO - TARRACO','NIU','TARRACO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('S02E4D6NBG','INODORO BONE TARRACO 1','NIU','TARRACO',330,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01431','KIT PARA BAÑO SEVILLA CROMADO X 6 PIEZAS - SEVILLA','NIU','SEVILLA',125,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01432','INODORO CORONA BLANCO M RAPID JET - CORONA','NIU','GENÉRICO',195,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('Y4OB96HN51','NIVELADORES INPORTADO DE 1M CELESTE CUÑAS - CUÑAS','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('X08ODVFMLC','REPUESTOS NIVELADORES OREJITAS IMPORTADAS 1M - IMPORTADO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('L4C7HE6AZK','INODORO ONEPIZ ORANGE BONE - ONEPIZ ORANGE','NIU','ONEPIZ',340,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01438','LLAVE LAVATORIO MONACO ECONOMICO - GIRALDY GANZITO','NIU','MONACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01439','PORCELANATO ROMA GRIS 60X60 (1.44 X CAJ) X4PZA VIDRIFICADO - ROMA VIDRIFICADO','MTK','GENÉRICO',68,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('2JKU8MAVIT','INODORO TREBOL EQUIPADO','NIU','TREBOL',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5L2MKFWBGI','JUEGO KITS ECO','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FB1HXRJD3V','URINARIO BLANCO EQUIPADO','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('JUQGF56RXA','FRAGUA HUESO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('AMG185WOR2','FRAGUA NEGRO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('W501RYU6CG','FRAGUA MARRON','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1B8O3I2QH6','PORCELANATO DE 1.20 X60 GRANILLA NEGRO','MTK','GENÉRICO',165,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01451','INODORO FRENCIA BLANCO ONE PIECE','NIU','FRENCIA',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01452','LAVADERO ACERO DOBLE POSA FRATELLI GRANITO - FRATELLY','NIU','FRATELLI',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7LEBWO8R62','LADERO 2POZAS PESADO - LAVADERO DE ACERO MONACO DOBLE POSA PESADO - MONACO','NIU','MONACO',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('W73I9GKZUR','MONACO 2 POZAS C/E - LAVADERO C/E MONACO 2POZAS PESADO - MONACO','NIU','MONACO',260,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01456','PISO MADERA LAMINADA BEIGE <X60 - PORCELANATO MADERA LAMINADA BEIGE 60X60 CELIMA - LAMINADA BEIGE 60X60','NIU','CELIMA',32.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01457','INODORO ONE PIECE VALI VAINSA BLANCO - VAINSA VALI','NIU','VAINSA',420,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01458','INODORO ONE PIECE VALI VAINSA BONE - VALI BONE VAINSA','NIU','VAINSA',430,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01459','LAVATORIO Y PEDESTAL BLANCO AVANTE VAINSA - AVANTE VAINZA','NIU','VAINSA',175,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01460','LAVATORIO /P BLANCO LAZIO GRANDE VAINSA - LAZIO VAINZA','NIU','VAINSA',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('TUJCHMKB14','INODORO BLANO TWENTY - INODORO BLANCO TWENTY PLUS - TWENTY ONEPIZ','NIU','TWENTY',310,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01462','LAPIZ CERAMICA PLATEADO 4 BOLITAS CORTO - PLATEADO 4 BOLITAS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('U1JBVTGKMW','LAPIZ MARMOLEADO BEIGE - MARMOLEADO BEIGE','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01464','LAVDERO DE COSINA POZA SOLA - LAVADERO COCINA FRATELLI POZA SOLA CH - FRATELLY','NIU','FRATELLI',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('B67N0AZJSF','MAYOLICA FABRIS - MAYOLICA 30X60 CURVAS BEIGE FABRIS - CURVAS BEIGE','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01466','PORCELANATO G/ JEFRY 60X60 - PORCELANATO MADERO GEOMETRICO VIDR 60X60 (1.44XCAJ) X 4PZA - MADERO','MTK','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01471','TABLON MURILLO CELIMA 20X60 - TABLON GRIS 20X60 CELIMA MURILLO SDA - CELIMA MURILLO 20X60','MTK','CELIMA',31,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01472','PISO CELIMA ANTIOKIA NATURAL 45X45 SDA - PISO ANTIOQUIA NATURAL CELIMA 45X45 SDA (2.03XCAJ) X 10PZA - CELIMA ANTIOKIA NATURAL','MTK','CELIMA',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01473','BURBUJA BLOCK - BLOCK DE VIDRIO BURBUJA - BURBUJA','NIU','GENÉRICO',14.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('F0V3IW18GC','CINTA TEFLON ROJO','NIU','GENÉRICO',2,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('CPFXIWS16Z','LLAVE PARA MESA DE OVALIN - LLAVE OVALIN MESA MONACO PESADO PALANCA - MONACO','NIU','MONACO',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('V2KRADGMPE','Fagrisur - LLAVE URINARIO FAGRISUR - Llave urinario','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01478','Pico ganzo cosina corrugado negro - LLAVE DE COSINA CORRUGADO MONACO NEGRO - Corrugado','NIU','MONACO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01479','Pico ganzo Mónaco pesado - LLAVE DE COSINA CORRUGADO MONACO PESADO - Monaco','NIU','MONACO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01486','LLAVE CORRUDADO COSINA SEMI PESADO PALAN COSTADO - PICO DE GANSO PARA COCINA CORRUGADO PALANCA COSTADO - CORRUGADO','NIU','GENÉRICO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01488','OVALIN AL MUEBLE VIDRIO - MUEBLE DE OVALIN DE VIDRIO CRISTAL EN L - ELE','NIU','GENÉRICO',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01489','OVALIN EN L VIDRIO NEGRO - MUEBLE DE OVALIN NEGRO VIDRIO EN L - ELE NEGRO','NIU','GENÉRICO',420,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01490','OVALIN MARRON VIDRIO - MUEBLE DE OVALIN MARRON VIDRIO EN L - ELE MARRON','NIU','GENÉRICO',410,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('X5QG1V2NMJ','PORCELANATO PERLA 60X60 MATE','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1ISDL68GCQ','TABLON CELIMA DE 20X60 CIPRE BEIGE - CELIMA TABLON 20X60','MTK','CELIMA',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('YK8H6A5REI','LAPIZ CERAMICO OVALADO CHICO - LAPIZ OVALADO CERAMICO PLATEADO DELGADO','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('IT8CYEM0PH','Mueble ala pared madera - MUEBLE CUADRADO VIDRIO MADERA BONE - Vidrio','NIU','GENÉRICO',400,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01507','PISO CELIMA GRANITO GRIS 60X60 - PISO GRANITO GRIS 60X60 CELIMA (1.80X5PZA) - GRANITO 60X60 CELIMA','MTK','CELIMA',33.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01508','Piso macael blanco 45x45 - PISO MACAEL BLANCO 45x45 CELI (2.03 X CAJ) X 10PZA - Celima macael 45x45','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QUIWYFOPDZ','LAV Y PEDESTAL BONE DAQUA - LAVATORIO Y PED3ESTAL DAQUA BONE - DAQUA BONE','NIU','GENÉRICO',165,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01514','LLAVE OVALIN TREBOL MODELO GANSITO - LLAVE OVALIN MODELO GANSITO TREBOL - GANSITO TREBOL','NIU','TREBOL',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01515','PISO AUSTIN 60X60 CELIMA - AUSTIN NATURAL 60X60 (1.80X5PZAS) COMERCIAL - AUSTIN','MTK','CELIMA',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('Y8QJUTMLF6','RODOPLAS','NIU','GENÉRICO',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('HSC4N9A8QB','ACSESORIO DE TANQUE TARRACO - ABS TARRACO','NIU','TARRACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01523','PORCELANATO TIGRILLO MARRON - PORCELANATO TIGRILLO MARRON 60X60 (1.44XCAJ) X 4PZA - TIGRILLO MARRON','MTK','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7VHTF2RBSC','FRAGUA HUESO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01530','PISO CELIMA DALLAS CARAMELO45X45 - PISO DALLAS CARAMELO 45X45 (2.03 XCAJ) X 10PZA - DALLAS CARAMELO','MTK','CELIMA',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01536','TAPA ECO BLANCA FAVINZA','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4W7CL5N3E2','PARED ORTENCIA','MTK','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('XZPFY6W5BJ','TABLON','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('XMABQPYEU8','DALIA BEIGE','NIU','GENÉRICO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6L37IFJGEX','TABLON CIPRES','MTK','GENÉRICO',29.43,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('95VLDWUYEF','PORCELANATO ROSALINDA','NIU','GENÉRICO',79.2,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01576','VIDRIFICADO 60X60 MADERA GRIS PLATA - PORCELANATO MADERA GRIS VIDRIFICADO 60X60 (1.44XCAJ) X4PZA - MADERA GRIS 60X60 IMPORTA','MTK','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('L6X7H1B5YS','TABLON CELIMA MAFLE CAFE 20X60 1RA - CELIMA','MTK','CELIMA',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('C2T4KZ7I9Y','RODOMETAL','NIU','GENÉRICO',17,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01582','PISO CAOBA CARAMELO 60X60 (1.80XCAJ) X 5PZA CELIMA 2DA - CAOBA CARAMELO 60X60','MTK','CELIMA',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01583','OVALIN PORTAGRIFERIA BLANCO TWENTY - OVALIN REDONDO BLANCO TWENTY CON P/G - TWENTY','NIU','TWENTY',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QGP70IRN6W','OVALIN BONE TWENTY P/g REDONDO','NIU','TWENTY',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01585','OVALIN BARQUITO BONE TWENTY SIN P/G','NIU','TWENTY',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9RJ6Y4IOXZ','INODORO ONEPIS TWENTY BONE','NIU','TWENTY',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GT9WR57NB3','FRAGUA HUESO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01593','LAPIZ CERAMICA PLATEADO 4 BOLITAS LARGO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KD5GE9QROM','BAÑOS TREBOL EQUIPADO BLANCO','NIU','TREBOL',400,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01599','MAYOLICA ANDREA BEIGE 25X40 - ANDREA BEIGE 25X40 (2.03 X CAJ) X 20 PZA - ANDREA BEIGE 25X40','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01600','CRUCETAS SIMPLES DE 1MM F3','NIU','F3C',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01601','CRUCETAS SIMPLE DE 2MM F3','NIU','F3C',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01604','PISO DALLAS CARAMELO 60X60 CELIMA - DALLAS CARAMELO COMERCIAL DE 60X60 (1.80 X 5PZA) - DALLAS CARAMELO 60X60 2','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01605','INODORO TREBOL BONE RAPID JET - RAPID JET BONE','NIU','TREBOL',310,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EKNHIDLAP9','ACSESORIO DOBLE PARA LAVADERO COSINA C/D','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01608','PEPELMAS CRISTAL CUADRADO - PEPELMAS CRISTAL','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01609','PEPELMA TIGRILLO MARRON CUADRADO - PEPELMA TIGRILLO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('WOVDEFPUXI','PEPELMA CINTA MARRON','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01611','PEPELMA SEBRA NEGRA CUADRADA - SEBRA NEGRA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('WFH294N0TG','TRAMPA BOTELLA CROMADO PARA DESAGUE - TRAMPA BOTELLA CROMADO','NIU','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QTWUNBOXIM','PEPELMA CINTA PLATA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('E1BWCL5XF6','PEPELMA TIGRILLO MARRON C/FLOR','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('EVO2F0TU3S','LADRILLO BLANCO CELIMA 30X60 - MAYOLICA BRICK BLANCO 30X60 - CELIMA BRICK BLANCO 30X60','MTK','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('39XV52IZOK','ACSESORIO TANQUE PALANCA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GOK52L61JC','KIT DE BAÑO LUJO','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('UVM13LH0ZG','INODORO TREBOL BOTON','NIU','TREBOL',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('1DYWQV97R0','TRAMPA CORRUGADA - TRAMPA CORRUGADA TREBOL - TREBOL','NIU','TREBOL',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QNJPFGRH29','FRAGUA CHEMICAL DUNAS - DUNAS CHEMICAL','NIU','CHEMICAL',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P7Y9TVEH6F','PISO CELIMA SECHURA 1 45X45 - CELIMA SECHURA 45X45','MTK','CELIMA',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01632','DECORADO 30X60 VANANA - DECORADO IMPORTADO BANANA 30X60 PARA COCINA - IMPORTADO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01633','DECORADO DE COSINA CAFETERA GRIS 30X60 - DECORADO DE COCINA CAFETERA GRIZ 30X60 IMPORTADO SARA GRIS - IMPORTADO CAFETERA 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('CXM0ODKTZL','DALIA PLATA 1RA 30X60 - CELIMA DALIA PLATA 1RA 30X60','MTK','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('J3D62Z5N8M','PICO GANZO AL MUEBLE IMPORTADO INTERMEDIO - PICO MUEBLE DE COSINA INTERMEDIA IMPORTADO - PIO MUEBLE IMPORTADO','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('Q6C1DI8MTH','PORCELANATO MATE60X60','MTK','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('97GH6NIPTE','PARED GRIS PLATA 30X60 CELIMA','MTK','CELIMA',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GN3K7AR4WX','PISO NEGRO MARMIL 45X45 CELIMA','MTK','CELIMA',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6LYNCU92OI','RODOPLAS ALUMINIO 2.40','NIU','GENÉRICO',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01654','HOLMOS MIX 60X60 CELIMA COMER - PISO CELIMA HOLMOS MIX 2DA 60X60 (1.80XCAJ) x 5 PZA - CELIMA HOLMOS MIX','MTK','CELIMA',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01655','MAYOLICA BAHIA BLANCA CELIMA 30X60 1RA - PARED BAHIA BLANCA CELIMA 30X60 1RA - CELIMA BAHIA BLANCA 30X60','MTK','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('GOVEK4U5ZN','MAYOLICA FILETIGRIS 30X60 CELIMA SDA - FACHALETA FILETI GRIS 30X60 CELIMA SDA - CELIMA FILETI GRIS','MTK','CELIMA',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01657','PISO DELTA NATURAL 45X45 CELIMA 1RA (2.03XCAJ) X 10 PZA - CELIMA DELTA NATURAL CELIMA 45X45','MTK','CELIMA',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01658','LLAVE DE LAVATORIO VAINSA - VAINSA','NIU','VAINSA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01659','LLAVE VAINSA - VAINSA','NIU','VAINSA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('3VQ61TZ9L4','fara azul 30x30','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4OUGNY1PCV','PORCELANICO60X60 CELIMA OPORTO CARAMELO - PISO 60X60 OPORTO CARAMELO - CELIMA 60X60 OPORTO CARAMELO','MTK','CELIMA',28.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('DWJSRETOQG','URINARIO','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5D0W8G9VTX','PERFIL CEPARADOR DE AMBIENTE DE 10 X 2.40','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01680','LAVATORIO BLANCO TREBOL ECO C/ KIT DE INTALACION - TREBOL ECO','NIU','TREBOL',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01681','INODORO HG PALACE BLANCO','NIU','HG',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('F1ZSWEQNOG','DECO ESPAÑA 15X60 CARTAGO COSINA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01683','DECO ESPAÑA 15X60 MAVI COSINA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FCN1SPQ7LO','DECO ESPAÑA 15X60 BARCELONA COSINA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('BE3ZX0J1GC','DECO ESPAÑA 15X60 QUIOTO BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KZFAMRGJNS','DECO ESPAÑA 15X60 PRAGA BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('RFJIVD96CN','DECO ESPAÑA 15X60 CAMILA BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FALWJYZRSP','DECO ESPAÑA 15X60 VIENA BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('LFSQ9UPK0X','TREBOSOL','NIU','GENÉRICO',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('9USPKWLG2N','RAKI PISO SAN LORENZO 45X45','MTK','SAN LORENZO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('U4XWV5D3NM','RODOPLAS','NIU','GENÉRICO',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('W6PRH14EKY','SILICONA','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01699','PARED FRESIA GRIS IMPORTADO 30X60','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6TOIUL0G41','DECORADO ESPÑOLA 30X60 LISBOA BAÑO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VKM3HTZNGL','DECORADO ESPAÑOLA 30X60 COSINA GINOS BEIGE','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('NI251FM9JC','DECORADO ESPAÑOL 30X60 ANA BAÑO ROSA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('W3XZ4YQBEG','FUXO METRO','NIU','GENÉRICO',400,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01707','TRAMPA FORTALY CORRUGADA PLUS','NIU','FORTALY',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7OKW93G1PV','DECORADO ESPAÑOL GUINOS 15X60 COSINA BEIGE','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('CBHJ2Z6DNT','DESGUE 42 PLUSH','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01715','LLAVE JARDIN DE PVC DE COLORES - PVC DE COLORES','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01724','REGISTRO NACIONAL ECO. DE 2"','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ETNVSXJ7QC','LLAVE JARDIN','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01726','REGISTRO MIXTO DE 2"','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01727','REGISTRO MIXTO DE 4','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01730','REGADERA DE DUCHA CUADRADA DE 6" FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01732','PERFIL SEPARADOR DE AMBIENTE EN T X 2.40','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01733','REGADERA DE LUJO ESPAÑOLA DE 8" APACHE - APACHE','NIU','APACHE',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5ZDA0XLEGT','REGADERA DE DUCHA ACERO DE 8 SEVILLA','NIU','SEVILLA',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('09APQSJV1W','REGADERA DE ACERO DE DUCHA SEVILLA DE 6','NIU','SEVILLA',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01737','MAYOLICA BETZEN CLARO JEFRY 30X60 IMPORTA','MTK','GENÉRICO',42,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('PFTDZ2W0RK','MAYOLICA BETZEN 30X60 MARRON JEFRY IMPORTADO','MTK','GENÉRICO',42,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KBD14SMENT','DALLAS CARAMELO DE 60X60 1RA CELIMA','MTK','CELIMA',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('SMY61LOUEK','PISO ATENAS GRIS 45X45 CELIMA','MTK','CELIMA',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('B4N70R5MZQ','LADRILLOS','NIU','GENÉRICO',0.85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01751','TABLONES COLOR GRIS 1.20','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8NTEU19MGX','JUEGOS DE ACCESORIO DE INSTALACION','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('B6QZM5X9P8','SHARA PLATA','NIU','GENÉRICO',230,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('Q5AL0RONSZ','RODOPLAS','NIU','GENÉRICO',133,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('COUA1652RQ','SUPER NEGRO P','NIU','GENÉRICO',420,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('ER02TQOBGH','TIGRILLO','NIU','GENÉRICO',111,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('OAWQKB97PN','FRAGUA GRIS','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01781','PORCELANATO CALACATA MATE BLANCO CELIMA 30X60 (1.48XCAJ) X 4PZA','MTK','CELIMA',36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01782','PISO BRASILIA NATURAL 45X45 (2.03XCAJ) X10 PZA CELIMA','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01784','PARED AQUARELA PLATINO GRIS PRIMERA 30X60 CELIMA','MTK','CELIMA',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01785','PARED MOSAICO GRIS 30X60 CELIMA (1.81 X 10 PZAS)','MTK','CELIMA',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01788','PORCELANATO MADERA BELEN 60X60 (1.44 X CAJ) CELIMA X4PZA','MTK','CELIMA',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01791','Mayolica nasca beige 27x45 - NAZCA BEIGE 27X45 (2.07 X CAJ) X 17PZA CELIMA - Celima','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01792','PISO PERLADO NEGRO COMERCIAL45 X45 - PISO PERLADO NEGRO 45X45 (2.23X11PZAS) COMER CELIMA','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01793','PISO CEMENTO GRIS PLATA 45X45 CELIMA COMER (2.03XCAJ) X10PZA - CELIMA CEMENTO GRIS 45 1RA','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6YZBN34UX9','FRESIA HUESO 30X60 CELIMA PRIMERA - Fresia hueso 1ra','MTK','CELIMA',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6OSU3QBV2A','BETON GRIS COMER 60X60 CELIMA','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01796','CAOBA BEIGE COMER 60X60 CELIMA (1.80 XCAJ) X 5PZA','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('X4YLV523J1','AMERICAN BLANCO COMER 45X45 - Celima','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('6M1APYFS9X','trebosol blanco','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('PGCQ0YM8BT','trebosol gris','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8XEZ6NFWV5','fragua negra','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('E6Z4381JMQ','rodoplas','NIU','GENÉRICO',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('I1PQBL5HJY','porcelanto hueso','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01815','PISO CEMENTO MARRON 45X45 COMER (2.23x11PZAS)','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('MNAQ9BJDS5','PISO MATISSE GRISACIO 60X60 COMER','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01818','PARED LADRILLO BRICK BLANCO 30X60 COMERCIAL (2.18X12PZAS)','MTK','GENÉRICO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('YPN5DAHQEF','FRAGUA GRIS PLATA','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01826','PORCELANATO CRUZAT 60X60 (1.44 X CAJ) X 4 PZA VIDRFI IMPORTA','MTK','GENÉRICO',52,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01833','PORCELANATO BARY AZUL 60X60 (1.44 X CJA) X 4 PZA ALINA VIDRI','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01834','PORCELANATO BARY BEIGE 60X60 (1.44XCAJ) X 4PZA ALINA VIDRIF','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('8EJPTDVXFG','OVALIN TWENTY CUADRADO S/P/G - CUADRADO','NIU','TWENTY',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('5MU8OYH4WR','PORCELANATO MADERADO PARQUET MATE 60X60','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01842','CAÑO LAVADERO','NIU','GENÉRICO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4QLIRSJ502','LAVATORIO DORADO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01848','CAÑO ECO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('UNS3TR9DY4','FACHALETA BOLIBIANA RAYAS GRIS','MTK','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('P98URHJAW4','FACHALETA INDIA 30X60 PIEDRAS','MTK','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('2PVTC4U38M','INODORO BABY MAXIME BLANCO','NIU','GENÉRICO',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('I4NL8GTU19','PISO MARBELLA 45X45 CALIDA UNICA','MTK','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01857','PISO CASPEN NATURAL 45X45 (2.44XCAJ) X 12PZA','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01858','PISO GRANITO BEIGE 60X60 1RA (1.80 X CAJ) X 5PZA (PORCELANICO)','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('R0B7QDY59T','PISO ARIANA HUESO 45X45 CELIMA COMER','MTK','CELIMA',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('DQA7J3LNI8','LADRILLOS','NIU','GENÉRICO',0.95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('KZLIY6XRVM','VENISE PLATA','MTK','GENÉRICO',36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('BIW7XY9UKV','FRAGUA GRIS PLATA','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('TRQMOGB761','FRAGUA DUNA','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('MK7ISWEUYZ','JUEGOS DE INSTALACION BABY','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('SPDW5A80OQ','BAÑOS BABY TREBOL EQUIPADO','NIU','TREBOL',550,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VQI1FA3X8D','Sumido de 2 cro importado','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('G428JODVM9','Registro de 2 cro importado','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01880','PERFIL PVC ALUMINIO 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('CPD5F0JWLU','PERFIL 10.5 BLANCO PVC','NIU','GENÉRICO',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01882','PERFIL PVC GRIS PLATA 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01883','PERFIL PVC MARMOL 10.5 USAPLAST - USAPLAST','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01884','PERFIL PVC MARFIL OSCURO 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01885','PERFIL PVC NEGRO 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('T1SP6YFQEA','PORCELANATOP TWAFOR 60X60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('7BSGRL6JIC','PARED FARAT AZUL 27X45 CELIMA','MTK','CELIMA',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01888','PISO PORCELANICO ONICIATA NOCE COMER 60X60 (1.80X5PZA)','MTK','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('YGR7931AKI','BAÑOS BLANCO','NIU','GENÉRICO',315,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('M5WJX9LPZT','BAÑOS BLANCO EQUIPADO','NIU','GENÉRICO',315,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FN2IC8JHVX','BLOCK DE VIDRIO ROMBUS','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('43A71C6B5Z','BLOCK DE VIDRIO HOLAS MARINAS','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('VTPEC3GMAF','DECO ESPAÑA 15X60 CHARLOTE','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('4QAPNO6ZSL','DECO ESPAÑA 15X60 APOLO BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('TOD5168W70','DECO ESPAÑA 15X60 SEVILLA BAÑO','NIU','SEVILLA',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('NP5KL2HWM4','DECO ESPAÑA 15X60 LISBOA BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('DAVMJ9G3OS','DECO ESPAÑA 15X60 SALAMANCA BAÑO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01904','PARED 30X60 IMPORTADO NEXA GOL TABACO','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('M7QF1J8R2W','PARED 30X60 LAR GRIS IMPORTADO','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('HRDOJEX2UZ','PARED 30X60 MARMOL HONDA OSCURO IMPORTA','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('QKG67PW4MN','PARED 30X60 HONDAS MARMOL CLARO IMPORTA','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01908','PARED LARK PLATA 30X60 IMPORT(1.62XCAJ) X 9PZA','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01909','PARED PIRAMIDE HUESO/BEIGE 30X60 IMPORTA','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01910','PARED 30X60 NEXA GOL MARFIL IMPORTADO','MTK','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01917','PARED CAYALTI GRIS 30X60 (1.62X9PZA) COMERCIAL','MTK','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01923','i baño trebol','NIU','TREBOL',290,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01924','PERFIL 10.5 PVC GRIS OSCURO BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01927','PORCELANATO UNIMASA GRIS NATURAL 60X60 (1.44XCAJ) X4PZA VIDRIF','MTK','GENÉRICO',16.56,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01932','rodoplas','NIU','GENÉRICO',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01939','PARED CAYALTI MIX GRIS 30X60 (1.62X9PZA) PRIMERA','BX','GENÉRICO',60.63,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01945','baño equipado blanco mas urinario','NIU','GENÉRICO',410,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01946','PISO SICUANI NATURAL 45X45 (2.23XCAJ) X11PZA CELIMA','MTK','CELIMA',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01970','urinario trebol equipado blanco','NIU','TREBOL',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01971','URINARIO TREBOL BLANCO','NIU','TREBOL',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01972','LLAVE URINARIO IVALSA NACIONAL','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01973','PAPELERA BONE LOZA TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01974','TRAMPA CORRUGADA DOBLE FORTALY','NIU','FORTALY',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01975','TRAMPA CORRUGADA CON CANASTILLAS FORTALY','NIU','FORTALY',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01977','PARED PERLADO BLANCO 27X45 CELIMA (2.07 X CAJ) X 17PZA','MTK','CELIMA',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01978','PARED BLANCO BRILLANTE 27X45 (2.07 X CAJ) X 17 PZACELIMA','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01981','PZAS DE CERAMICAS 45 BLANCO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01982','PERFIL PVC BLANCO 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01995','TREBOL BLANCO','NIU','TREBOL',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01997','URINARIO NEGRO EQUIPADO','NIU','GENÉRICO',144,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01998','PORCELANATO ALICANTE NEGRO VIDRIF TAWFOR 60X60 (1.44X4PZAS)','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01999','PISO HUELVA CARAMELO 45X45 COMER (2.23XCAJ) X 11PZA','NIU','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02002','FRAGUA ROJA CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02003','FRAGUA ROJA CHEMICAL','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02005','PERFIL PVC CELESTE OCEANO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02007','PERFIL PVC CUERO OSCURO 10.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02008','OVALIN CUADRADO HG BONE SIN P/G','NIU','HG',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02009','OVALIN FRATELLI CUADRADO BLANCO S/P','NIU','FRATELLI',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02010','OVALIN MINIBOOL RECTANGULAR BLANCO FRATELLY C/PG','NIU','FRATELLI',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02011','OVALIN BARQUITO BONE XM SIN P/G','NIU','XM',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02012','OVALIN BONE OVALADO XM','NIU','XM',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02013','OVALIN BLANCO TWENTY OVALADO','NIU','TWENTY',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02015','OVALIN BLANCO CHICA OVALADO','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02016','OVALIN BONE CHICA S/PG OVALADO','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02017','OVALIN DE VIDRIO CHICO CRISTAL OVALADO','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02018','OVALIN ROJO VIDRIO OVALADO','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02019','OVALIN CRISTAL OVALADO MEDIANO','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02020','PORCELANATO MARMOLEADO GRIS 60x60 (1.44XCAJ)X4PZA VIDRI','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02034','ladrillo pandereta','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02042','LLAVE DE OVALIN AL MUEBLE FRENCIA','NIU','FRENCIA',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02043','LAPIZ CERAMICO LIZO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02044','PORCELANATO MARMOLEADO GRIS MATE 60X60','MTK','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02045','PORCELANATO CALACATA BLANCO 60X1.20 (1.44X2PZAS)','MTK','GENÉRICO',52,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02050','REGILLAS DE 2','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02052','DECORADO HELADO COSINA 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02053','DECORADO CANTAROS BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02054','DECORADO TETERA GRIS COSINA 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02055','DECORADO LAR COSINA PLATA 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02056','DECORADO LAR PLATA BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02057','DECORADO LADRILLO BLANCO BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02058','DECORADO IMPORTADO TOALLA BEIGE 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02059','DECORADO SARA TOALLA BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02060','DECORADO SEA MARFIL BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02061','DECORADO IMPORTADO GRESIA PEZ BEIGE BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02064','DECORADO ONDAS FLOR GRIS 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02065','DECORADO IMPORTADO GRESIA 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02066','DECORADO CEBOLLA BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02067','DECORADO ROSAS MARFIL BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02068','DECORADO LIRIO BEIGE 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02069','DECORADO SEA GRIS BEIGE BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02070','DECORADO IMPORTADO CAPUCHINO 30X60 PARA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02071','DECORADO ANDES ESTRELLA MAR 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02073','DECORADO COFFY LATE COSINA 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02074','DECORADO SEA PLATA BAÑO 30X60','NIU','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02075','PORCELANATO CELIMA CERESO CAFE 60X60','MTK','CELIMA',52.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02076','ILLINOIS NATURAL 45X45','MTK','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02077','FACHALETA FILETI GRANITO BEIGE 30X60','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02078','AVORIO HUESO 45X45','MTK','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02081','LLAVE URINARIO PLUSH CROMADO APACHE','NIU','APACHE',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02083','BRAZO DE DUCHA SEVILLA ESPAÑOLA 4"','NIU','SEVILLA',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02089','BRAZO DE DUCHA TREBOL','NIU','TREBOL',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02090','LLAVE LAVATORIO PLUS FORTALY','NIU','FORTALY',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02097','LARA GRIS 45X45','MTK','LARA',25.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02100','PORCELANATO DALLAS GRIS MATE ROMA 60X60 (1.44 X CAJ) X4PZA','MTK','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02102','LUCIANE NEGRO 45X45','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02103','LARA GRIS 45X45','BX','LARA',51,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02108','ANDREA BEIGE 45X45','NIU','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02114','TABLON','MTK','GENÉRICO',37.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02119','BAÑO EQUPADO TREBOL','NIU','TREBOL',310,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02128','RODOPLAS','NIU','GENÉRICO',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02130','PORCELANATO VETA MARMOLISADO','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02132','FRAGUA CELIMA BLANCO','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02135','RODOPLAS AZUL','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02136','FARAH AZUL 27X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02140','PARED AMAPOLA PLATA 30X60 COMERCIAL','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02147','PORCELANATO HUESO 60X60 (1.44 x4 PZAS)','MTK','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02148','FRAGUA CHEMICAL MARFIL','NIU','CHEMICAL',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02150','PORCELANATO GRANITO GRIS DOBLE CARGA 60X60 (1.44XCAJ) X 4PZA - ROMASA','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02156','PERFIL BRILLO 9.5X2','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02157','FRAGUA CHEMICAL ARENA','NIU','CHEMICAL',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02167','INODORO HG','NIU','HG',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02169','LAVATORIO PEDESTAL TREBOL','NIU','TREBOL',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02178','LAPIDA','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02179','PORCELATANO MATE','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02187','FRAGUA HUESO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02189','JUEGO DE UÑAS PARA URINARIO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02190','TRAMPA PAVCO CON DESAGUE','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02194','REJILLA 2 IMPORTADA','NIU','GENÉRICO',12.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02195','REGISTRO IMP. DE 2 PESADO','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02197','INODORO HG BLANCO','NIU','HG',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02205','REGADERA DE DUCHA MODELO ESPAÑOL DE 6" CROMADO SEVILLA - SEVILLA','NIU','SEVILLA',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02209','RODOMETAL','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02216','PORCELANATO MARBLE BLANCO 60X1.20 (1.44X2PZAS)','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02217','PORCELANATO JUAN CARLOS MARMOL GRAY GRAY 60X60','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02218','PORCELANATO JUAN CARLOS GRANITE BLU 60X60 (1.44XCAJ) X4PZA','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('01836','PORCELANATO DALLAS CARAMELO MATE 60X60 (1.44XCAJ) X 4PZA','MTK','GENÉRICO',52,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02222','AREQUIIPA MIX 30X60','MTK','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02223','INODORO Y TANQUE ACUACER CORONA','NIU','GENÉRICO',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02224','LAVATORIO MINOS BLANCO TARRACO','NIU','TARRACO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02225','PEDESTAL MINOS BLANCO TARRACO','NIU','TARRACO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02228','CABEZA DE DUCHA REDONDA MONACO','NIU','MONACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02229','GRIFERIA PICO DE GANSO PARA COCINA MONACO','NIU','MONACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02233','PISO MARINA HUESO 45X45 (2.44XCAJ) X 12 PZA','MTK','GENÉRICO',25.9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02240','CANVAS VERDE COMERCIAL 27X45 (1.70 X CAJ) X 14 PZA SAN LORENZO','MTK','SAN LORENZO',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02241','PEPELMA FLOR CUADRADA BEIGE','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02242','PEPELMA ESFERA MARRON','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02243','DECORADO FLOR AZUL PARA BAÑO HUGO 30X60','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02244','PARED FLOR CELESTE CLARO HUGO 30X60','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02245','PARED FLOR AZUL OSCURO HUGO 30X60 (1.62 X 9PZA)A','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02267','fara azul','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02284','temple','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02290','PISO SAN LORENSO MURSIA - PISO MADERA MURSIA 45X45 (2.08XCAJ) X 1OPZA - MURSIA','MTK','SAN LORENZO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02291','INODORO RELINDO PLUS BLANCO','NIU','GENÉRICO',260,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02294','FRAGUA CHOCOLATE','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02301','LLAVE VAINSA PARA OVALIN MATE NEGRO - VAINSA','NIU','VAINSA',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02302','PICO DE GANSO VAINSA PARA LAVATORIO COCINA NEGRO','NIU','VAINSA',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02303','LLAVE PARA COCINA MANGUERA NEGRA FRATELLY - LLAVE PARA COCINA MANGUERA NEGRA FRATELLI - FRATELLI','NIU','FRATELLI',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02304','PISO MARILLA CARAMELO 45X45 - MARILLA CARAMELO 45X45 1RA','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02309','ONEPIZ FRENCIA - INODORO NEGRO FRENCIA ONEPIECE - ONEPIZ','NIU','FRENCIA',420,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02310','URINARIO BAMBY TREBOL BLANCO','NIU','TREBOL',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02311','OVALIN BONE - MESA MELAMINE BONE DE SOBRE PONER DE OVALIN VIDRIO','NIU','GENÉRICO',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02312','URINARIO DORADO AZUL','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02315','PORCELANATO VIDRFICADO','MTK','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02323','FRAGUA GRIS PLATA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02332','FRAGUA GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02333','FRAGUA GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02336','OVALIN MARMOLEADO GRIS REDONDO FRENCIA','NIU','FRENCIA',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02337','baños blanco','NIU','GENÉRICO',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02341','REGILLA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02343','CAÑO LAVADERO JARDIN','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02345','MEDIO BAÑO TARRACO SILVER BOTON - TARRACO','NIU','TARRACO',340,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02346','LAVATORIO FLORIDA BLANCO ECO S/P - FLORIDA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02347','INODORO MINOS TARRACO BONE BOTON - INODORO BONE TARRACO BOTON MINOS','NIU','TARRACO',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02348','LAVATORIO Y PEDESTAL BONE TARRACO MINOS - LAVATORIO Y PEDESTAL TARRACO MINOS BONE - MINOS','NIU','TARRACO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02349','OVALIN BONE RECTANGULAR CON PORTA GRIFERIA - OVALIN TWENTY BONE C/p GRIFERIA - TWENTY','NIU','TWENTY',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02350','PINTURA SHERVINS WILLIANS','NIU','GENÉRICO',390,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02351','VALDE CELLADOR','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02352','BROCHAS TUMY','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02353','RODILLOS','NIU','GENÉRICO',44,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02354','TEMPLE','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02363','PINTURA SHERWINS WILLIANS','NIU','GENÉRICO',390,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02364','VALADE DE SELLADOR','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02365','BROCHAS TUMY','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02366','RODILLOS','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02367','TEMPLE','NIU','GENÉRICO',28.8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02368','VALDE SELLADOR','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02369','PISO CELIMA CAOBA GRIS 60 - CAOBA GRIS CELIMA 60X60 1RA (1.80X5PZAS)','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02370','OVALIN RECTANGULAR BONE TWENTY CON P/G - TWENTY','NIU','TWENTY',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02375','PISO REQUENA CELIMA DE 60 1RTA - PISO REQUENA BEIGE 60X60 1° (1.80XCAJ) X 5PZA - CELIMA REQUENA BEIGE','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02380','PORCELANATO MESA 60X60','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02391','TRAMPA PLUS TREBOL - TRAMPA CORRUGADA TREBOL PLUSH - TREBOL','NIU','TREBOL',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02395','TAPA FIORI GUINDA','NIU','FIORI',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02396','INODOROS MONACO BLANCO ONEPIS','NIU','MONACO',230,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02398','PORCELANATO UNIMASA DECOR HOUSE 60 X 60','MTK','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02400','PORCELANATO RÚSTICO 60X60 (1.44X4)','MTK','GENÉRICO',42,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02402','PORCELANATO MADERA MATE GRIS 60 X 60 (1.44X4PZAS)','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02412','TRAMPA JAMECO PVC - JAMECO','NIU','JAMECO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02413','TRAMPA "P" ABS PVC - ABS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02414','LLAVE LAVATORIO GRIFESUR NACIONAL','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02416','PORCELANATO MARMOLIZADO GRIS 60X60 (1.44XCAJ) X 4PZA ALINA VIDRI','MTK','GENÉRICO',36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02417','PISO SANORA GREY CELIMA 45X45 COMERCIAL X 1.62','MTK','CELIMA',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02418','PISO SONOMA GREY DE 45X45 X 1.62 CELIMA','MTK','CELIMA',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02419','PISO ANCOA BEIGE COMERCIAL (2,03XCAJ) X 10PZA','MTK','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02424','PERFIL ALUMINIO DORADO 9.5 X2 VICEPLAST - VICEPLAST','NIU','VICEPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02425','PORCELANATO DALLAS CARAMELO 60X60 MATE','MTK','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02426','PORCELANATO DALLAS CARAMELO VIDRIFICADO DE 60X60 (1.44XCAJ) X 4PZA - DALLAS VIDRIFICADO','MTK','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02429','CAOBA GRIS DE 60X60 SDA - PORCELANICO CAOBA GRIS SDA 60X60 (1.80X5PZAS)','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02430','REQUENA GRIS 60X60 SDA - PORCELANICO REQUENA GRIS SDA 60X60 (1.80XCAJ) X 5 PZA CELIMA','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02432','FRAGUA HUESO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02435','PORECLANATO HUESO','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02436','PARED LAR GRIS','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02441','INODORO TREBOL BLANCO RAPID JET PREMIUM - PREMIUM TREBOL','NIU','TREBOL',230,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02442','LAVATORIO Y PEDESTAL BONE FRENCIA IMPORTADO - FRENCIA','NIU','FRENCIA',165,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02443','LAVATORIO Y PEDESTAL BONE FRENCIA','NIU','FRENCIA',165,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02451','PARED SIENA DORADA EXTRA 30X60 (2.18 X 12PZA)','MTK','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02456','PISO TERRE GRAFITO 60X60 (1.80X5PZAS) CELIMA','MTK','CELIMA',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02459','TERRE GRIS','MTK','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02464','KIT CROMADO HIMPORTADO','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02468','OVALIN BLANCO BARQUITO','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02469','DESAGUE CROMADO TRAMPA','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02470','BROZO DE DUCHA LUJO','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02471','PARED FRESIA PLUS GRIS 30X60 (1.81X 10PZ) PRIMERA','MTK','GENÉRICO',29.33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02482','DESAGUE CROMADO','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02485','UÑA FIERRO','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02487','LAVATORIO Y PEDESTAL HG BONE - HG','NIU','HG',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02490','CATONERA DE 1 PARA CERAMICA CON ANCLAJE','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02501','REPARACION DE UN MOTOR SERVICIO KOHER 5HP','NIU','GENÉRICO',94.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02502','BRAZO DE DUCHA FORTALY DE 4 REGULABLE','NIU','FORTALY',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02505','PORCELANATO MATE BEIGE 60X60','MTK','GENÉRICO',36.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02507','CALTONERAS DE ALUMINIO','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02509','FACHALETAS IMPORTADAS ASUNCION (BOLIVIANA) 30X45 (1.64 X CAJ) X 12 PZA','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02514','fachaletas blancas','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02521','MESCLADORA DE DUCHA','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02525','PISO IVORY 45X45 (2.03X10PZAS)','MTK','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02526','SERVICIO DE MOTORES REPARACION 5.5HP','NIU','GENÉRICO',106,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02527','LAPIZ ESCARCHADO DE VIDRIO DE 2.5X1 NEGRO','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02531','CAÑO PARA OVALIN CUADRADO PESADO DE MEDIA FORTALY - FORTALY','NIU','FORTALY',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02532','LLAVE OVALIN DE MESA NEGRO PESADO ALTO','NIU','GENÉRICO',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02536','OVALIN BARQUITO BLANCO FRENCIA','NIU','FRENCIA',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02543','UÑAS','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02544','CAÑO FRATELLI','NIU','FRATELLI',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02545','TRAMPA TREBOL','NIU','TREBOL',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02546','LLAVE LAVATORIO FRATELLI PESADO CJA','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02547','PORCELANICO DE 60X60 MATE CELIMA SUITE GREY (1.80X5PZAS)','MTK','CELIMA',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02551','PISO CELESTE PISCINA 30X30 CELIMA (2.34XCAJ) X 25 PZA','MTK','CELIMA',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02554','PARED BLANCO VISELADO WILMER - MAYOLICA BLANCA VISELADA HIMPORTA','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02557','FRAGUA PARA PORCELANATOX 1KG','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02567','RODOPASO MARMOL','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02571','FRAGUA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02572','FRAGUA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02573','FRAGUA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02574','FRAGUA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02575','FRAGUA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02576','FRAGUA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02586','LAVDERO DE ACERO','NIU','GENÉRICO',290,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02590','TRAMPA DESAGUE PEGAMENTO PVC','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02591','PORCELANATO MATE CARAMELO 60X60 (1.44 X CAJ) X 4PZA','MTK','GENÉRICO',37,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02592','TABLONES','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02594','PORCELANATO MADERA BLANCA','MTK','GENÉRICO',36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02595','MAYOLICA BLANCA CELIMA 30X30 I CAJA MAS 8 PIEZAS','NIU','CELIMA',66.8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02604','FRAGUA HUESO','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02612','INODORO SANI FLOR BLANCO ECO','NIU','SANI',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02613','TABLOM DE CELIMA 20X60','NIU','CELIMA',38.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02614','LAPIZ DE VIDRIO DE 2X0.60','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02617','FRAGUA CHEMA NEGRA','NIU','CHEMA',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02621','FRAGUA GRIS','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02623','PORCELANATO NEGRO VIDRFICADO','NIU','GENÉRICO',53.16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02627','FRAGUA NEGRO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02628','PORCELANATO NEGRO','NIU','GENÉRICO',46.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02650','baño baby','NIU','GENÉRICO',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02661','PARED AMARILLO 30X60','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02662','PERFIL BRILLO 9.5 X 2.40 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02666','FRAGUA CERAMICA','NIU','GENÉRICO',5.03,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02667','PRCELANATO HUESO DE 60X60','MTK','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02669','MAYOLICA BLANCO BETAS','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02680','LAVATORIO CHICO EQUIPADO','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02687','PISO ORION GRIS 45X45 (2.23X11PZAS) COMERCIAL','MTK','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02694','REGILLA','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02695','REJILLA ECONOMICO DE 2"','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02710','PARED BLANCO BRILLANTE 27X45','NIU','GENÉRICO',45.33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02712','PEGAMENTO CHEMAYOLIC','NIU','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02721','LAVTORIO GRANDE TREBOL','NIU','TREBOL',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02723','TRAMPA LAVATORIO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02737','FRAGUA MEDERA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02743','LLAVE CORRUGADO DE COCINA C&A - C&A','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02748','fragua negra','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02751','PEGAMENTO CELIMA GRIS','NIU','CELIMA',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02753','canaletas','NIU','GENÉRICO',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02755','temple','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02761','GRAFUAS GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02770','FRAGUA GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02772','PEGAMENTO CELIMA BLANCO EXTRAFUERTE','NIU','CELIMA',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02773','PEGAMENTO PARA MAYOLICA PEGAVAL GRIS - PEGAMENTO PEGAVAL GRIS','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02777','FRAGUA GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02781','FRAGUA GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02784','FRAGUA CHEMA GRIS PLATA','NIU','CHEMA',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02785','MAYOLICA 25X40 ESENSE BLANCO - MAYOLICA ESSENCE BLANCO 25X40 (2.03 XCAJ) X 2O PZA PARED - CELIMA 25X40','NIU','CELIMA',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02786','MAYOLICA PARED CHOCOLATE GRIS 27X45 - PARED CHOCOLATE GRIS 27X45 CELIMA (2.07 X17 PZA) PRIMERA - CELIMA 27X45 PARED','MTK','CELIMA',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02787','MAYOLICA PARED CHOCOLATE AZUL 27X45 - CHOCOLATE AZUL 27X45 CELIMA (2.07XCAJ) X 17PZA - CELIMA CHOCOLATE AZUL','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02788','PORCELANICO LAMINADO BALSA SDA CELIMA DE 60X60 - LAMINADO BALSA SDA DE 60X60 (1.80X5PZAS)','MTK','CELIMA',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02789','PORCELANATO TRAVERTINO HUESO DE 60X60 (1.44XCAJ) X 4PZA - TRAVERTINO DE 60 HUESO','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02790','PARED DUNAS NARANJA 25X40 - DUNAS NARANJA 25X40 (2.03 XC AJ) X 20 PZA CELIMA','MTK','CELIMA',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02791','PARED SCALA JASPEN ROJO CELIMA 30X60 1RA - ESCALA JASPES ROJO 1RA 30X60 CELIMA 1.80MT 10PZAS - SCALA JASPEN ROJO','MTK','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02796','OVALIN MINIBOOL BLANCO RECTANGULAR MONACO 34X29 CON P/G','NIU','MONACO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02797','OVALIN MINIBOOL CUADRADO BLANCO MONACO CON P/G 38X38','NIU','MONACO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02798','LLAVE DE COSINA CORRUGADO MONACO ALA PARED - MONACO COSINA ALA PARED CORRUGADO','NIU','MONACO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02799','PARED CELIMA TROPIC HUESO 30X60 - MURO TROPIC PLUS HUESO BRILL 30X60 (1.80X10PZA)SDA MAYOLICA - CELIMA TROPIC HUESO','MTK','CELIMA',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02800','PARED CELIMA BAHIA GRIS PLUS 30X60 COMER - PARED BAHIA GRIS PLUS SDA 30X60 MAYOLICA','MTK','CELIMA',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02801','ACSESORIO DE TANQ PALANCA SEVILLA - ACCESORIO DE TANQUE PALANCA SEVILLA - SEVILLA','NIU','SEVILLA',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02802','BRAZO DE DUCHA ESPAÑOLA DE 8 CROMADO - BRAZO DE DUCHA ESPAÑOLA DE 8 REDONDO CROMADO','NIU','GENÉRICO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02803','BRAZO DE DUCHA DE 6 CROMADO - BRAZO DE DUCHA ESPAÑOLA DE 6 CROMADO','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02804','BRAZO DE DUCHA DIROFASA SEMI PESADO REDONDO - BRAZO DE DUCHA IMPORTADO REDONDO DE 4 SEMIPESADO','NIU','DIROFASA',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02805','BRAZO DE DUCHA SEVILLA SEMIPESADO DE 4 - BRAZO DE DUCHA REDONDO SEVILLA SEMI PESADO DE 4','NIU','SEVILLA',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02812','PERFIL ALUMINIO MATE DE 12 X2.40 VICEPLAST - VICEPLAST','NIU','VICEPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02814','PERFIL ALUMINIO DORADO 11.5 X 2 VICEPLAST - VICEPLAST','NIU','VICEPLAST',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02815','PERFIL NEGRO BRILLANTE DE 9.5X2.00 VISEPLAST - VISEPLAST','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02816','PERFIL ALUMINIO EN L DE 10X 2.40 VICEPLAST - VICEPLAST','NIU','VICEPLAST',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02817','PERFIL ALUMINIO EN L DE 12X2.40 VICEPLAST - VICEPLAST','NIU','VICEPLAST',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02819','PARED BRICK ONDAS PLATA 30X60 COMER - CELIMA BRICK PLATA','MTK','CELIMA',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02821','LLAVE FRATELLY COSINA CORRUDADO ALQAM PARED - PICO DE GANSO PARA COCINA FRATELLI CORRUGADO PESADO','NIU','FRATELLI',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02822','PORCELANATO MATE BLANCO DE 60X60 LILLY (1.44XCAJ) X 4PZA - CELIMA LILLY MATE 60X60','MTK','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02829','LSPIZ CERAMICO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02831','CRUCETA SIMPLE DE 3MM F3','NIU','F3C',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02833','FRAGUA CHOCOLATE','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02834','INODORO TREBOL EQUIPADO','NIU','TREBOL',227,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02835','OVALIN CUADRADO BLANCO TWENTY S/P - TWENTY','NIU','TWENTY',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02836','PISO ALMANSA NATURAL 45X45 CELIMA (2.23XCAJ) X 11PZA','MTK','CELIMA',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02837','NAPOLES GRIS 27X45 (2.07XCAJ) X 17 PZA PARED','MTK','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02839','KIT PARA BAÑO BLANCO LOZA MILANO X 5 PZAS - MILANO','NIU','MILANO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02840','URINARIO MILANO BLANCO','NIU','MILANO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02845','PISO PARQUET QUILLA CAFE 45X45 (2.08X10PZAS)','MTK','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02848','PEPELMA CINTA AZUL MARINO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02849','TABLON 30X60','MTK','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02858','PEPELMA CINTA NEGRA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02859','TABOLO GRIS 30X60','MTK','GENÉRICO',29.6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02864','PISO PIANO BLANCO 45X45 CELIMA (2.23XCAJ) X 11PZA','MTK','CELIMA',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02865','MURO TROPIC NEW BLANCO 30X60 COMERCIAL (1.80x10PZAS)','MTK','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02866','MURO TROPIC NEW AZUL COMERCIAL 30X60 (1.80 X 10PZAS)','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02868','OVALIN RECTANGULAR HG BLANCO CON P/G','NIU','HG',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02869','OVALIN RECTANGULAR HG BLANCO C/P/g','NIU','HG',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02871','pPORCELANATO DALLAS','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02877','LAPIZ DE VIDRIO DE 2.5 X 1 MTR','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02878','PISO AMERICAN BLANCO 30X30 (2.34XCAJ) X 25 PZA COMERC','MTK','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02880','FRAGUA CUERO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02881','CEPARADOR DE ANBIEMTE','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02885','LLAVE DE LAVATORIO PESADO MONACO PALANCA','NIU','MONACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02886','LAVADERO 2 PZAS PESADO MONACO','NIU','MONACO',2.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02887','OVALIN FLOR BLANCO MONACO','NIU','MONACO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02888','OVALIN REDONDO MARMOLEADO MONACO SIN P/G','NIU','MONACO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02889','OVALIN CUADRADO BLANCO MONACO C/P 41X41 - MONACO','NIU','MONACO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02890','INODORO FLORIDA BLANCO ECONOMICO','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02892','PISO HUELVA NATURAL DE 60X60 1RA (1.80XCAJ) X 5PZAS','MTK','GENÉRICO',21,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02893','LLAVE LAVATORIO PLUSH APACHE PESADO','NIU','APACHE',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02900','PARED FLOR AZUL CLARO HUGO 30X60','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02901','COMERCIAL - PISO PIANO BLANCO 60X60 COMERCIAL (1.80XCAJ) X 5 PZA','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02902','PIANO BLANCO BRILLANTE - PISO PIANO BLANCO BRILL 30X60 COMERCIAL (1.80XCAJ) X 10PZA','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02903','PARED HEXAGONAL BEIGE 30X60 (1.62XCAJ) X9PZA','NIU','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02904','PARED PRISMA RED 30X60 (1.44XCAJ) X 8PZA','NIU','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02905','PISO CEMENTO GRIS 45X45 1° (2.03XCAJ) X 10PZ','NIU','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02906','PISO SILEX GRIS 60X60 (1.80 X CAJ) X 5PZA','NIU','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02907','PISO HUELVA NATURAL 60X60 (1.80XCAJ) X 5PZA COMERCIAL','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02908','PORCELANATO CRUZ BEIGE VIDRIF 60X60 (1.44XCAJ) X4PZA','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02909','ANILLO DE CERA CON GUIA OSAKA','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02911','REPUESTO DE NIVELEDOR F3 DE1 MM','NIU','F3C',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('A011','OVALIN RECTANGULAR BLANCO TWENTY CON P/G - TWENTY','NIU','TWENTY',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('A058','OVALIN BARQUITO BLANCO TWENTY SIN P/G - TWENTY','NIU','TWENTY',78,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FST-092','OVALIN RECTANGULAR MARMOLEADO TWENTY - TWENTY','NIU','TWENTY',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FST-093','OVALIN RECTANGULAR BLANCO DORADO TWENTY - TWENTY','NIU','TWENTY',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FST-099','OVALIN CIRCULAR PLATEADO TWENTY - TWENTY','NIU','TWENTY',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('FST-103','OVALIN BARQUITO MARMOLEADO TWENTY - TWENTY','NIU','TWENTY',104,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02918','BELLA PLAS PVC - PERFIL PVC AZUL PASTEL 8.5 BELLA PLAS - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02919','PERFIL PVC GRIS PLATA 8.5 BELLA PLAS - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02920','PERFIL PVC BLANCO 8.5 BELLA PLAS - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02921','PERFIL PVC CARAMELO CLARO 8.5 BELLAPLAST - PVC BELLAPLAST','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02922','PERFIL PVC CUERO 8.5 BELLAPLAST - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02923','PERFIL PVC CUERO CLARO 8.5 BELLAPLAST - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02924','PERFIL PVC GRIS CLARO 8.5 BELLAPLAST - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02925','PERFIL PVC GRIS OSCURO 8.5 BELLAPLAST - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02926','PERFIL PVC MARFIL OSCURO 8.5 BELLAPLAST - PVC BELLA PLAS','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02927','PERFIL PVC TURQUESA 8.5 BELLAPLAST - PVC BELLLAPLAST','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02929','PERFIL PVC MARRON OSCURO 10.5 USA PLAS - PVC USA PLAS','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02930','PERFIL PVC CUERO 10.5 USAPLAST - PVC USA PLAS','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02931','PERFIL PVC CUERO CLARO 10.5 USAPLAST - PVC USA PLAS','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02932','PERFIL PVC CREMA 10.5 USA PLAS - PVC USA PLAS','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02933','PERFIL PVC GRIS CLARO 10.5 USAPLAST - PVC USAPLAST','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02934','PERFIL PVC MARFIL CLARO 10.5 USAPLAST - PVC USA PLAS','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02935','PERFIL PVC MARFIL OSCURO 10.5 USA PLAS - PVC USA PLAS','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02936','PERFIL PVC ALUMINIO 10.5 USAPLAST - PVC USAPLAST','NIU','USAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02937','PERFIL ALUMINIO BRILLO 9.5 X 2.40 USAPLAST - USA PLAS','NIU','USAPLAST',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02938','PERFIL ALUMINIO BRILLO 11.5 X 2,40 USAPLAST - USA PLAS','NIU','USAPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02939','PERFIL ALUMINIO MATE 9.5 X 2.40 USAPLAST - USAPLAST','NIU','USAPLAST',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02940','PERFIL ALUMINIO MATE 11.5 X 2.40 USAPLAST - USAPLAST','NIU','USAPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02941','PORCELANATO MANCHAS GRIS 60X60 (1.44XCAJ) X 4PZA VIDRI','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02942','PORCELANATO MANCHAS BEIGE 60X60 (1.44XCAJ) X 4PZA','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02943','PERFIL PVC BONE 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02944','PERFIL PVC BONE 8.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02945','PORCELANATO RECTIFICADO BEIGE 60X60','MTK','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02946','PEGAMENTO EXTRAFUERTE BLANCO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02947','SIKAFLEX','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02951','MEDIO LITRO DE THINER','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02952','DISCO DIAMANTADO DE COPA DE 4"','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02954','PEGAMENTO BLANCO FLEXIBLE EXTRAFUERTE','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02955','FRAGUA CELIMA GRIS','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02957','PERFIL PVC CUERO OSCURO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02958','PERFIL PVC CUERO CLARO 10.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02959','PERFIL PVC MARMOL 10.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02960','PERFIL PVC CUERO OSCURO 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02961','PERFIL PVC MARFIL CLARO 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02962','PERFIL PVC MARRON TABACO 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02963','PERFIL PVC CARAMELO 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02964','PERFIL PVC MARRON OSCURO 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02965','PERFIL PVC AZUL OSCURO 8.5 FINOPLAST - FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02966','PERFIL PVC MARMOL 8.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02967','PERFIL PVC CUERO OSCURO 8.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02968','PERFIL PVC GRIS CLARO 10.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02969','PERFIL PVC ALMENDRA 8.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02970','PERFIL PVC ALUMINIO 10.5 VICEPLAST - VICEPLAST','NIU','VICEPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02971','PERFIL PVC CARAMELO CLARO 10.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02972','LAVATORIO Y PEDESTAL HG BLANCO - HG','NIU','HG',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02974','PERFIL ALUMINIO CUADRADO EUROBORDE - EUROBORDE','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02975','LAPIZ DE ACERO GRIS 3,5','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02976','FRAGUA CELIMA ARENA','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02977','FRAGUA MAESTRO GRIS','NIU','MAESTRO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02978','FRAGUA MAESTRO GRIS PERLA','NIU','MAESTRO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02979','FRAGUA AQUIMARZA DUNA','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02980','FRAGUA AQUIMARZA CELESTE','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02981','FRAGUA AQUIMARZA HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02982','PEPELMA LINEAS CRISTAL CARAMELO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02983','PEPELMA TIGRILLO TABACO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02984','PEPELMA MARRON CUADRADO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02985','PEGAMENTO NOVAYOLIC INTERIORES Y EXTERIORES EXTRAFUERTE','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02987','INODORO BABY BLANCO HG - HG','NIU','HG',245,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02990','PEPELMA CELESTE PASTEL','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02991','PEPELMA DORADO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02992','PEPELMA MATE PLATEADO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02993','PEPELMA ROSA PLATEADA CUADRADA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02994','PEPELMA HEXAGONO PLATEADO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02995','PEPELMA RUSTICO MARRON','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02996','PEPELMA CRISTAL DORADO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02997','PEPELMA ESTERA NEGRO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02998','FRAGUA CHEMA CHOCOLATE','NIU','CHEMA',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('02999','FRAGUA AQUILA ROSADA','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03000','OVALIN RECTANGULAR NEGRO MATE MAXIME CON P/G','NIU','GENÉRICO',270,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03001','OVALIN REDONDO BLANCO TWENTY SIN P/G','NIU','TWENTY',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03002','OVALIN CUADRADO BONE HG CON P/G - HG','NIU','HG',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03003','BLOCK DE VIDRIO SEA WEVE','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03004','KIT PARA BAÑO BONE FV - FV','NIU','FV',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03005','KIT PARA BAÑO BLANCO FV - FV','NIU','FV',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03006','KIT PARA BAÑO FRENCIA (CROMADO) - FRENCIA','NIU','FRENCIA',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03007','MINI KIT PARA BAÑO BONE FV - FV','NIU','FV',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03009','BLOCK DE VIDRIO COCOS','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03010','PARED BRICK ONDA HUESO EXTRA 30X60 (2.18X11PZAS)','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03011','CANASTILLA O CABEZAL DE DUCHA CUADRADO DE 6" FRATELLI - FRATELLY','NIU','FRATELLI',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03012','PERFIL PVC LILA CLARO 8.5 BELLAPLAST - BELLAPLAST','NIU','BELLAPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03013','PERFIL PVC DORADO BRONCE 11.5 ROSSIPLAST - ROSSIPLAST','NIU','ROSSIPLAST',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03014','PERFIL MPVC PLATEADO DOBLE PESTAÑA 10MM TORREWS - TORREWS','NIU','TORREWS',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03015','LAVADERO COCINA PEQUEÑO GIGANTE FORTALY C/E','NIU','FORTALY',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03016','LAVADERO COCINA MEDIANO FRATELLI C/E LIVIANO','NIU','FRATELLI',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03017','LAVADERO COcINA RECORD CAMPEON C/E','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03018','LAVADERO COSINA CODIFER C/E PESADO','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03019','LAVADERO COSINA MONACO 2POZAS LIVIANO C/E','NIU','MONACO',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03020','LAVADERO COSINA TRAMONTINA 2 POZAS C/E','NIU','GENÉRICO',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03021','LAVADERO COSINA MONAKO 2 POZAS C/E PESADO','NIU','GENÉRICO',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03022','LAVADERO COSINA MONACO MEDIANO C/E PESADO','NIU','MONACO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03023','LAVADERO COSINA MONACO PEQUEÑO JIGANTE C/E PESADO','NIU','MONACO',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03024','LAVADERO COSINA NONAKO 2 POZAS S/E PESADO','NIU','GENÉRICO',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03026','LAVADERO COSINA TRAMONTINA C/E 50X80','NIU','GENÉRICO',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03028','LAVADERO COSINA MONACO 2 POZAS SOLAS PESADO','NIU','MONACO',260,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03029','LAVADERO COcINA MONACO C/E PESADO MODELO RECORD','NIU','MONACO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03031','LAVADERO COCINA FRATELLI POSA ONDA PARA GRANITO PEQUEÑO','NIU','FRATELLI',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03032','NIVELADOR PARA PORCELANATO 2MM 100 UNID F3C (60126) - F3C','NIU','F3C',5.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03033','LAVADERO COCINA FRATELLI POSA ONDA GRANDE PARA GRANITO','NIU','FRATELLI',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03034','LAVADRERO COSINA AMERICA LIVIANA POSA SOLA','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03035','LAVADERO COSINA CODIFER POSA SOLA GRANDE LIVIANO','NIU','GENÉRICO',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03036','LAVADERO COSINA AMERICA POSA SOLA LIVIANO','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03037','TABLON GRIS (1.20X6PZAS)','NIU','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03039','LAVADERO COSINA TRAMONTINA C/E PESADO','NIU','GENÉRICO',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03040','NIVELADOR PARA PORCELANATO 1MM 100UNID F3C (60125) - F3','NIU','F3C',5.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03041','LAVADERO COCINA FRATELLI MEDIANO C/E LIVIANO','NIU','FRATELLI',80,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03042','LAVADERO COcINA MONACO C/E MODELO RECORD PESADO','NIU','MONACO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03043','NIVELADOR F3C 1.00MM (60341) - F3','NIU','F3C',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03044','LAVADERO COCINA FRATELLI PARA GRANITO INTERMEDIO PESADO','NIU','FRATELLI',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03045','LAVADERO COSINA TRAMONTINA 50X80 C/E','NIU','GENÉRICO',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03046','LAVADERO COCINA FORTALY LIVIANO C/E PEQUEÑO LIVIANO','NIU','FORTALY',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03047','LAVADERO COSINA INOXSOL POSA SOLA','NIU','GENÉRICO',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03048','SISTEMA DE NIVELACION TORNADO 50UNID','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03049','CUÑA PARA PORCELANATO 100UNID F3C AMARILLO - F3C','NIU','F3C',7.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03050','NIVELADOR PARA PORCELANATO 3MM 100 UNID F3C (60127) - F3C','NIU','F3C',5.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03051','PIAVE BLANCO 45X45 (2.03X10PZA) - CELIMA','NIU','CELIMA',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03052','LAVATORIO Y PEDESTAL VERDE LIMON TARRACO - TARRACO','NIU','TARRACO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03053','LAVATORIO Y PEDESTAL ALMENDRA TREBOL - TREBOL','NIU','TREBOL',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03054','LAVATORIO BONE DACQUA - DACQUA','NIU','DACQUA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03055','LAVATORIO Y PEDESTAL FV BONE','NIU','FV',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03056','MESA DE MELAMINE SOBRE PONER GRIS PLATA PARA OVALIN VIDRIO','NIU','GENÉRICO',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03057','LAVATORIO Y PEDESTAL FV NEGRO - FV NEGRO','NIU','FV',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03058','LAVATORIO Y PEDESTAL BLANCO ITALGRIF - ITALGRIF','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03059','LAVATORIO GRECIA NEGRO - GRECIA','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03060','PERFIL PVC CHOCOLATE 8.5 FINOPLAST','NIU','FINOPLAST',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03061','LAVATORIO TARRACO BONE - TARRACO','NIU','TARRACO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03062','LAVATORIO BLANCO TWENTY - TWENTY','NIU','TWENTY',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03063','OVALIN DE VIDRIO CRISTAL GRANDE','NIU','GENÉRICO',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03064','INODORO ALMENDRA TREBOL - TREBOL','NIU','TREBOL',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03066','INSERTO DECORADO VIENA PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03067','INSERTO DECORADO MADRID PARA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03069','INSERTO DECORADO GINOS BEIGE PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03070','INSERTO DECORADO KIOTO PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03071','INSERTO DECORADO SALAMANCA PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03072','INSERTO DECORADO CARTAGO PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03073','INSERTO DECORADO MABEL BEIGE PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03074','INSERTO DECORADO BARCELONA PARA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03075','INSERTO DECORADO LINDA ROSA PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03076','DECORADO IMPORTADO CAFE 30 X 60 PARA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03077','DECORADO IMPORTADO ESTRELLA MAR AZUL 30 X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03078','DECORADO IMPORTADO TOALLA GRIS 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03079','DECORADO IMPORTADO GIRASOLROSADO 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03080','DECORADO IMPORTADO ALGAS VERDES 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03081','DECORADO IMPORTADO ACUARIO 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03082','DECORADO IMPORTADO JARRON NEGRO 30X60 PARA CCCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03083','DECORADO IMPORTADO TAZAS GRIS 30X60 PARA COCINA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03084','DECORADO IMPORTADO ROSAS BEIGE 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03085','LLAVE PREMIUM PARA BOWL/ LAVATORIO BRUSELAS','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03086','LLAVE DE DUCHA DE 1/2 X 1/2 CROMADA FAVINZA - FAVINZA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03087','DECORADO IMPORTADO FLOR CARAMELO 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03088','DECORADO IMPORTADO FLOR GRIS 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03089','DECORADO IMPORTADO GIRASOL SARA PLATA 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03090','DECORADO IMPORTADO TOALLA MARFIL 30X60 PARA BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03091','LLAVE LAVATORIO PICO LARGO PESADA MONACO','NIU','MONACO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03092','CUÑA PARA PORCELANATO 100UNID TORREWS AZUL - TORREWS','NIU','TORREWS',11,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03093','PISO FIORE CARAMELO 45X45 - FIORE CARAMELO S/L 1RA (2.08','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03094','PEGAMENTO CELIMA ORIGINAL BLANCO EXTRAFUERTE','NIU','CELIMA',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03097','LLAVE LAVATORIO VAINSA PERILLA ACRÍLICA','NIU','VAINSA',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03098','LLAVE DE DUCHA PALANCA FRATELLI - FRATELLI','NIU','FRATELLI',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03099','INODOROS OBELIA BLANCO - OBELIA BLANCO','NIU','GENÉRICO',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03101','CAÑO BOTADERO CRUZ FRATELLI - FRATELLI','NIU','FRATELLI',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03102','CAÑO PLUS AZ - AZ','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03103','LLAVE LAVATORIO CON PALANCA FORTALY - FORTALY','NIU','FORTALY',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03104','LLAVE DE DUCHA PERILLA ACRILICA VAINSA - VAINSA','NIU','VAINSA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03105','LLAVE DE OVALIN ALTO PESADO FRATELLI SDY-1 - FRATELLI','NIU','FRATELLI',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03106','LLAVE DE OVALIN CUADRADO PESADO FRATELLI SDY S-3 - FRATELLI','NIU','FRATELLI',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03107','LLAVE PARA OVALIN SOBREPONER C/ PERILLA CRUZ FRATELLI SEMIPESADO - FRATELLI','NIU','FRATELLI',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03108','PICO DE GANZO PERILLA CRUZ PESADO FRATELLI - FRATELLI','NIU','FRATELLI',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03109','LLAVE PARA COCINA CORRUGADO PESADO MANIJA CRUZ FRATELLI - FRATELLI','NIU','FRATELLI',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03110','PICO DE GANSO PARA COCINA FRATELLI PESADO MANIJA ALETA - FRATELLI','NIU','FRATELLI',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03111','PICO DE GANSO PARA COCINA MANGUERA NEGRA FRENCIA - FRENCIA','NIU','FRENCIA',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03112','LLAVE PARA COCINA APACHE CORRUGADO SEMIPESADO - APACHE','NIU','APACHE',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03113','LLAVE LAVATORIO PERILLA CROMADA VAINSA - VAINSA','NIU','VAINSA',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03114','LLAVE DE DUCHA NACIONAL TECNISUR - TECNISUR','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03115','LLAVE DE DUCHA MANIJA DE ALETA RUBINETO - RUBINETO','NIU','RUBINETO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03116','LLAVE DE DUCHA PERILLA MODELO TREBOL RUBINETO - RUBINETO','NIU','TREBOL',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03117','LLAVE PARA COCINA CORRUGADA VAINSA - VAINSA','NIU','VAINSA',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03118','LLAVE DE DUCHA CASTLE - CASTLE','NIU','CASTLE',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03119','PICO DE GANSO AL MUEBLE PARA COCINA PERILLA ALETA GIRALDI - GIRALDI','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03120','MEZCLADORA DE DUCHA VAINSA MANIJA CRUZ - VAINSA','NIU','VAINSA',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03121','MEZCLADORA DE DUCHA VAINSA MANIJA CROMADA - VAINSA','NIU','VAINSA',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03122','MEZCLADORA DE COCINA MANIJA CROMADA RUBINETO - RUBINETO','NIU','RUBINETO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03123','PICO DE GANSO PARA COCINA MANIJA PALANCA FORTALY - FORTALY','NIU','FORTALY',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03124','PICO DE GANSO PARA COCINA MANIJA CRUZ FORTALY - FORTALY','NIU','FORTALY',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03125','PICO DE GANSO PARA COCINA CON MAGUERA DE COLORES APACHE - APACHE','NIU','APACHE',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03126','MEZCLADORA AL MUEBLE PARA COCINA RUBINETO - RUBINETO','NIU','RUBINETO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03127','LLAVE PARA COCINA CORRUGADA PERILLA CUADRADA APACHE - APACHE','NIU','APACHE',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03128','PORCELANATO UNIMASA GRANITO GRIS 60X1.20 (1.44X2PZAS)','NIU','GENÉRICO',98,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03129','LLAVE PARA COCINA AL MUEBLE CORRUGADO PERILLA CRUZ PESADO FRATELLI - FRATELLI','NIU','FRATELLI',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03130','LLAVE PARA COCINA AL MUEBLE CORRUGADO PERILLA ALETA PESADO FRATELLI - FRATELLI','NIU','FRATELLI',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03131','CAÑO JARDIN MANIJA AMARILLO AYRON - AYRON','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03132','CAÑO JARDIN MANIJA ROJO FERROSI - FERROSI','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03133','CAÑO JARDIN MANIJA AZUL AMERICA - AMERICA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03134','LLAVE LAVATORIO SEMIPESADO PERILLA ALETA GIRALI - GIRALI','NIU','GIRALI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03135','LLAVE LAVATORIO DE LUJO TREBOL - TREBOL','NIU','TREBOL',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03136','LLAVE PARA OVALIN ALTO SEMIPESADO FORTALY - FORTALY','NIU','FORTALY',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03137','LLAVE DE COCINA CORRUGADA ECONOMICO MANIJA ALETA FRATELLI - FRATELLY','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03138','LLAVE PARA OVALIN ALTO LIVIANO ECONOMICO SIN MARCA - SIN MARCA','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03139','PICO DE GANSO PARA COCINA CON MANGUERA LILA FRENCIA - FRENCIA','NIU','FRENCIA',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03140','LLAVE MANGUERA COLORES PARA COCINA PERILLA CUADRADA SIN MARCA - SIN MARCA','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03141','LLAVE PARA COCINA CORRUGADO SATINADO FORTALY - FORTALY','NIU','FORTALY',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03142','LLAVE LAVATORIO DE LUJO SIN MARCA - SIN MARCA','NIU','GENÉRICO',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03143','LLAVE PARA OVALIN DE LUJO CASTLE - CASTLE','NIU','CASTLE',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03144','LLAVE PARA OVALIN DE LUJO GIRALI - GIRALI','NIU','GIRALI',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03145','LLAVE PARA OVALIN SEMIPESADO MANIJA CRUZ FORTALY - FORTALY','NIU','FORTALY',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03146','LLAVE PARA OVALIN PARA SOBREPONER BAJO PESADO CON PERILLA MONOCOMANDO FRATELLI - FRATELLI','NIU','FRATELLI',85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03147','LLAVE LAVATORIO MONOCOMANDO DACQUA - DACQUA','NIU','DACQUA',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03149','PEGAMENTO CELIMA GRIS BASICO','NIU','CELIMA',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03152','BRAZO DE DUCHA REDONDA SEMIPESADO ECON. DIROFASA - DIROFASA','NIU','DIROFASA',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03153','REGADERA DE DUCHA MODELO CAMPANA SIN MARCA - SIN MARCA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03154','REGADERA DE DUCHA FORTALY EN CAJA - FORTALY','NIU','FORTALY',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03155','REGADERA DE DUCHA REGULABLE SIN MARCA','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03156','REGADERA DE DUCHA REDONDA CROMADA SIN MARCA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03157','REGADERA DE DUCHA MODELO ESPAÑOL CROMADO SEVILLA - SEVILLA','NIU','SEVILLA',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03158','REGADERA DE DUCHA MODELO ESPAÑOL PVC DE 8" SIN MARCA - SIN MARCA','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03159','CANASTILLA DE DUCHA MODELO CAMPANA DE 4" SEVILLA - SEVILLA','NIU','SEVILLA',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03160','REGADERA DE DUCHA PVC BLANCO SEVILLA DE 4" - SEVILLA','NIU','SEVILLA',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03161','REGADERA DE DUCHA C/REGULADOR DE 5" REDONDA SIN MARCA - SIN MARCA','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03162','LLAVE PARA LAVATORIO NACIONAL GRIFASUR - GRIFASUR','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03163','TAPON REJILLA DE 2" CON TAPA JEBE DE 2"','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03165','FRAGUA CELIMA NEGRO','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03166','BAÑO COMPLETO','NIU','GENÉRICO',420,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03168','LLAVE BOTADERO CON PALANCA FRATELLI','NIU','FRATELLI',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03169','PICO DE GANSO PARA COCINA AL MUEBLE NAC. FAGRICENTER','NIU','FAGRICENTER',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03170','LLAVE LAVATORIO FRATELLI PERILLA CRUZ SEMIPESADA - FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03171','DESAGUE CROMADO PUSH PARA OVALIN VENICE - VENICE','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03172','DESAGUE PUSH LARGO PARA OVALIN CROMADOFRATELLI - FRATELLI','NIU','FRATELLI',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03173','DESAGUE DE PVC MONACO 3.5 - MONACO','NIU','MONACO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03174','LLAVE PARA LAVATORIO QATAR MONACO PERILLA 4 (101004) - MONACO','NIU','MONACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03175','LLAVE PARA LAVATORIO QATAR MONACO PERILLA 3 (101003) - MONACO','NIU','MONACO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03176','TRAMPA JAMECO CROMADO - JAMECO','NIU','JAMECO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03177','LLAVE DE OVALIN PERILLA RUZ LIVIANO FRATELLI','NIU','FRATELLI',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03178','REJILLA DE 4" CROMADO','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03180','FRAGUA CHEMA MARRON','NIU','CHEMA',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03182','CAOBA CARAMELO','NIU','GENÉRICO',33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03184','LAVATORIO COCINA','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03187','TRAVERTINO HUESO','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03188','LAPIZ DE VIDRIO DE 0.60','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03190','FLOR AZUL OSCURO','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03191','PEGAMENTO BLANCO','NIU','GENÉRICO',17,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03192','MESA DE MELAMINE SOBREPONER PARA OVALIN','NIU','GENÉRICO',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03193','LLAVE PARA OVALIN-','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03194','ALUMINIO EN L -','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03196','INODORO RAPIDJET','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03197','TUBO DE ABASTO-','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03199','ESPEJO-','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03201','ACCESORIO PARA BAÑO-','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03202','TRAMPA FIORI-','NIU','FIORI',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03203','GRANITO GRIS-','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03207','TERRE GRAFITO-','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03209','MARILIA','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03210','ACCESORIO PARA INODORO TARRACO EN HG - HG','NIU','TARRACO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03211','TRAMPA PVC CON REGISTRO DE 2" FIORI - FIORI','NIU','FIORI',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03212','TRAMPA P EN FAMA PARA LAVADERO - FAMA','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03213','MEZCLADORA DE LAVATORIO MONOCOMANDO SIN MARCA IMP. - SIN MARCA','NIU','GENÉRICO',160,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03214','PICO DE GANSO ECO. IMPORTADO SIN MARCA - SIN MARCA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03215','CAÑO DE BRONCE NACIONAL FIRPASA - FIRPASA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03216','BAÑO TWENTY ONE P.','NIU','TWENTY',200,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03217','TUBO DE ABASTO 1/2 X 1/2 ECKOGRIF - ECKOGRIF','NIU','ECKOGRIF',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03218','TUBO DE ABASTO 1/2 X 7/8 ECKOGRIF - ECKOGRIF','NIU','ECKOGRIF',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03219','TUBO DE ABASTO 1/2 X 7/8 SANI - SANI','NIU','SANI',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03220','TUBO DE ABASTO 1/2 X 7/8 FRATELLY - FRATELLY','NIU','FRATELLI',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03221','TUBO DE ABASTO 1/2 X 7/8 SIN MARCA - SIN MARCA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03222','TUBO DE ABASTO 1/2 X 1/2 SIN MARCA - SIN MARCA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03223','TUBO DE ABASTO 1/2 X 7/8 PVC METUSA - METUSA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03224','TUBO DE ABASTO 1/2 X 7/8 HYDRA - HYDRA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03225','LLAVE PARA OVALIN DE SOBREPONER DE LUJO BAJO GOLDFLAG - GOLDFLAG','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03226','ACCESORIO PLUSH TANQUE SIFON MODELO TREBOL - SIFÓN','NIU','TREBOL',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03227','DESAGUE PVC SANI - SANI','NIU','SANI',17,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03228','TOALLERO DE ALUMINIO REGULABLE DE 2" A PRESION','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03229','TOALLERO DE BRIDA DE 1/2 A PRESION','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03230','TUBO DE ABASTO DE 1/2 X 1MTR - SIN MARCA','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03231','LLAVE PARA OVALIN DE LUJO BAJO EN CASTLE - CASTLE','NIU','CASTLE',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03232','PARED BLANCO SATINADO 27X45 (2.07X17 PZA) CELIMA - CELIMA','NIU','CELIMA',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03233','REPUESTOS DE NIVELADOR TIPO ROSCA SOMBREITO FABREPLAST - FABREPLAST','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03234','ESPEJO BISELADO','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03235','ESPEJO SIMPLE DE VIDRIO','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03236','ARIANA PLATA','NIU','GENÉRICO',24.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03237','BRICK ONDAS GRIS','NIU','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03238','BRICK TRAVISO BLANCO','NIU','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03248','block de vidrio','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03249','llave para ovalin','NIU','GENÉRICO',250,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03250','ESPEJO SIRENA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03251','ESPEJO ZTA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03252','ESPEJO CHAVO','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03253','ESPEJO CHAVO FLOR','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03254','ESPEJO COLIBRI','NIU','GENÉRICO',43,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03255','ESPEJO SIRENA ITERMEDIO','NIU','GENÉRICO',43,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03256','ESPEJO DELFIN','NIU','GENÉRICO',43,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03257','ESPEJO LED','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03260','LAPIZ DORADO.-','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03261','MESA DE OVALIN.-','NIU','GENÉRICO',330,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03262','SEPARADOR DE AMBIENTE','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03263','REGADERA.-','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03265','LAPIZ DE VIDRIO D 1','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03267','TRAMPA BOTELLA','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03268','TAPA BABY','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03270','california','NIU','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03273','ALMANSA NATURAL','NIU','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03275','LAVADERO PARA COCINA.-','NIU','GENÉRICO',170,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03276','FIORE CARAMELO','NIU','GENÉRICO',38.48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03277','PISO PISA BLANCO 45X45 COM (2.23X11 PZAS)','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03278','PISO PARQUET QUINILLA BEIGE 45X45 (2.08X10PAS)','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03279','SALDO','NIU','GENÉRICO',22.3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03283','FRAGUA CELIMA ALUMINIO','NIU','CELIMA',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03284','SUMIDERO P.','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03286','PORCELANATO UNIMASA GENESIS NEGRO 1.20X60 (1.44X2PZAS)','NIU','GENÉRICO',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03287','GJ612703 - PORCELANATO UNIMASA GENESIS BLANCO 1.20X60 (1.44X2PZAS)','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03288','PORCELANATO UNIMASA MARBENA WHITE 1.20X60 (1.44X2PZAS)','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03289','PORCELANATO UNIMASA VIGO GOLD 1.20X60 (1.44X2PZAS)','NIU','GENÉRICO',73,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03290','PISO SIENA DORADA 60X60 COM (1.80X5PZAS)','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03291','MAYOLICA 30X60 (COD LG36060B) (1.62X9PZAS)','NIU','GENÉRICO',36.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03300','fraguas','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03306','FRAGUA CELIMA AVELLANA','NIU','CELIMA',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03309','FRAGUAS CELIMA','NIU','CELIMA',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03320','fraguas celima','NIU','CELIMA',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03321','fragua pisina','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03326','pepelmas','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03330','tanque rodoplas','NIU','GENÉRICO',1850,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03334','aluminio en l 10','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03336','lapiz ceramico','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03338','fraguas','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03339','trampa corrugado','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03340','PORCELANATO MATE 60X60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03341','PEGAMENTO BLANCO EXTRAFUERTE','NIU','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03342','inodoro onepis blanco','NIU','GENÉRICO',330,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03343','ovalines','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03344','fragua','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03345','pegamento chemayolic','NIU','GENÉRICO',49,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03346','lapiz acero','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03347','silicona','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03348','silicona','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03349','lavadero enchapado','NIU','GENÉRICO',175,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03350','trampas para lavadero','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03351','patas de lavaderos enchapados','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03352','caños para lavadero','NIU','GENÉRICO',50,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03353','cinta teflon','NIU','GENÉRICO',2,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03354','mayolica pisina','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03355','pegamento','NIU','GENÉRICO',49,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03356','fragua','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03357','ovalin hg blanco','NIU','HG',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03358','llave ovalin','NIU','GENÉRICO',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03359','fragua gris plata','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03360','tubo abasto acero','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03361','trampa cromada','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03362','medio baño negro','NIU','GENÉRICO',480,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03363','tubo de abasto','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03364','anillo cera','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03365','trampa trebol','NIU','TREBOL',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03366','uñas de lavatorio','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03367','urinario blanco','NIU','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03368','urinario negro','NIU','GENÉRICO',95,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03369','pared de baño','MTK','GENÉRICO',20.76,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03370','piso','MTK','GENÉRICO',22.44,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03371','listelo','NIU','GENÉRICO',12.92,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03372','lapiz vidrio','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03373','fragua','NIU','GENÉRICO',7.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03374','medio baño hg','NIU','HG',340,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03375','rodoplas','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03376','PORCELANATO OREO NEGRO 60X60 VIDRIFICADO 1.44 X 4PZAS DECORWAUS','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03377','PISO BETON MARFIL CELIMA DE 60X60 1.80 X5PZAS COMERCIAL','MTK','CELIMA',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03378','PISO EMPORIO PERLA CELIMA 60X60 X 5 PZAS 1.80MT COMERCIAL','MTK','CELIMA',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03379','ANDREA AZUL 25X40','NIU','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03380','piso 60x60 marmoleado','MTK','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03381','pegamento extrafuerte pagaval','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03382','fragua','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03383','porcelanato hueso 60x60','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03384','pegamento blanco estrafuerte','NIU','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03385','PEGAMENTO BLANCO CELIMA','NIU','CELIMA',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03386','LAPIZ CERAMICO 4BOLITAS DE 2X60 PLATEADO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03387','LAPIZ CERAMICO BOTON 2X60 PLATEADO','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03388','CRUZETA DE 2 F3 BOLSA X 100 UNI','NIU','F3C',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03389','CRUZETA DE 3 MM F3 X 100 UNI','NIU','F3C',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03390','pared ladrillo blanco','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03391','urinario equipado','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03392','PISO URPI SL 45X45','NIU','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03393','PORCELANATO -CAMELIA 60X60','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03394','PISO RUSTICO 60X60 SL','NIU','GENÉRICO',28.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03395','PORCELANATO GRIS 60X60','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03396','PISO BLANCO 45X45','NIU','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03397','PARED 30X60','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03398','FRAGUA PISCINA 25 KG CHEMA','NIU','CHEMA',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03399','FRAGUA CHEMA SANSON GRISPLATA','NIU','SANSON',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03400','PISO 45X45','NIU','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03401','PORCELANATO CALACATA BLANCO 60X60','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03402','LAPIDAS TALLADAS','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03403','PORCELANATO - ALICANTE NEGRO','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03404','FACHALETAS','MTK','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03405','PEGAMENTO CHEMA','NIU','CHEMA',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03406','FRAGUAS','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03407','FACHALETA HIMPORTADO','MTK','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03408','PEGAMENTO BLANCO','NIU','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03409','FRAGUA','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03410','NIVELADOR','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03411','piso baño','MTK','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03412','pegamento blanco extrafuerte baño','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03413','fraguas','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03414','rodo aluminio','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03415','perfil pvc','NIU','GENÉRICO',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03416','piso antideslizante','MTK','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03417','pegamentos blanco','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03418','mayolica pared baño','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03419','decorado de baño','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03420','decorado de baño','NIU','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03421','tina ducha','NIU','GENÉRICO',350,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03422','axesorio tina','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03423','caños tina ducha','NIU','GENÉRICO',55,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03424','perfil aluminio','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03425','PISO CEIBO 45X45 CELIMA','MTK','CELIMA',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03426','PISO 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03427','ONE PICE C/ ACCESORIO DE INSTALACION','NIU','GENÉRICO',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03428','DECORTADOS 15X60 IMP.','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03429','LLAVE DE PASO CONTROL','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03430','PARED ONDAS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03431','DIBUJOS','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03432','PISO 60X60','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03433','PEGAMENTO GRIS','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03434','FRAGUA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03435','CRUZETA','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03436','PERFIL PVC','NIU','GENÉRICO',56,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03437','MAYOLICA PARED','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03438','PRED ONDAS GRIS','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03439','PEGAMENTOS GRIS','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03440','PEGAMENTO BLANCO','NIU','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03441','LADRILLO DORADO 30X60 IM.','MTK','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03442','PISO 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03443','PORCELANATO MARMOLEADO GRIS 60X60','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03444','INODORO FLORIDA BLANCO C/ KIT DE ACCESORIO','NIU','GENÉRICO',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03445','PORCELANICO DALLAS CARAMELO 60X60','MTK','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03446','PARED TURQUESA 30X60 IMP.','MTK','GENÉRICO',27.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03447','MAYOLICA 30X60','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03448','PISO 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03449','OVALIN EQUIPADO BLANCO','NIU','GENÉRICO',230,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03450','URINARIO C/ KIT DE INSTALACION','NIU','GENÉRICO',165,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03451','FRAGUA','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03452','OVALIN C/ KIT DE INSTALACION','NIU','GENÉRICO',230,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03453','PORCELANATO 60X60','MTK','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03454','PISO RECTIFICADO 46X46','MTK','GENÉRICO',21.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03455','FACHALETA 27X45','MTK','GENÉRICO',28.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03456','PERFILES PVC','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03457','GRANILLA NEGRO 60X60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03458','PORCELANATO 60X60','MTK','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03459','PORCELANATO 60X60','MTK','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03460','DECORADO COCINA 15X60','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03461','PORCELANATO MATE 60X60','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03462','CORTINERO PEQUEÑO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03463','NIVELADOR TORNADO F3','NIU','F3C',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03464','RESINA PARA PORCELANATO','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03465','LAVADERO DE COCINA RECOD INOXOL','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03466','CORTES','NIU','GENÉRICO',2.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03467','PICO GANZO TREBOL','NIU','TREBOL',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03468','PORCELANATO 60X60','MTK','GENÉRICO',28.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03469','PISO 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03470','PORCELANATO 60X60','MTK','GENÉRICO',27.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03471','PORCELANATO 60X60','MTK','GENÉRICO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03472','PARED 30X60','MTK','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03473','SERVICIO DE INSTALACION DE CERAMICA','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03474','PISO 30X30','MTK','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03475','TINA JACUZZI','NIU','GENÉRICO',330,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03476','PORCELANATO 60X60','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03477','PORCELANATO 60X60','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03478','PORCELANATO 60X60','MTK','GENÉRICO',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03479','PISO 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03480','PISO 45X45','MTK','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03481','PISO 45X45','MTK','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03482','PISO 45X45','MTK','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03483','PISO DE 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03484','PORCELANATO 60X60','MTK','GENÉRICO',38.16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03485','PORCELANATO 60X60 RUSTICO','MTK','GENÉRICO',36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03486','CORTADOR DE NIVELADOR','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03487','PORCELANATO 60X60','MTK','GENÉRICO',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03488','PORCELANATO 60X60','MTK','GENÉRICO',25.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03489','INODORO SIFON TREBOL TZA&STANQUE','NIU','TREBOL',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03490','RESPUESTO DE NIVELADOR DE CERAMICO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03491','LAVADERO C/ PEDESTAL ITALGRIF','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03492','LAVATORIO Y PEDESTAL BLANCO TREBOL','NIU','TREBOL',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03493','PORCELANATO 60X60','MTK','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03494','LAMAR MARINO 27X45 AZUL','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03495','LAMAR MARINO BLANCO 27X45','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03496','PISO 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03497','PORCELANATO DE 1.2X0.60','MTK','GENÉRICO',65,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03498','OVALIN RECTANGULAR BLANCO','NIU','GENÉRICO',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03499','ONE PIECE BLANCO HG','NIU','HG',230,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03500','LARIZA VERDE','MTK','GENÉRICO',27.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03501','FACHALETA 34X50 ESPAÑOLA','MTK','GENÉRICO',54,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03502','REPUESTO DE VALVULA','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03503','piso concreto gris 45x45','MTK','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03504','mayolica pared 27x45','MTK','GENÉRICO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03505','pegamentos gris','NIU','GENÉRICO',13.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03506','fraguas gris','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03507','perfil aluminio','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03508','cruzeta 2','NIU','GENÉRICO',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03509','ONE PIECE C/ LAVATORIO Y PEDESTAL BONE','NIU','GENÉRICO',380,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03510','PISO RECTIFICADO 60X60','MTK','GENÉRICO',21.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03511','DECOARDOA BAÑO GRIS 15X60','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03512','BLANCO BRILLANTE 30X60 IMP.','MTK','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03513','PORCELANATO UNIMASA 1.2X60','MTK','GENÉRICO',130,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03514','DECORADO GRIS BAÑO 15X60','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03515','CANTONERA DE 1MM CON SOPORTE','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03516','PISO 45X45','MTK','GENÉRICO',17,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03517','DECORADOS','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03518','JUEGO DE BAÑO ONE PIECE C/ ACCESORIO','NIU','GENÉRICO',400,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03519','OVALIN DORADO','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03520','PISO ESTEFANIA 45X45','MTK','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03521','PORCELANATO MARMOLEADO 60X60','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03522','PORCELANATO NEGRO CON VETAS DORADAS 60X60','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03523','PORCELANATO VITRIFICADO LPY66052','MTK','GENÉRICO',27.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03524','INODORO RAPIJET TREBOL','NIU','TREBOL',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03525','CANTONERA PESADA','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03526','PEGAMENTO BLANCO EXTRAFUERTE PORCELANATINO','NIU','GENÉRICO',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03527','RESINA DE PORCELANATO GRIS','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03528','porcelanato mate de 60x60','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03529','perfil de aluminio en l','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03530','porcelanato 1.20 negro dorado','NIU','GENÉRICO',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03531','cuñas para porcelanato','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03532','TABLON 1.2X60','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03533','PISO PORCELANANICO MADERA','MTK','GENÉRICO',18.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03534','ZOCALOS','NIU','GENÉRICO',18.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03535','INODORO C/ TAZA + LAVATORIO Y PEDESTAL + ACC DE INSTACION','NIU','GENÉRICO',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03536','PORCELANATO BLANCO MARMOLEADO','MTK','GENÉRICO',27,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03537','PEGAMENTO PEGAVAL BLANCO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03538','ONE PICE BLANCO C/ MUEBLE+LAVADERO','NIU','GENÉRICO',580,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03539','PORCE. HUESO MARMOLEADO','MTK','GENÉRICO',23.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03540','PEGAMENTO BLANCO MAESTRO','MTK','MAESTRO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03541','PORCE. DIAMENATE CLARO 60X60','MTK','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03542','ONE PIECE RELINDA BLANCO','NIU','GENÉRICO',240,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03543','PORCELANATO DIAMANTE CLARO 60X60','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03544','LAVATORIO C/ PEDESTAL BLANCO TWENTY','NIU','TWENTY',180,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03545','KIT DE INSTALION ONE PIECE C/ LAVATORIO','NIU','GENÉRICO',145,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03546','PORCELANATO GRIS MARMOLEADO MATE 60X60','MTK','GENÉRICO',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03547','PORCELANATO GRIS PLATA MARMOLEADO 60X60','MTK','GENÉRICO',26.56,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03548','PORCELANADO DIAMANTE CLARO 60X60','MTK','GENÉRICO',26.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03549','CANTONERA RODOPASO ALUMINIO','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03550','PORCELANATO 60X60','MTK','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03551','PORCELANATO NEGRO MARMOLEADO 60X60','MTK','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03552','PORCELANATO GRIS VITRIFICADO','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03553','porcelanato','NIU','GENÉRICO',47.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03554','pegamento maestro','NIU','MAESTRO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03555','fragua','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03556','rodoplas','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03557','porcelanato','NIU','GENÉRICO',47.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03558','piso','BX','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03559','piso (caja)','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03560','piso (caja)','BX','GENÉRICO',58.13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03561','doroplas aluminio','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03562','piso (caja)','BX','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03563','pegamento blanco fexible pegaval forte','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03564','pegamento blanco','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03565','resina','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03566','fragua hueso','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03567','fragua marron','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03568','rodoplas','NIU','GENÉRICO',3.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03569','piso (MESA)','MTR','GENÉRICO',34.97,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03570','PISO - MESA','MTR','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03571','PISO - MESA','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03572','PISO - PARED','NIU','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03573','FACHALETA','NIU','GENÉRICO',24,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03574','DIBUJO','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03575','LAPIZ','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03576','RODO. METAL','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03577','PISO - COCINA','MTR','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03578','PISO - CONTRA MESA','MTR','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03579','PEGAMENTO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03580','FRAGUA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03581','LAVADERO EQUIPADO','NIU','GENÉRICO',235,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03582','PORCELANATO 60X60','MTR','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03583','PISO - PORCELANATO 60X60','NIU','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03584','PISO - PORCELANATO 60X60','MTR','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03585','PISO - PARED DE BAÑO 60X30','MTR','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03586','PISO BAÑO 45X45','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03587','FRAGUA COLOR HUESO','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03588','FRAGUA COLOR HUESO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03589','FRAGUA COLOR GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03590','SEPARADORES DE 1 (PARA PISO)','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03591','SEPARADORES DE 2 (PARA PISO)','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03592','SEPARADORES DE 2 (PARA PISO)','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03593','VARRILLA DE JEBE','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03594','PISO DE BAÑO 45X45','MTR','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03595','PISO MATE GRIS GRAFITO CELIMA','NIU','CELIMA',33.3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03596','PARED MARMOLEADOS 30X60','NIU','GENÉRICO',29.6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03597','PEGAMENTO BLANCO','NIU','GENÉRICO',22.8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03598','PEGAMENTO GRIS','NIU','GENÉRICO',14.8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03599','FRAGUAS','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03600','PERFILES ALU','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03601','PORCELANATO','NIU','GENÉRICO',86.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03602','PORCELANATO','NIU','GENÉRICO',86.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03603','PORCELANATO 1.30 X 60','NIU','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03604','PORCELANATO 30 X 60','NIU','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03605','PORCELANATO 1.20 X 60','NIU','GENÉRICO',86.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03606','PORCELANATO 1.20 X 60','NIU','GENÉRICO',84.6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03607','PORCELANATO 1.20 X60','NIU','GENÉRICO',86.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03608','PORCELANATO 30 X60','NIU','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03609','PORCELANATO 30 X 60','NIU','GENÉRICO',39,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03610','PORCELANATO 1.20 X 60','NIU','GENÉRICO',86.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03611','PORCELANATO 60 X 60','NIU','GENÉRICO',41,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03612','PEGAMENTO CHEMAYOLIC','NIU','GENÉRICO',49,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03613','FRAGUA CHEMA','NIU','CHEMA',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03614','PEGAMENTO CHEMAYOLIC','NIU','GENÉRICO',49,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03615','RESINA KG','NIU','GENÉRICO',90,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03616','NIVELADORES','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03617','CUÑAS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03618','DISCO','NIU','GENÉRICO',53,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03619','ALICATE','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03620','LAVADERO','NIU','GENÉRICO',350,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03621','LLAVE DE DUCHA','NIU','GENÉRICO',200,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03622','LLAVE DE COCINA','NIU','GENÉRICO',200,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03623','SERVICIO DE TRANSPORTE','NIU','GENÉRICO',350,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03624','SERVIVIO DE TAXI','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03625','Piso 60x60 (marmoleado)','BX','GENÉRICO',37.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03626','Piso 60x60 (burbuja)','BX','GENÉRICO',37.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03627','Resina - Gris plata','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03628','mayolica de pared','NIU','GENÉRICO',27.54,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03629','MAYOLICAS DE PARED','NIU','GENÉRICO',27.54,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03630','MAYOLICAS DE PARED 30X60','NIU','GENÉRICO',27.54,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03631','PORCELANATO HUESO MARMOLEADO DE 60','NIU','GENÉRICO',27.36,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03632','CELIMA BLANCO ESTRAFUERTE','NIU','CELIMA',37,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03633','FRAGUA CHEMA','NIU','CHEMA',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03634','mayolicas pared gris','MTK','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03635','porcelanato hueso de 60x60','BX','GENÉRICO',24.48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03636','pegamento maestro blanco','NIU','MAESTRO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03637','fragua hueso','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03638','porcelanato hueso60x60','BX','GENÉRICO',24.48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03639','pegamentos blanco maestro','NIU','MAESTRO',23,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03640','fraguashueso','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03641','piso american blanco d 30x30','BX','GENÉRICO',55.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03642','porcelanato de 60x60','BX','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03643','pegamento blanco','NIU','GENÉRICO',37.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03644','perfiles aluminio','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03645','tina blanco marmol','NIU','GENÉRICO',650,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03646','mescladora de ducha tina','NIU','GENÉRICO',400,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03647','piso ceramica de 60x60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03648','perfiles metal','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03649','pisos cuarto 45x45','MTK','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03650','tablones de 1.20 x20','MTK','GENÉRICO',12.85,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03651','perfiles','NIU','GENÉRICO',6.67,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03652','silicona extrafuerte','NIU','GENÉRICO',83.33,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03653','mescladora ducha','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03654','lavadero acero','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03655','inodoro himportado','NIU','GENÉRICO',550,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03656','kits de acero','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03657','ovalin dorado','NIU','GENÉRICO',280,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03658','kits para ovalin juego','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03659','pegamento chema','NIU','CHEMA',47.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03660','pegamento chema extrafuerte','NIU','CHEMA',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03661','pegammento trebol gris','NIU','TREBOL',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03662','fraguas','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03663','porcelanato marron','BX','GENÉRICO',48.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03664','porcelanato','BX','GENÉRICO',64,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03665','pegamento gris','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03666','fraguas','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03667','perfiles pvc','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03668','baños blanco equipado','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03669','MAYOLICA DE PARED','BX','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03670','PORCELANATO','BX','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03671','DECORADOS BAÑO','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03672','LAPIS','NIU','GENÉRICO',6.7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03673','BAÑO ONEPIZ','NIU','ONEPIZ',1150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03674','PORCELANATO TABLONES','MTK','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03675','RODOPASO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03676','OVALIN MUEBLE','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03677','KIT DE INSTALACION DE OVALIN','NIU','GENÉRICO',350,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03678','porcelanato de 1.20','MTK','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03679','porcelanato mate','MTK','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03680','pegamento chema','NIU','CHEMA',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03681','fragua chema','NIU','CHEMA',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03682','lavaderos multifuncional','NIU','GENÉRICO',600,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03683','mescladoras de cosina','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03684','trampas','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03685','pepelmas','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03686','porcelanato','NIU','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03687','PORCELANATO','MTK','GENÉRICO',26,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03688','PEGAMENTO','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03689','FRAGUA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03690','NIVELADORES','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03691','NIVELADORES','NIU','GENÉRICO',33.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03692','porcelanato','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03693','pegamento chemoyolic blanco','NIU','GENÉRICO',46,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03694','fraguas premiun','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03695','G.gris','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03696','PORCELANATO ESCARCHADO','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03697','PEGAMENTO CHAMA BLANCO FLEXIBLE','NIU','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03698','PIEZAS DE ESCARCHADO','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03699','PERFIL DE 10','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03700','PORCELANATO ESCARCHADO','NIU','GENÉRICO',54,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03701','PEGAMENTO CHEMAYOLIC','NIU','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03702','tablon de 1.20','MTK','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03703','pegamento chema','NIU','CHEMA',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03704','cantoneras escalera','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03705','piso de 60x60','MTK','GENÉRICO',29,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03706','CISTERJNA DE TANQUE','NIU','GENÉRICO',700,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03707','PEGAMENTO GRIS','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03708','MEDIO BAÑO COMPLETO','NIU','GENÉRICO',450,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03709','BALINES','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03710','lavaderos enchapados','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03711','pegamento gris','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03712','inodoros eco','NIU','GENÉRICO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03713','jakusi','NIU','GENÉRICO',2900,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03714','lapiz acero','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03715','ovalin','NIU','GENÉRICO',110,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03716','laves ovalin','NIU','GENÉRICO',140,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03717','mayolicas de pared','MTK','GENÉRICO',16,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03718','piso','MTK','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03719','lapiz','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03720','pegamento chemoyolic','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03721','fragua','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03722','perfil aluminio','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03723','pegamento blanco','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03724','porcelanato de 1.20','NIU','GENÉRICO',25.9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03725','pefil dorado L','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03726','FRAGUAS CHEMA','NIU','CHEMA',8.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03727','porcelanato azul 60x60','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03728','piso porcelanato mate','MTK','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03729','pegamento blanco extrafuerte','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03730','fraguas','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03731','decorado de baño','NIU','GENÉRICO',14.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03732','porcelanato azul','NIU','GENÉRICO',12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03733','porcelanato de 60x60','MTK','GENÉRICO',19,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03734','mayolica pared 30x60','BX','GENÉRICO',30.06,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03735','fragua','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03736','perfil','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03737','porcelanato de 60x60 azul blu','BX','GENÉRICO',49,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03738','porcelanato mate 60x60','BX','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03739','pegamento blanco','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03740','medio baño eco','NIU','GENÉRICO',320,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03741','fraguas','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03742','PISOS CERAMICAS DE 60X60','NIU','GENÉRICO',34.2,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03743','GRANITO 1.20 X 60','NIU','GENÉRICO',13,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03744','PGRELIMA. B. E FUERTE ECO','NIU','GENÉRICO',25,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03745','PORCELANATO 60 X 60','MTR','GENÉRICO',41.76,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03746','CREAMICA 60 X 60','MTR','GENÉRICO',33.3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03747','FRAGUA GRIS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03748','FRAGUA HUESO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03749','GRANITO 1.20 X 60','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03750','PORCELANATO MARRON MATE','MTK','GENÉRICO',29.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03751','PEGAMENTO BLANCO','NIU','GENÉRICO',46,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03752','FRAGUA','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03753','PORCELANATO','MTK','GENÉRICO',33.12,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03754','PEGAMENTO','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03755','FRAGUA','NIU','GENÉRICO',9,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03756','porcelanato hueso 60x60','BX','GENÉRICO',34.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03757','pegamento celima','NIU','CELIMA',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03758','inodoro onepiz blanco','NIU','ONEPIZ',295,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03759','vanitorios baño blanco','NIU','GENÉRICO',350,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03760','anillo cera','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03761','tubos de abasto','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03762','trampa botella trebol','NIU','TREBOL',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03763','llaves para vanitorio','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03764','piso de 60x60','BX','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03765','tapas inteligente de inodoro','NIU','GENÉRICO',22.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03766','PORCELANATO','NIU','GENÉRICO',38,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03767','PEGAMENTO','NIU','GENÉRICO',48,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03768','FRAGUA','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03769','CAJA DE PISO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03770','CAJAS DE PARED','MTK','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03771','INODORO','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03772','FRAGUA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03773','PEGAMENTO CELIMA B.E.F','NIU','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03774','NIVELADOR DE 1 MM','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03775','TAPA DE INODORO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03776','CAJA DE PISO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03777','CAJA DE PARED','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03778','PEGAMENTO CELIMA B.E.F','NIU','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03779','FRAGUAS','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03780','INODORO','NIU','GENÉRICO',220,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03781','NIVELADOR DE 1MM','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03782','TAPA DE INODORO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03783','VARIYA PVC GRIS PLATA','NIU','GENÉRICO',3,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03784','TABLON','NIU','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03785','FRAGUAS DE MADERA','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03786','FRAGUA','NIU','GENÉRICO',8,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03787','PAQUETE DE CRUCETAS','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03788','BOLSA DE NIVELADORES','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03789','TACOS CHICOS','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03790','CAJAS 60 X 60','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03791','CAJAS 60 X 60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03792','CAJA 60 X 60','MTK','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03793','CAJAS DE TABLON','MTK','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03794','CAJAS DE TABLONES','NIU','GENÉRICO',34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03795','OVALIN','NIU','GENÉRICO',100,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03796','LLAVE','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03797','TRAMPA DESAGUE','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03798','TUBOS DE ABASTO','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03799','ANILLO DE CERA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03800','JUEGO DE UÑAS','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03801','LLAVE DE DUCHA','NIU','GENÉRICO',120,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03802','INODORO','NIU','GENÉRICO',190,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03803','LAPIZ','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03804','LAVANDERIA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03805','PEGAMENTO CELIMA','NIU','CELIMA',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03806','RODOPLAS','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03807','DECORADOS','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03808','LAPIZ','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03809','PARED','NIU','GENÉRICO',43,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03810','PISO','NIU','GENÉRICO',1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03811','PISO','NIU','GENÉRICO',2.7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03812','LAPIZ','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03813','PERFIL','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03814','PEGAMENTO','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03815','FRAGUA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03816','PISO','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03817','PARED','NIU','GENÉRICO',32.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03818','DISTELO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03819','LAPIZ','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03820','PISO','NIU','GENÉRICO',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03821','MESA','NIU','GENÉRICO',3.6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03822','RODOPLAS','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03823','PEGAMENTO','NIU','GENÉRICO',28,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03824','FRAGUA','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03825','PORCELANATO','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03826','PEGAMENTO BLANCO','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03827','HUESO 60 X 60','NIU','GENÉRICO',18,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03828','PEGAMENTO','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03829','FRAGUA HUESO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03830','PORCELANATO NEGRO','NIU','GENÉRICO',32,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03831','PEGAMENTO B. TREBOL','NIU','TREBOL',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03832','FRAGUA NEGRO','NIU','GENÉRICO',7,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03833','PORCELANATO','NIU','GENÉRICO',70,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03834','PEGAMENTO BLANCO','NIU','GENÉRICO',45,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03835','PERFIL 9.5','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03836','PEGAMENTO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03837','TABLON','MTK','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03838','TABLON','NIU','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03839','PEGAMENTO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03840','PERFILES','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03841','FRAGUA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03842','TABLONES','NIU','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03843','TABLONES','NIU','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03844','TABLONES','NIU','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03845','PEGAMENTO','NIU','GENÉRICO',40,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03846','PERFILES','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03847','FRAGUA','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03848','NIVELADORES','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03849','CUÑA','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03850','NIVELADORES','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03851','CAJAS DE 43.20M PARA SALA','NIU','GENÉRICO',32.4,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03852','CAJAS DE 44.64M PARA CUARTO','NIU','GENÉRICO',35.34,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03853','CAJAS 23.40 PARA PASADIZO','NIU','GENÉRICO',35.1,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03854','PEGAMENTO GRIS PEGABAL','NIU','GENÉRICO',14,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03855','FRAGUA CREMA','NIU','GENÉRICO',5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03856','PIESA 30 X 60','NIU','GENÉRICO',77,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03857','PARED','NIU','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03858','PISO','NIU','GENÉRICO',24.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03859','REPUESTOS','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03860','PERFIL ALUMINIO','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03861','PEGAMENTO BLANCO CELIMA','NIU','CELIMA',35,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03862','16M CREMA','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03863','10M LAPICERO','NIU','GENÉRICO',22,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03864','27M CREMA 30 X 60','NIU','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03865','7M LAPICE','NIU','GENÉRICO',30.5,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03866','decorados de 1.20','NIU','GENÉRICO',77,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03867','decorados ceramicas','NIU','GENÉRICO',77,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03868','decorados de porcelanato de 1.20','NIU','GENÉRICO',77,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03869','pegamento celima gris','NIU','CELIMA',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03870','repuesto nivelador de 1mm o/ancha','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03871','medio baños trebol blanco','NIU','TREBOL',400,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03872','pegamento blanco extrafuerte','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03873','perfiles aluminio','NIU','GENÉRICO',15,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03874','fraguas celeste pisina','NIU','GENÉRICO',75,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03875','pegamentos extrafuerte','NIU','GENÉRICO',30,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03876','ceramicas1.20','NIU','GENÉRICO',20,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03877','lavadero eco','NIU','GENÉRICO',150,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03878','fraguas','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03879','nivelador','NIU','GENÉRICO',10,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03880','fragua','NIU','GENÉRICO',6,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03881','cantoneras aluminio','NIU','GENÉRICO',60,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03882','baño bone talia','NIU','GENÉRICO',800,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03883','kit de acsesorios de instalacion','NIU','GENÉRICO',300,NULL,'HABILITADO');
INSERT INTO PRODUCTOS(codigo_interno,descripcion,unidad_medida,marca,precio,categoria,estado)
VALUES ('03884','perfil dorados','NIU','GENÉRICO',10,NULL,'HABILITADO');
COMMIT TRANSACTION;
GO

USE CERAMICAS_VALE
GO
SET NOCOUNT ON
GO

DELETE FROM DETALLE_VENTAS
DELETE FROM VENTAS
DELETE FROM CLIENTES
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ('CLIENTES', RESEED, 0)
UPDATE PRODUCTOS SET id_proveedor = NULL
DELETE FROM PROVEEDORES
if @@ROWCOUNT <> 0
	DBCC CHECKIDENT ('PROVEEDORES', RESEED, 0)
GO

insert into PROVEEDORES (ruc, razon_social, telefono, ciudad)
select '20' + RIGHT('000000000' + CAST(ABS(CHECKSUM(HASHBYTES('MD5', marca))) % 1000000000 AS varchar(9)), 9),
       'DISTRIBUIDORA ' + marca + ' S.A.C.',
       '01' + RIGHT('0000000' + CAST(ABS(CHECKSUM(HASHBYTES('MD5', 'tel' + marca))) % 10000000 AS varchar(7)), 7),
       CASE ABS(CHECKSUM(HASHBYTES('MD5', 'ciu' + marca))) % 10
            WHEN 0 THEN ' lima ' WHEN 1 THEN NULL WHEN 2 THEN 'CALLAO' ELSE 'LIMA' END
from (select distinct marca from PRODUCTOS where marca <> 'GENÉRICO') m
order by marca
go

insert into PROVEEDORES (ruc, razon_social, telefono, ciudad) values
('20601234561', 'IMPORTADORA ANDINA DE ACABADOS S.A.C.', '015284410', 'LIMA'),
('20605678912', 'DISTRIBUIDORA DEL NORTE E.I.R.L.',      '015471236', 'LIMA'),
('20609876543', 'comercial los olivos s.r.l.',            NULL,        'lima'),
('20603456789', 'IMPORT ASIA CERAMICS S.A.C.',            '017789012', 'CALLAO')
go

update P set id_proveedor = ISNULL(PV.id_proveedor, G.id_proveedor)
from PRODUCTOS P
left join PROVEEDORES PV on PV.razon_social = 'DISTRIBUIDORA ' + P.marca + ' S.A.C.'
cross apply (select id_proveedor
             from (select id_proveedor, ROW_NUMBER() over (order by id_proveedor) - 1 rn
                   from PROVEEDORES where razon_social not like 'DISTRIBUIDORA % S.A.C.') x
             where x.rn = ABS(CHECKSUM(HASHBYTES('MD5', P.codigo_interno))) % 4) G
go

update PRODUCTOS set m2_por_caja =
    CASE WHEN PATINDEX('%([0-9].[0-9][0-9]%', descripcion) > 0
              THEN TRY_CAST(SUBSTRING(descripcion, PATINDEX('%([0-9].[0-9][0-9]%', descripcion) + 1, 4) AS decimal(6,2))
         WHEN descripcion LIKE '%60X60%' THEN 1.44
         WHEN descripcion LIKE '%30X60%' THEN 1.62
         WHEN descripcion LIKE '%45X45%' THEN 2.03
         WHEN descripcion LIKE '%25X40%' THEN 1.50
         WHEN descripcion LIKE '%27X45%' THEN 1.58
         WHEN descripcion LIKE '%20X60%' THEN 1.44
         WHEN descripcion LIKE '%30X30%' THEN 1.80
         ELSE 1.50 END
where unidad_medida in ('MTK', 'BX')
go

update PRODUCTOS set
    costo_unitario = ROUND(precio * (0.60 + (ABS(CHECKSUM(HASHBYTES('MD5', 'cos' + codigo_interno))) % 16) / 100.0), 2),
    stock_minimo   = 10 + ABS(CHECKSUM(HASHBYTES('MD5', 'min' + codigo_interno))) % 31,
    stock_actual   = ABS(CHECKSUM(HASHBYTES('MD5', 'stk' + codigo_interno))) % 220
go

insert into CLIENTES (tipo_documento, nro_documento, nombre, distrito)
values ('DNI', '00000000', 'CLIENTES VARIOS', 'PUENTE PIEDRA')
go

declare @nombres table (i int, v varchar(30))
insert into @nombres values (0,'JORGE'),(1,'MARIA'),(2,'LUIS'),(3,'ROSA'),(4,'CARLOS'),(5,'ANA'),(6,'JOSE'),(7,'CARMEN'),
 (8,'MIGUEL'),(9,'LUCIA'),(10,'PEDRO'),(11,'ELENA'),(12,'JUAN'),(13,'PATRICIA'),(14,'VICTOR'),(15,'SONIA'),
 (16,'RAUL'),(17,'GLADYS'),(18,'CESAR'),(19,'MILAGROS')
declare @apellidos table (i int, v varchar(30))
insert into @apellidos values (0,'QUISPE'),(1,'FLORES'),(2,'RAMOS'),(3,'HUAMAN'),(4,'MENDOZA'),(5,'TORRES'),(6,'ROJAS'),
 (7,'CHAVEZ'),(8,'VARGAS'),(9,'CASTILLO'),(10,'SALAZAR'),(11,'GUTIERREZ'),(12,'ESPINOZA'),(13,'PAREDES'),
 (14,'CONDORI'),(15,'MAMANI'),(16,'VEGA'),(17,'SANCHEZ'),(18,'ORTIZ'),(19,'CRUZ')
declare @prefijos table (i int, v varchar(30))
insert into @prefijos values (0,'CONSTRUCTORA'),(1,'INVERSIONES'),(2,'CORPORACION'),(3,'SERVICIOS GENERALES'),
 (4,'ACABADOS'),(5,'INMOBILIARIA'),(6,'MULTISERVICIOS'),(7,'GRUPO')
declare @nucleos table (i int, v varchar(30))
insert into @nucleos values (0,'SAN JUAN'),(1,'LOS ANDES'),(2,'EL PROGRESO'),(3,'NUEVA ERA'),(4,'SANTA ROSA'),(5,'HORIZONTE'),
 (6,'PACIFICO'),(7,'LOS PINOS'),(8,'VIRGEN DEL CARMEN'),(9,'EL SOL'),(10,'NORTE CHICO'),(11,'MI CASA'),
 (12,'ROCA FUERTE'),(13,'LA ESPERANZA'),(14,'ALTO PERU'),(15,'SAN MARTIN'),(16,'VILLA NORTE'),(17,'DIAMANTE'),
 (18,'EL MAESTRO'),(19,'CHAVIN')
declare @sufijos table (i int, v varchar(10))
insert into @sufijos values (0,'S.A.C.'),(1,'E.I.R.L.'),(2,'S.R.L.')
declare @distritos table (i int, v varchar(30))
insert into @distritos values (0,'PUENTE PIEDRA'),(1,'LOS OLIVOS'),(2,'COMAS'),(3,'CARABAYLLO'),(4,'SAN MARTIN DE PORRES'),
 (5,'INDEPENDENCIA'),(6,'ANCON'),(7,'SANTA ROSA'),(8,'VENTANILLA'),(9,'CALLAO'),(10,'LIMA'),(11,'SAN JUAN DE LURIGANCHO')

;with n as (select top (399) ROW_NUMBER() over (order by (select null)) + 1 n from sys.all_objects),
h as (select n,
             ABS(CHECKSUM(HASHBYTES('MD5', CONCAT('cli|', n)))) h1,
             ABS(CHECKSUM(HASHBYTES('MD5', CONCAT('cl2|', n)))) h2
      from n),
c as (
  select h.n,
         case when h.n % 3 = 0 then 'RUC' else 'DNI' end tipo,
         case when h.n % 3 = 0
              then '20' + RIGHT('000000000' + CAST(h.h1 % 1000000000 AS varchar(9)), 9)
              else RIGHT('0' + CAST(10000000 + h.h1 % 89999999 AS varchar(8)), 8) end doc,
         case when h.n % 3 = 0
              then pf.v + ' ' + nu.v + ' ' + sf.v
              else a1.v + ' ' + a2.v + ' ' + nm.v end nombre,
         ds.v distrito
  from h
  join @nombres   nm on nm.i = h.h1 % 20
  join @apellidos a1 on a1.i = h.h2 % 20
  join @apellidos a2 on a2.i = (h.h1 / 20) % 20
  join @prefijos  pf on pf.i = h.h2 % 8
  join @nucleos   nu on nu.i = (h.h1 / 7) % 20
  join @sufijos   sf on sf.i = (h.h2 / 11) % 3
  join @distritos ds on ds.i = (h.h1 / 13) % 12
)
insert into CLIENTES (tipo_documento, nro_documento, nombre, distrito)
select tipo, doc,
       case when n % 17 = 0 then LOWER(REPLACE(nombre, ' ', '  ')) else nombre end,
       case when n % 23 = 0 then NULL
            when n % 29 = 0 then '  ' + LOWER(distrito)
            else distrito end
from c
order by n
go

select (select count(*) from PROVEEDORES) proveedores,
       (select count(*) from PRODUCTOS where id_proveedor is not null) productos_con_proveedor,
       (select count(*) from PRODUCTOS where m2_por_caja is not null) productos_con_m2,
       (select count(*) from CLIENTES) clientes
go

USE CERAMICAS_VALE
GO

-- Uso: EXEC sp_generar_ventas @num_ventas = 10000, @semilla = 2026
-- Incluye a propósito comprobantes ANULADOS (~2 %) y líneas con precio 0 para probar la calidad del ETL
IF OBJECT_ID('dbo.sp_generar_ventas') IS NOT NULL
    DROP PROCEDURE dbo.sp_generar_ventas
GO

CREATE PROCEDURE dbo.sp_generar_ventas
    @num_ventas int  = 10000,
    @semilla    int  = 2026,
    @fecha_ini  date = '2024-01-01',
    @fecha_fin  date = '2026-10-19'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @dias int = DATEDIFF(DAY, @fecha_ini, @fecha_fin) + 1;

    DELETE FROM DETALLE_VENTAS;
    DELETE FROM VENTAS;

    SELECT ROW_NUMBER() OVER (ORDER BY ABS(CHECKSUM(HASHBYTES('MD5', CONCAT(@semilla, '|p|', codigo_interno)))) % 1000
                                       - CASE WHEN unidad_medida = 'MTK' THEN 350 ELSE 0 END,
                                       codigo_interno) rn,
           codigo_interno, unidad_medida, precio, m2_por_caja
    INTO #prod
    FROM PRODUCTOS
    WHERE precio > 1 AND estado = 'HABILITADO';
    DECLARE @np int = @@ROWCOUNT;

    DECLARE @id_varios int = (SELECT id_cliente FROM CLIENTES WHERE nro_documento = '00000000');

    SELECT ROW_NUMBER() OVER (ORDER BY ABS(CHECKSUM(HASHBYTES('MD5', CONCAT(@semilla, '|c|', id_cliente)))), id_cliente) rn,
           id_cliente, tipo_documento
    INTO #cli
    FROM CLIENTES WHERE id_cliente <> @id_varios;
    DECLARE @nc int = @@ROWCOUNT;

    ;WITH n AS (
        SELECT TOP (@num_ventas) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
        FROM sys.all_objects a CROSS JOIN sys.all_objects b CROSS JOIN sys.all_objects c)
    SELECT n,
           ABS(CHECKSUM(HASHBYTES('MD5', CONCAT(@semilla, '|v|', n)))) h1,
           ABS(CHECKSUM(HASHBYTES('MD5', CONCAT(@semilla, '|w|', n)))) h2
    INTO #v FROM n
    OPTION (MAX_GRANT_PERCENT = 10);

    INSERT INTO VENTAS (id_venta, tipo_comprobante, fecha, id_cliente, estado)
    SELECT v.n,
           CASE WHEN c.tipo_documento = 'RUC' THEN 'FACTURA' ELSE 'BOLETA' END,
           DATEADD(MINUTE, (v.h2 / 11) % 60,
             DATEADD(HOUR, 8 + v.h2 % 11,
               CAST(DATEADD(DAY, FLOOR(@dias * POWER((v.h1 / 7 % 100000) / 100000.0, 0.8)), @fecha_ini) AS datetime))),
           ISNULL(c.id_cliente, @id_varios),
           CASE WHEN v.h1 % 50 = 0 THEN 'ANULADO' ELSE 'EMITIDO' END
    FROM #v v
    LEFT JOIN #cli c
           ON v.h1 % 100 >= 30
          AND c.rn = 1 + FLOOR(@nc * POWER((v.h2 % 100000) / 100000.0, 1.8))
    OPTION (MAX_GRANT_PERCENT = 10);

    UPDATE VENTAS SET fecha = DATEADD(DAY, -1, fecha)
    WHERE DATEDIFF(DAY, '19000101', fecha) % 7 = 6 AND id_venta % 3 <> 0;

    ;WITH s AS (
        SELECT serie_numero, tipo_comprobante,
               ROW_NUMBER() OVER (PARTITION BY tipo_comprobante ORDER BY fecha, id_venta) corr
        FROM VENTAS)
    UPDATE s SET serie_numero = CASE tipo_comprobante WHEN 'FACTURA' THEN 'FE01-' ELSE 'BE01-' END
                                + RIGHT('000000' + CAST(corr AS varchar(6)), 6)
    OPTION (MAX_GRANT_PERCENT = 10);

    ;WITH l AS (
        SELECT v.n, k.k,
               ABS(CHECKSUM(HASHBYTES('MD5', CONCAT(@semilla, '|d|', v.n, '|', k.k)))) h
        FROM #v v
        CROSS JOIN (VALUES (1), (2), (3), (4)) k(k)
        WHERE k.k <= 1 + v.h2 % 4)
    INSERT INTO DETALLE_VENTAS (id_venta, item, codigo_interno, cantidad, precio_unitario, descuento_pct)
    SELECT l.n, l.k, p.codigo_interno,
           CASE p.unidad_medida
                WHEN 'MTK' THEN (1 + (l.h / 100000) % 30) * ISNULL(p.m2_por_caja, 1.50)
                WHEN 'BX'  THEN 1 + (l.h / 100000) % 20
                WHEN 'MTR' THEN 1 + (l.h / 100000) % 15
                ELSE CASE WHEN p.precio >= 100 THEN 1 + (l.h / 100000) % 3
                          ELSE 1 + (l.h / 100000) % 12 END
           END,
           CASE WHEN l.h % 2500 = 0 THEN 0 ELSE p.precio END,
           CASE WHEN (l.h / 1000) % 10 = 0 THEN 0.05
                WHEN (l.h / 1000) % 25 = 1 THEN 0.10 ELSE 0 END
    FROM l
    JOIN #prod p ON p.rn = 1 + FLOOR(@np * POWER((l.h % 100000) / 100000.0, 2.5))
    OPTION (MAX_GRANT_PERCENT = 10);

    UPDATE V SET total = D.total
    FROM VENTAS V
    JOIN (SELECT id_venta, SUM(cantidad * precio_unitario * (1 - descuento_pct)) total
          FROM DETALLE_VENTAS GROUP BY id_venta) D ON D.id_venta = V.id_venta;

    SELECT COUNT(*) ventas,
           SUM(CASE WHEN estado = 'ANULADO' THEN 1 ELSE 0 END) anuladas,
           (SELECT COUNT(*) FROM DETALLE_VENTAS) lineas_detalle,
           MIN(fecha) desde, MAX(fecha) hasta, SUM(total) total_soles
    FROM VENTAS;
END
GO

-- Exportación de caja (comprobante | método de pago) para generar operacionVenta.txt.
-- Trae a propósito comprobantes sin pago, duplicados y el método 9, que no existe
CREATE VIEW dbo.vw_export_pagos_caja
AS
SELECT serie_numero comprobante,
       CASE WHEN id_venta % 997 = 0 THEN 9
            ELSE CASE WHEN h % 100 < 35 THEN 1
                      WHEN h % 100 < 65 THEN 2
                      WHEN h % 100 < 80 THEN 3
                      WHEN h % 100 < 95 THEN 4
                      ELSE 5 END
       END metodoPago
FROM (SELECT id_venta, serie_numero, ABS(CHECKSUM(HASHBYTES('MD5', CONCAT('pago|', id_venta)))) h
      FROM dbo.VENTAS) v
WHERE id_venta % 211 <> 0
UNION ALL
SELECT serie_numero, 1 + id_venta % 5
FROM dbo.VENTAS WHERE id_venta % 1499 = 0
GO

EXEC sp_generar_ventas @num_ventas = 100000, @semilla = 2026
GO
