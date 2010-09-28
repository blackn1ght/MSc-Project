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
%token <token> TBECOMES TNOT TGROUP
%token <token> TLPAREN TRPAREN TCOMMA TNL TCHOOSE
%token <token> TIF TRULE TQUESTION TACTION TINPUT TSTOP TQEND
%token <token> TAND TOR TTHEN TASK TBECAUSE TDO TWRITE TEND
%token <token> TPLUS TMINUS TMUL TDIV

%type <s> ident
%type <a> flexes expr input comp comps
%type <a> program programs script stmts question_block
%type <a> rule question action
%type <a> group groups group_choices

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start flexes

%%

/* Variables */
ident : TIDENTIFIER           		{ /*$$ = variable($1);*/ }
      ;

/* Comparisons */
comp : ident CMP ident       		{ $$ = newcmp($2, $1, $3); }
     | ident CMP TSTRING		{ $$ = newcmp($2, $1, $3); }
     | ident CMP TNUMBER        { $$ = newcmp($2, $1, $<s>3); }
     | TNUMBER CMP TNUMBER		{ $$ = newcmp($2, $<s>1, $<s>3); }
     ;	

comps : comp              { }
      | comps TAND comp        { }
      | comps TOR comp         { }
      ;

/* Expressions, such as value1 becomes value2, etc */
expr : TAND expr                        { } 
     | TIF comps TTHEN expr		        { $$ = flow('i', $2, $4); }
     | ident TBECOMES ident   		    { $$ = newassign($1, $3); }
     | ident TBECOMES TSTRING		    { $$ = newassign($1, $3); }
     | ident TBECOMES TNUMBER           { $$ = newassign($1, $<s>3); }
     | TEND				                {  }
     | TNL                              {  }
     | TASK ident			            {  }
     | TLPAREN expr TRPAREN   		    {  }
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
      | TCHOOSE ident           { }
      ;

question_block : TSTRING TQEND input TQEND TBECAUSE TSTRING { $$ = question_block($1,$3,$6); }
               | TSTRING TQEND input TBECAUSE TSTRING       { $$ = question_block($1,$3,$5); }
               | TSTRING TQEND input                        { $$ = question_block($1,$3, NULL); }
               ;

question : TQUESTION ident question_block TSTOP		{ $$ = function('q', $2, $3); }
         ;

group_choices : ident                       { }
              | group_choices TCOMMA ident   { }
	      ;

group : TGROUP ident group_choices TSTOP     { }
      ;

groups : group                              { }
       | groups group                       { }
       ;

program : rule						{ $$ = newast('p', $1, NULL); }
        | question					{ $$ = newast('p', $1, NULL); }
        ;

programs : program 					{ $$ = newast('p', $1, NULL); }
         | programs program		 		{ $$ = newast('p', $1, $2); }
         ;

script: programs action                     { $$ = newast('p', $1, $2); }
      | groups programs action      		{ $$ = newast('p', $1, $2); }
      ;

flexes: script				{ $$ = $1; return eval($1); }
	  ;
     
%%
