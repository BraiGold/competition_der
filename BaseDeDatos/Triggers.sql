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
