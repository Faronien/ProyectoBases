create table usuario(
	usuario nvarchar(30) not null primary key,
	pswd nvarchar(30) not null,
    tipo int not null -- Si es tipo 0, es invitado. Si es tipo 1, es alumno. Si es tipo 2, es profesor.
);

create table alumno(
	boleta int not null primary key,
    usuario nvarchar(30) not null,
    nombre nvarchar(50) not null,
    correo nvarchar(50) not null,
    foreign key(usuario) references usuario(usuario) on delete cascade on update cascade);
    
create table protocolo(
	num_registro nvarchar(10) not null primary key,
    nombre nvarchar(50) not null,
    dir_pdf nvarchar(50) not null
    boleta int not null,
    ult_revision date,
    foreign key(boleta) references alumno(boleta) on delete cascade on update cascade);
    
create table palabra_clave(
	id_palabra_clave int not null primary key,
    palabra_clave nvarchar(15) not null);

create table protocolo_palabra_clave(
	num_registro nvarchar(10) not null, 
    id_palabra_clave int not null,
    foreign key(num_registro) references protocolo(num_registro) on delete cascade on update cascade,
    foreign key(id_palabra_clave) references palabra_clave(id_palabra_clave) on delete cascade on update cascade,
    primary key(num_registro,id_palabra_clave));  
  
create table profesor(
	id_profesor nvarchar(10) not null primary key,
    usuario nvarchar(30) not null,
    nombre nvarchar(50) not null,
    rol nvarchar(50) default 'normal',
	foreign key(id_presidente) references profesor(id_profesor),
    foreign key(usuario) references usuario(usuario) on delete cascade on update cascade);

create table sinodal_protocolo(
    id_profesor nvarchar(10) not null,
    num_registro nvarchar(10) not null,
	foreign key(num_registro) references protocolo(num_registro),
    foreign key(id_profesor) references profesor(id_profesor),
    primary key(id_profesor,num_registro));
    
create table evaluacion(
	id_evaluacion int not null primary key,
    id_profesor nvarchar(10) not null,
    num_registro nvarchar(10) not null,
    estatus nvarchar(10) not null,
    dir_pdf nvarchar(50) not null,
    foreign key(num_registro) references protocolo(num_registro) ,
    foreign key(id_profesor) references profesor(id_profesor)
);

create table academia(
	id_academia int not null primary key,
    nombre nvarchar(50) not null
);

create table profesor_academia(
	id_academia int not null,
    id_profesor nvarchar(10) not null,
    foreign key(id_academia) references academia(id_academia) on delete cascade on update cascade,
    foreign key(id_profesor) references profesor(id_profesor) on delete cascade on update cascade,
    primary key(id_profesor,id_academia));

CREATE PROCEDURE registrar_alumno @var_usuario NVARCHAR(30),@var_pswd NVARCHAR(30),@var_boleta int,@var_nombre nvarchar(50),@var_correo nvarchar(50)
AS
    DECLARE @var_existe int;
	DECLARE @var_registrado int;
    SET @var_registrado = -1;
    -- Verificando que el usuario no exista
	set @var_existe = (SELECT count(*) from usuario where usuario = @var_usuario) + (select count(*) from alumno where boleta = @var_boleta);
    IF 
    @var_existe = 0 -- Si el usuario no existe, registrarlo
    BEGIN
        -- Registrando en tablas correspondientes
        insert into usuario(usuario, pswd, tipo) values(@var_usuario,@var_pswd, 1);
        insert into alumno(boleta, usuario, nombre, correo) values(@var_boleta, @var_usuario, @var_nombre,@var_correo);
		set @var_registrado = 1;
	END
    ELSE
    BEGIN -- Si el usuario existe, enviar error
        set @var_registrado = 0;
    END
    SELECT @var_registrado as var_registrado; 


CREATE PROCEDURE iniciar_sesion @var_usuario NVARCHAR(30), @var_pswd NVARCHAR(30)
AS
    declare @var_existe int;
	declare @var_iniciado int;
    declare @var_tipo int;
    set @var_iniciado = -1;
    set @var_tipo = 0;

	-- Verificando que el usuario exista
	set @var_existe = (select count(*) from usuario where usuario = @var_usuario);

	if (@var_existe = 1)  -- Si el usuario se encuentra, verificar que la contraseña sea válida
	begin	
        if(@var_pswd = (select pswd from usuario where usuario = @var_usuario))  -- Si la contraseña es válida, iniciar sesión
		begin	
            set @var_iniciado = 1;
            set @var_tipo = (select tipo from usuario where usuario = @var_usuario);
		end
        else
        begin
			set @var_iniciado = 0;
        end
	end
	else
    begin -- Si el usuario no existe o hay algún error, enviar error
        set @var_iniciado = 0;
	end
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.
	select @var_iniciado as var_iniciado, @var_usuario as var_usuario, @var_tipo as var_tipo;

CREATE PROCEDURE ver_evaluaciones @var_usuario nvarchar(30)
AS
    declare @var_existe int;
    declare @var_tipo int;
    set @var_tipo = 0;

	-- Verificando que el usuario exista
	set @var_existe = (select count(*) from usuario where usuario = @var_usuario);

	if (@var_existe = 1)  -- Si el usuario se encuentra, obtener su tipo
    BEGIN
        set @var_tipo = (select tipo from usuario where usuario = @var_usuario);
        if(@var_tipo = 1) -- Si el usuario es alumno desplegar las evaluaciones de su protocolo
		BEGIN	
            select @var_existe,id_evaluacion,evaluacion.dir_pdf,protocolo.num_registro,profesor.nombre,estatus from evaluacion 
		    	inner join protocolo on evaluacion.num_registro = protocolo.num_registro
                inner join profesor on evaluacion.id_profesor = profesor.id_profesor
                inner join alumno on protocolo.boleta = alumno.boleta 
                inner join usuario on alumno.usuario = usuario.usuario
            where usuario.usuario = @var_usuario;
        END
        else
        BEGIN
		    if(@var_tipo = 2) -- Si el usuario es profesor, desplegar las evaluaciones donde es sinodal
			BEGIN
            	select @var_existe,id_evaluacion,evaluacion.dir_pdf,protocolo.num_registro,alumno.nombre from evaluacion 
					inner join protocolo on evaluacion.num_registro = protocolo.num_registro
                    inner join alumno on protocolo.boleta = alumno.boleta
                    inner join profesor on evaluacion.id_profesor = profesor.id_profesor
                    inner join usuario on profesor.usuario = usuario.usuario
                where usuario.usuario = @var_usuario;
            END
            else
            BEGIN
			    set @var_existe = 0;
				select @var_existe;
            END 
        END
    END    
	else -- Si el usuario no existe o hay algún error, enviar error
    BEGIN
        select @var_existe;
	END
    -- IMPORTANTE: TODOS LOS PROCEDIMIENTOS DEBEN TERMINAR EN UN SELECT, PARA SU MANEJO GENERAL EN LA LÓGICA.

CREATE PROCEDURE ver_protocolos @var_usuario nvarchar(30)
AS
    declare @var_existe int;
    declare @var_tipo int;
    set @var_tipo = 0;

	-- Verificando que el usuario exista
	set @var_existe = (select count(*) from usuario where usuario = @var_usuario);

	if (@var_existe = 1)  -- Si el usuario se encuentra, obtener su tipo
    BEGIN
        set @var_tipo = (select tipo from usuario where usuario = @var_usuario);
        if(@var_tipo = 1) -- Si el usuario es alumno desplegar su protocolo
        BEGIN    
            select @var_existe,protocolo.num_registro,protocolo.nombre,protocolo.dir_pdf from protocolo
                    inner join alumno on protocolo.boleta=alumno.boleta
                    inner join usuario on alumno.usuario=usuario.usuario
                    where usuario.usuario=@var_usuario;
            --select @var_existe,protocolo.num_registro,protocolo.nombre,protocolo.dir_pdf,profesor.nombre from protocolo
            --		inner join alumno on protocolo.boleta=alumno.boleta
            --        inner join sinodal_protocolo on protocolo.num_registro=sinodal_protocolo.num_registro
            --        inner join profesor on sinodal_protocolo.id_profesor=profesor.id_profesor
            --        inner join usuario on alumno.usuario=usuario.usuario
            --        where usuario.usuario=@var_usuario;
        END
        else
        BEGIN
            if(@var_tipo = 2) -- Si el usuario es profesor, desplegar los protocolos que evaluara
            BEGIN
                select @var_existe,protocolo.num_registro,protocolo.nombre,alumno.nombre,protocolo.dir_pdf from protocolo 
                    inner join alumno on protocolo.boleta=alumno.boleta
                    inner join sinodal_protocolo on protocolo.num_registro=sinodal_protocolo.num_registro
                    inner join profesor on sinodal_protocolo.id_profesor=profesor.id_profesor
                    inner join usuario on profesor.usuario=usuario.usuario
                    where usuario.usuario=@var_usuario;
            END
            else
            BEGIN
                set @var_existe = 0;
                select @var_existe;
            END
        END
    END    
	else -- Si el usuario no existe o hay algún error, enviar error
    BEGIN
        select @var_existe;
	END

CREATE PROCEDURE ver_protocolo_eleg @num_reg nvarchar(10)
AS
    select num_registro,protocolo.nombre,dir_pdf,protocolo.boleta,ult_revision,alumno.nombre,alumno.correo 
    from protocolo,alumno 
    where 
        @num_reg=num_registro AND protocolo.boleta=alumno.boleta;

CREATE PROCEDURE registrar_evaluacion @var_idevaluacion int,
    @var_idprofesor nvarchar(10),
    @var_num_registro nvarchar(10),
    @var_estatus nvarchar(15),
    @var_dirpdf nvarchar(100)
AS
    declare @ev_registrada int;
    set @ev_registrada=-1;
	insert into evaluacion(id_evaluacion,id_profesor,num_registro,estatus,dir_pdf) values (@var_idevaluacion,@var_idprofesor,@var_num_registro,@var_estatus,@var_dirpdf);
    set @ev_registrada=1;
    select @ev_registrada as ev_registrada;

CREATE PROCEDURE getidProf @usuario nvarchar(30)
AS
    select id_profesor from profesor where @usuario=profesor.usuario;

CREATE PROCEDURE getMailAlum @var_idevaluacion nvarchar(10)
AS
    select correo from alumno, protocolo where protocolo.boleta=alumno.boleta and @var_idevaluacion=num_registro;

CREATE PROCEDURE contarEv
AS
    select count(id_evaluacion)+1 as sigID from evaluacion;

CREATE PROCEDURE sp_getMyProt @xboleta int
AS
    declare @exs int;
    set @exs = (select ISNULL(count(*),0) from protocolo where boleta = @xboleta);
    if @exs = 1
    BEGIN
		select '1' as estat, num_registro, nombre, dir_pdf, ult_revision
        from protocolo
        where
			boleta = @xboleta;
	END
    else
    BEGIN
		select 0 as estat;
	END

CREATE PROCEDURE sp_insertMyProt
    @xboleta int, 
    @xnombre nvarchar(50), 
    @xdir_pdf nvarchar(50)
AS
    declare @registred int;
	declare @xnum varchar(10);
    declare @cuenta int;
    
    set @registred = (select count(*) from protocolo where boleta = @xboleta);
    
    if @registred >= 1
    BEGIN
		select 0 as estat, 'Ya tienes un protocolo registrado' as msj;
	END
    else
    BEGIN
		set @cuenta = (SELECT TOP 1 SUBSTRING(num_registro,7,4) as nums from protocolo order by nums desc);
		set @xnum = CONCAT('PROTTT',RIGHT('000'+CAST(@cuenta AS VARCHAR(4)),4));
		insert into protocolo(num_registro,nombre,dir_pdf,boleta,ult_revision) values(@xnum,@xnombre,@xdir_pdf,@xboleta,GETDATE());
		select 1 as stat, 'Registro exitoso' as msj,@xnum as num_reg;
	END

CREATE PROCEDURE sp_updateReg @xnum nvarchar(10), @xnew_pdf nvarchar(50)
AS
    update protocolo set dir_pdf = @xnew_pdf WHERE num_registro = @xnum;
    select 1 as stat,'Correcion realizada' as msj;

CREATE PROCEDURE sp_regKeyW @palabra nvarchar(15), @xnum nvarchar(10)
AS
    declare @idp int;
    declare @exs int;
    set @exs = (select count(*) from palabra_clave where palabra_clave = @palabra);
    if @exs = 0
    BEGIN
		set @idp = (select ISNULL(max(id_palabra_clave),0)+1 from palabra_clave);
        insert into palabra_clave values (@idp,@palabra);
	END
    else
    BEGIN
		set @idp = (select id_palabra_clave from palabra_clave where palabra_clave = @palabra);
	END
	insert into protocolo_palabra_clave values (@xnum,@idp);
    select 1 as estat, 'Palabra registrada y asociada' as msj;

CREATE PROCEDURE sp_getBoleta @xnombre nvarchar(50)
AS
    select a.boleta 
    from alumno a, usuario u 
    where 
        a.usuario = u.usuario and u.usuario = @xnombre;

--Este probarlo con más cuidado
CREATE PROCEDURE sp_canUpdate @xnum nvarchar(10)
AS
    declare @exs int;
    set @exs = (select count(*) from protocolo where num_registro = @xnum);
    if @exs = 1
    BEGIN
		select CAST(
            CASE
                WHEN estatus='RECHAZADO'
                    THEN 1
                ELSE 2
        END AS int) as stat from evaluacion where num_registro = @xnum;
	END
    else
    BEGIN
		select 0 as stat;
    END

CREATE PROCEDURE asignar_sinodal @idprof varchar (10), @nreg varchar(10)
AS
    declare @msj nvarchar(50);
	if ((select count(*) from sinodal_protocolo where id_profesor = @idprof) < 3)   -- Si hay un profesor como sinodal en menos de 3 protocolos
	BEGIN	
        if((select count(*) from sinodal_protocolo where num_registro = @nreg) < 3)  -- Si hay menos de 3 sinodales en el protocolo
		BEGIN	
            if((select count(*) from sinodal_protocolo where id_profesor = @idprof and num_registro = @nreg) < 1)  -- Si el profesor no ha sido asignado a ese protocolo
			BEGIN
            	insert into sinodal_protocolo(id_profesor,num_registro)values(@idprof,@nreg);
				set @msj = 'Asignado';
			END
            else
            BEGIN
				set @msj = 'c1'; -- Profesor ya asignado a ese protocolo
			END
        END
		else
        BEGIN
			set @msj = 'c2'; -- Protocolo ya con 3 sinodales
		END
    END
	else
    BEGIN
		set @msj = 'c3'; -- Profesor ya con 3 protocolos
	END
		select @msj;

CREATE PROCEDURE rol_profesor @idprof varchar (10)
AS
    select rol from profesor where id_profesor = @idprof;

CREATE PROCEDURE academia_profesor @idProfesor varchar (10)
AS
    select a.id_academia,a.nombre 
    from academia a 
    inner join 
        profesor_academia pa on a.id_academia = pa.id_academia 
    inner join 
        profesor p on p.id_profesor = pa.id_profesor 
    where 
        p.id_profesor = @idProfesor;