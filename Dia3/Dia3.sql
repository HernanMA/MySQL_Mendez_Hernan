-- #####################
-- ### DIA # 3 - Jardinería ###
-- #####################

show databases;

create database dia3;

use dia3;

create table gama_producto (
	gama varchar(50) primary key,
    descripcion_texto text null,
    descripcion_html text null,
    imagen varchar(256) null
);

create table producto (
	codigo_producto varchar(15) primary key,
    nombre varchar(70) not null,
    gama  varchar(50) not null,
    foreign key (gama) references gama_producto(gama),
    dimensiones varchar(25) null,
    proveedor varchar(50),
    descripcion text null,
    cantidad_en_stock smallint(6) not null,
    precio_venta decimal(15,2) not null,
    precio_proveedor decimal(15,2) null
);

create table cliente (
	codigo_cliente int(11) primary key,
    nombre_cliente varchar(50) not null,
    nombre_contacto varchar(30) null,
    apellido_contacto varchar(30) null,
    telefono varchar(15) not null,
    fax varchar(15) not null,
    linea_direccion1 varchar(50) not null,
    linea_direccion2 varchar(50) null,
    ciudad varchar(50) not null,
    region varchar(50) null,
    pais varchar(50) null,
    codigo_postal varchar(10) null,
    codigo_empleado_rep_ventas int(11) null,
    foreign key (codigo_empleado_rep_ventas) references empleado(codigo_empleado),
    limite_credito decimal (15,2) null
);

create table pedido (
	codigo_pedido int(11) primary key,
    fecha_pedido date not null,
    fecha_esperada date not null,
    fecha_entrega date null,
    estado varchar(15) not null,
    comentarios text null,
    codigo_cliente int(11) not null,
    foreign key (codigo_cliente) references cliente(codigo_cliente)
);

create table detalle_pedido (
	codigo_pedido int(11) not null,
    codigo_producto varchar(15) not null,
    foreign key (codigo_pedido) references pedido(codigo_pedido),
    foreign key (codigo_producto) references producto(codigo_producto),
    cantidad int(11) not null,
    precio_unidad decimal(15,2) not null,
    numero_linea smallint(6)
);

create table pago (
	codigo_cliente int(11) not null,
    forma_pago varchar(40) not null,
    id_transaccion varchar(50) primary key,
    fecha_pago date not null,
    total decimal(15,2) not null
);

create table oficina (
	codigo_oficina varchar(10) primary key,
    ciudad varchar(30) not null,
    pais varchar(50) not null,
    region varchar(50) null,
    codigo_postal varchar(10) not null,
    telefono varchar(20) not null,
    linea_direccion1 varchar(50) not null,
    linea_direccion2 varchar(50) null
);

create table empleado (
	codigo_empleado int(11) primary key,
    nombre varchar(50) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar(50) null,
    extension varchar(10) not null,
    email varchar(100) not null,
    codigo_oficina varchar(10) not null,
    foreign key (codigo_oficina) references oficina(codigo_oficina),
    codigo_jefe int(11) null,
    foreign key (codigo_jefe) references empleado(codigo_empleado),
    puesto varchar(50) null
);

show tables;

-- Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
select codigo_oficina, ciudad from oficina;

-- Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
select ciudad, telefono from oficina where pais = "España";

-- Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
select nombre, apellido1, apellido2, email from empleado where codigo_jefe = 7;

-- Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
select puesto, nombre, apellido1, apellido2, email from empleado where codigo_empleado = 1;

-- Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
select nombre, apellido1, apellido2, puesto from empleado where puesto != "Representante Ventas";

-- Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente, pais from cliente where pais = "Spain";

-- Devuelve un listado con los distintos estados por los que puede pasar un pedido.
select estado from pedido;

-- Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
-- Utilizando la función YEAR de MySQL.
-- Utilizando la función DATE_FORMAT de MySQL.
-- Sin utilizar ninguna de las funciones anteriores.
select codigo_cliente, nombre_cliente





-- Desarrollado por Hernan Mendez  /    1101685607