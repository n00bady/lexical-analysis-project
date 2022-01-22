
output: lex.yy.o parser.tab.o
	gcc lex.yy.o parser.tab.o -o output

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: cscan.l
	flex cscan.l

lex.yy.o: lex.yy.c parser.tab.h
	gcc -c lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c parser.tab.c

clean:
	rm *.o *.tab.h *.tab.c lex.yy.c


