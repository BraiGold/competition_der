create table Fragancia (
idFragancia int not null,
nombre varchar(20),
idTipo int not null,
Primary Key (idFragancia)
);

create table TipoFragancia (
idTipo int not null,
nombre varchar(20),
Primary Key (idTipo)
);

create table MateriaPrima (
idMateriaPrima int not null,
nombre varchar(20),
precio int,
idProveedor int not null,
Primary Key (idMateriaPrima, idProveedor)
);

create table Proveedor (
idProveedor int not null,
nombre varchar(20),
Primary Key (idProveedor)
);

create table CompuestoCon (
idFragancia int not null,
idMateriaPrima int not null,
cantidad int,
Primary Key (idMateriaPrima, idFragancia)
);
