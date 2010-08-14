/* Flex tokens */
%option noyywrap nodefault yylineno
%{
# include <string.h>
# include "flexes.h"
# include "flexes.tab.h"
/*# include "parser.hpp"*/
# define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
# define TOKEN(t) (yylval.token = t)
%}

%%
[ \t\n]+			; /* Whitespace, ignore */
^%			; /* Comment, ignore */
"."			{ return TSTOP; }
";"			{ return TQEND; }


"^question"		{ yylval.fn = F_question; return TQUESTION; }
"^rule"			  { yylval.fn = F_rule; return TRULE; }
"^action"     { yylval.fn = F_action; return TACTION; }

"^input"		  { return TINPUT; }
"^if"			    { return TIF; }
"and"			    { return TAND; }
"then"			  { return TTHEN; }
"not"         { return TNOT; }
"do"			    { return TDO; }
"ask"			    { return TASK; }
"because"		  { return TBECAUSE; }
"write"       { return TWRITE; }

"="			      { yylval.fn = 1; return CMP; }
">"			      { yylval.fn = 2; return CMP; }
"<"			      { yylval.fn = 3; return CMP; }
">="			    { yylval.fn = 4; return CMP; }
"<="			    { yylval.fn = 5; return CMP; }
"is"          { yylval.fn = 6; return CMP; }

"becomes"		  { return TBECOMES; }

"("			                { return TLPAREN; }
")"			                { return TRPAREN; }
[0-9]+\.[0-9]*		      { yylval.d = atof(yytext); return TNUMBER; }
[0-9]+			            { yylval.d = atof(yytext); return TNUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*	{ yylval.s = lookup(yytext); return TIDENTIFIER; }

'(\\.|''|[^'\n])*'  |
\"(\\.|\"\"|[^"\n])*\"  { yylval.s = lookup(yytext); return TSTRING; }
.			                  { yyerror("Mystery Character, wtf?\n"); }
%%
/*
main(argc, argv)
int argc;
char **argv;
{
    if (argc > 1) {
        printf("File: ", argv[1], "\n");
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
    }

    yylex();
    printf("\n\t-- FILE READ --\n");
}
*/

