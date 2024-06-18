show databases;

create database examen;

use examen;

create table departamento (
	id int(10) primary key,
    nombre varchar(50) not null
);

create table alumno (
	id int(10) primary key,
    nif varchar(9) null,
    nombre varchar(25) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar(50) null,
    ciudad varchar(25) not null,
    direccion varchar(50) not null,
    telefono varchar(9) null,
    fecha_nacimiento date not null,
    sexo enum('H', 'M')
);

create table profesor (
	id int(10) primary key,
    nif varchar(9) null,
    nombre varchar(25) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar(50) null,
    ciudad varchar(25) not null,
    direccion varchar(50) not null,
    telefono varchar(9) null,
    fecha_nacimiento date,
    sexo enum('H', 'M') not null,
    id_departamento int(10) not null,
    foreign key (id_departamento) references departamento(id)
);

create table grado (
	id int(10) primary key,
    nombre varchar(100)
);

create table asignatura (
	id int primary key,
    nombre varchar(100) not null,
    creditos float not null,
    tipo enum('básica', 'obligatoria', 'optativa') not null,
    curso tinyint(3) not null,
    cuatrimestre tinyint(3) not null,
    id_profesor int(10) null,
    foreign key (id_profesor) references profesor(id),
	id_grado int(10) not null,
    foreign key (id_grado) references grado(id)
);

create table curso_escolar (
	id int(10) primary key,
    anyo_inicio year(4) not null,
    anyo_fin year(4) not null
);

create table alumno_se_matricula_asignatura (
	id_alumno int(10) not null,
    foreign key (id_alumno) references alumno(id),
    id_asignatura int(10) not null,
    foreign key (id_asignatura) references asignatura(id),
    id_curso_escolar int(10) not null,
    foreign key (id_curso_escolar) references curso_escolar(id)
);

show tables;

-- ################################################
-- ########### Consultas sobre una tabla ##########
-- ################################################


-- 1. Devuelve un listado con el primer apellido, segundo apellido y el nombre de todos los alumnos. El listado deberá estar ordenado alfabéticamente de menor a mayor por el primer apellido, segundo apellido y nombre.
select apellido1, apellido2, nombre
from alumno
order by apellido1, apellido2, nombre;

-- 2. Averigua el nombre y los dos apellidos de los alumnos que no han dado de alta su número de teléfono en la base de datos.
select apellido1, apellido2, nombre
from alumno
where telefono is null;

-- 3. Devuelve el listado de los alumnos que nacieron en 1999.
select apellido1, apellido2, nombre, fecha_nacimiento
from alumno
where year(fecha_nacimiento) = 1999;

-- 4. Devuelve el listado de profesores que no han dado de alta su número de teléfono en la base de datos y además su nif termina en K.
select nombre, apellido1, apellido2, nif
from profesor
where telefono is null and nif like '%K';

-- 5. Devuelve el listado de las asignaturas que se imparten en el primer cuatrimestre, en el tercer curso del grado que tiene el identificador 7.
select distinct cuatrimestre, nombre
from asignatura
where cuatrimestre = 1;

-- ################################################
-- ########### Consultas Multitabla ###############
-- ################################################
## Consultas multitabla

-- 1. Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015).
select alumno.nombre, grado.nombre
from alumno 
inner join alumno_se_matricula_asignatura on alumno.id = alumno_se_matricula_asignatura.id_alumno
inner join asignatura on alumno_se_matricula_asignatura.id_asignatura = asignatura.id
inner join grado on asignatura.id_grado = grado.id
where grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 2. Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015).
select asignatura.nombre, grado.nombre
from asignatura
inner join grado on asignatura.id = grado.id
where grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 3. Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados. El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento. El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre.
select profesor.nombre, profesor.apellido1, profesor.apellido2, departamento.nombre as departamento_nombre
from profesor
inner join departamento on profesor.id_departamento = departamento.id;

-- 4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno con nif 26902806M.
select alumno.nombre, asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin, alumno.nif
from asignatura 
inner join alumno_se_matricula_asignatura on asignatura.id = alumno_se_matricula_asignatura.id_asignatura 
inner join alumno on alumno.id = alumno_se_matricula_asignatura.id_alumno 
inner join curso_escolar on alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id 
where alumno.nif = '26902806M';

-- 5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna asignatura en el Grado en Ingeniería Informática (Plan 2015).
select profesor.nombre, profesor.apellido1, profesor.apellido2, departamento.nombre
from profesor
inner join departamento on profesor.id_departamento = departamento.id
left join asignatura on profesor.id = asignatura.id_profesor
left join grado on asignatura.id_grado = grado.id
where grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura durante el curso escolar 2018/2019.
select alumno.nombre, anyo_inicio, anyo_fin
from alumno 
inner join alumno_se_matricula_asignatura on alumno.id = alumno_se_matricula_asignatura.id_alumno
left join curso_escolar on alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
where year(curso_escolar.anyo_fin) = 2018 or 2019 
order by curso_escolar.anyo_fin desc;

-- ################################################
-- ########### Consultas Multitabla ###############
-- ################################################
## Consultas multitabla (Composición externa)

-- 1. Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen vinculados. El listado también debe mostrar aquellos profesores que no tienen ningún departamento asociado. El listado debe devolver cuatro columnas, nombre del departamento, primer apellido, segundo apellido y nombre del profesor. El resultado estará ordenado alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el nombre.
select profesor.nombre, profesor.apellido1, profesor.apellido2, departamento.nombre
from profesor
left join departamento on profesor.id_departamento = departamento.id
order by profesor.nombre, profesor.apellido1, profesor.apellido2, departamento.nombre;

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.
select profesor.nombre, profesor.apellido1, profesor.apellido2, departamento.nombre
from profesor
left join departamento on profesor.id_departamento = departamento.id
where profesor.id_departamento is null;

-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados.
select profesor.nombre, departamento.nombre
from departamento
left join profesor on departamento.id  = profesor.id_departamento
where profesor.id_departamento is null;

-- 4. Devuelve un listado con los profesores que no imparten ninguna asignatura.
select profesor.nombre, profesor.apellido1, profesor.apellido2, asignatura.nombre as asignatura_nombre
from profesor
left join asignatura on profesor.id = asignatura.id_profesor
where asignatura.id_profesor is null;

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.
select profesor.nombre, profesor.apellido1, profesor.apellido2, asignatura.nombre
from asignatura 
left join profesor on asignatura.id_profesor = profesor.id
where id_profesor is null;

-- 6. Devuelve un listado con todos los departamentos que tienen alguna asignatura que no se haya impartido en ningún curso escolar. El resultado debe mostrar el nombre del departamento y el nombre de la asignatura que no se haya impartido nunca.
select departamento.nombre, asignatura.nombre
from departamento
left join profesor on departamento.id = profesor.id_departamento
left join asignatura on profesor.id = asignatura.id_profesor
left join alumno_se_matricula_asignatura on asignatura.id = alumno_se_matricula_asignatura.id_asignatura
where alumno_se_matricula_asignatura.id_asignatura is null;


-- ################################################
-- ########### Consultas resumen ###############
-- ################################################
## Consultas resúmen

-- 1. Devuelve el número total de alumnas que hay.
select count(id)
from alumno;

-- 2. Calcula cuántos alumnos nacieron en 1999.
select fecha_nacimiento, count(id)
from alumno
where year(fecha_nacimiento) = 1999
group by fecha_nacimiento;

-- 3. Calcula cuántos profesores hay en cada departamento. El resultado sólo debe mostrar dos columnas, una con el nombre del departamento y otra con el número de profesores que hay en ese departamento. El resultado sólo debe incluir los departamentos que tienen profesores asociados y deberá estar ordenado de mayor a menor por el número de profesores.
select  departamento.nombre, count(profesor.id)
from profesor
left join departamento on profesor.id_departamento = departamento.id
group by departamento.nombre;

-- 4. Devuelve un listado con todos los departamentos y el número de profesores que hay en cada uno de ellos. Tenga en cuenta que pueden existir departamentos que no tienen profesores asociados. Estos departamentos también tienen que aparecer en el listado.
select  departamento.nombre, count(profesor.id)
from departamento
left join profesor on departamento.id = profesor.id_departamento 
group by departamento.nombre;

-- 5. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno. Tenga en cuenta que pueden existir grados que no tienen asignaturas asociadas. Estos grados también tienen que aparecer en el listado. El resultado deberá estar ordenado de mayor a menor por el número de asignaturas.
select grado.nombre, count(asignatura.nombre)
from grado
left join asignatura on grado.id = asignatura.id_grado
group by grado.nombre
order by grado.nombre desc;

-- 6. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno, de los grados que tengan más de 40 asignaturas asociadas.
select grado.nombre, count(asignatura.nombre)
from grado
left join asignatura on grado.id = asignatura.id_grado
group by grado.nombre
having count(asignatura.nombre) > 40
order by grado.nombre desc;

-- 7. Devuelve un listado que muestre el nombre de los grados y la suma del número total de créditos que hay para cada tipo de asignatura. El resultado debe tener tres columnas: nombre del grado, tipo de asignatura y la suma de los créditos de todas las asignaturas que hay de ese tipo. Ordene el resultado de mayor a menor por el número total de crédidos.
select grado.nombre, asignatura.tipo, sum(asignatura.creditos)
from grado
left join asignatura on grado.id = asignatura.id_grado
group by grado.nombre, asignatura.tipo
order by asignatura.tipo, grado.nombre desc;

-- 8. Devuelve un listado que muestre cuántos alumnos se han matriculado de alguna asignatura en cada uno de los cursos escolares. El resultado deberá mostrar dos columnas, una columna con el año de inicio del curso escolar y otra con el número de alumnos matriculados.

select curso_escolar.anyo_inicio, count(alumno_se_matricula_asignatura.id_alumno)
from alumno_se_matricula_asignatura
left join alumno on alumno_se_matricula_asignatura.id_alumno = alumno.id
left join curso_escolar on alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
group by curso_escolar.anyo_inicio;

-- 9. Devuelve un listado con el número de asignaturas que imparte cada profesor. El listado debe tener en cuenta aquellos profesores que no imparten ninguna asignatura. El resultado mostrará cinco columnas: id, nombre, primer apellido, segundo apellido y número de asignaturas. El resultado estará ordenado de mayor a menor por el número de asignaturas.
select profesor.id, profesor.nombre, profesor.apellido1, profesor.apellido2, count(asignatura.id_profesor)
from profesor
left join asignatura on profesor.id = asignatura.id_profesor
group by profesor.id, profesor.nombre, profesor.apellido1, profesor.apellido2;


select * from asignatura;
select * from grado;
select * from departamento;
select * from profesor;
select * from alumno_se_matricula_asignatura;
select * from curso_escolar;

-- #### Desarrollado por Hernan Mendez Guerrero / 1101685607