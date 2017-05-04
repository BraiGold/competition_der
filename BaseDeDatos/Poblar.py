#!/usr/bin/env python
import sqlite3
from random import seed, choice
import numpy.random as npr
seed(42)
npr.seed(42)

def generarPaises():

    listaPaises = ["Argentina",
                   "Canada",
                   "India",
                   "China",
                   "Somalia",
                   "Irlanda"] # a manopla

    return enumerate(listaPaises)

listaNombres = ["Drupada",
                "Xu2",
                "Dhrtarastra",
                "Padma",
                "Zi4"]

listaApellidos = ["Silva",
                  "Zhi4Lei2",
                  "Kelly",
                  "Reynolds",
                  "Qiu1"]

l = len(listaNombres)

def generarMaestro():

    return zip (range(l), listaNombres, listaApellidos,  range(1, l + 1), range(l))

def generarEscuela():

    return zip (range(l), range(l))

def generarEstudiante():

    #f = [1 for i in range(9)]
    f = "foto" #placeholder que no spammea 1s cuando hago print
    carac = [ (s, d, p, f, e)
            for s in ["M", "F"]
            for d in range(1, 7)
            for p in [50, 60]
            for e in range(len(list(generarEscuela())))]
    return [ (i, *rest) for i, rest in enumerate([ (n, a, *choice(carac))
                                                 for n in listaNombres
                                                 for a in listaApellidos])]

def generarParticipantes(est):

    part  = [ (e[0], *(npr.randint(10**7, 3*(10**7)),
                     "%d/%d/%d" % (npr.randint(1, 28), npr.randint(1, 13), 1980 + npr.randint(15))))
               for e in est]
    coaches = [ (e[0],) for e in est] #clave la coma -- tiene que ser una tupla, aunque sea de un solo valor
    return part, coaches

def generarCompetencia(cats):

    tipos = ["F", "C", "S", "R", "cE"]
    comps = [ (i, *r) for i, r in enumerate([ (c[0], 1, t)
                                             for t in tipos
                                             for c in cats[t]])]
    modalidades = [ map(lambda x: (x[0],), (filter(lambda c: c[-1] == t, comps))) for t in tipos]
    return comps, modalidades

def generarCategoria():

    i = 0
    FS = [ (i + j, *r) for j, r in enumerate([ (s, cE[0], cE[1]) for s in ["M", "F"] for cE in generarCatEdad()]) ]
    EC = list(map(lambda x: (x[0], x[2], x[3]), FS))
    i += len(FS)
    C = [ (i + j, *r) for j, r in enumerate([ (s, cE[0], cE[1], p[0], p[1]) for s in ["M", "F"]
                                             for cE in generarCatEdad()
                                             for p in generarCatPeso()]) ]
    EC += list(map(lambda x: (x[0], x[2], x[3]), C))
    PC = list(map(lambda x: (x[0], x[4], x[5]), C) )
    i += len(C)
    RcE = [ (i + j, *r) for j, r in enumerate([ (s,) for s in ["M", "F"] ]) ]
    i += len(RcE)
    def f(l):
        return list(map(lambda x: (x[0], x[1]), l))
    return { "F": f(FS), "S": f(FS), "C": f(C), "R": f(RcE), "cE": f(RcE) }, [EC, PC]

def generarCatDan():

    return [ v for v in range(1, 7)]

def generarCatEdad():

    return [ v for v in [(14, 17), (18, 35), (35, 100)]]

def generarCatPeso():

    return [ v for v in [(10 * i, 10 * i + 9) for i in range(5, 7) ]]

def generarArbitro():

    carac = [ (d, p[0])
            for d in range(1, 7)
            for p in generarPaises()]
    return [ (i, *rest) for i, rest in enumerate([ (n, a, *choice(carac))
                                                 for n in listaNombres
                                                 for a in listaApellidos])]

def generarEsArbPor(c, a, r):

    res = [ (C[0], a[0][0], r[0][0], "PresidenteDeMesa") for C in c ]
    res += [ (C[0], a[1][0], r[0][0], "Central") for C in c ]
    res += [ (C[0], A[0], r[0][0], "Suplente") for C in c for A in a[2:4] ]
    res += [ (C[0], a[5][0], r[0][0], "Juez") for C in c ]
    return res

def generarRing():

    return [ (i,) for i in range(6)]

def generarInscripciones(estudiantes, participantes, coaches, competencias,cat, catD):
    inscripciones = []
    individual = []
    grupal = []
    esintegrantede = []
    esen = []

    puestos_competencias = {}
    categorias = cat["F"] + cat["cE"] + cat["C"]
    # Individuales
    ultimo_id = 0
    for i in range(len(estudiantes)):
        for j in range(len(estudiantes)):
            if i == j or estudiantes[i][7] != estudiantes[j][7]:
                continue
            estudiante = estudiantes[j]
            edad_e = 2017 - int(participantes[i][2][-4:])
            competencia_i  =  0
            for x in competencias:
                categoria = categorias[x[1]]
                if categoria[1] != estudiante[3]:
                    continue
                salir = False
                for dan in []:
                    if categoria[0] == dan[0] and dan[1] != estudiante[4]:
                        salir = True
                    if salir: break
                if salir: continue
                for edad in catD[0]:
                    if categoria[0] == edad[0] and edad[1] <= edad_e <= edad[2]:
                        salir = True
                    if salir: break
                if salir: continue
                for peso in catD[1]:
                    if categoria[0] == peso[0] and peso[1] <= estudiante[5] <= peso[2]:
                        salir = True
                    if salir: break
                if salir: continue
                id_ = (i + j * len(estudiantes)) * len(competencias) + competencia_i
                inscripciones.append((id_, i, "I"))
                individual.append((id_, ))
                esintegrantede.append((estudiantes[i][0], id_, True))
                if (x[0], id_) not in puestos_competencias:
                    esen.append((x[0], id_, 1))
                    puestos_competencias[(x[0], id_)] = 2
                else:
                    esen.append((x[0], id_, puestos_competencias[(x[0], id_)]))
                    puestos_competencias[(x[0], id_, 1)] += 1
                ultimo_id = id_
                competencia_i += 1

    inscripciones.append((ultimo_id + 1, 1, "G"))
    grupal.append((ultimo_id + 1, ))
    esintegrantede.append((3, ultimo_id + 1, True))
    esintegrantede.append((8, ultimo_id + 1, True))
    esintegrantede.append((11, ultimo_id + 1, True))
    esintegrantede.append((12, ultimo_id + 1, True))
    esintegrantede.append((13, ultimo_id + 1, True))
    esintegrantede.append((16, ultimo_id + 1, False))
    esintegrantede.append((17, ultimo_id + 1, False))
    esintegrantede.append((21, ultimo_id + 1, False))
    esen.append((26, ultimo_id + 1, 1))

    return inscripciones, individual, grupal, esintegrantede, esen

flatten = lambda l: [item for sublist in l for item in sublist]


estudiantes = generarEstudiante()
part, coaches = generarParticipantes(estudiantes)
cat, catD = generarCategoria()
comp, mod = generarCompetencia(cat)
arb = generarArbitro()
rings = generarRing()
esAPor = generarEsArbPor(comp, arb, rings)
inscripciones,individual,grupal,esintegrantede,esen = generarInscripciones(estudiantes,part, coaches,comp,cat, catD)

conn = sqlite3.connect('DB.db')
c = conn.cursor()

c.executemany('insert into Pais values (?,?)', generarPaises())
conn.commit()

c.executemany('insert into Maestro values (?,?,?,?,?)', generarMaestro())
conn.commit()

c.executemany('insert into Escuela values (?,?)', generarEscuela())
conn.commit()

c.executemany('insert into Estudiante values (?,?,?,?,?,?,?,?)', estudiantes)
conn.commit()

c.executemany('insert into Participante values (?,?,?)', part)
conn.commit()

c.executemany('insert into Coach values (?)', coaches)
conn.commit()

c.executemany('insert into Competencia values (?,?,?,?)', comp)
conn.commit()

c.executemany('insert into CompetenciaFormas values (?)', mod[0])
conn.commit()

c.executemany('insert into CompetenciaCombate values (?)', mod[1])
conn.commit()

c.executemany('insert into CompetenciaSalto values (?)', mod[2])
conn.commit()

c.executemany('insert into CompetenciaRotura values (?)', mod[3])
conn.commit()

c.executemany('insert into CompetenciaCombatePorEquipos values (?)', mod[4])
conn.commit()

c.executemany('insert into Categoria values (?,?)', cat["F"])
conn.commit()

c.executemany('insert into Categoria values (?,?)', cat["C"])
conn.commit()

c.executemany('insert into Categoria values (?,?)', cat["cE"])
conn.commit()

c.executemany('insert into CategoriaEdad values (?,?,?)', catD[0])
conn.commit()

c.executemany('insert into CategoriaPeso values (?,?,?)', catD[1])
conn.commit()

c.executemany('insert into Arbitro values (?,?,?,?,?)', arb)
conn.commit()

c.executemany('insert into Ring values (?)', rings)
conn.commit()

c.executemany('insert into esArbitradaPor values (?,?,?,?)', esAPor)
conn.commit()

c.executemany('insert into inscripcion values(?,?,?)', inscripciones)
conn.commit()

c.executemany('insert into inscripcionindividual  values(?)', individual)
conn.commit()

c.executemany('insert into esintegrantede values(?,?,?)', esintegrantede)
conn.commit()

c.executemany('insert into esen values(?,?,?)', esen)
conn.commit()

