
output: lex.yy.o parser.o sds.o
	gcc lex.yy.o parser.o sds.o -o output

parser.c parser.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l
	flex lexer.l

lex.yy.o: lex.yy.c parser.h
	gcc -c lex.yy.c

parser.o: parser.c sds.h
	gcc -c parser.c

sds.o: sds.c sds.h sdsalloc.h
	gcc -c sds.c

clean:
	rm *.o lex.yy.c parser.c parser.h


