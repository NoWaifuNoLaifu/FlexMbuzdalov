/*Seccion de definiciones*/
%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	int flag=0;
	int yylex();
	#define YYSTYPE char *
	int count=0;
	char *arbol="";
	char aux[100];
	char *auxNeg="";
	char *arg1 = "";
	char *t = "t";
	char *t_act = "";
	char *snum[100];
	char *nodoRaiz="";
	char *temp_cuad[100];
%}


%token ALPHANUM 

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

/*Seccion de reglas*/
%%
T: E ;
E:E '+' T {count++; auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t+\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux);nodoRaiz=$$; sprintf(temp_cuad, "Cuad: OP : %s, Arg1 : %c, Arg2 : %s, Res : T%d","+",$1[0],$3,count);}
|'-' T {count++;  sprintf(aux,"Nivel %d: neg  %s\n",count,auxNeg); arbol=concat(arbol, aux);  nodoRaiz=$$;}
|E '-' T {count++; auxNeg=$$; sprintf(aux,"Nivel %d: %c ->\t-\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;}
|E '*' T {count++;auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t*\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;}
|E '/' T {count++;auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t/\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;}
|E'%'T {count++; auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t%\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;}
|'(' E ')' {count++; printf("\n(%s)\n",$2);}
| ALPHANUM { $$=$1; auxNeg=$$; printf("var: %s \t",$1);}

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
		printf("%s",arbol);
		count++;
		printf("Nivel %d: %s",count,nodoRaiz);
		printf("Counter de nodos: %d \n ",count);
		printf("temp_cuad : %s", temp_cuad);
		
	}else{
		printf("\nExpresion invalida\n\n");
	}
}

char* concat(const char *s1, const char *s2)
{
    char *result = malloc(strlen(s1) + strlen(s2) + 1); // +1 for the null-terminator
    // in real code you would check for errors in malloc here
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}
