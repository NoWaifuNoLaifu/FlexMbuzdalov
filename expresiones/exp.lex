/*Definiciones*/
%{
#include<stdio.h>
#include<string.h>
#include "y.tab.h"

#include "y.tab.h" 
 
%}

/*Seccion de reglas*/
%%
[a-zA-Z0-9]+ { yylval.a = yytext; return ALPHANUM ; } 
[\t]+ ; 
\n { return 0; } 

. { return yytext[0]; } 
%%


/*Codigo C*/

int yywrap(){
	return 1;
}