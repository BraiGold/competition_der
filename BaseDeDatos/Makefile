all: clean | poblar

clean:
	rm -f DB.db

poblar: triggers
	python Poblar.py

triggers: DB.db Triggers.sql
	sqlite3 --column --header DB.db < Triggers.sql
# Mientras que no arreglemos Poblar.py, comentar esta linea ^.

DB.db: CrearDB.sql
	cat CrearDB.sql | sqlite3 --column --header DB.db

