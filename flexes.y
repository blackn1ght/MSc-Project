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
%token <s> TIDENTIFIER TSENTENCE TINPUT
%token <strval> TSTRING


%token TCOMMA TDOT TSCOLON TSTOP TQEND
%token TPLUS TMINUS TMUL TDIV
%token TIF TTHEN TBECOMES TAND TOR TNOT
%token TDO TASK TBECAUSE TWRITE
%token TLPAREN TRPAREN UNKNOWN
%token NL

%type <a> program program_ext rule action expr
%type <a> stmts stmt question
%type <s> sentence input ident

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%

program : rule program_ext action              { $$ = newast('p', $1, NULL); }
        | question program_ext action          { $$ = newast('q', $1, NULL); }
	      ;

program_ext : { /* nothing */ }
            | rule              { /* Single rule */ }
            | question           { /* Single question */ }  
            | rule rule         { /* rule followed by a rule */ }
            | rule question     { /* rule followed by a question */ }
            | question rule     { /* question followed by a rule */ }
            | question question { /* variation of chains of rules */ }
            ;

rule : TRULE ident stmts TDOT   { $$ = newrule($2, $3); }
     ;

question : TQUESTION ident sentence TQEND input ident TSTOP                         { $$ = newquestion($2, $3, $5, NULL);}
         | TQUESTION ident sentence TQEND input ident TQEND TBECAUSE sentence TSTOP { $$ = newquestion($2,$3,$5,$9);}
         ;

action : TACTION ident stmts TDOT { }
       ;

stmts : stmt  { $$ = $1; }
      ;

stmt :                                              { /* Do nothing */ }
     | TIF expr TTHEN expr                          { $$ = newflow('I', $2, $4); }
     | TDO TASK ident                               { /* do ask question */ }
     | TWRITE TLPAREN ident TRPAREN                 { $$ = newwrite($3); }
     | TWRITE TLPAREN '\'' TSENTENCE '\'' TRPAREN   { $$ = newwrite($4); }
     ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident CMP UNKNOWN      { /* meh */ }
     | ident CMP ident        { $$ = newcmp($2, $1, $3); }     
     | ident TBECOMES ident   { $$ = newassign($1, $3); }
     | TAND expr              { /* AND expression */ }
     | TNUMBER                { $$ = newnum($1); }
     ;

ident : TIDENTIFIER           { $$ = $1; }
      ;
      
sentence : TSENTENCE          { $$ = $1; }
         ;
         
input : TINPUT                { $$ = $1; }
      ;

%%
