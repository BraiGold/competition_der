all:
	make BD

clean:
	rm -f DB.db 

poblar:
	python Poblar.py

generar:
	cat CrearDB.sql | sqlite3 --column --header DB.db

noBorrar:
	make generar && poblar

BD:
	make clean && make generar && make poblar
