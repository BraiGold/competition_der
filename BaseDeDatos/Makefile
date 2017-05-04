all:
	make BD

clean:
	rm -f DB.db

poblar:
	python Poblar.py

generar:
	cat CrearDB.sql | sqlite3 --column --header DB.db

noBorrar:
	make generar && make triggers && make poblar

triggers:
	sqlite3 --column --header DB.db < Triggers.sql
	sqlite3 --column --header DB.db < TriggersPrima.sql

BD:
	make clean && make noBorrar
