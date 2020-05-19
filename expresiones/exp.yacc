/*Seccion de definiciones*/
%{
	#include<stdio.h>
	int flag=0;
	int yylex();
	#define YYSTYPE char *
%}
%union {
    char *a;
    double d;
    int fn;
}

%token ALPHANUM 

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

/*Seccion de reglas*/
%%
E : '\n'  {
                        printf("\nComplete\n");
                        exit(1);
                      };

E:E '+' E {/*strcat($$,$1);*/ printf("Suma\n");}
|'-' E {/*strcat($$,$2);*/ printf("Cambio de signo\n");}
|E '-' E {/*strcat($$,$1);*/ printf("Resta\n");}
|E '*' E {printf("Multiplicacion\n");}
|E '/' E {printf("Division\n");}
|E'%'E {printf("Modulo\n");}
|'(' E ')' { printf("Encapsulación\n");}
| ALPHANUM { $$=$1; printf("variable: %s\n",$1);}

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
	}else{
		printf("\nExpresion invalida\n\n");
	}
}