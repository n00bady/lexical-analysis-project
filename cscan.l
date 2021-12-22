
%option noyywrap
%{
    #include <stdio.h>

    int line_number = 1;
    void ret_print(char *token_type);
    void yyerror();
%}

white_space [ \t]*
digit [0-9]
alpha [A-Za-z_]
alpha_num ({alpha}|{digit})
hex [0-9A-F]
hex_int ${hex}{hex}*
id {alpha}{alpha_num}*
un_int {digit}+
exp e[+-]?{digit}+
i {un_int}
real ({i}\.{i}?|{i}?\.{i}){exp}?
str \'([^'\n]|\'\')+\'

%%

    /* multi-line comments ??? */
"//".*      ret_print("COMMENT");
^"#".*      ret_print("PREPROCESSOR");

    /* -=keywords=- */
auto        ret_print("KEYWORD");
break       ret_print("KEYWORD");
case        ret_print("KEYWORD");
char        ret_print("KEYWORD");
const       ret_print("KEYWORD");
continue    ret_print("KEYWORD");
default     ret_print("KEYWORD");
do          ret_print("KEYWORD");
double      ret_print("KEYWORD");
else        ret_print("KEYWORD");
enum        ret_print("KEYWORD");
extern      ret_print("KEYWORD");
float       ret_print("KEYWORD");
for         ret_print("KEYWORD");
goto        ret_print("KEYWORD");
if          ret_print("KEYWORD");
int         ret_print("KEYWORD");
long        ret_print("KEYWORD");
register    ret_print("KEYWORD");
return      ret_print("KEYWORD");
short       ret_print("KEYWORD");
signed      ret_print("KEYWORD");
sizeof      ret_print("KEYWORD");
static      ret_print("KEYWORD");
struct      ret_print("KEYWORD");
switch      ret_print("KEYWORD");
typedef     ret_print("KEYWORD");
union       ret_print("KEYWORD");
unsigned    ret_print("KEYWORD");
void        ret_print("KEYWORD");
volatile    ret_print("KEYWORD");
while       ret_print("KEYWORD");

    /* -=operators=- */
"=="        ret_print("OPERATOR");
"++"        ret_print("OPERATOR");


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
