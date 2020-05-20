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
	char *nodoRaiz="";
	int f=0;
	char opr [40];
	char arg1[40];
	char arg2[40];
	char temp[7]={'0','1','2','3','4','5','6'};
	
%}


%token ALPHANUM 

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

/*Seccion de reglas*/
%%
T: E ;
E:E '+' T {count++; auxNeg=$$;   sprintf(aux,"Nivel %d: %c ->\t+\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$; 
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '+'; f++;}
|'-' T {count++;  sprintf(aux,"Nivel %d: neg  %s\n",count,auxNeg); arbol=concat(arbol, aux);  nodoRaiz=$$;
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '-'; f++;}
|E '-' T {count++; auxNeg=$$; sprintf(aux,"Nivel %d: %c ->\t-\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '-'; f++;}
|E '*' T {count++;auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t*\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '*'; f++;}
|E '/' T {count++;auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t/\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '/'; f++;}
|E'%'T {count++; auxNeg=$$;  sprintf(aux,"Nivel %d: %c ->\t%\t<- %s\n",count,$1[0],$3); arbol=concat(arbol, aux); nodoRaiz=$$;
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '%'; f++;}
|'(' E ')' {count++; sprintf(aux,"Nivel %d: %c ->\t(\t<- %s\n",count,$1[0],$2); arbol=concat(arbol, aux); nodoRaiz=$$;//printf("\n(%s)\n",$2); 
	if(f-1!=-1){arg1[f]=$1[0]; arg2[f]= temp[f];}
	else {arg1[f]=$1[0]; arg2[f]= $1[2]; } opr[f]= '('; f++;}
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
		printf("Op \t arg1 \t arg2 \n");
		
		for(int x=0; x<count; x++){
			if(opr[x]=='(' )
				printf(" %c) \t %c \t %c \n", opr[x], arg1[x], arg2[x]);
			else
				printf(" %c \t %c \t %c \n", opr[x], arg1[x], arg2[x]);
		}
		
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