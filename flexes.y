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
%token <s> TIDENTIFIER TSTRING
%token <d> TNUMBER
%token <token> TBECOMES TNOT
%token <token> TLPAREN TRPAREN TCOMMA TNEWLINE
%token <token> TIF TRULE TQUESTION TACTION TINPUT TSTOP TQEND
%token <token> TAND TOR TTHEN TASK TBECAUSE TDO TWRITE TEND
%token <token> TPLUS TMINUS TMUL TDIV

%type <s> ident
%type <a> flexes expr
%type <a> program programs script stmts question_block
%type <a> stmt rule question action

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start flexes

%%

ident : TIDENTIFIER           		{ printf("flexes.y: identifier found.\n"); $$ = variable($1); }
      ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident TBECOMES ident   		{ $$ = newassign($1, $3); }
     | ident TBECOMES TSTRING		{ $$ = newassign($1, $3); }
     | ident CMP ident       		{ $$ = newcmp($2, $1, $3); }
     | ident CMP TSTRING		{ $$ = newcmp($2, $1, $3); }
     | TNUMBER				{ $$ = num($1); }
     | TSTRING				{ $$ = sentence($1); }
     | TEND				{  }
     | TAND expr                    	{  }
     | TASK ident			{  }
     | TLPAREN expr TRPAREN   		{  }
     | TWRITE TLPAREN ident TRPAREN 	{ $$ = dowrite($3); }	
     | TWRITE TLPAREN TSTRING TRPAREN	{ $$ = dowrite($3); }
     ;

stmt : expr 				{ $$ = newast('e', $1, NULL); }
     | TIF expr TTHEN expr		{ $$ = flow('i', $2, $4); }
     ;

stmts : stmt 				{ $$ = newast('s', $1, NULL); }
      | stmts stmt 			{ $$ = newast('S', $1, $2); }
      ;

action : TACTION ident stmts TSTOP 	{ $$ = function('a', $2, $3); }
       ;

rule : TRULE ident stmts TSTOP  	{ $$ = function('r', $2, $3); }
     ;

question_block : TSTRING TQEND TINPUT ident TQEND TBECAUSE TSTRING { $$ = question_block($1,$4,$7); }
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
