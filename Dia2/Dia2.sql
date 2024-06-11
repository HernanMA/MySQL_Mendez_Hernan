-- #####################
-- ### DIA # 2 - Comandos Generales ###
-- #####################

-- Comando general para revisión de bases de datos creadas
show databases;

-- Crear base de datos

create database dia2;

-- Utilizar BBDD dia2

use dia2;

-- Crear tabla departamento
create table departamento (
    id int auto_increment primary key,
    nombre varchar(50) not null
);

-- Crear tabla persona
create table persona(
    id int auto_increment primary key,
    nif varchar(9),
    nombre varchar(25) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar (50),
    ciudad varchar(25) not null,
    direccion varchar(50) not null,
    telefono varchar(9),
    fecha_nacimiento DATE not null,
    sexo enum('H','M') not null,
    tipo enum('profesor','alumno') not null
);

-- Crear la tabla de profesor
create table profesor(
    id_profesor int primary key,
    id_departamento int not null,
    foreign key (id_profesor) references persona(id),
    foreign key (id_departamento) references departamento(id)
);

-- Crear tabla de curso escolar
create table curso (
	id_curso int primary key,
    año_inicio year(4) not null,
    año_fin year(4) not null
    );

-- Crear tabla de grado
create table grado (
	id_grado int primary key,
    nombre varchar (100) not null
);

-- Crear la tabla asignatura
create table asignatura (
	id_asignatura int primary key,
    nombre varchar (100) not null,
    creditos float not null,
    id_grado int(10) not null,
    tipo enum ('basica','obligatoria','optativa') not null,
    curso tinyint (3) not null,
    cuatrimestre tinyint (10) not null,
    foreign key (id_asignatura) references profesor(id_profesor),
    foreign key (id_grado) references grado(id_grado)
);

-- Crear tabla alumno se matricula en asignatura
create table matricula (
	id_alumno int primary key,
    id_asignatura int (10) not null,
    id_curso int (10) not null,
    foreign key (id_alumno) references persona(id),
    foreign key (id_asignatura) references asignatura(id_asignatura),
    foreign key (id_curso) references curso(id_curso)
);



select * from grado;

show tables;



-- Desarrollado por Hernan Mendez / 1101685607