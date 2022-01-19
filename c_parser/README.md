## C Language Scanner
This is a simple C language scanner built with flex for a class project.

What the files are:
* `cscan.l` - the flex file to build the scanner.
* `test.c`  - a random program I wrote in C for testing the scanner.
* `lex.yy.c` - automaticaly generated by flex, the C code for the scanner.
* `a.out`   - default name that the gcc use as output, the executable binary for the scanner.

## Build
`flex cscan.l && gcc lex.yy.c -lfl`

## Run
`./a.out test.c`