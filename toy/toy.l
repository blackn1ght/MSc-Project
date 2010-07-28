/* Tokens */
%option noyywrap nodefault yylineno
%{
# include "toy.h"
# include "toy.tab.h"
%}

%%

"rule"		|
"question" 	|
"action"	{ printf("Function: %s\n", yytext); }

[ \t]		{ /* whitespce, ignore */ }
.		{ printf("Mystery Characters, ignore.\n", yytext); }

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
	printf("\nFILE READ ...... DONE.\n");
}
