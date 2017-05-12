all: clean | triggers

clean:
	rm -f DB.db

poblar: DB.db 
	python Poblar.py

triggers: DB.db poblar Triggers.sql
	sqlite3 --column --header DB.db < Triggers.sql

DB.db: CrearDB.sql
	sqlite3 DB.db < CrearDB.sql 

