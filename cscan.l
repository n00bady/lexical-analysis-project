%option noyywrap
%{
    #include <stdio.h>

    int line_number = 1;
    void ret_print(char *token_type);
    void yyerror();
%}

%x M_Comments

white_space [ \t]*
digit [0-9]
alpha [A-Za-z_]
alpha_num ({alpha}|{digit})
hex 0x[0-9A-F]
hex_int ${hex}{hex}*
id {alpha}{alpha_num}*
un_int {digit}+
exp e[+-]?{digit}+
i {un_int}
real ({i}\.{i}?|{i}?\.{i}){exp}?
char '([^\r^\n^']|\\0)'
str \"(\\.|[^\\"])*\"

%%

"/*"                { BEGIN(M_Comments); } /* multi-line comments */
<M_Comments>"*/"    { BEGIN(INITIAL); }
<M_Comments>.       { }
<M_Comments>\n      { line_number++; }
"//".*      ret_print("COMMENT");   /* Single line comments */
^"#".*      ret_print("PREPROCESSOR");

    /* -=keywords=- */
auto        ret_print("AUTO");
break       ret_print("BREAK");
case        ret_print("CASE");
char        ret_print("CHAR");
const       ret_print("CONST");
continue    ret_print("CONTINUE");
default     ret_print("DEFAULT");
do          ret_print("DO");
double      ret_print("DOUBLE");
else        ret_print("ELSE");
enum        ret_print("ENUM");
extern      ret_print("EXTERN");
float       ret_print("FLOAT");
for         ret_print("FOR");
goto        ret_print("GOTO");
if          ret_print("IF");
int         ret_print("INT");
long        ret_print("LONG");
register    ret_print("REGISTER");
return      ret_print("RETURN");
short       ret_print("SHORT");
signed      ret_print("SIGNED");
sizeof      ret_print("SIZEOF");
static      ret_print("STATIC");
struct      ret_print("STRUCT");
switch      ret_print("SWITCH");
typedef     ret_print("TYPEDEF");
union       ret_print("UNION");
unsigned    ret_print("UNSIGNED");
void        ret_print("VOID");
volatile    ret_print("VOLATILE");
while       ret_print("WHILE");

    /* -=Constants=- */
[-+]?{digit}+   ret_print("DECIMAL");
{hex}+          ret_print("HEXADECIMAL");
{real}          ret_print("REAL");
{char}          ret_print("CHARACTER");
{str}           ret_print("STRING");
    /* -=Identifier=- */
{id}            ret_print("IDENTIFIER");

    /* -=Operators=- */
        /* -=Relational Operators=- */
"=="        ret_print("EQUAL_OPERATOR");
"!="        ret_print("NOT_EQUAL_OPERATOR");
">"         ret_print("GREATER_OPERATOR");
"<"         ret_print("LESSER_OPERATOR");
">="        ret_print("GREATER_EQUAL_OPERATOR");
"<="        ret_print("LESSER_EQUAL_OPERATOR");
        /* -=Arithmetic Operators=- */
"++"        ret_print("INCREMENT_OPERATOR");
"--"        ret_print("DECREMENT_OPERATOR");
"*"         ret_print("MULTIPLICATION_OPERATOR");
"+"         ret_print("ADDITION_OPERATOR");
"-"         ret_print("SUBTRACTION_OPERATOR");
"/"         ret_print("DIVISION_OPERATOR");
        /* -=Logical Operators=- */
"&&"        ret_print("LOGICAL_AND_OPERATOR");
"||"        ret_print("LOGICAL_OR_OPERATOR");
"!"         ret_print("LOGICAL_NOT_OPERATOR");
        /* -=Bitwise Operators=- */
"&"         ret_print("BITWISE_AND_OPERATOR");
"|"         ret_print("BITWISE_OR_OPERATOR");

    /* -=Punctuation=- */
"("         ret_print("(");
")"         ret_print(")");
","         ret_print(",");
"."         ret_print(".");
";"         ret_print(";");
"["         ret_print("[");
"]"         ret_print("]");
"{"         ret_print("{");
"}"         ret_print("}");
"="         ret_print("=");

    /* -=Empty lines and new lines=- */
{white_space}   { /* ignore white space */ }
\n              { line_number++; }
    /* -=Anything else=- */
.           { yyerror("Not defined!"); }

%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    yyout = fopen("output.txt", "w");
    if (yyin == NULL) {
        perror("Unable to open file!");
        exit(EXIT_FAILURE);
    }
    if (argc != 2) {
        perror("Give the input file as an argument.");
        exit(EXIT_FAILURE);
    }
    yylex();
    
    printf("------------");
    printf("\nTotal lines: %d\n", line_number-1);
    fclose(yyin);
    fclose(yyout);
    return 0;
}

void ret_print(char *token_type) {
    printf("%s\t%s\n", yytext, token_type);
    fprintf(yyout, "%s\t%s\n", yytext, token_type);
}

void yyerror(char *message) {
    fprintf(yyout, "Error: \"%s\" in line %d. Token = %s\n", message, line_number, yytext);
    exit(1);
}
