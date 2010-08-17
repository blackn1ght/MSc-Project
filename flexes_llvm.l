/* Flex tokens */
%option noyywrap nodefault yylineno
%{
#include <string.h>
#include "node.h"
# include "parser.hpp"
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
extern "C" int yywrap() { }
%}

%%
[ \t\n]+			; /* Whitespace, ignore */
^%					; /* Comment, ignore */
"."					return TOKEN(TSTOP);
";"					return TOKEN(TQEND);


"^question"			return TOKEN(TQUESTION);
"^rule"			  	return TOKEN(TRULE);
"^action"     		return TOKEN(TACTION);

"^input"		  	return TOKEN(TINPUT);
"^if"			    return TOKEN(TIF);
"and"			    return TOKEN(TAND);
"then"			  	return TOKEN(TTHEN);
"not"         		return TOKEN(TNOT);
"do"			    return TOKEN(TDO);
"ask"			    return TOKEN(TASK);
"because"		  	return TOKEN(TBECAUSE);
"write"       		return TOOKEN(TWRITE);

"="			      	{ yylval.fn = 1; return CMP; }
">"			      	{ yylval.fn = 2; return CMP; }
"<"			      	{ yylval.fn = 3; return CMP; }
">="			    { yylval.fn = 4; return CMP; }
"<="			    { yylval.fn = 5; return CMP; }
"is"          		{ yylval.fn = 6; return CMP; }

"="					return TOKEN(TEQUAL);
"is"				return TOKEN(TIS);
"becomes"			return TOKEN(TBECOMES);
"not"				return TOKEN(TNOT);
"<"					return TOKEN(TCLT);
">"					return TOKEN(TCGT);
"<="				return TOKEN(TCLE);
">="				return TOKNE(TCGE);
"("			        return TOKEN(TLPAREN);
")"			        return TOKEN(TRPAREN);

[0-9]+\.[0-9]*		    { SAVE_TOKEN; return TDOUBLE; }
[0-9]+			        { SAVE_TOKEN; return TINTEGER; }
[a-zA-Z_][a-zA-Z0-9_]*	{ SAVE_TOKEN; return TIDENTIFIER; }

'(\\.|''|[^'\n])*'  |
\"(\\.|\"\"|[^"\n])*\"  { yylval.s = lookup(yytext); return TSTRING; }

.			            printf("Unknown token!\n"); yyterminate();
%%

