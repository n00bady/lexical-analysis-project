%option noyywrap
%{
    #include <stdio.h>

    #include "parser.tab.h"

    int line_number = 1;
    void yyerror();
%}

%x M_Comments

white_space [ \t]*
digit [0-9]
alpha [A-Za-z_]
alpha_num ({alpha}|{digit})
hex 0x[0-9A-F]
id {alpha}{alpha_num}*
un_int {digit}+
exp e[+-]?{digit}+
i   {un_int}
real ({i}\.{i}?|{i}?\.{i}){exp}?
char '([^\r^\n^']|\\0)'
str \"(\\.|[^\\"])*\"

%%

"/*"                { BEGIN(M_Comments); } /* eat multi-line comments */
<M_Comments>"*/"    { BEGIN(INITIAL); }
<M_Comments>.       { }
<M_Comments>\n      { line_number++; }
"//".*      { /* eat single line comment */}
^"#".*       

    /* -=keywords=- */
auto        { return(AUTO); }
_Bool       { return(BOOL); }
break       { return(BREAK); }
case        { return(CASE); }
char        { return(CHAR); }
const       { return(CONST); }
continue    { return(CONTINUE); }
_Complex    { return(COMPLEX); }
default     { return(DEFAULT); }
do          { return(DO); }
double      { return(DOUBLE); }
else        { return(ELSE); }
enum        { return(ENUM); }
extern      { return(EXTERN); }
float       { return(FLOAT); }
for         { return(FOR); }
goto        { return(GOTO); }
if          { return(IF); }
_Imaginary  { return(IMAGINARY); }
inline      { return(INLINE); }
int         { return(INT); }
long        { return(LONG); }
register    { return(REGISTER); }
restrict    { return(RESTRICT); }
return      { return(RETURN); }
short       { return(SHORT); }
signed      { return(SIGNED); }
sizeof      { return(SIZEOF); }
static      { return(STATIC); }
struct      { return(STRUCT); }
switch      { return(SWITCH); }
typedef     { return(TYPEDEF); }
union       { return(UNION); }
unsigned    { return(UNSIGNED); }
void        { return(VOID); }
volatile    { return(VOLATILE); }
while       { return(WHILE); }

    /* -=Constants=- */
[-+]?{digit}+   { return(CONSTANT); }
{hex}+          { return(CONSTANT); }
{real}          { return(CONSTANT); }
{char}          { return(CONSTANT); }
{str}           { return(STRING_LITERAL); }
    /* -=Identifier=- */
{id}            { return(IDENTIFIER); }

    /* -=Operators=- */
        /* -=Relational Operators=- */
"=="        { return(EQUAL_OPERATOR); }
"!="        { return(NOT_EQUAL_OPERATOR); }
">"         { return('>'); }
"<"         { return('<'); }
">="        { return(GREATER_EQUAL_OPERATOR); }
"<="        { return(LESS_EQUAL_OPERATOR); }
        /* -=Arithmetic Operators=- */
"++"        { return(INCREMENT_OPERATOR); }
"--"        { return(DECREMENT_OPERATOR); }
"*"         { return('*'); }
"+"         { return('+'); }
"-"         { return('-'); }
"/"         { return('/'); }
"%"         { return('%'); }
        /* -=Logical Operators=- */
"&&"        { return(AND_OPERATOR); }
"||"        { return(OR_OPERATOR); }
"!"         { return('!'); }
        /* -=Bitwise Operators=- */
"&"         { return('&'); }
"|"         { return('|'); }
"<<"        { return(BINARY_LEFT_SHIFT_OPERATOR); }
">>"        { return(BINARY_RIGHT_SHIFT_OPERATOR); }
"~"         { return('~'); }
"^"         { return('^'); }

        /* -=Assignment Operators=- */
"="         { return('='); }
"+="        { return(ADD_ASSIGN); }
"-="        { return(SUB_ASSIGN); }
"*="        { return(MUL_ASSIGN); }
"/="        { return(DIV_ASSIGN); }
"%="        { return(MOD_ASSIGN); }
"<<="       { return(LEFT_ASSIGN); }
">>="       { return(RIGHT_ASSIGN); }
"&="        { return(AND_ASSIGN); }
"^="        { return(XOR_ASSIGN); }
"|="        { return(OR_ASSIGN); }

        /* -=Misc. Operators=- */
"->"        { return(POINTER_OPERATOR); }
    /* \&{id}        not needed that's what bison is for */
    /* \*{id}        not needed that's what bison is for */
"?"         { return('?'); }/* not sure how to handle this (bison) */
"..."       { return(ELLIPSIS); }

    /* -=Punctuation=- */
"("          
")"          
","          
"."          
";"          
"["          
"]"          
"{"          
"}"          

    /* -=Empty lines and new lines=- */
{white_space}   { /* ignore white space */ }
\n              { line_number++; }
    /* -=Anything else=- */
.           { yyerror("Not defined!"); }

%%
/*
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
}   */
