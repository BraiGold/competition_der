
CREATE TRIGGER individualUnParticipante AFTER INSERT ON esIntegranteDe
    BEGIN
        Select Raise(Rollback, "Una inscripción individual solo puede tener un participante.")
        Where Exists (
          select 1
          from inscripcionindividual i, esintegrantede e
          where i.idinscripcion = e.idinscripcion
          group by e.idinscripcion
          having count(e.numcertificado) != 1);
    END;

CREATE TRIGGER combatePorEquiposAceptaGrupos AFTER INSERT ON esEn
    BEGIN
        Select Raise(Rollback, "Combate por equipos solo acepta grupos.")
        Where Exists (
          select 1
          from competenciacombateporequipos c, inscripcion i, esen e
          where c.idcompetencia =e.idcompetencia and
                      i.idinscripcion = e.idinscripcion and
                (select count(e2.numcertificado)
                 from esintegrantede e2
                 where i.idinscripcion = e2.idinscripcion) != 8);
    END;

CREATE TRIGGER combateAceptaUnParticipante AFTER INSERT ON esEn
    BEGIN
        Select Raise(Rollback, "Combate solo acepta individuales.")
        Where Exists (
          select 1
          from competenciacombate c, inscripcion i, esen e
          where c.idcompetencia =e.idcompetencia and
                      i.idinscripcion = e.idinscripcion and
                (select count(e2.numcertificado)
                 from esintegrantede e2
                 where i.idinscripcion = e2.idinscripcion) != 1);
    END;

CREATE TRIGGER formasAceptaUnParticipante AFTER INSERT ON esEn
    BEGIN
        Select Raise(Rollback, "Formas solo acepta individuales.")
        Where Exists (
          select 1
          from competenciaformas c, inscripcion i, esen e
          where c.idcompetencia =e.idcompetencia and
                      i.idinscripcion = e.idinscripcion and
                (select count(e2.numcertificado)
                 from esintegrantede e2
                 where i.idinscripcion = e2.idinscripcion) != 1);
    END;

CREATE TRIGGER roturaAceptaUnParticipante AFTER INSERT ON esEn
    BEGIN
        Select Raise(Rollback, "Rotura solo acepta individuales.")
        Where Exists (
          select 1
          from competenciarotura c, inscripcion i, esen e
          where c.idcompetencia =e.idcompetencia and
                      i.idinscripcion = e.idinscripcion and
                (select count(e2.numcertificado)
                 from esintegrantede e2
                 where i.idinscripcion = e2.idinscripcion) != 1);
    END;

CREATE TRIGGER saltoAceptaUnParticipante AFTER INSERT ON esEn
    BEGIN
        Select Raise(Rollback, "Salto solo acepta individuales.")
        Where Exists (
          select 1
          from competenciasalto c, inscripcion i, esen e
          where c.idcompetencia =e.idcompetencia and
                      i.idinscripcion = e.idinscripcion and
                (select count(e2.numcertificado)
                 from esintegrantede e2
                 where i.idinscripcion = e2.idinscripcion) != 1);
    END;


CREATE TRIGGER individualEsTitular AFTER INSERT ON esIntegranteDe
    BEGIN
        Select Raise(Rollback, "En una inscripcion individual, su participante debe ser titular.")
        Where Exists (
          select 1
          from inscripcionindividual i, esintegrantede e
          where i.idinscripcion = e.idinscripcion and not e.estitular);
    END;
