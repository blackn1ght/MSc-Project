/* Flex tokens */
%%
"rule"		{ printf("RULE: "); }
"if"		{ printf("IF\n"); }
"is"		{ printf("IS\n"); }
"the"		{ printf("THE\n"); }
"then"		{ printf("THEN\n"); }
"question"	{ printf("QUESTION: "); }
"ask "		{ printf("ASK\n"); }
"group"		{ printf("GROUP\n"); }
"unknown"	{ printf("UNKNOWN\n"); }
"and"		{ printf("AND\n"); }
"."		{ printf("END\n"); }
\n		{ }
[ \t]		{ }
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
