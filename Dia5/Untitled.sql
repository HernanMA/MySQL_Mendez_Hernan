show databases;

create database dia5;

use dia5;

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
    codigo_cliente_pedido int(11) not null,
    foreign key (codigo_cliente_pedido) references cliente(codigo_cliente)
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
	cliente_codigo int(11) not null,
    forma_pago varchar(40) not null,
    id_transaccion varchar(50) primary key,
    fecha_pago date not null,
    total decimal(15,2) not null,
    foreign key (cliente_codigo) references cliente(codigo_cliente)
);

show tables;

-- Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
select codigo_oficina, ciudad 
from oficina;

-- Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
select ciudad, telefono 
from oficina 
where pais = "España";

-- Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
select nombre, apellido1, apellido2, email, codigo_jefe
from empleado 
where codigo_jefe = 7;

-- Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
select puesto, nombre, apellido1, apellido2, email 
from empleado 
where codigo_empleado = 1;

-- Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
select nombre, apellido1, apellido2, puesto 
from empleado 
where puesto != "Representante Ventas";

-- Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente, pais 
from cliente 
where pais = "Spain";

-- Devuelve un listado con los distintos estados por los que puede pasar un pedido.
select distinct estado 
from pedido;

-- Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
-- Utilizando la función YEAR de MySQL.
-- Utilizando la función DATE_FORMAT de MySQL.
-- Sin utilizar ninguna de las funciones anteriores.
select distinct cliente_codigo from pago where year(fecha_pago) = 2008;
select distinct cliente_codigo from pago where date_format(fecha_pago, "%Y") = "2008";
select distinct cliente_codigo from pago where fecha_pago between "2008-01-01" AND "2008-12-31";

-- Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega, estado from pedido where fecha_entrega > fecha_esperada;

-- Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- Utilizando la función ADDDATE de MySQL.
-- Utilizando la función DATEDIFF de MySQL.
-- ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?
select codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega from pedido where fecha_entrega <= adddate(fecha_esperada, interval -2 day);
select codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega from pedido where datediff(fecha_esperada, fecha_entrega) >= 2;
select codigo_pedido, codigo_cliente_pedido, fecha_esperada, fecha_entrega from pedido where fecha_esperada - interval 2 day >= fecha_entrega;

-- Devuelve un listado de todos los pedidos que fueron en 2009.
select codigo_pedido, fecha_entrega 
from pedido 
where year(fecha_entrega) = 2009;

-- Devuelve un listado de todos los pedidos que han sido  en el mes de enero de cualquier año.
select codigo_pedido, fecha_entrega 
from pedido 
where month(fecha_entrega) = 1;

-- Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
select fecha_pago, forma_pago, total 
from pago 
where forma_pago = "PayPal" order by total desc;

-- Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.
select distinct forma_pago 
from pago;

-- Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
select gama, precio_venta, cantidad_en_stock 
from producto 
where gama = "Ornamentales" and cantidad_en_stock >= 100 order by precio_venta desc;

-- Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.
select codigo_cliente, nombre_cliente, ciudad 
from cliente 
where ciudad = "Madrid" and codigo_empleado_rep_ventas in (11, 30);

-- ####### Consultas multitabla (Composición interna) #######
-- Resuelva todas las consultas mediante INNER JOIN y NATURAL JOIN.
-- ###################################################################
-- Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
select nombre_cliente, nombre, apellido1, puesto
from cliente
inner join empleado 
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

-- Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
select codigo_cliente, nombre_cliente, fecha_pago, total, nombre, apellido1, puesto
from pago 
inner join cliente
on pago.cliente_codigo = cliente.codigo_cliente
inner join empleado 
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;


-- Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.


-- Devuelve el nombre de los clientes que  hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.


-- Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.


-- Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.


-- Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.


-- Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.


-- Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.



-- Desarrollado por Hernan Mendez  /    1101685607