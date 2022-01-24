%{
/* C declarations */
#include <stdio.h>
#include <stdlib.h>

extern int line_number;
extern int yylex();
extern FILE *yyin;
extern char *yytext;
void yyerror(char *s);

%}
/* bison declarations/tokens */
%start start

%token AUTO BREAK CASE CONST CONTINUE DEFAULT DO ELSE ENUM EXTERN FOR GOTO IF
%token REGISTER RESTRICT RETURN SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF
%token UNION UNSIGNED VOLATILE WHILE

%token INTEGER HEX REAL CHARACTER
%token CHAR DOUBLE FLOAT INT LONG SHORT VOID

%token SEMICOLON COMMA O_SQ_BRACKET C_SQ_BRACKET O_CURLY_BRACES C_CURLY_BRACES 
%token O_PARENTHESIS C_PARENTHESIS

%token EQUAL_OPERATOR NOT_EQUAL_OPERATOR
%token GREATER_EQUAL_OPERATOR LESS_EQUAL_OPERATOR
%token GREATER_OPERATOR LESS_OPERATOR
%token AND_OPERATOR OR_OPERATOR
%token BINARY_LEFT_SHIFT_OPERATOR BINARY_RIGHT_SHIFT_OPERATOR

%token STRING IDENTIFIER

%%
/* da rulez */
start
     : declaration start
     | function start
     |
     ;

declaration
    : type_list assignment SEMICOLON
    | assignment SEMICOLON
    | function_call SEMICOLON
    | array SEMICOLON
    | type_list array SEMICOLON
    ;

type_list
    : CHAR
    | DOUBLE
    | FLOAT
    | INT
    | LONG
    | SHORT
    | VOID
    ;    

assignment
    : IDENTIFIER '=' assignment { printf("Simple assignment found!\n"); }
    | IDENTIFIER '=' function_call
    | IDENTIFIER '=' array
    | array '=' assignment
    | IDENTIFIER COMMA assignment
    | IDENTIFIER '+' assignment
    | IDENTIFIER '-' assignment
    | IDENTIFIER '*' assignment
    | IDENTIFIER '/' assignment
    | '\'' assignment '\''
    | O_PARENTHESIS assignment C_PARENTHESIS
    | '-' IDENTIFIER
    | IDENTIFIER
    | INTEGER
    | HEX
    | REAL
    | CHARACTER
    ;

array
    : IDENTIFIER O_SQ_BRACKET assignment C_SQ_BRACKET
    |
    ;

function_call
    : IDENTIFIER O_PARENTHESIS parameter_list C_PARENTHESIS SEMICOLON { printf("Found a function call!"); }
    ;

function
    : type_list IDENTIFIER O_PARENTHESIS parameter_list C_PARENTHESIS body 
    ;

body
    : O_CURLY_BRACES statement_list return_statement C_CURLY_BRACES
    ;

statement_list
    : statement_list statement
    |
    ;

statement
    : declaration
    | for_statement
    | if_statement
    | while_statement
    | return_statement
    ;

parameter_list
    : parameter_list COMMA param
    | param
    | expression
    ;

param
    : type_list IDENTIFIER
    | STRING
    | assignment
    |
    ;

for_statement
    : FOR O_PARENTHESIS expression SEMICOLON expression SEMICOLON expression C_PARENTHESIS statement
    | FOR O_PARENTHESIS expression SEMICOLON expression SEMICOLON expression C_PARENTHESIS body
    | FOR O_PARENTHESIS expression C_PARENTHESIS statement
    | FOR O_PARENTHESIS expression C_PARENTHESIS body
    ;

if_statement
    : IF O_PARENTHESIS expression C_PARENTHESIS statement
    ;

while_statement
    : WHILE O_PARENTHESIS expression C_PARENTHESIS body 
    ;

expression
    : expression GREATER_OPERATOR expression
    | expression LESS_OPERATOR expression
    | expression GREATER_EQUAL_OPERATOR expression
    | expression LESS_EQUAL_OPERATOR expression
    | expression EQUAL_OPERATOR expression
    | expression NOT_EQUAL_OPERATOR expression
    | parameter_list
    | assignment
    | array
    | function_call
    |
    ;

return_statement
    : RETURN expression SEMICOLON
    |
    ;

%%

/* C code */
int main(int arc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Unable to open file!");
        exit(1);
    }
    yyparse();

    fclose(yyin);
    return 0;
}

void yyerror(char *s) {
    printf("Error on line %d:\t %s\n", line_number, s);
    printf("last token: %s\n", yytext);
    exit(1);
}
