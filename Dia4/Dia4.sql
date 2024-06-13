show databases;

create database dia4;

use dia4;

create table pais (
	id int primary key,
    nombre varchar(20) null,
	continente varchar(50) null,
    poblacion int
);

create table idioma (
	id int primary key,
    idioma varchar(50) null
);

create table ciudad (
	id int primary key,
    nombre varchar(20) null,
    id_pais int,
    foreign key (id_pais) references pais(id)
);

create table idioma_pais (
	id_idioma int,
    foreign key (id_idioma) references idioma(id),
    id_pais int,
    foreign key (id_pais) references pais(id),
    es_oficial tinyint(1)
);
  
INSERT INTO idioma (id, idioma) VALUES 
(1, 'Español'),
(2, 'Catalán'),
(3, 'Inglés'),
(4, 'Japonés');  
  
INSERT INTO idioma_pais (id_idioma, id_pais, es_oficial) VALUES 
(1, 1, 1), -- Español es oficial en España
(2, 1, 1), -- Catalán es oficial en España
(1, 2, 1), -- Español es oficial en México
(4, 3, 1), -- Japonés es oficial en Japón
(3, 1, 0), -- Inglés no es oficial en España
(3, 2, 0), -- Inglés no es oficial en México
(3, 3, 0); -- Inglés no es oficial en Japón

-- Todos los pares de nombres de paises y sus ciudades
-- correspondientes que están relacionadas
-- en la base de datos (INNER JOIN = COINCIDENCIA EN
-- AMBAS TABLAS, como la intersección de conjuntos).
SELECT pais.nombre as Pais,
ciudad.nombre as Ciudad
from pais -- Pais es un conjunto A
inner join ciudad -- Ciudad es un conjunto B
on pais.id = ciudad.id_pais; -- Interseccion de A y B

-- ######### INGRESO ADICIONAL #########
INSERT INTO ciudad VALUES
(7, 'Ciudad Unknow', Null);
INSERT INTO pais VALUES
(4, 'Italia','Europa', 10000022);

-- Listar todas las ciudades con el nombre de su pais
-- si alguna ciudad no tiene pais asignado, aun aparecera
-- en la lista con null (LEFT JOIN)
SELECT pais.nombre as Pais,
ciudad.nombre as Ciudad
from pais -- Pais es un conjunto A
left join ciudad -- Ciudad es un conjunto B
on pais.id = ciudad.id_pais; -- Interseccion de A y B

-- Mostrar todos los paises y si tienen ciudades asociadas,
-- se muestran junto al nombre del pais. Si no hay ciudades
-- asociadas a un pais, el nombre de la ciudad aparecera
-- como null (RIGHT JOIN)
SELECT pais.nombre as Pais,
ciudad.nombre as Ciudad
from pais -- Pais es un conjunto A
right join ciudad -- Ciudad es un conjunto B
on pais.id = ciudad.id_pais; -- Interseccion de A y B


show tables