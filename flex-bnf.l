/* Flex tokens */
%%
"rule"		{ printf("RULE\n"); }
"if"		{ printf("IF\n"); }
"is"		{ printf("IS\n"); }
"the"		{ printf("THE\n"); }
"then"		{ printf("THEN\n"); }
"question"	{ printf("QUESTION\n"); }
"ask "		{ printf("ASK\n"); }
"group"		{ printf("GROUP\n"); }
"."		{ printf("END\n"); }
[ \t]		{ }
[a-zA-Z]+	{ printf("%s\n", yytext); }
%%
