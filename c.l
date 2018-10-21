
%{
#include <stdio.h>
#include<stdlib.h>
#include <string.h>
#include "y.tab.h"

%}

alpha [a-zA-Z]
string ["][.]+["]
digit [0-9]
fs [%d  | %s | %c]

%%


^"#include".+  {}
[" "]     ;
[ \t]		;
[ \n]   { yylineno = yylineno + 1;
	//printf("new line");
	 }
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;

int	{yylval.f=strdup(yytext);return INT;}
float return FLOAT;
string {yylval.f=strdup(yytext);return CHAR;}
"{"  {yylval.f=strdup(yytext);return F1;}
"}"  {yylval.f=strdup(yytext);return F2;}
";"  {yylval.f=strdup(yytext);return SC;}
"*" {return yytext[0];}
"'" {return yytext[0];}
"," {printf("cama\n",yytext); return yytext[0];}
stripall { yylval.f=strdup(yytext); printf("istr%s\n",yytext);return STRIPALL;} 
strip { yylval.f=strdup(yytext); printf("istr%s\n",yytext);return STRIP;} 
"-" {return yytext[0];}
"/" {return yytext[0];}
"<" {yylval.f=strdup(yytext);return LT;}
">" {yylval.f=strdup(yytext);return GT;}
"<=" {yylval.f=strdup(yytext);return LE;}
">=" {yylval.f=strdup(yytext);return GE;}
"==" {yylval.f=strdup(yytext);return DE;}
"!=" {yylval.f=strdup(yytext);return NE;}
if   {yylval.f=strdup(yytext);return IF;}
else  {yylval.f=strdup(yytext);return ELSE;}
printf {yylval.f=strdup(yytext);return PRINTF;}
"@" {yylval.f=strdup(yytext);return SSTRING;}

[\"][.]*{fs}+[.]*[\"] {yylval.f=strdup(yytext);return INPRINT1;}


([\,]{alpha}+)* {yylval.f=strdup(yytext);return INPRINT2;}



double return DOUBLE;
[=]      {yylval.f=strdup(yytext); return EQ;} 
[+]      {yylval.f=strdup(yytext);return PLUS;} 


{digit}+       {yylval.f=strdup(yytext); return num;} 
({alpha}({alpha}|{digit})*) {yylval.f=strdup(yytext); return id;}
[']({alpha}({alpha}|{digit})*)['] {yylval.f=strdup(yytext); return qchar;}
(({alpha}({alpha}|{digit})*)+[,]*)+  { yylval.f=strdup(yytext); printf("iii%s\n",yytext);return idlist;} 

.       return yytext[0];

%%

int yywrap() { return 1;}


