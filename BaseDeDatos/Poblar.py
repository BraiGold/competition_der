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
            for s in [0, 1]
            for d in range(1, 7)
            for p in [(4 + i) * 10 for i in range(l)]
            for e in range(len(list(generarEscuela())))] 
    return [ (i, *rest) for i, rest in enumerate([ (n, a, *choice(carac))
                                                 for n in listaNombres
                                                 for a in listaApellidos])]

def generarParticipantes(est):

    inter = [ (npr.choice(["P", "C", "PC"]), e[0]) for e in est ]
    part  = [ (e, *(npr.randint(10**7, 3*(10**7)), 
                     "%d/%d/%d" % (npr.randint(1, 28), npr.randint(1, 13), 1980 + npr.randint(15))))
               for (v, e) in inter if ("P" in v) ]
    coaches = [ (e,) for (v, e) in inter if ("C" in v) ] #clave la coma -- tiene que ser una tupla, aunque sea
                                                         #de un solo valor
    return part, coaches

estudiantes = generarEstudiante()
part, coaches = generarParticipantes(estudiantes)

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
