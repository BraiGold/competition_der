--medallero por escuela
Select idEscBronces idEscuela, cantOros, cantPlatas, cantBronces from 
(select escuela.idEscuela idEscBronces , COUNT(broncesPorEsc.idEsc) cantBronces from Escuela
left join
(Select distinct  E.idEscuela idEsc , I.idInscripcion from esen
inner join inscripcion I on esen.idInscripcion = I.idInscripcion
inner join esIntegranteDe esIntDe on esIntDe.idInscripcion = I.idInscripcion
inner join Estudiante E on esIntDe.numCertificado = E.numCertificado
where esen.puesto = 3) broncesPorEsc
 
 on Escuela.idEscuela= broncesPorEsc.idEsc
 group by Escuela.idEscuela) bronces

 inner join
 (select escuela.idEscuela idEscPlatas , COUNT(platasPorEsc.idEsc) cantPlatas from Escuela
left join
(Select distinct  E.idEscuela idEsc , I.idInscripcion from esen
inner join inscripcion I on esen.idInscripcion = I.idInscripcion
inner join esIntegranteDe esIntDe on esIntDe.idInscripcion = I.idInscripcion
inner join Estudiante E on esIntDe.numCertificado = E.numCertificado
where esen.puesto = 2) platasPorEsc
 
 on Escuela.idEscuela= platasPorEsc.idEsc
 group by Escuela.idEscuela) platas
 
 on bronces.idEscBronces = platas.idEscPlatas
 
 inner join
 (select escuela.idEscuela idEscOros , COUNT(orosPorEsc.idEsc) cantOros from Escuela
left join
(Select distinct  E.idEscuela idEsc , I.idInscripcion from esen
inner join inscripcion I on esen.idInscripcion = I.idInscripcion
inner join esIntegranteDe esIntDe on esIntDe.idInscripcion = I.idInscripcion
inner join Estudiante E on esIntDe.numCertificado = E.numCertificado
where esen.puesto = 1) orosPorEsc
 
 on Escuela.idEscuela= orosPorEsc.idEsc
 group by Escuela.idEscuela) oros
 
 on oros.idEscOros=platas.idEscPlatas


--listado de arbitros por pais

select DISTINCT p.nombre pNom , A.nombre, A.apellido , A.numDePlaca placa from pais p
inner join arbitro A on p.idPais = a.idPais
order by pNom

--lista de arbitros que actuaron como central en la modalidad "combate"

select DISTINCT   A.nombre, A.apellido , A.numDePlaca placa  from esarbitradapor eap
inner join arbitro A on eap.numDeplacaArbitro = A.numDePlaca
inner join competencia  C on C.IdCompetencia = eap.idCompetencia

where C.tipo = 'C' and eap.funcionDelArbitro = 'Central'

--lista de equipos por pais
select DISTINCT P.nombre pNombre , Ig.nombre equipo  from pais P
inner join maestro M on M.idPais = P.idPais
inner join Escuela E on E.idMaestro = M.placaInstructor
inner join Estudiante Est on Est.idEscuela = E.idEscuela
inner join esintegrantede eid on est.numCertificado = eid.numCertificado
inner join Inscripcion I on I.idInscripcion = eid.idInscripcion
inner join Inscripciongrupal Ig on I.idInscripcion = Ig.idInscripcion

where I.grupaloIndividual ='G'
order by pNombre

