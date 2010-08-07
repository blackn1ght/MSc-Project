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
%token <s> TIDENTIFIER TSENTENCE
%token <strval> TSTRING


%token TCOMMA TDOT TSCOLON TSTOP TQEND
%token TPLUS TMINUS TMUL TDIV
%token TIF TTHEN TBECOMES TAND TOR TNOT
%token TDO TASK TBECAUSE TINPUT TWRITE
%token TLPAREN TRPAREN
%token NL
%token UNKNOWN

%type <a> program program_ext rule question action expr
%type <a> question_block ident stmts stmt q_stmt

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

rule : TRULE ident stmts TDOT     { $$ = newrule($2, $3); }
     ;
     
question : TQUESTION ident q_stmt   { /* actions for a question */ }
         ;
         
question_block : TSENTENCE TQEND TINPUT ident TSTOP { /* question */ }
               | TSENTENCE TQEND TINPUT ident TQEND TBECAUSE TSENTENCE TSTOP { /* question */ }
               ;

action : TACTION ident stmts TDOT { }
       ;

stmts : stmt  { $$ = $1; }
      ;

stmt : { /* Do nothing */ }
     | TIF expr TTHEN expr                          { $$ = newflow('I', $2, $4)l; }
     | TDO TASK ident                               { /* do ask question */ }
     | TWRITE TLPAREN ident TRPAREN                 { $$ = newwrite($3); }
     | TWRITE TLPAREN '\'' TSENTENCE '\'' TRPAREN   { $$ = newwrite($4); }
     ;
     
q_stmt : TSENTENCE TQEND                  { $$ = newsentence($1); }
       | TINPUT ident TQEND               
       | TINPUT ident TSTOP               { }
       | TBECAUSE TSENTENCE TSTOP         { }
       ;


/* Expressions, such as value1 becomes value2, etc */
expr : ident CMP UNKNOWN
     | ident CMP ident        { $$ = newcmp($2, $1, $3); }     
     | ident TBECOMES ident   { $$ = newassign($1, $3); }
     | TAND expr              { /* AND expression */ }
     | TNUMBER                { $$ = newnum($1); }
     ;

ident : TIDENTIFIER           { $$ = $1; }
      ;

%%
