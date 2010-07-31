/* Flex tokens */
%option noyywrap nodefault yylineno
%{
# include <string>
# include "flexes.h"
# include "flexhes.tab.h"
# include "parser.hpp"
# define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
# define TOKEN(t) (yylval.token = t)
extern "C" int yywrap() { }
%}

%%
[ \t\n]+			; /* Whitespace, ignore */
^%			; /* Comment, ignore */
"."			return TOKEN(TSTOP);
";"			return TOKEN(TQEND);


"^question"		{ yylval.fn = F_question; return TOKEN(TQUESTION); }
"^rule"			  { yylval.fn = F_rule; return TOKEN(TRULE); }
"^action"     { yylval.fn = F_action; return TOKEN(TACTION); }

"^input"		  return TOKEN(TINPUT);
"^if"			    return TOKEN(TIF);
"and"			    return TOKEN(TAND);
"then"			  return TOKEN(TTHEN);
"is"			    return TOKEN(TIS);
"not"         return TOKEN(TNOT);
"do"			    return TOKEN(TDO);
"ask"			    return TOKEN(TASK);
"because"		  return TOKEN(TBECAUSE);

"="			      { yylval.fn = 1; return TOKEN(CMP); }
">"			      { yylval.fn = 2; return TOKEN(CMP); }
"<"			      { yylval.fn = 3; return TOKEN(CMP); }
">="			    { yylval.fn = 4; return TOKEN(CMP); }
"<="			    { yylval.fn = 5; return TOKEN(CMP); }

"becomes"		  return TOKEN(TBECOMES);

"("			      return TOKEN(TLPAREN);
")"			      return TOKEN(TRPAREN);
[0-9]+\.[0-9]*		SAVE_TOKEN; return TDOUBLE;
[0-9]+			  SAVE_TOKEN; return TINTEGER;
[a-zA-Z_][a-zA-Z0-9_]*	SAVE_TOKEN; return TIDENTIFIER;

.			        printf("Unknown token!\n"); yyterminate();
%%

main(argc, argv)
int argc;
char **argv;
{
    if (argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
    }

    yylex();
    printf("\n\t-- FILE READ --\n");
}
