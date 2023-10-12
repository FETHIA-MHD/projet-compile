%{
 #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "machine.c"
     int nb_lignes=1;
typedef struct Tmaillon Tmaillon;
Tmaillon *tete;
%}

%option yylineno
KEYWORD PROGRAM|VAR|INT|BEGIN|IF|FUNCTION|END|ELSE|THEN|RETURN
OPERATEUR_ARRITHMETIQUE [+=|:=|-|+|/|%|=]
SEPARATEUR [;|:|,|(|)]
CONSTANT 0|1
INTEGER (-)?[0-9]*|[0-9]*
DOUBLE  (-)?[0-9]+([.][0-9]+)?|[0-9]+([.][0-9]+)?
CHAR ['][a-zA-Z][']
IDENTIFIANT ([a-zA-Z]|[0-9]|[_])*
ESPACE [ ]
SAUT_LIGNE \n
ERREUR [^(\n\s\r)]

%%

{ESPACE}        {}
{SAUT_LIGNE}    {nb_lignes++;}
{KEYWORD}    {AJOUTER_ENTITE(tete,yytext,"KEYWORD",strlen(yytext)*sizeof(yytext)/8);}
{SEPARATEUR}             {AJOUTER_ENTITE(tete,yytext,"SEPARATEUR",sizeof(yytext)/8);}
{CONSTANT}       {AJOUTER_ENTITE(tete,yytext,"CONSTANT",sizeof(yytext)/8);}
{OPERATEUR_ARRITHMETIQUE}  {AJOUTER_ENTITE(tete,yytext,"OPERATEUR_ARRITHMETIQUE",sizeof(yytext)/8);}
{INTEGER}  {AJOUTER_ENTITE(tete,yytext,"INTEGER",sizeof(atoi(yytext)));}
{DOUBLE}  {AJOUTER_ENTITE(tete,yytext,"DOUBLE",sizeof(atoi(yytext))*2);}
{CHAR} {AJOUTER_ENTITE(tete,yytext,"CHAR",1);}
{IDENTIFIANT}    {AJOUTER_ENTITE(tete,yytext,"IDENTIFIANT",strlen(yytext)*sizeof(yytext)/8);}
{ERREUR} { nb_lignes++;
printf("Erreur lexicale au niveau de \"%s\" , ligne %d.\n",yytext,yylineno);
exit(0); }
%%
int yywrap() {
return 1;}
int main()  {
    tete=CREATION_TABLE_SYMBOLES();
yylex();
AFFICHER_TABLE_SYMBOLES(tete);
}