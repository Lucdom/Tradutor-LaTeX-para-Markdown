%option noyywrap

%{
#include "COMP-T1-LucasMagalhaesDomingues.tab.h"
%}

%%

"\\documentclass" 	{ return CLASSE; }
"\\usepackage" 	{ return PACKAGE; }
"\\title" 		{ return TITLE; }
"\\author" 		{ return AUTHOR; }
"\\begin{document}" 	{ return BEGINDOCUMENT; }
"\\end{document}" 	{ return ENDDOCUMENT; }
"\\chapter" 		{ return CHAPTER; }
"\\section" 		{ return SECTION; }
"\\subsection" 	{ return SUBSECTION; }
"\\paragraph" 		{ return PARAGRAPH; }
"\\bf" 		{ return BF; }
"\\underline" 		{ return UNDERLINE; }
"\\it"			{ return IT; }
"\\begin{enumerate}" 	{ return BEGINENUMERATE; }
"\\end{enumerate}" 	{ return ENDENUMERATE; }
"\\begin{itemize}"	{ return BEGINITEM; }
"\\item" 		{ return ITEMMIZE; }
"\\end{itemize}" 	{ return ENDITEM; }
\n 			{ return EOL; }
"{" 			{ return ABRECOLCHETE; }
"}" 			{ return FECHACOLCHETE; }
[ \t] 			;
[a-zA-Z0-9]+		{ yylval.str = strdup(yytext); return STRING; }
. 			{ printf("Caracter não reconhecido %s\n", yytext); }
%%
