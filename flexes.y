%{
# include <stdio.h>
# include <stdlib.h>
# include "flexes.h"
%}

%union {
	struct ast *a;
	double d;
	struct symbol *s;
	int fn;
}

/* The tokens */
%token <s> TIDENTIFIER TSTRING TNAME TINUMBER TIINTEGER
%token <d> TNUMBER
%token <token> TBECOMES TNOT
%token <token> TLPAREN TRPAREN TCOMMA TNEWLINE
%token <token> TIF TRULE TQUESTION TACTION TINPUT TSTOP TQEND
%token <token> TAND TOR TTHEN TASK TBECAUSE TDO TWRITE TEND
%token <token> TPLUS TMINUS TMUL TDIV

%type <s> ident
%type <a> flexes expr input comp
%type <a> program programs script stmts question_block
%type <a> rule question action

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start flexes

%%

/* Variables */
ident : TIDENTIFIER           		{ printf("flexes.y: identifier found.\n"); /*$$ = variable($1);*/ }
      ;

/* Comparisons */
comp : ident CMP ident       		{ $$ = newcmp($2, $1, $3); }
     | ident CMP TSTRING		{ $$ = newcmp($2, $1, $3); }
     | TNUMBER CMP TNUMBER		{ $$ = newcmp($2, $<s>1, $<s>3); }
     | TAND comp			{ }
     ;	

/* Expressions, such as value1 becomes value2, etc */
expr : TIF comp TTHEN expr		{ $$ = flow('i', $2, $4); }
     | ident TBECOMES ident   		{ $$ = newassign($1, $3); }
     | ident TBECOMES TSTRING		{ $$ = newassign($1, $3); }
     | TNUMBER				{ $$ = num($1); }
     | TSTRING				{ $$ = sentence($1); }
     | TEND				{  }
     | TAND expr                    	{  }
     | TASK ident			{  }
     | TLPAREN expr TRPAREN   		{  }
     | TWRITE TLPAREN ident TRPAREN 	{ $$ = dowrite($3); }	
     | TWRITE TLPAREN TSTRING TRPAREN	{ $$ = dowrite($3); }
     ;

stmts : expr				{ $$ = newast('s', $1, NULL); }
      | stmts expr			{ $$ = newast('S', $1, $2); }
      ;

/* Action block */
action : TACTION ident stmts TSTOP 	{ $$ = function('a', $2, $3); }
       ;

/* Rule block */
rule : TRULE ident stmts TSTOP  	{ $$ = function('r', $2, $3); }
     ;

input : TINPUT TNAME 			{ $$ = newast('i', $<a>2, NULL); }
      | TINPUT TINUMBER 		{ $$ = newast('i', $<a>2, NULL); }
      | TINPUT TIINTEGER 		{ $$ = newast('i', $<a>2, NULL); }
      | TINPUT ident			{ $$ = newast('i', $<a>2, NULL); }
      ;

question_block : TSTRING TQEND input TQEND TBECAUSE TSTRING { $$ = question_block($1,$3,$6); }
		;

question : TQUESTION ident question_block TSTOP		{ $$ = function('q', $2, $3); }
         ;

program : rule						{ $$ = newast('p', $1, NULL); }
        | question					{ $$ = newast('p', $1, NULL); }
        ;

programs : program 					{ $$ = newast('p', $1, NULL); }
         | programs program		 		{ $$ = newast('p', $1, $2); }
         ;

script: programs action      		{ $$ = newast('p', $1, $2); }
     ;

flexes: script				{ $$ = $1; return eval($1); }
	  ;
     
%%
