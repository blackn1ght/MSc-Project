/* Flex tokens */
%option noyywrap nodefault yylineno
%{
# include "flexes.h"
# include "flexhes.tab.h"
%}

%%
"rule"	|
"if"	|
"is"	|	
"the"   |	
"then"  |	
"question" |
"ask " |	
"group" |
"unknown" |
"and" |
"." { printf(yytext, "\n"); }	
[ \t]		{/* do nothing, whitespace */ }
[a-zA-Z]*";"	{ printf("QUESTION: %s\n", yytext); }
[a-zA-Z_]+	{ printf("%s\n", yytext); }
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
