%{
# include <stdio.h>
# include <stdlib.h>
# include "flexes.h"
%}

%union {
  struct ast *a;
  double d;
  char *strval;
  struct symbol *s;
  struct symlist *sl;
  int fn;    
}

%token <fn> TRULE TACTION TQUESTION
%token <d> TNUMBER
%token <s> TIDENTIFIER TSTRING TINPUT


%token TCOMMA TDOT TSCOLON TSTOP TQEND
%token TPLUS TMINUS TMUL TDIV
%token TIF TTHEN TBECOMES TAND TOR TNOT
%token TDO TASK TBECAUSE TWRITE
%token TLPAREN TRPAREN UNKNOWN
%token NL

%type <a> programs program rule action expr
%type <a> stmts stmt question
%type <s> sentence input ident

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start programs

%%
/*
block: programs       {  $$ = $1; 
						 printf("Program started.\n"); }
     ;
*/
programs : { printf("programs: no rule fired.\n"); }
         | programs program action    { $$ = newast('B',$1,$2);
         								printf("programs detected.\n"); }
         ;
         
program : rule                  { $$ = newast('R',$1,NULL); }
        | question              { $$ = newast('Q',$1,NULL); }
        ;

rule : TRULE ident stmts TDOT   { $$ = rule($2, $3);
								  printf("Rule identified.\n"); }
     ;

question : TQUESTION ident sentence TQEND input ident TSTOP                         { $$ = question($2, $3, $5, NULL);}
         | TQUESTION ident sentence TQEND input ident TQEND TBECAUSE sentence TSTOP { $$ = question($2,$3,$5,$9);}
         ;

action : TACTION ident stmts TDOT { }
       ;

stmts : { /* do nothing */ }
      | stmts stmt  { $$ = $1; }
      ;

stmt : TIF expr TTHEN expr                          { $$ = flow('I', $2, $4); }
     | TDO TASK ident                               { /* do ask question */ }
     | TWRITE TLPAREN ident TRPAREN                 { $$ = dowrite($3); }
     | TWRITE TLPAREN '\'' sentence '\'' TRPAREN   { $$ = dowrite($4); }
     ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident CMP UNKNOWN      { /* meh */ }
     | ident CMP ident        { $$ = newcmp($2, $1, $3); }     
     | ident TBECOMES ident   { $$ = newassign($1, $3); }
     | TAND expr                                    { /* and expression */ }
     | TNUMBER                { $$ = num($1); }
     | ident                  { $$ = variable($1); }
     | TLPAREN expr TRPAREN   { $$ = $2; }
     ;

ident : TIDENTIFIER           { $$ = $1; }
      ;
      
sentence : TSTRING          { $$ = $1; }
         ;
         
input : TINPUT                { $$ = $1; }
      ;

%%
