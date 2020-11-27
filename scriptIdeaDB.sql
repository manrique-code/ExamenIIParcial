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
