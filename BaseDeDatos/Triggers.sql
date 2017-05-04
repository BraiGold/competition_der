CREATE TRIGGER mismaEscuela AFTER INSERT ON esIntegranteDe
    BEGIN
        Select Raise(Rollback, "Tanto los participantes como el coach deben ser de la misma escuela.")
        Where Exists (Select 1 From esIntegranteDe eid, Estudiante e, (Select es.idEscuela id From Estudiante es
                Where es.numCertificado = new.numCertificado) esc
                Where new.idInscripcion = eid.idInscripcion And e.numCertificado = eid.numCertificado
            And e.idEscuela != esc.id)
        Or Exists (Select 1 From Inscripcion i, Estudiante e, (Select es.idEscuela id From Estudiante es
                Where es.numCertificado = new.numCertificado) esc
                Where new.idInscripcion = i.idInscripcion And 
                i.idCoach = e.numCertificado
            And e.idEscuela != esc.id);
    END;

CREATE TRIGGER unSoloTeam AFTER INSERT ON esIntegranteDe
    BEGIN
        Select Raise(Rollback, "Un participante no puede estar en más de un equipo.")
        Where Exists (Select 1 From Inscripcion i Where i.idInscripcion = new.idInscripcion And 
            i.GrupalOIndividual = "G") And 
        Exists (Select 1 From esIntegranteDe eid, Inscripcion i 
                Where eid.numCertificado = new.numCertificado And new.idInscripcion != eid.idInscripcion
                And i.idInscripcion = eid.idInscripcion And i.GrupalOIndividual = "G");
    END;

--CREATE TRIGGER noSelfCoach AFTER INSERT ON esIntegranteDe
--    BEGIN
--        Select Raise(Rollback, "Un participante no puede coachearse a sí mismo.")
--        Where Exists (Select 1 From Inscripcion i, Estudiante e
--                Where new.idInscripcion = i.idInscripcion And 
--                i.idCoach = e.numCertificado
--            And e.numCertificado = new.numCertificado);
--    END;

CREATE TRIGGER categoriaCorrectaCombate AFTER INSERT ON Competencia
    BEGIN
        Select Raise(Rollback, "Las categorías de una competencia de Combate deben ser: Peso, Edad, Género y Graduación.")
        From Categoria c
        Where new.tipo = "C" And
        (c.idCategoria not in (Select cP.idCategoria From CategoriaPeso cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaEdad cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaDan cP));
    END;

CREATE TRIGGER categoriaCorrectaFormas AFTER INSERT ON Competencia
    BEGIN
        Select Raise(Rollback, "Las categorías de una competencia de Formas deben ser: Edad, Género y Graduación.")
        From Categoria c
        Where new.tipo = "F" And
        (c.idCategoria in (Select cP.idCategoria From CategoriaPeso cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaEdad cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaDan cP));
    END;

CREATE TRIGGER categoriaCorrectaSalto AFTER INSERT ON Competencia
    BEGIN
        Select Raise(Rollback, "Las categorías de una competencia de Salto deben ser: Edad, Género y Graduación.")
        From Categoria c
        Where new.tipo = "S" And
        (c.idCategoria in (Select cP.idCategoria From CategoriaPeso cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaEdad cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaDan cP));
    END;

CREATE TRIGGER categoriaCorrectaRotura AFTER INSERT ON Competencia
    BEGIN
        Select Raise(Rollback, "Las categorías de una competencia de Rotura deben ser: Género y Graduación.")
        From Categoria c
        Where new.tipo = "R" And
        (c.idCategoria in (Select cP.idCategoria From CategoriaPeso cP)
        Or c.idCategoria in (Select cP.idCategoria From CategoriaEdad cP)
        Or c.idCategoria not in (Select cP.idCategoria From CategoriaDan cP));
    END;

CREATE TRIGGER categoriaCorrectaCombatePorEquipos AFTER INSERT ON Competencia
    BEGIN
        Select Raise(Rollback, "La categoría de una competencia de Combate por Equipos debe ser por Género.")
        From Categoria c
        Where new.tipo = "cE" And
        (c.idCategoria in (Select cP.idCategoria From CategoriaPeso cP)
        Or c.idCategoria in (Select cP.idCategoria From CategoriaEdad cP)
        Or c.idCategoria in (Select cP.idCategoria From CategoriaDan cP));
    END;

CREATE TRIGGER cumpleConLaCategoria AFTER INSERT ON esIntegranteDe
    BEGIN
        Select Raise(Rollback, "El participante no cumple con las categorías de la competencia.")
        From Estudiante e, Participante p, Inscripcion i, esEn es, Competencia comp, Categoria c
        Where e.numCertificado = new.numCertificado And p.numCertificado = new.numCertificado 
        And new.idInscripcion = i.idInscripcion And i.idInscripcion = es.idInscripcion 
        And es.idCompetencia = comp.idCompetencia And comp.idCategoria = c.idCategoria
        And (e.genero != c.genero
        Or Exists (Select 1 From CategoriaPeso cP Where c.idCategoria = cP.idCategoria And 
                (cP.minimo > e.peso Or cP.maximo < e.peso))
        Or Exists (Select 1 From CategoriaEdad cP Where c.idCategoria = cP.idCategoria And 
                (cP.minima > (2017 - p.fechaDeNacimiento) Or cP.maxima < (2017 - p.fechaDeNacimiento)))
        Or Exists (Select 1 From CategoriaDan cP Where c.idCategoria = cP.idCategoria And 
                cP.dan != e.graduacion));
    END;
