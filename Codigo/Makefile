lex.yy.c: procesador.lex
	flex procesador.lex

procesador: lex.yy.c
	gcc lex.yy.c -lfl -o procesador

exe: procesador
	@./procesador "../Ficheros de prueba/ejemplo_jugadores.txt"

clean:
	@rm -f *.c
	@rm -f pruebas
