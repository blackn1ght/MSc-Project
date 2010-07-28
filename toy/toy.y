%{
	#include "toy.h"
	NBlock *programBlock;	/* the top level root node of our final ast */
	
	extern int yylex();
	void yyerror(const char *s) {printf("ERROR: %s\n", s); }
%}

/* Represents the many different ways we can access our data */
%union {
	Node *node;
	NBlock *block;
}
