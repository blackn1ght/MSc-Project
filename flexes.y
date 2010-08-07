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
%token <d> TINTEGER TDOUBLE
%token <s> TIDENTIFIER TSENTENCE
%token <strval> TSTRING


%token TCOMMA TDOT TSCOLON TSTOP TQEND
%token TPLUS TMINUS TMUL TDIV
%token TIF TTHEN TIS TBECOMES TAND TOR TNOT
%token TDO TASK TBECAUSE TINPUT TWRITE
%token TLPAREN TRPAREN
%token NL
%token UNKNOWN

%type <a> program program_ext rule question action
%type <a> question_block ident stmts stmt if_stmt

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
     
question : TQUESTION ident question_block TDOT   { /* actions for a question */ }
         ;
         
question_block : TSENTENCE TQEND TINPUT ident TSTOP { /* question */ }
               | TSENTENCE TQEND TINPUT ident TQEND TBECAUSE TSENTENCE TSTOP { /* question */ }
               ;

action : TACTION ident stmts TDOT { }
       ;

stmts : stmt  { /* Do something here */ }
      | stmt stmt { /* Do something here */ }
      ;

stmt : { /* Do nothing */ }
     | if_stmt                { /* if statement */ }
     | expr                   { /* raw expression, not part of an if statement */ }
     | TDO TASK ident         { /* do ask question */ }
     | write                  { /* A write statement */ }
     ;

/* If statements. */
if_stmt : TIF expr TTHEN expr     { $$ = newflow('I', $2, $4); }
	      | TIF ident TIS ident     { $$ = newflow('I', $2, $4); }
	      ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident TIS UNKNOWN      { /* exp against unknown */ }
     | ident TIS ident        { /* var against var */ }
     | ident TBECOMES ident   { /* var becomes var */ }
     | ident CMP ident        { /* var compared to var */ }
     | TAND expr              { /* AND expression */ }
     ;
     
write : TWRITE TLPAREN ident TRPAREN              { /* rule for the write function */ }
      | TWRITE TLPAREN ''' TSENTENCE ''' TRPAREN  { /* rule for the write function */ }
      ;

ident : TIDENTIFIER           { /* Do something here */ }
      ;

%%
