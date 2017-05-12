  select  esc.idEscuela
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


  select ig.idinscripcion
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

  select c.idcompetencia
  from competencia c
  where not  (
    select count(e.idinscripcion)
    from esen e
    where e.idcompetencia = c.idcompetencia) >= 3;


select cc.idcompetencia
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


select cc.idcompetencia
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

select cc.idcompetencia
  from competencia cc
  where not (
    select count(e.numdeplacaarbitro)
    from esarbitradapor e
    where e.idcompetencia = cc.idcompetencia) >= (
    select c.cantidaddearbitros
    from competencia c
    where c.idcompetencia = cc.idcompetencia);
