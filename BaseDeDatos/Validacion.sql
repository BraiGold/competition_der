  select  esc.idEscuela as "Escuelas que tienen menos de 1 coach cada 5 competidores."
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
              e.idescuela = esc.idescuela);


  select ig.idinscripcion as "Inscripciones grupales sin 5 titulares y 3 suplentes."
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
	        not e.estitular) = 3);

  select c.idcompetencia as "Competencias con menos de 3 participantes."
  from competencia c
  where not  (
    select count(e.idinscripcion)
    from esen e
    where e.idcompetencia = c.idcompetencia) >= 3;


select cc.idcompetencia as "Competencias sin exactamente un primer, segundo y tercer puesto."
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
  where e.idcompetencia = cc.idcompetencia and e.puesto = 3) = 1;


select cc.idcompetencia as "Competencias sin un Presidente de Mesa, un Árbitro Central, 2 Jueces y 3 Suplentes."
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
          e.funciondelarbitro = "Suplente") >= 3;

select cc.idcompetencia as "Competencias con menor cantidad de árbitros que la requerida por la categoría."
  from competencia cc
  where not (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia) >= (
    select c.cantidaddearbitros
    from competencia c
    where c.idcompetencia = cc.idcompetencia);
