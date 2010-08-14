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

%type <a> programs program rule action expr block
%type <a> stmts stmt question
%type <s> sentence input ident

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start block

%%

block: programs       {  $$ = $1; }
     ;

programs : { /* nothing - not sure if that's really possible */ }
         | programs program action    { /* A collection of rules and quetions */ }
         ;
         
program : rule                  { /* $$ = new_rule(BLAH, $1); */ }
        | question              { /* $$ = new_question(BLAH, $1); */ }
        ;

rule : TRULE ident stmts TDOT   { $$ = rule($2, $3); }
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
