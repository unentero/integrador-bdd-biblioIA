create database if not exists biblioia;
use biblioia;
create table Genero (
   id_genero int auto_increment,
   nombre varchar(100) not null,
   descripcion text,
   constraint pk_genero primary key (id_genero),
   constraint uq_genero_nombre unique (nombre)
);
create table Autor (
   id_autor int auto_increment,
   nombre varchar(100) not null,
   apellido varchar(100) not null,
   nacionalidad varchar(100),
   constraint pk_autor primary key (id_autor)
);
create table Socio (
   id_socio int auto_increment,
   dni varchar(20) not null,
   nombre varchar(100) not null,
   apellido varchar(100) not null,
   email varchar(150) not null,
   fecha_alta date not null,
   estado varchar(20) not null default 'activo',
   constraint pk_socio primary key (id_socio),
   constraint uq_socio_dni unique (dni),
   constraint uq_socio_email unique (email),
   constraint chk_socio_estado check (estado in ('activo', 'suspendido', 'baja'))
);
create table Libro (
   isbn varchar(20),
   titulo varchar(255) not null,
   anio_publicacion int,
   stock_total int not null default 0,
   stock_disponible int not null default 0,
   constraint pk_libro primary key (isbn),
   constraint chk_libro_stock check (stock_disponible >= 0 and stock_disponible <= stock_total)
);

create table Libro_Genero (
    isbn varchar(20) not null,
    id_genero int not null,
    primary key (isbn, id_genero),
    constraint fk_libro_genero_libro 
        foreign key (isbn) 
        references Libro (isbn) 
        on delete cascade,
    constraint fk_libro_genero_genero 
        foreign key (id_genero) 
        references Genero (id_genero) 
         on delete cascade
);
create table Autor_libro (
   id_autor int,
   isbn varchar(20),
   constraint pk_autor_libro primary key (id_autor, isbn),
   constraint fk_autor_libro_autor foreign key (id_autor)
       references Autor(id_autor) on delete cascade,
   constraint fk_autor_libro_libro foreign key (isbn)
       references Libro(isbn) on delete cascade
);
create table Ejemplar (
   id_ejemplar int auto_increment,
   isbn varchar(20) not null,
   nro_ejemplar int not null,
   estado_fisico varchar(20) not null default 'bueno',
   constraint pk_ejemplar primary key (id_ejemplar),
   constraint uq_ejemplar_numero unique (isbn, nro_ejemplar),
   constraint chk_ejemplar_estado check (estado_fisico in ('bueno', 'regular', 'reparacion', 'baja')),
   constraint fk_ejemplar_libro foreign key (isbn)
       references Libro(isbn) on update cascade on delete cascade
);
create table Prestamo (
   id_prestamo int auto_increment,
   id_socio int not null,
   id_ejemplar int not null,
   fecha_prestamo date not null,
   fecha_vencimiento date not null,
   fecha_devolucion date null,
   estado varchar(20) not null default 'activo',
   constraint pk_prestamo primary key (id_prestamo),
   constraint chk_prestamo_estado check (estado in ('activo', 'devuelto', 'vencido')),
   constraint fk_prestamo_socio foreign key (id_socio)
       references Socio(id_socio) on update cascade on delete restrict,
   constraint fk_prestamo_ejemplar foreign key (id_ejemplar)
       references Ejemplar(id_ejemplar) on update cascade on delete restrict
);
create table Sancion (
   id_sancion int auto_increment,
   id_socio int not null,
   tipo varchar(50) not null,
   fecha_inicio date not null,
   fecha_fin date not null,
   motivo text,
   constraint pk_sancion primary key (id_sancion),
   constraint fk_sancion_socio foreign key (id_socio)
       references Socio(id_socio) on update cascade on delete cascade
);


CREATE TABLE Auditoria_Prestamos (
   id_auditoria INT AUTO_INCREMENT,
   id_prestamo INT NOT NULL,    # ID del prestamo que fue cargado, actualizado o eliminado
   accion VARCHAR(10) NOT NULL, # Insert, update o delete
   fecha_hora DATETIME NOT NULL,
   usuario_bd VARCHAR(50) NOT NULL, #Usuario que ha realizado el cambio
   CONSTRAINT chk_accion CHECK (accion IN ('insert', 'update', 'delete')),
   CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria)
);




create index idx_socio_dni on Socio(dni);
create index idx_socio_email on Socio(email);
