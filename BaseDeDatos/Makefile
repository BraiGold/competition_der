all: clean | validar

clean:
	rm -f DB.db

validar: DB.db poblar triggers
	sqlite3 --column --header DB.db < Validacion.sql

poblar: DB.db triggers
	python Poblar.py

triggers: DB.db Triggers.sql
	sqlite3 --column --header DB.db < Triggers.sql

DB.db: CrearDB.sql
	sqlite3 DB.db < CrearDB.sql 

