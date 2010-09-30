/* Flex tokens */
%option noyywrap nodefault yylineno
%{
#include <string.h>
#include "flexes.h"
#include "flexes.tab.h"
%}

%%
[ \t\n]+			; /* Whitespace, ignore */
"%".*				; /* comment, ignore */
"question"			return TQUESTION;
"rule"			  	return TRULE;
"action"     			return TACTION;

"input"		  		return TINPUT;
"if"			    	return TIF;
"and"			    	return TAND;
"or"                		return TOR;
"then"			  	return TTHEN;
"not"         			return TNOT;
"do"			   	return TDO;
"ask"			    	return TASK;
"because"		  	return TBECAUSE;
"write"       			return TWRITE;
"nl"				return TNL;
"run"				return TEND;	// Temporary to end the program. Not an actual keyword.
"becomes"			return TBECOMES;
"name"				return TNAME;
"number"			return TINUMBER;
"integer"			return TIINTEGER;
"group"             		return TGROUP;
"choose from"       		return TCHOOSE;

">"				yylval.fn = 1; return CMP;
"<"				yylval.fn = 2; return CMP;
">="				yylval.fn = 3; return CMP;
"<="				yylval.fn = 4; return CMP;
"="				yylval.fn = 5; return CMP;
"is not"			yylval.fn = 6; return CMP;
"is"				yylval.fn = 7; return CMP;

"("			        return TLPAREN;
")"			        return TRPAREN;

"."				return TSTOP;
";"				return TQEND;
","                 		return TCOMMA;

[0-9]+\.[0-9]*		    	yylval.d = atof(yytext); return TNUMBER;
[0-9]+			        yylval.d = atof(yytext); return TNUMBER;
[a-zA-Z_][a-zA-Z0-9_]*		yylval.s = lookup(yytext); return TIDENTIFIER;

'(\\.|''|[^'\n])*'  |
\"(\\.|\"\"|[^"\n])*\"  	yylval.s = lookup(yytext); return TSTRING;
.			        printf("Unknown token!\n"); yyterminate();


