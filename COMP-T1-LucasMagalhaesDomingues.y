
%{
#include<stdio.h>
#include<string.h>
#define YYSTYPE char *
FILE *yyout;
int i1 = 0;
%}

%union {
	char *str;
	int num;
}

/* declaracao de tokens */

%token CLASSE
%token PACKAGE
%token AUTHOR
%token TITLE
%token PARAGRAPH
%token CHAPTER SECTION SUBSECTION
%token BF UNDERLINE IT
%token ITEMMIZE
%token BEGINDOCUMENT ENDDOCUMENT
%token BEGINENUMERATE ENDENUMERATE
%token BEGINITEM ENDITEM
%token STRING
%token ABRECOLCHETE FECHACOLCHETE
%token EOL

%%

documento:	configuracao identificacao esqueleto
		;

configuracao:	classe pacote 
		| classe 
		;

classe: 	CLASSE ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "[//]: <> (classe: %s)\n", yylval); } 
		;

pacote: 	PACKAGE ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "[//]: <> (pacote: %s)\n", yylval); } 
		;

identificacao: titulo autor 
		| titulo 
		;

titulo: 	TITLE ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "#title %s\n", yylval); } 
		;

autor: 	AUTHOR ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "#author %s\n", yylval); } 
		;

esqueleto: 	inicio corpolista fim
		;

inicio: 	BEGINDOCUMENT EOL { fprintf(yyout, "[//]: <> (COMEÇO)\n\n"); } 
		;

corpolista: 	capitulo corpo secao corpo subsecao corpo 
		| corpo 
		;
		
fim: 		ENDDOCUMENT { fprintf(yyout, "[//]: <> (FIM)"); } 
		;
		
capitulo: 	CHAPTER ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "## %s\n\n", yylval); } 
		;

secao: 	SECTION ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "### %s\n\n", yylval); } 
		;

subsecao: 	SUBSECTION ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "#### %s\n\n", yylval); } 
		;

corpo: 	texto 
		| texto corpo 
		| textoEstilo corpo 
		| listas corpo 
		;

texto: 	PARAGRAPH ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "\n%s\n\n", yylval); } 
		;
    
textoEstilo: 	BF ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "**%s**\n", yylval); } 
		| UNDERLINE ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "%s\n", yylval); } 
       	| IT ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "*%s*\n", yylval); } 
       	;

listas: 	listaNumerada texto listaItens 
		| listaNumerada 
		| listaItens texto listaNumerada 
		| listaItens 
		;

listaNumerada: inicioenumerate itensLNumerada fimenumerate 
		;
		
listaItens: 	inicioitem itensLItens fimitem 
		;

inicioitem: 	BEGINITEM EOL 
		;

fimitem: 	ENDITEM EOL 
		;

inicioenumerate: BEGINENUMERATE EOL 
		 ;

fimenumerate: 	ENDENUMERATE EOL { i1=0; }
		;

itensLNumerada: itemN 
		| itemN itensLNumerada 
		;

itemN: 	ITEMMIZE ABRECOLCHETE STRING FECHACOLCHETE EOL { i1=i1+1 ; fprintf(yyout, "\n%d. %s", i1, yylval); } 
                ;

itensLItens: 	itemI 
		| itemI itensLItens 
		;

itemI:		ITEMMIZE ABRECOLCHETE STRING FECHACOLCHETE EOL { fprintf(yyout, "\n* %s", yylval); } 
        	;

%%

int main(int argc, char *argv[]){
    	extern FILE *yyin, *yyout;
   	yyin = fopen("Input.tex", "r");
   	yyout = fopen("Output.md", "w");
	return yyparse();
	}

int yyerror(char *s)
{
fprintf(stderr, "Atencao! erro no programa: %s\n", s);
}
