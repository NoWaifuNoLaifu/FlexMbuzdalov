/*Seccion de definiciones*/
%{
	#include<stdio.h>
	int flag=0;
	int yylex();
	#define YYSTYPE char *
	int count=0;
%}


%token ALPHANUM 

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

/*Seccion de reglas*/
%%
T: E ;
E:E '+' T {count++; /*$$=$1+$3;*/ printf("\n%c \t\t %s\n",$1[0],$3);printf("\t+\n");}
|'-' E {count++;  printf("\n%s\n",$2);}
|E '-' T {count++; printf("\n%s\n",$1);}
|E '*' T {count++; printf("\n%s\n",$1);}
|E '/' T {count++; printf("\n%s\n",$1);}
|E'%'T {count++; printf("\n%s \n",$1);}
|'(' E ')' {count++; printf("\n%s\n",$2);}
| ALPHANUM {count++; $$=$1; printf("var: %s \t",$1);}

;
%%
/*Codigo en C*/
void yyerror(char *s) {
    fprintf(stderr, "yeet : %s\n" , s);
	flag=-1;
}
void main(){
	printf("\nIngresa una expresion aritmetica:\n");
	yyparse();
	if(flag==0){
		printf("\nExpresion aritmetica valida\n\n");
		printf("Counter de nodos: %d \n ",count);
	}else{
		printf("\nExpresion invalida\n\n");
	}
}