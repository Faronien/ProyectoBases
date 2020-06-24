-- Alumnos:
-- Cruz Macías Ricardo Iván
-- López Hernández Marcos Daniel
-- Rojas Fernández Rafael
-- García Valencia Jesús Alberto
-- Grupo: 3CM9
-- Asignatura: Distributed Data Base


drop database if exists dbprotocolo;
create database dbprotocolo;
use dbprotocolo;


CALL registrar_alumno('faronienm','asdf',2015090373,'marcos','faronienm@gmail.com');
CALL registrar_alumno('spooky','dooky',2015090376,'matt','spooky@gmail.com');
CALL iniciar_sesion('spooky','dooky');
SELECT * FROM usuario;
create table usuario(
	usuario nvarchar(30) not null primary key,
	pswd nvarchar(30) not null,
    tipo int(2) not null -- Si es tipo 0, es invitado. Si es tipo 1, es alumno. Si es tipo 2, es profesor.
);

create table alumno(
	boleta int(10) not null primary key,
    usuario nvarchar(30) not null,
    nombre nvarchar(50) not null,
    correo nvarchar(50) not null,
    foreign key(usuario) references usuario(usuario) on delete cascade on update cascade);
    
create table protocolo(
	num_registro nvarchar(10) not null primary key,
    nombre nvarchar(50) not null,
    dir_pdf nvarchar(50) not null,
    boleta int(10) not null,
    ult_revision date,
    foreign key(boleta) references alumno(boleta) on delete cascade on update cascade);
    
    
create table palabra_clave(
	id_palabra_clave int(4) not null primary key,
    palabra_clave nvarchar(15) not null);

create table protocolo_palabra_clave(
	num_registro nvarchar(10) not null, 
    id_palabra_clave int(4) not null,
    foreign key(num_registro) references protocolo(num_registro) on delete cascade on update cascade,
    foreign key(id_palabra_clave) references palabra_clave(id_palabra_clave) on delete cascade on update cascade,
    primary key(num_registro,id_palabra_clave));  
  
create table profesor(
	id_profesor nvarchar(10) not null primary key,
    usuario nvarchar(30) not null,
    nombre nvarchar(50) not null,
    id_presidente nvarchar(10) not null,
	foreign key(id_presidente) references profesor(id_profesor),
    foreign key(usuario) references usuario(usuario) on delete cascade on update cascade);

create table sinodal_protocolo(
    id_profesor nvarchar(10) not null,
    num_registro nvarchar(10) not null,
	foreign key(num_registro) references protocolo(num_registro) on delete cascade on update cascade,
    foreign key(id_profesor) references profesor(id_profesor) on delete cascade on update cascade,
    primary key(id_profesor,num_registro));
    
create table evaluacion(
	id_evaluacion int(6) not null primary key,
    id_profesor nvarchar(10) not null,
    num_registro nvarchar(10) not null,
    estatus nvarchar(10) not null,
    dir_pdf nvarchar(50) not null,
    foreign key(num_registro) references protocolo(num_registro) on delete cascade on update cascade,
    foreign key(id_profesor) references profesor(id_profesor) on delete cascade on update cascade);

create table academia(
	id_academia int(6) not null primary key,
    nombre nvarchar(50) not null);
    
create table profesor_academia(
	id_academia int(6) not null,
    id_profesor nvarchar(10) not null,
    foreign key(id_academia) references academia(id_academia) on delete cascade on update cascade,
    foreign key(id_profesor) references profesor(id_profesor) on delete cascade on update cascade,
    primary key(id_profesor,id_academia));


-- Añadir procedimientos
drop procedure if exists registrar_alumno;
delimiter **
create procedure registrar_alumno(in var_usuario nvarchar(30), in var_pswd nvarchar(30), in var_boleta int(10), in var_nombre nvarchar(50), in var_correo nvarchar(50))
begin
	declare var_existe int;
	declare var_registrado int;
    set var_registrado = -1;

	-- Verificando que el usuario no exista
	set var_existe = (select count(*) from usuario where usuario = var_usuario) + (select count(*) from alumno where boleta = var_boleta);

	if (var_existe = 0) then -- Si el usuario no existe, registrarlo
        -- Registrando en tablas correspondientes
        insert into usuario(usuario, pswd, tipo) values(var_usuario, var_pswd, 1);
        insert into alumno(boleta, usuario, nombre, correo) values(var_boleta, var_usuario, var_nombre,var_correo);
		set var_registrado = 1;
	else -- Si el usuario existe, enviar error
        set var_registrado = 0;
	end if;
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.
	select var_registrado as var_registrado; 
end **
delimiter ;

drop procedure if exists iniciar_sesion;
delimiter **
create procedure iniciar_sesion(in var_usuario nvarchar(30), in var_pswd nvarchar(30))
begin
	declare var_existe int;
	declare var_iniciado int;
    declare var_tipo int;
    set var_iniciado = -1;
    set var_tipo = 0;

	-- Verificando que el usuario exista
	set var_existe = (select count(*) from usuario where usuario = var_usuario);

	if (var_existe = 1) then -- Si el usuario se encuentra, verificar que la contraseña sea válida
		if(var_pswd = (select pswd from usuario where usuario = var_usuario)) then -- Si la contraseña es válida, iniciar sesión
			set var_iniciado = 1;
            set var_tipo = (select tipo from usuario where usuario = var_usuario);
		else
			set var_iniciado = 0;
		end if;
	else -- Si el usuario no existe o hay algún error, enviar error
        set var_iniciado = 0;
	end if;
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.
	select var_iniciado as var_iniciado, var_usuario as var_usuario, var_tipo as var_tipo; 
end **
delimiter ;
call iniciar_sesion('faronien','asdf');
call registrar_alumno('faronien','asdf','2015090373','marcos','faronienm@gmail.com');
select * from alumno;