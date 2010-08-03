%{
# include <stdio.h>
# include <stdlib.h>
# include "flexes.h"
%}

%union {
  struct ast *a;
  double d;
  struct symbol *s;
  struct symlist *sl;
  int fn;    
}

%token <fn> TRULE TACTION TQUESTION
%token <d> TINTEGER TDOUBLE
%token <s> TIDENTIFIER TSENTENCE


%token TCOMMA TDOT TSCOLON TSTOP TQEND
%token TPLUS TMINUS TMUL TDIV
%token TIF TTHEN TIS TBECOMES TAND TOR TNOT
%token TDO TASK TBECAUSE TINPUT
%token TLPAREN TRPAREN
%token NL
%token UNKNOWN

%type <a> program rule question question_block ident stmts stmt if_stmt if_stmt_ext 

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%

program : rule                { $$ = newast('p', $1, NULL); }
        | question            { $$ = newast('q', $1, NULL); }
	      ;

program_ext : /* nothing */
            | rule rule
            | rule question
            | question rule
            | question quesiton { /* variation of chains of rules */ }
            ;

rule : TRULE ident stmts TDOT     { $$ = newrule($2, $3); }
     ;
     
question : TQUESTION ident question_block TDOT   { /* actions for a question */ }
         ;
         
question_block : TSENTENCE TQEND TINPUT ident { }
               ;

stmts : stmt  { /* Do something here */ }
      ;

stmt : { /* Do nothing */ }
     | if_stmt                { /* if statement */ }
     | expr                   { /* raw expression, not part of an if statement */ }
     | TDO TASK ident         { /* do ask question */ }
     ;

/* If statements. */
if_stmt : TIF expr if_stmt_ext TTHEN expr if_stmt_ext { /* if statment */ }
	      | TIF ident TIS ident { /* if statement */ }
	      ;

/* This allows for optional extras in if-statements. */	      
if_stmt_ext : /* nothing */   { $$ = NULL; } 
            | TAND expr       { /* if something is something AND something is something */ }
            ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident TIS UNKNOWN      { /* exp against unknown */ }
     | ident TIS ident        { /* var against var */ }
     | ident TBECOMES ident   { /* var becomes var */ }
     | ident CMP ident        { /* var compared to var */ }
     ;

ident : TIDENTIFIER           { /* Do something here */ }
      ;

/*
words : letter letter
      ;

rule : RULE identifier rule_contents "." { $$ = newast('R', $1, $3); }
     ;


letter: "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J"
      | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T"
      | "U" | "V" | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d"
      | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n"
      | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x"
      | "y" | "z"
      ;

digit : "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
      ;
*/
%%
