-- Alumnos:
-- Cruz Macías Ricardo Iván
-- López Hernández Marcos Daniel
-- Rojas Fernández Rafael
-- García Valencia Jesús Alberto
-- Grupo: 3CM9
-- Asignatura: Distributed Data Base
SET default_storage_engine=INNODB;
drop database if exists dbprotocolo;
create database dbprotocolo;
use dbprotocolo;

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
	rol nvarchar(50) default 'normal',
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
    estatus nvarchar(15) not null,
    dir_pdf nvarchar(100) not null,
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

drop procedure if exists ver_evaluaciones;
delimiter **
create procedure ver_evaluaciones(in var_usuario nvarchar(30))
begin
	declare var_existe int;
    declare var_tipo int;
    set var_tipo = 0;

	-- Verificando que el usuario exista
	set var_existe = (select count(*) from usuario where usuario = var_usuario);

	if (var_existe = 1) then -- Si el usuario se encuentra, obtener su tipo
            set var_tipo = (select tipo from usuario where usuario = var_usuario);
            if(var_tipo = 1)then -- Si el usuario es alumno desplegar las evaluaciones de su protocolo
				select var_existe,id_evaluacion,evaluacion.dir_pdf,protocolo.num_registro,profesor.nombre,estatus from evaluacion 
						inner join protocolo on evaluacion.num_registro = protocolo.num_registro
                        inner join profesor on evaluacion.id_profesor = profesor.id_profesor
                        inner join alumno on protocolo.boleta = alumno.boleta 
                        inner join usuario on alumno.usuario = usuario.usuario
                        where usuario.usuario = var_usuario;
            else
				if(var_tipo = 2)then -- Si el usuario es profesor, desplegar las evaluaciones donde es sinodal
					select var_existe,id_evaluacion,evaluacion.dir_pdf,protocolo.num_registro,alumno.nombre from evaluacion 
						inner join protocolo on evaluacion.num_registro = protocolo.num_registro
                        inner join alumno on protocolo.boleta = alumno.boleta
                        inner join profesor on evaluacion.id_profesor = profesor.id_profesor
                        inner join usuario on profesor.usuario = usuario.usuario
                        where usuario.usuario = var_usuario;
                else
					set var_existe = 0;
					select var_existe;
                end if;
            end if;    
	else -- Si el usuario no existe o hay algún error, enviar error
        select var_existe;
	end if;
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.
end **
delimiter ;

drop procedure if exists ver_protocolos;
delimiter **
create procedure ver_protocolos(in var_usuario nvarchar(30))
begin
	declare var_existe int;
    declare var_tipo int;
    set var_tipo = 0;

	-- Verificando que el usuario exista
	set var_existe = (select count(*) from usuario where usuario = var_usuario);

	if (var_existe = 1) then -- Si el usuario se encuentra, obtener su tipo
            set var_tipo = (select tipo from usuario where usuario = var_usuario);
            if(var_tipo = 1)then -- Si el usuario es alumno desplegar su protocolo
				select var_existe,protocolo.num_registro,protocolo.nombre,protocolo.dir_pdf from protocolo
						inner join alumno on protocolo.boleta=alumno.boleta
                        inner join usuario on alumno.usuario=usuario.usuario
                        where usuario.usuario=var_usuario;
				#select var_existe,protocolo.num_registro,protocolo.nombre,protocolo.dir_pdf,profesor.nombre from protocolo
				#		inner join alumno on protocolo.boleta=alumno.boleta
                #        inner join sinodal_protocolo on protocolo.num_registro=sinodal_protocolo.num_registro
                #        inner join profesor on sinodal_protocolo.id_profesor=profesor.id_profesor
                #        inner join usuario on alumno.usuario=usuario.usuario
                #        where usuario.usuario=var_usuario;
            else
				if(var_tipo = 2)then -- Si el usuario es profesor, desplegar los protocolos que evaluara
					select var_existe,protocolo.num_registro,protocolo.nombre,alumno.nombre,protocolo.dir_pdf from protocolo 
						inner join alumno on protocolo.boleta=alumno.boleta
                        inner join sinodal_protocolo on protocolo.num_registro=sinodal_protocolo.num_registro
                        inner join profesor on sinodal_protocolo.id_profesor=profesor.id_profesor
                        inner join usuario on profesor.usuario=usuario.usuario
                        where usuario.usuario=var_usuario;
                else
					set var_existe = 0;
					select var_existe;
                end if;
            end if;    
	else -- Si el usuario no existe o hay algún error, enviar error
        select var_existe;
	end if;
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.
end **
delimiter ;

drop procedure if exists ver_protocolo_eleg;
delimiter **
create procedure ver_protocolo_eleg(in num_reg nvarchar(10))
begin
	select num_registro,protocolo.nombre,dir_pdf,protocolo.boleta,ult_revision,alumno.nombre,alumno.correo from protocolo,alumno where num_reg=num_registro AND protocolo.boleta=alumno.boleta;
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.
end **
delimiter ;

drop procedure if exists registrar_evaluacion;
delimiter **
create procedure registrar_evaluacion(in var_idevaluacion int(6),in var_idprofesor nvarchar(10),in var_num_registro nvarchar(10),in var_estatus nvarchar(15),in var_dirpdf nvarchar(100) )
begin
declare ev_registrada int;
set ev_registrada=-1;
	insert into evaluacion(id_evaluacion,id_profesor,num_registro,estatus,dir_pdf) values (var_idevaluacion,var_idprofesor,var_num_registro,var_estatus,var_dirpdf);
    set ev_registrada=1;
    select ev_registrada as ev_registrada;
end **
delimiter ;
drop procedure if exists getidProf;
delimiter **
create procedure getidProf(in usuario nvarchar(30))
begin
select id_profesor from profesor where usuario=profesor.usuario;
end **
delimiter ;


drop procedure if exists getMailAlum;
delimiter **
create procedure getMailAlum(in var_idevaluacion nvarchar(10))
begin
select correo from alumno, protocolo where protocolo.boleta=alumno.boleta and var_idevaluacion=num_registro;
end **
delimiter ;

drop procedure if exists contarEv;
delimiter **
create procedure contarEv()
begin
	select count(id_evaluacion)+1 as sigID from evaluacion;
end **
delimiter ;


drop procedure if exists sp_getMyProt;
delimiter **
create procedure sp_getMyProt(in xboleta int(10))
begin
	declare exs int;
    set exs = (select ifnull(count(*),0) from protocolo where boleta = xboleta);
    if exs = 1 then
		select '1' as estat, num_registro, nombre, dir_pdf, ult_revision
        from protocolo
        where
			boleta = xboleta;
	else
		select 0 as estat;
	end if;
end**
delimiter ;


-- Inserta el protocolo, recibe la boleta, el titulo y la direccion del pdf
-- Devuelve estat (0,1) 1 es insertado, 0 es que no se puede insertar, un mensaje y el num_registro
drop procedure if exists sp_insertMyProt;
delimiter **
create procedure sp_insertMyProt(
	in xboleta int(10), 
    in xnombre nvarchar(50), 
    in xdir_pdf nvarchar(50)
)
begin
	declare registred int;
	declare xnum varchar(10);
    declare cuenta int(3);
    
    set registred = (select count(*) from protocolo where boleta = xboleta);
    
    if registred >= 1 then
		select 0 as estat, 'Ya tienes un protocolo registrado' as msj;
	else
		set cuenta = (select substr(num_registro,7,4) as nums from protocolo order by nums desc limit 1);
		set xnum = (select concat('PROTTT',lpad(trim(LEADING '0' from cuenta)+1,4,0)));
		insert into protocolo(num_registro,nombre,dir_pdf,boleta,ult_revision) values(xnum,xnombre,xdir_pdf,xboleta,now());
		select 1 as stat, 'Registro exitoso' as msj,xnum as num_reg;
	end if;
end**
delimiter ;


-- Cambia la dirección del pdf
-- Recibe el número de registro y la nueva dirección
-- Regresa 1 de exito y un mensaje
drop procedure if exists sp_updateReg;
delimiter **
create procedure sp_updateReg(in xnum nvarchar(10), xnew_pdf nvarchar(50))
begin
	update protocolo set dir_pdf = xnew_pdf;
    select 1 as stat,'Correcion realizada' as msj;
end**

delimiter ;


-- Registra las palabras clave (solo una por una)
-- Recibe una palabra y el numero de registro
-- Regresa 1 de exito y un mensaje
drop procedure if exists sp_regKeyW;
delimiter **
create procedure sp_regKeyW(in palabra nvarchar(15), in xnum nvarchar(10))
begin
	declare idp int(4);
    declare exs int;
    set exs = (select count(*) from palabra_clave where palabra_clave = palabra);
    if exs = 0 then
		set idp = (select ifnull(max(id_palabra_clave),0)+1 from palabra_clave);
        insert into palabra_clave values (idp,palabra);
	else
		set idp = (select id_palabra_clave from palabra_clave where palabra_clave = palabra);
	end if;
	insert into protocolo_palabra_clave values (xnum,idp);
    select 1 as estat, 'Palabra registrada y asociada' as msj;
end**
delimiter ;

select * from protocolo;
-- Consulta la boleta
drop procedure if exists sp_getBoleta;
delimiter **
create procedure sp_getBoleta(in xnombre nvarchar(50))
begin
	select a.boleta from alumno a, usuario u where a.usuario = u.usuario and u.usuario = xnombre;
end**
delimiter ;


-- Valida que puedas meter correcciones
-- Recibe el numero de registro
-- Regresa 0 si no puedes corregir
-- 1 Si se puede corregir, 2 si Ya fue aceptado
drop procedure if exists sp_canUpdate;
delimiter **
create procedure sp_canUpdate(in xnum nvarchar(10))
begin
	declare exs int;
    declare recha int;
    set exs = (select count(*) from protocolo where num_registro = xnum);
    if exs = 1 then
		select ifnull(if(estatus='RECHAZADO',1,2),0) as stat from evaluacion where num_registro = xnum;
	else
		select 0 as stat;
    end if;
end**
delimiter ;

-- Procedure para que un presidente de academia puede designar profesores como sinodales de un TT
delimiter **
create procedure asignar_sinodal(in idprof varchar (10),in nreg varchar(10))
begin
declare msj nvarchar(50);
if ((select count(*) from sinodal_protocolo where id_profesor = idprof) < 3) then  -- Si hay un profesor como sinodal en menos de 3 protocolos
	if((select count(*) from sinodal_protocolo where num_registro = nreg) < 3) then -- Si hay menos de 3 sinodales en el protocolo
		if((select count(*) from sinodal_protocolo where id_profesor = idprof and num_registro = nreg) < 1) then -- Si el profesor no ha sido asignado a ese protocolo
			insert into sinodal_protocolo(id_profesor,num_registro)values(idprof,nreg);
            set msj = 'Asignado';
		else
			set msj = 'c1'; -- Profesor ya asignado a ese protocolo
		end if;
    else
		set msj = 'c2'; -- Protocolo ya con 3 sinodales
	end if;
else
	set msj = 'c3'; -- Profesor ya con 3 protocolos
end if;
	select msj;
end **
delimiter ; 

delimiter **
create procedure rol_profesor(in idprof varchar (10))
begin
	select rol from profesor where id_profesor = idprof;
end **
delimiter ; 

delimiter **
create procedure profesores_academia(in idAcademia varchar (10))
begin
	select p.id_profesor,p.nombre from profesor p inner join profesor_academia pa on p.id_profesor = pa.id_profesor inner join academia a on a.id_academia = pa.id_academia where a.id_academia = idAcademia;
end **
delimiter ; 

delimiter **
create procedure academia_profesor(in idProfesor varchar (10))
begin
	select a.id_academia,a.nombre from academia a inner join profesor_academia pa on a.id_academia = pa.id_academia inner join profesor p on p.id_profesor = pa.id_profesor where p.id_profesor = idProfesor;
end **
delimiter ; 

delimiter **
create procedure sinodales_protocolo(in nreg varchar(10))
begin
	select p.id_profesor,p.nombre from profesor p inner join sinodal_protocolo sp on p.id_profesor = sp.id_profesor where sp.num_registro = nreg;
end **
delimiter ; 

delimiter **
create procedure existe_protocolo(in nreg varchar(10))
begin
	declare msj varchar(30);
	if ((select count(*) from protocolo where num_registro = nreg)>0) then
		set msj = "Existente";
    else
		set msj = "Inexistente";
    end if;
    select msj;
end **
delimiter ; 

-- PARA PRUEBAS

select * from protocolo;
select * from palabra_clave;
call iniciar_sesion('faronien','asdf');
call registrar_alumno('faronien','asdf','2015090373','marcos','faronienm@gmail.com');
insert into protocolo(num_registro,nombre,dir_pdf,boleta,ult_revision)values('PROTTT0001','PROTTT0001','docs/protocolos/pr1.pdf','2015090373','2020-02-24');

insert into academia(id_academia,nombre)values(1,"Ciencias Básicas");
insert into academia(id_academia,nombre)values(2,"Ciencias Sociales");
insert into academia(id_academia,nombre)values(3,"Ingenieria");

insert into usuario(usuario,pswd,tipo)values('prof1','prof1',2);
insert into profesor(id_profesor,usuario,nombre,rol)values(1,'prof1','Hernan Martinez','presidente');
insert into profesor_academia(id_academia,id_profesor)values('1','1');

insert into usuario(usuario,pswd,tipo)values('prof2','prof2',2);
insert into profesor(id_profesor,usuario,nombre)values(2,'prof2','Juan Perez');
insert into profesor_academia(id_academia,id_profesor)values('2','2');

insert into usuario(usuario,pswd,tipo)values('prof3','prof3',2);
insert into profesor(id_profesor,usuario,nombre)values('3','prof3','Adriana Hernandez');
insert into profesor_academia(id_academia,id_profesor)values('3','3');

insert into usuario(usuario,pswd,tipo)values('prof4','prof4',2);
insert into profesor(id_profesor,usuario,nombre)values('4','prof4','Edgar Carranza');
insert into profesor_academia(id_academia,id_profesor)values('1','4');

insert into usuario(usuario,pswd,tipo)values('prof5','prof5',2);
insert into profesor(id_profesor,usuario,nombre)values('5','prof5','César Frias');
insert into profesor_academia(id_academia,id_profesor)values('1','5');

call asignar_sinodal('1','PROTTT0001');
call asignar_sinodal('2','PROTTT0001');
call asignar_sinodal('3','PROTTT0001');

insert into evaluacion(id_evaluacion,id_profesor,num_registro,estatus,dir_pdf)values(1,1,'PROTTT0001','ACEPTADA','docs/evaluaciones/ev1.pdf');
insert into evaluacion(id_evaluacion,id_profesor,num_registro,estatus,dir_pdf)values(2,2,'PROTTT0001','ACEPTADA','docs/evaluaciones/ev2.pdf');
insert into evaluacion(id_evaluacion,id_profesor,num_registro,estatus,dir_pdf)values(3,3,'PROTTT0001','RECHAZADA','docs/evaluaciones/ev3.pdf');

call ver_evaluaciones('faronien');
call ver_evaluaciones('prof1');

call ver_protocolos('faronien');
call ver_protocolos('prof1');
call ver_protocolo_eleg(1);
call getidProf('prof1');
call getMailAlum('2');
call registrar_evaluacion('4','1','PROTTT0001','RECHAZADO','/docs/');

SELECT * from alumno;
#update protocolo set num_registro = 'PROTTT001';
select * from protocolo;
#insert into protocolo(num_registro,nombre,dir_pdf,boleta,ult_revision)values('PROTTT0002','protocolo 2','docs/protocolos/pr2.pdf',2015090373,'2020-03-03');

call sp_getBoleta('faronien');
#call sp_insertMyProt(2015090373,'titulo','dir');
select * from alumno;

select * from profesor;
