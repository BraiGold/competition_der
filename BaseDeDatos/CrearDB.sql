create table Pais (
idPais int not null,
nombre varchar(30),
Primary Key (idPais)
);

create table Maestro (
placaInstructor int not null,
nombre varchar(30),
apellido varchar(30),
graduacion int,
idPais int not null,
Primary Key (placaInstructor),
Foreign Key (idPais) References Pais(idPais)
);

create table Escuela (
idEscuela int not null,
idMaestro int not null,
Primary Key (idEscuela),
Foreign Key (idMaestro) References Maestro(placaInstructor)
);

create table Estudiante (
numCertificado int not null,
nombre varchar(30),
apellido varchar(30),
genero bool,
graduacion int,
peso int,
foto binary(9),
idEscuela int not null,
Primary Key (numCertificado),
Foreign Key (idEscuela) References Escuela(idEscuela)
);

create table Participante (
numCertificado int not null,
DNI int,
fechaDeNacimiento varchar(30),
Primary Key (numCertificado),
Foreign Key (numCertificado) References Estudiante(numCertificado)
);

create table Coach (
numCertificado int not null,
Primary Key (numCertificado),
Foreign Key (numCertificado) References Estudiante(numCertificado)
);

create table esIntegranteDe (
numCertificado int not null,
idInscripcion int not null,
esTitular bool,
Primary Key (numCertificado, idInscripcion),
Foreign Key (numCertificado) References Estudiante(numCertificado),
Foreign Key (idInscripcion) References Inscripcion(idInscripcion)
);

create table Inscripcion (
idInscripcion int not null,
idCoach int not null,
grupalOIndividual bool,
Primary Key (idInscripcion),
Foreign Key (idCoach) References Coach(numCertificado)
);

create table InscripcionIndividual (
idInscripcion int not null,
Primary Key (idInscripcion),
Foreign Key (idInscripcion) References Inscripcion(idInscripcion)
);

create table InscripcionGrupal (
idInscripcion int not null,
nombre varchar(30),
Primary Key (idInscripcion),
Foreign Key (idInscripcion) References Inscripcion(idInscripcion)
);

create table esEn (
idCompetencia int not null,
idInscripcion int not null,
puesto int,
Primary Key (idCompetencia, idInscripcion),
Foreign Key (idCompetencia) References Competencia(idCompetencia),
Foreign Key (idInscripcion) References Inscripcion(idInscripcion)
);

create table Competencia (
idCompetencia int not null,
idCategoria int not null,
cantidadDeArbitros int,
tipo varchar(30),
Primary Key (idCompetencia),
Foreign Key (idCategoria) References Categoria(idCategoria)
);

create table CompetenciaFormas (
idCompetencia int not null,
Primary Key (idCompetencia),
Foreign Key (idCompetencia) References Competencia(idCompetencia)
);

create table CompetenciaCombate (
idCompetencia int not null,
Primary Key (idCompetencia),
Foreign Key (idCompetencia) References Competencia(idCompetencia)
);

create table CompetenciaSalto (
idCompetencia int not null,
Primary Key (idCompetencia),
Foreign Key (idCompetencia) References Competencia(idCompetencia)
);

create table CompetenciaRotura (
idCompetencia int not null,
Primary Key (idCompetencia),
Foreign Key (idCompetencia) References Competencia(idCompetencia)
);

create table CompetenciaCombatePorEquipos (
idCompetencia int not null,
Primary Key (idCompetencia),
Foreign Key (idCompetencia) References Competencia(idCompetencia)
);

create table Categoria (
idCategoria int not null,
genero bool,
Primary Key (idCategoria)
);

create table CategoriaDan (
idCategoria int not null,
dan int,
Primary Key (idCategoria),
Foreign Key (idCategoria) References Categoria(idCategoria)
);

create table CategoriaEdad (
idCategoria int not null,
minima int,
maxima int,
Primary Key (idCategoria),
Foreign Key (idCategoria) References Categoria(idCategoria)
);

create table CategoriaPeso (
idCategoria int not null,
minimo int,
maximo int,
Primary Key (idCategoria),
Foreign Key (idCategoria) References Categoria(idCategoria)
);

create table Ring (
numeroDeRing int not null,
Primary Key (numeroDeRing)
);

create table Arbitro (
numDePlaca int not null,
nombre varchar(30),
apellido varchar(30),
graduacion int,
idPais int not null,
Primary Key (numDePlaca),
Foreign Key (idPais) References Pais(idPais)
);

create table esArbitradaPor (
idCategoria int not null,
numDePlacaArbitro int not null,
numeroDeRing int not null,
funcionDelArbitro varchar(30),
Primary Key (idCategoria, numDePlacaArbitro),
Foreign Key (idCategoria) References Categoria(idCategoria),
Foreign Key (numDePlacaArbitro) References Arbitro(numDePlacaArbitro),
Foreign Key (numeroDeRing) References Ring(numeroDeRing)
);
