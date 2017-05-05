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

CREATE TRIGGER unSoloRingPorArbitro AFTER INSERT ON esArbitradaPor
    BEGIN
        Select Raise(Rollback, "Un árbitro no puede arbtirar en más de un ring.")
        From esArbitradaPor eAP 
        Where eAP.numDePlacaArbitro = new.numDePlacaArbitro And eap.numeroDeRing != new.numeroDeRing;
    END;

CREATE TRIGGER noPuedeArbitrarMayorGraduacion AFTER INSERT ON esArbitradaPor
    BEGIN
        Select Raise(Rollback, "Un árbitro no puede arbitrar una categoría de mayor graduación que la suya.")
        From Competencia comp, CategoriaDan c, Arbitro a
        Where new.idCompetencia = comp.idCompetencia And a.numDePlaca = new.numDePlacaArbitro 
        And comp.idCategoria = c.idCategoria And a.graduacion <= c.dan;
    END;

CREATE TRIGGER sinModalidadesYCategoriasRepetidas AFTER INSERT ON Competencia
    BEGIN
        Select Raise(Rollback, "No puede haber dos competencias de igual modalidad y con categorías iguales .")
        From Competencia comp, Categoria cNew, Categoria cOtra
        Where new.idCompetencia != comp.idCompetencia And new.tipo = comp.tipo 
        And new.idCategoria = cNew.idCategoria And comp.idCategoria = cOtra.idCategoria 
        And cNew.genero = cOtra.genero
        And Not Exists (Select 1 From CategoriaPeso cPN, CategoriaPeso cPO Where cNew.idCategoria = cPN.idCategoria 
            And cOtra.idCategoria = cPO.idCategoria And cPN.minimo = cPO.minimo And cPN.maximo = cPO.maximo)
        And Not Exists (Select 1 From CategoriaEdad cEN, CategoriaEdad cEO Where cNew.idCategoria = cEN.idCategoria 
            And cOtra.idCategoria = cEO.idCategoria And cEN.minima = cEO.minima And cEN.maxima = cEO.maxima)
        And Not Exists (Select 1 From CategoriaDan cDN, CategoriaDan cDO Where cNew.idCategoria = cDN.idCategoria 
            And cOtra.idCategoria = cDO.idCategoria And cDN.dan = cDO.dan);
    END;

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


----------------------------------
-- Consultas ---------------------
----------------------------------

select not exists (
  select  1
  from escuela esc
  where not (
        select count(p.numcertificado)
        from participante p, estudiante e
        where p.numcertificado = e.numcertificado and
              e.idescuela = esc.idescuela)
      <= 5* (
        select count(c.numcertificado)
        from coach c, estudiante e
        where c.numcertificado = e.numcertificado and
              e.idescuela = esc.idescuela));


select not exists (
  select 1
  from inscripciongrupal ig
  where not (
    (select count(p.numcertificado)
    from participante p, esintegrantede e
    where e.numcertificado = p.numcertificado and
                e.idinscripcion = ig.idinscripcion and
                e.estitular) = 5 and (
    select count(p.numcertificado)
    from participante p, esintegrantede e
    where e.numcertificado = p.numcertificado and
                e.idinscripcion = ig.idinscripcion and
	        not e.estitular) = 3));

select not exists (
  select 1
  from competencia c
  where not  (
    select count(e.idinscripcion)
    from esen e
    where e.idcompetencia = c.idcompetencia) >= 3);


select (
  select count(e.idinscripcion)
  from esen e
  where e.idcompetencia = @idCompetencia and e.puesto = 1) = 1 and (
  select count(e.idinscripcion)
  from esen e
  where e.idcompetencia = @idCompetencia and e.puesto = 2) = 1 and (
  select count(e.idinscripcion)
  from esen e
  where e.idcompetencia = @idCompetencia and e.puesto = 3) = 1;


select not exists (
select 1
from competencia cc
where not (
  select count(e.idinscripcion)
  from esen e
  where e.idcompetencia = cc.idcompetencia and e.puesto = 1) = 1 and (
  select count(e.idinscripcion)
  from esen e
  where e.idcompetencia = cc.idcompetencia and e.puesto = 2) = 1 and (
  select count(e.idinscripcion)
  from esen e
  where e.idcompetencia = cc.idcompetencia and e.puesto = 3) = 1);


select not exists (
  select 1
  from competencia cc
  where not (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia and
          e.funciondelarbitro = "PresidenteDeMesa") >= 1 and (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia and
          e.funciondelarbitro = "Central") >= 1 and (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia and
          e.funciondelarbitro = "Juez") >= 2 and (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia and
          e.funciondelarbitro = "Suplente") >= 3);

select not exists (
  select 1
  from competencia cc
  where not (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia) >= (
    select c.cantidaddearbitros
    from competencia c
    where c.idcompetencia = cc.idcompetencia));
