
output: lex.yy.o y.tab.o
	gcc lex.yy.o y.tab.o -o Parser.exe

y.tab.c y.tab.h: bison.y
	bison -y -d bison.y

lex.yy.c: flex.l
	flex flex.l

lex.yy.o: lex.yy.c  y.tab.h
	gcc -c lex.yy.c

y.tab.o: y.tab.c
	gcc -c y.tab.c

clean:
	rm *.o *.tab.h *.tab.c lex.yy.c



