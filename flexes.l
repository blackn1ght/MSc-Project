/* Flex tokens */
%option noyywrap nodefault yylineno
%{
#include <string.h>
#include "flexes.h"
#include "flexes.tab.h"
#define SAVE_TOKEN yylval.s = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
//extern "C" int yywrap() { }
%}

%%
[ \t\n]+			; /* Whitespace, ignore */
"%"					printf("Just a comment, ignore the line.\n");
"question"			return TQUESTION;
"rule"			  	return TRULE;
"action"     		return TACTION;

"input"		  		return TINPUT;
"if"			    return TIF;
"and"			    return TAND;
"then"			  	return TTHEN;
"not"         		return TNOT;
"do"			    return TDO;
"ask"			    return TASK;
"because"		  	return TBECAUSE;
"write"       		return TWRITE;
"nl"				return TNEWLINE;
"end"				return TEND;	// Temporary to end the program. Not an actual keyword.
"becomes"			return TBECOMES;

">"					yylval.fn = 1; return CMP;
"<"					yylval.fn = 2; return CMP;
">="				yylval.fn = 3; return CMP;
"<="				yylval.fn = 4; return CMP;
"="					yylval.fn = 5; return CMP;
"is not"			yylval.fn = 6; return CMP;
"is"				yylval.fn = 7; return CMP;

"("			        return TLPAREN;
")"			        return TRPAREN;

"."					return TSTOP;
";"					return TQEND;

[0-9]+\.[0-9]*		    yylval.d = atof(yytext); return TNUMBER;
[0-9]+			        yylval.d = atof(yytext); return TNUMBER;
[a-zA-Z_][a-zA-Z0-9_]*	yylval.s = lookup(yytext); return TIDENTIFIER;

'(\\.|''|[^'\n])*'  |
\"(\\.|\"\"|[^"\n])*\"  yylval.s = lookup(yytext); return TSTRING;

.			            printf("Unknown token!\n"); yyterminate();

