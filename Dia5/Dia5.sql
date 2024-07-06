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
    total decimal(15,2) not null,
    foreign key (codigo_cliente) references cliente(codigo_cliente)
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
select distinct codigo_cliente from pago where year(fecha_pago) = 2008;
select distinct codigo_cliente from pago where date_format(fecha_pago, "%Y") = "2008";
select distinct codigo_cliente from pago where fecha_pago between "2008-01-01" AND "2008-12-31";

-- Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega, estado from pedido where fecha_entrega > fecha_esperada;

-- Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- Utilizando la función ADDDATE de MySQL.
-- Utilizando la función DATEDIFF de MySQL.
-- ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_entrega <= adddate(fecha_esperada, interval -2 day);
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where datediff(fecha_esperada, fecha_entrega) >= 2;
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_esperada - interval 2 day >= fecha_entrega;

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
select cliente.codigo_cliente, cliente.nombre_cliente, empleado.nombre, empleado.apellido1,	 empleado.puesto
from cliente
inner join empleado 
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

-- Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
select distinct cliente.nombre_cliente, empleado.nombre, empleado.apellido1, apellido2 
from cliente
inner join pago
on cliente.codigo_cliente = cliente.codigo_cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

-- Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
select distinct cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2, oficina.ciudad
from cliente
inner join pago
on cliente.codigo_cliente = cliente.codigo_cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina 
on empleado.codigo_oficina = oficina.codigo_oficina;

-- Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
select distinct cliente.ciudad, oficina.ciudad, oficina.linea_direccion1, oficina.linea_direccion2
from cliente
inner join empleado
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina 
on empleado.codigo_oficina = oficina.codigo_oficina
where cliente.ciudad = 'Fuenlabrada';

-- Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
select distinct cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.puesto, oficina.ciudad
from cliente
inner join empleado 
on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina 
on empleado.codigo_oficina = oficina.codigo_oficina;

-- Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
select empleado.nombre, empleado_jefe.nombre
from empleado 
inner join  empleado empleado_jefe
on empleado.codigo_jefe = empleado_jefe.codigo_empleado;

-- Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.
select empleado.nombre, jefe1.nombre, jefe2.nombre
from empleado
inner join empleado jefe1
on empleado.codigo_empleado = jefe1.codigo_empleado
inner join empleado jefe2 
on empleado.codigo_empleado = jefe2.codigo_empleado;

-- Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
select cliente.nombre_cliente, pedido.fecha_esperada, pedido.fecha_entrega
from cliente
inner join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
where fecha_entrega > fecha_esperada;

-- Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
select distinct cliente.nombre_cliente, pedido.codigo_pedido, detalle_pedido.cantidad, producto.gama
from cliente 
inner join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
inner join detalle_pedido
on pedido.codigo_pedido = detalle_pedido.codigo_pedido
inner join producto
on detalle_pedido.codigo_producto = producto.codigo_producto;

-- ######################################################################################################################################
-- 1 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select cliente.nombre_cliente 
from cliente
left join pago
on cliente.codigo_cliente = pago.codigo_cliente
where pago.codigo_cliente is null;

-- 2 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
select cliente.nombre_cliente 
from cliente
left join pedido
on cliente.codigo_cliente = pedido.codigo_cliente
where pedido.codigo_cliente is null;

-- 3 Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
select cliente.nombre_cliente 
from cliente
left join pedido on cliente.codigo_cliente = pedido.codigo_cliente
left join pago on cliente.codigo_cliente = pago.codigo_cliente
where pago.codigo_cliente is null or pedido.codigo_cliente is null;

-- 4 Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
select cliente.nombre_cliente, empleado.nombre
from cliente
inner join empleado on cliente.codigo_cliente = empleado.codigo_empleado
left join oficina on empleado.codigo_oficina = oficina.codigo_oficina
where empleado.codigo_oficina is null;

-- 5 Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
select cliente.nombre_cliente, empleado.nombre
from cliente
left join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
where cliente.codigo_empleado_rep_ventas is null;

-- 6 Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.
select cliente.nombre_cliente, empleado.nombre, oficina.codigo_oficina
from cliente
left join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
left join oficina on empleado.codigo_oficina = oficina.codigo_oficina
where cliente.codigo_empleado_rep_ventas is null;

-- 7 Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.
select cliente.nombre_cliente, empleado.nombre, oficina.codigo_oficina
from cliente 
left join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
left join oficina on empleado.codigo_oficina = oficina.codigo_oficina
where empleado.codigo_oficina is null and cliente.codigo_empleado_rep_ventas is null;

-- 8 Devuelve un listado de los productos que nunca han aparecido en un pedido.
select distinct producto.nombre
from producto
left join detalle_pedido on producto.codigo_producto = detalle_pedido.codigo_producto
left join pedido on detalle_pedido.codigo_pedido = pedido.codigo_pedido
where detalle_pedido.codigo_producto is null;

-- 9 Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.
select distinct producto.nombre, producto.descripcion, producto.gama, detalle_pedido.codigo_producto
from producto
left join detalle_pedido on producto.codigo_producto = detalle_pedido.codigo_producto
left join pedido on detalle_pedido.codigo_pedido = pedido.codigo_pedido
where detalle_pedido.codigo_producto is null;

-- 10 Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
select oficina.codigo_oficina, empleado.codigo_empleado, empleado.nombre, cliente.nombre_cliente, pedido.codigo_pedido, pedido.estado, producto.gama
from oficina 
left join empleado on oficina.codigo_oficina = empleado.codigo_empleado
left join cliente on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas 
left join pedido on cliente.codigo_cliente = pedido.codigo_pedido 
left join detalle_pedido on pedido.codigo_pedido = detalle_pedido.codigo_pedido 
left join producto on  detalle_pedido.codigo_producto = producto.codigo_producto
where empleado.codigo_oficina is null and producto.gama = 'Frutales';

-- 11 Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
select cliente.nombre_cliente 
from cliente
left join pedido on cliente.codigo_cliente = pedido.codigo_cliente
left join pago on cliente.codigo_cliente = pago.codigo_cliente
where pago.codigo_cliente is null;

-- 12 Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
select empleado.codigo_empleado, empleado.nombre, empleado.apellido1, empleado.apellido2, empleado.email, empleado.codigo_oficina
from cliente 
left join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
where codigo_empleado_rep_ventas is null;

-- #############################################################
-- 1.4.7 Consultas resumen
-- 1 ¿Cuántos empleados hay en la compañía?
select count(codigo_empleado)
from empleado;

-- 2 ¿Cuántos clientes tiene cada país?
select pais, count(*)
from cliente
group by pais
order by pais desc;

-- 3 ¿Cuál fue el pago medio en 2009?
select avg(total)
from pago
where year(fecha_pago) = 2009;

-- 4 ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
select estado, count(*)
from pedido
group by codigo_pedido
order by codigo_pedido desc;

-- 5 Calcula el precio de venta del producto más caro y más barato en una misma consulta.
select max(precio_venta), min(precio_venta)
from producto;

-- 6 Calcula el número de clientes que tiene la empresa.
select count(codigo_cliente)
from cliente;

-- 7 ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?
select ciudad, count(*)
from cliente
where ciudad = 'Madrid';

-- 8 ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
select ciudad, count(*)
from cliente
where ciudad like 'M%'
group by ciudad
order by ciudad desc;

-- 9 Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.
select empleado.nombre, count(cliente.codigo_cliente)
from empleado 
left join cliente on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
group by empleado.nombre
order by empleado.nombre desc;

-- 10 Calcula el número de clientes que no tiene asignado representante de ventas.
select empleado.nombre, count(cliente.codigo_cliente)
from empleado 
left join cliente on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
where cliente.codigo_empleado_rep_ventas is null
group by empleado.nombre
order by empleado.nombre desc;

select count(codigo_cliente)
from cliente 
where cliente.codigo_empleado_rep_ventas is null;

-- 11 Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.
select cliente.nombre_cliente, cliente.apellido_contacto, min(fecha_pago), max(fecha_pago)
from cliente
left join pago on cliente.codigo_cliente = pago.codigo_cliente
group by cliente.nombre_cliente, cliente.apellido_contacto;

-- 12 Calcula el número de productos diferentes que hay en cada uno de los pedidos.
select pedido.codigo_pedido, count(distinct detalle_pedido.codigo_producto) 
from pedido
inner join detalle_pedido on pedido.codigo_pedido = detalle_pedido.codigo_pedido
group by pedido.codigo_pedido;

-- 13 Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.
select pedido.codigo_pedido, sum(distinct detalle_pedido.codigo_producto) 
from pedido
inner join detalle_pedido on pedido.codigo_pedido = detalle_pedido.codigo_pedido
group by pedido.codigo_pedido;

-- 14 Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.
select producto.nombre_producto, sum(detalle_pedido.cantidad) as total_unidades_vendidas
from producto
inner join detalle_pedido on producto.codigo_producto = detalle_pedido.codigo_producto
group by producto.nombre_producto
order by total_unidades_vendidas desc
limit 20;

-- 15 La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.
select 
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) as base_imponible,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 0.21 as iva,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 1.21 as total_facturado
from detalle_pedido;

-- 16 La misma información que en la pregunta anterior, pero agrupada por código de producto.
select 
    detalle_pedido.codigo_producto,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) as base_imponible,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 0.21 as iva,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 1.21 as total_facturado
from detalle_pedido
group by detalle_pedido.codigo_producto;

-- 17 La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.
select 
    detalle_pedido.codigo_producto,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) as base_imponible,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 0.21 as iva,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 1.21 as total_facturado
from detalle_pedido
where detalle_pedido.codigo_producto like 'OR%'
group by detalle_pedido.codigo_producto;

-- 18 Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).
select 
    producto.nombre,
    sum(detalle_pedido.cantidad) as unidades_vendidas,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) as total_facturado,
    sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) * 1.21 as total_facturado_con_iva
from detalle_pedido
inner join producto on detalle_pedido.codigo_producto = producto.codigo_producto
group by producto.nombre
having sum(detalle_pedido.cantidad * detalle_pedido.precio_unidad) > 3000;

-- 19 Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.
select 
    year(pago.fecha_pago) as año,
    sum(pago.total) as suma_total
from pago
group by year(pago.fecha_pago);

-- #############################################################
-- 1.4.8 Subconsultas con operadores básicos de comparación

-- 1 Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente
from cliente
where limite_credito = (select max(limite_credito) from cliente);

-- 2 Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre
from producto
where precio_venta = (select max(precio_venta) from producto);

-- 3 Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido)
select nombre
from producto
where codigo_producto = (select codigo_producto from detalle_pedido group by codigo_producto order by sum(cantidad) desc limit 1);

-- 4 Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
select nombre_cliente
from cliente
where limite_credito > (select sum(total) from pago where cliente.codigo_cliente = pago.codigo_cliente);

-- 5 Devuelve el producto que más unidades tiene en stock.
select nombre
from producto
where cantidad_en_stock = (select max(cantidad_en_stock) from producto);

-- 6 Devuelve el producto que menos unidades tiene en stock.
select nombre
from producto
where cantidad_en_stock = (select min(cantidad_en_stock) from producto);

-- 7 Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
select nombre, apellido1, email
from empleado
where codigo_jefe = (select codigo_empleado from empleado where nombre = 'Alberto' and apellido1 = 'Soria');

-- #############################################################
-- 1.4.8.2 Subconsultas con ALL y ANY

-- 8 Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente
from cliente
where limite_credito = (select max(limite_credito) from cliente);

-- 9 Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre
from producto
where precio_venta = (select max(precio_venta) from producto);

-- 10 Devuelve el producto que menos unidades tiene en stock.
select nombre
from producto
where cantidad_en_stock = (select min(cantidad_en_stock) from producto);

-- #############################################################
-- 1.4.8.3 Subconsultas con IN y NOT IN
-- 11 Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
select nombre, apellido1, puesto
from empleado
where codigo_empleado not in (select codigo_empleado_rep_ventas from cliente where codigo_empleado_rep_ventas is not null);

-- 12 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select nombre_cliente
from cliente
where codigo_cliente not in (select codigo_cliente from pago);

-- 13 Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
select nombre_cliente
from cliente
where codigo_cliente in (select codigo_cliente from pago);

-- 14 Devuelve un listado de los productos que nunca han aparecido en un pedido.
select nombre
from producto
where codigo_producto not in (select codigo_producto from detalle_pedido);

-- 15 Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
select nombre, apellido1, puesto
from empleado
where codigo_empleado not in (select codigo_empleado_rep_ventas from cliente where codigo_empleado_rep_ventas is not null);

-- 16 Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
select distinct oficina.codigo_oficina
from oficina
where oficina.codigo_oficina not in (
    select empleado.codigo_oficina
    from empleado
    where empleado.codigo_empleado in (
        select cliente.codigo_empleado_rep_ventas
        from cliente
        where cliente.codigo_cliente in (
            select pedido.codigo_cliente
            from pedido
            where pedido.codigo_pedido in (
                select detalle_pedido.codigo_pedido
                from detalle_pedido
                where detalle_pedido.codigo_producto in (
                    select producto.codigo_producto
                    from producto
                    where producto.gama = 'Frutales'
                )
            )
        )
    )
);


-- 17 Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
select nombre_cliente
from cliente
where codigo_cliente in (select codigo_cliente from pedido)
and codigo_cliente not in (select codigo_cliente from pago);

-- #############################################################
-- 1.4.8.4 Subconsultas con EXISTS y NOT EXISTS

-- 18 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select nombre_cliente
from cliente
where not exists (select 1 from pago where cliente.codigo_cliente = pago.codigo_cliente);

-- 19 Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
select nombre_cliente
from cliente
where exists (select 1 from pago where cliente.codigo_cliente = pago.codigo_cliente);

-- 20 Devuelve un listado de los productos que nunca han aparecido en un pedido.
select nombre
from producto
where not exists (select 1 from detalle_pedido where producto.codigo_producto = detalle_pedido.codigo_producto);

-- 21 Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
select nombre
from producto
where exists (select 1 from detalle_pedido where producto.codigo_producto = detalle_pedido.codigo_producto);

-- #############################################################
-- 1.4.8.5 Subconsultas correlacionadas
-- 1.4.9 Consultas variadas

-- 1 Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.
select cliente.nombre_cliente, count(pedido.codigo_pedido) as numero_pedidos
from cliente
left join pedido on cliente.codigo_cliente = pedido.codigo_cliente
group by cliente.nombre_cliente;

-- 2 Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.
select cliente.nombre_cliente, sum(pago.total) as total_pagado
from cliente
left join pago on cliente.codigo_cliente = pago.codigo_cliente
group by cliente.nombre_cliente;

-- 3 Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.
select distinct cliente.nombre_cliente
from cliente
inner join pedido on cliente.codigo_cliente = pedido.codigo_cliente
where year(pedido.fecha_pedido) = 2008
order by cliente.nombre_cliente;

-- 4 Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.
select cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.extension
from cliente
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
where cliente.codigo_cliente not in (select codigo_cliente from pago);

-- 5 Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.
select 
    cliente.nombre_cliente, 
    empleado.nombre, 
    empleado.apellido1, 
    oficina.ciudad
from cliente
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina on empleado.codigo_oficina = oficina.codigo_oficina;

-- 6 Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
select 
    empleado.nombre, 
    empleado.apellido1, 
    empleado.apellido2, 
    empleado.puesto, 
    oficina.telefono
from empleado
inner join oficina on empleado.codigo_oficina = oficina.codigo_oficina
where empleado.codigo_empleado not in (select codigo_empleado_rep_ventas from cliente where codigo_empleado_rep_ventas is not null);

-- 7 Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.
select 
    oficina.ciudad, 
    count(empleado.codigo_empleado) 
from oficina
inner join empleado on oficina.codigo_oficina = empleado.codigo_oficina
group by oficina.ciudad;


-- Desarrollado por Hernan Mendez / 1101685607