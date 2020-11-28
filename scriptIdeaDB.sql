create database idea;
use idea;

-- DDL ------------------------------------------------------------
#ejecutado
create table Sexo(
	IdSexo int primary key auto_increment,
    NombreSexo varchar(9) unique not null
);

#ejecutado
create table Persona(
	IdPersona int primary key auto_increment,
    NombrePersona varchar(50) not null,
    ApellidoPersona varchar(50) not null,
    FechaNacimiento date not null,
    IdSexo int not null,
    constraint FK_Persona_Sexo
    foreign key (IdSexo) references Sexo(IdSexo)    
);

#ejecutado
create table Cuenta(
	IdCuenta int primary key auto_increment,
    NombreCuenta varchar(10) unique not null,
    Contra varchar(50) not null,
    CorreoCuenta varchar(50) not null,
    FechaCreacionCuenta datetime not null,
    IdPersona int not null,
    constraint FK_Cuenta_Persona
    foreign key (IdPersona) references Persona(IdPersona)
);

#ejecutado
create table TipoMensaje(
	CodTipoMensaje varchar(10) primary key,
    NombreTipoMensaje varchar(100) unique not null
);

#ejecutado
create table Mensaje(
	IdMensaje int primary key auto_increment,
    ContenidoMensaje varchar(256) not null,
    FechaMensaje datetime not null,
    CodTipoMensaje varchar(10) not null,
    IdCuenta int not null,
    constraint FK_Mensaje_TipoMensaje
    foreign key (CodTipoMensaje) references TipoMensaje(CodTipoMensaje),
    constraint FK_Mensaje_Cuenta
    foreign key (IdCuenta) references Cuenta(IdCuenta)
);

#ejecutado
create table Reaccion(
	IdReaccion int primary key auto_increment,
    NombreReaccion varchar(20) unique not null,
    TipoReaccion varchar(14) unique not null 
    #bien puede ser predeterminado o personalizado
);

#ejecutado
create table CuentaReaccionMensaje(
	IdCuentaReaccionMensaje int primary key auto_increment,
    IdMensaje int not null,
    IdCuenta int not null,
    IdReaccion int not null,
    constraint FK_CuentaReaccionMensaje_Mensaje
    foreign key (IdMensaje) references Mensaje(IdMensaje),
    constraint FK_CuentaReaccionMensaje_Cuenta
    foreign key (IdCuenta) references Cuenta(IdCuenta),
    constraint FK_CuentaReaccionMensaje_Reaccion
    foreign key (IdReaccion) references Reaccion(IdReaccion)    
);
-- FIN DDL ------------------------------------------------------------

-- DML ------------------------------------------------------------

# ingresamos datos en la tabla de sexo
insert into Sexo(NombreSexo)
values("masculino"), ("femenino");


# ingresamos datos en la tabla de reacciones ---------------------------------------------------
insert into Reaccion(NombreReaccion, TipoReaccion)
values("No me gusta", "Predeterminado");

select * from Reaccion;

# ingresamos datos en la tabla de tipo mensaje -----------------------------------------------
insert into TipoMensaje(CodTipoMensaje, NombreTipoMensaje)
values(`fn_crearCodigoMensaje`("Música"),"Música");

call `sp_insertarTipoMensaje`("Música");

select `fn_crearCodigoMensaje`("Trompetas");

select * from TipoMensaje;

delimiter $$
create procedure `sp_insertarTipoMensaje`( in _tipoMensaje varchar(100) )
begin
	insert into TipoMensaje(CodTipoMensaje, NombreTipoMensaje)
    values(`fn_crearCodigoMensaje`(_tipoMensaje), _tipoMensaje);
end $$ 
delimiter ;

delimiter $$
create function `fn_crearCodigoMensaje` (_codigo varchar(100)) 
returns varchar(10)
deterministic
begin
	declare username varchar(100);
    set username = concat(substr(lower(_codigo), 1, 6), '#', substr(uuid(), 1, 4));
    set username = if(char_length(username) > 10, concat(substr(username, 1, 5),'#', substr(uuid(), 1, 4)), username);
    return username;
end $$ 
delimiter ;

# insertar datos personas --------------------------------------------------
delimiter $$
	create procedure `sp_insertarPersona`(
		in _nombre varchar(50),
        in _apellido varchar(50),
        in _fechaNacimiento date,
        in _idSexo int
    )
begin
	insert into Persona(
		NombrePersona,
        ApellidoPersona,
        FechaNacimiento,
        IdSexo
    )
    values(
		_nombre,
        _apellido,
        _fechaNacimiento,
        _idSexo
    );
end $$
delimiter ;

call `sp_insertarPersonas`("Sergio", "Rios", '2000-03-13', 1);

delimiter $$
	create procedure `sp_verPersonasPorID`(in _idPersona int)
    begin 
		select p.NombrePersona,
			   p.ApellidoPersona,
               p.FechaNacimiento, 
               s.NombreSexo Sexo
        from Persona p inner join Sexo s
								on p.IdSexo = s.IdSexo;
    end $$
delimiter ;

call `sp_verPersonasPorID`(1);

delimiter $$
	create procedure `sp_actualizarPersona`(
		in _idPersona int, 
        in _nombrePersona varchar(50),
        in _apellidoPersona varchar(50),
        in _fechaNacimiento date,
        in _idSexo int
    )
    begin
    update Persona
    set NombrePersona = _nombrePersona,
		ApellidoPersona = _apellidoPersona,
        FechaNacimiento = _fechaNacimiento,
        IdSexo = _idSexo
	where IdPersona = _idPersona;  	
    end $$
delimiter ;

call `sp_actualizarPersona`(
	1,
    'Sergio',
    'Rios Reyes',
    '2000-03-13',
    1
);

delimiter $$
	create procedure `sp_eliminarPersona`(in _idPersona int)
    begin
		delete from Persona
        where IdPersona = _idPersona;
    end $$
delimiter ;

call `sp_eliminarPersona`(1);

alter table Persona auto_increment = 1;

# datos de la tabla de cuentas

# insertar
delimiter $$
	create procedure `sp_insertarCuenta`(
		in _nombreCuenta varchar(10),
        in _contra varchar(50),
        in _correoCuenta varchar(50),
        in _idPersona int
    )
    begin
		insert into Cuenta(
			NombreCuenta,
            Contra,
            CorreoCuenta,
            FechaCreacionCuenta,
            IdPersona
        ) 
        values (
			_nombreCuenta,
            md5(_contra),
            _correoCuenta,
            current_date(),
            _idPersona
        );
    end $$
delimiter ;

alter table Cuenta auto_increment = 1;

call `sp_insertarCuenta`(
	"srios",
    "movil1",
    "sergio.mnrq1@gmail.com",
    1
);

alter table Cuenta
change column FechaCreacionCuenta FechaCreacionCuenta date;

# actualizar
delimiter $$
	create procedure `sp_actualizarCuenta`(
		in _idCuenta int,
        in _nombreCuenta varchar(10),
        in _correoCuenta varchar(50)
    )
    begin
		update Cuenta
        set NombreCuenta = _nombreCuenta,
			CorreoCuenta = _correoCuenta
		where IdCuenta = _idCuenta;
    end $$
delimiter ;

delimiter $$
	create procedure `sp_actualizarContra`(
		in _idCuenta int,
        in _contra varchar(50)
    )
    begin
		update Cuenta
        set Contra = _contra
        where IdCuenta = _idCuenta;
    end $$
delimiter ;

# ver
delimiter $$
	create procedure `sp_verCuentaPorID`(in _idCuenta int)
    begin
		select p.NombrePersona,
			   p.ApellidoPersona,
               p.FechaNacimiento,
               s.NombreSexo,
               c.NombreCuenta,
               c.FechaCreacionCuenta
        from Cuenta c inner join Persona p
					  on c.IdPersona = p.IdPersona
                      inner join Sexo s
                      on p.IdSexo = s.IdSexo
		where c.IdCuenta = _idCuenta;
    end $$
delimiter ;

select * from Cuenta;

select c.IdCuenta,
	   p.NombrePersona,
	   p.ApellidoPersona,
	   p.FechaNacimiento,
	   s.NombreSexo,
	   c.NombreCuenta,
	   c.FechaCreacionCuenta
from Cuenta c inner join Persona p
			  on c.IdPersona = p.IdPersona
			  inner join Sexo s
			  on p.IdSexo = s.IdSexo
where c.IdCuenta = 1;

call `sp_verCuentaPorID`(1);

# eliminar
delimiter $$
	create procedure `sp_eliminarCuenta`(in _idCuenta int)
    begin
		delete from Cuenta
        where IdCuenta = _idCuenta;
    end $$
delimiter ;

call `sp_eliminarCuenta`(1);

# mensajes -------------------------------------------------------------
# insertar 
delimiter $$
	create procedure `sp_insertarMensaje`(
		in _contenidoMensaje varchar(256),
        in _tipoMensaje varchar(100),
        in _idCuenta int
    )
    begin
		insert into Mensaje(
			ContenidoMensaje,
            FechaMensaje,
            CodTipoMensaje,
            IdCuenta
        ) 
        values(
			_contenidoMensaje,
            now(),
            (select CodTipoMensaje 
			from TipoMensaje
			where NombreTipoMensaje = _tipoMensaje),
            _idCuenta           
        );
    end $$
delimiter ;

select CodTipoMensaje 
from TipoMensaje
where NombreTipoMensaje = "Música";

call `sp_insertarTipoMensaje`("Programación");

select * 
from TipoMensaje;

call `sp_insertarMensaje`(
	'Hola mundo',
    'Programación',
    1
);

# ver mensajes
delimiter $$
	create procedure `sp_verTodosMensajesPorCuenta`(in _idCuenta int)
    begin
		select m.ContenidoMensaje,
		   m.FechaMensaje,
		   tm.NombreTipoMensaje,
		   c.NombreCuenta,
		   p.NombrePersona,
		   p.ApellidoPersona
		from TipoMensaje tm inner join Mensaje m
						on tm.CodTipoMensaje = m.CodTipoMensaje
						inner join Cuenta c 
						on m.IdCuenta = c.IdCuenta
						inner join Persona p
						on c.IdPersona = p.IdPersona
		where c.IdCuenta = _idCuenta;
end $$
delimiter ;

call `sp_verTodosMensajesPorCuenta`(1);

# eliminar mensaje 
delimiter $$
	create procedure `sp_eliminarMensaje`(in _idMensaje int)
    begin
		delete from mensajes 
        where IdMensaje = _idMensaje;
    end $$
delimiter ;

# reacciones ------------------------------------------------------------

CALL `idea`.`sp_insertarCuenta`(
	"linux",
	"ubuntu",
	"linus.contact@linux.com", 
	2
);

CALL `idea`.`sp_insertarPersona`(
	"Dennis",
	"Ritchie",
	'1941-09-09',
	1
);

CALL `idea`.`sp_insertarCuenta`(
	"langC",
	"lenguajeC",
	"dritchie22@gmail.com", 
	3
);

call `sp_verCuentaPorID`(3);

# insertar reaccion
delimiter $$
	create procedure `sp_reaccionarAMensaje`(
		in _idMensaje int,
        in _idCuenta int,
        in _idReaccion int
    )
    begin
		insert into CuentaReaccionMensaje(
			IdMensaje,
            IdCuenta,
            IdReaccion
        )
        values(
			_idMensaje,
            _idCuenta,
            _idReaccion
        );
    end $$ 
delimiter ;

select * from Cuenta;

call `sp_reaccionarAMensaje`(
	1,
    3,
    2
);

# ver

delimiter $$
	create procedure `sp_verCantidadReaccionesDeUnMensaje`(in _idMensaje int)
    begin
		select  r.NombreReaccion,
				count(crm.IdReaccion) Cantidad
		from CuentaReaccionMensaje crm inner join Reaccion r
							   on crm.IdReaccion = r.IdReaccion
                               inner join Mensaje m
                               on crm.IdMensaje = m.IdMensaje
		where m.IdMensaje = _idMensaje
		group by r.NombreReaccion;
    end $$
delimiter ;

call `sp_verCantidadReaccionesDeUnMensaje`(1);

# ver quienes han reaccionado?

delimiter $$
	create procedure `sp_verQuienReacciona`(in _idMensaje int)
    begin
		select p.NombrePersona,
	   p.ApellidoPersona,
       r.NombreReaccion
		from CuentaReaccionMensaje crm inner join Mensaje m
									   on crm.IdMensaje = m.IdMensaje
									   inner join Cuenta c
									   on crm.IdCuenta = c.IdCuenta
									   inner join Reaccion r
									   on crm.IdReaccion = r.IdReaccion
									   inner join Persona p
									   on c.IdPersona = p.IdPersona
		where m.IdMensaje = _idMensaje;
    end $$
delimiter ;

select p.NombrePersona,
	   p.ApellidoPersona,
       r.NombreReaccion
from CuentaReaccionMensaje crm inner join Mensaje m
						   on crm.IdMensaje = m.IdMensaje
						   inner join Cuenta c
						   on crm.IdCuenta = c.IdCuenta
						   inner join Reaccion r
						   on crm.IdReaccion = r.IdReaccion
						   inner join Persona p
						   on c.IdPersona = p.IdPersona
where m.IdMensaje = 1;

# quitar reaccion
delimiter $$
	create procedure `sp_quitarReaccion`(in _idCuentaReaccionMensaje int)
    begin
		delete from CuentaReaccionMensaje
        where IdCuentaReaccionMensaje = _idCuentaReaccionMensaje;
    end $$
delimiter ;

# login ---------------------------------------------------------------
delimiter $$
	create procedure `sp_login`(
		in _nombreUsuario varchar(10),
        in _contra varchar(50)        
    )
    begin 
		select c.IdCuenta
        from Cuenta c inner join Persona p
					  on c.IdPersona = p.IdPersona
        where c.NombreCuenta = _nombreUsuario 
			  and c.Contra = md5(_contra);
    end $$
delimiter ;

select * from Cuenta;

call `sp_login`("srios", "movil1");

-- FIN DML ------------------------------------------------------------
