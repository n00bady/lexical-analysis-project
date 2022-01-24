%{	
	#include "y.tab.h"  
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
%}
		
%option noyywrap
%option yylineno 
/*Maintains the current line as a global variable*/

/*Names*/

digit [0-9]
num	{digit}+
sign ("+"|"-")
signed {sign}{digit}+
identifier [a-zA-Z][a-zA-Z0-9]*
whitespace [ \t\n]

%% /*Rules*/

"extern" {printf("----|TYPE: %s\n", yytext); return EXTERN;}
"void" {printf("----|TYPE: %s\n", yytext); return VOID;}
"(" {printf("   --|SYMVOLO: %s\n", yytext); return LEFT_P;}
")" {printf("   --|SYMVOLO: %s\n", yytext); return RIGHT_P;}
";" {printf("   --|SYMVOLO: %s\n", yytext); return DELIM;}
"integer" {printf("----|TYPE: %s\n", yytext); return INTEGER;}
"boolean" {printf("----|TYPE: %s\n", yytext); return BOOLEAN;}
"string" {printf("----|TYPE: %s\n", yytext); return STRING;}
"," {printf("   --|SYMVOLO: %s\n", yytext); return COM;}
"&" {printf("   --|SYMVOLO: %s\n", yytext); return AMP;}
"begin" {printf("    -|LEKSI_KLIDI: %s\n", yytext); return BEGINN;}
"end" {printf("    -|LEKSI_KLIDI: %s\n", yytext); return ENDD;}
"{" {printf("   --|SYMVOLO: %s\n", yytext); return LEFT_C;}
"}" {printf("   --|SYMVOLO: %s\n", yytext); return RIGHT_C;}
"if" {printf("   -|LEKSI_KLIDI: %s\n", yytext); return IF;}
"else" {printf("   -|LEKSI_KLIDI: %s\n", yytext); return ELSE;}
"for" {printf("   -|LEKSI_KLIDI: %s\n", yytext); return FOR;}
"while" {printf("   -|LEKSI_KLIDI: %s\n", yytext); return WHILE;}
"=" {printf("   -|TELESTIS: %s\n", yytext); return SET;}
"return" {printf("   -|LEKSI_KLIDI: %s\n", yytext); return RETURN;}
"||" {printf("   -|TELESTIS: %s\n", yytext); return LOG_0;}
"&&" {printf("   -|TELESTIS: %s\n", yytext); return LOG_1;}
"!" {printf("   -|TELESTIS: %s\n", yytext); return LOG_2;}
"==" {printf("   -|TELESTIS: %s\n", yytext); return LOG_3;}
"!=" {printf("   -|TELESTIS: %s\n", yytext); return LOG_4;}
"<" {printf("   -|TELESTIS: %s\n", yytext); return LOG_5;}
">" {printf("   -|TELESTIS: %s\n", yytext); return LOG_6;}
"<=" {printf("   -|TELESTIS: %s\n", yytext); return LOG_7;}
">=" {printf("   -|TELESTIS: %s\n", yytext); return LOG_8;}
"+" {printf("   -|TELESTIS: %s\n", yytext); return ADD;}
"-" {printf("   -|TELESTIS: %s\n", yytext); return SUB;}
"*" {printf("   -|TELESTIS: %s\n", yytext); return MUL;}
"/" {printf("   -|TELESTIS: %s\n", yytext); return DIV;}
"%" {printf("   -|TELESTIS: %s\n", yytext); return MOD;}
"true" {printf("   --|BOOL: %s\n", yytext); return TRUE;}
"false" {printf("   --|BOOL: %s\n", yytext); return FALSE;}

{num} {printf("  |ARITHMOS: %s\n", yytext); yylval = atoi(yytext); return INT;}
{identifier} {printf("  |IDENT: %s\n", yytext); return IDENT;}
{whitespace} {}

%%