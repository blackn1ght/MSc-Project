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

%token <fn> RULE ACTION QUESTION
%token <d> TINTEGER TDOUBLE
%token <s> TIDENTIFIER
%token <sl> symlist

%token TCOMMA TDOT TSCOLON
%token TPLUS TMINUS TMUL TDIV
%token IF THEN IS BECOMES AND OR NOT
%token RULE QUESTION ACTION
%token DO ASK BECAUSE INPUT
%token NL
%token UNKNOWN

%type <a> program rule ident

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%

program : rule { $$ = newast('p', $1, NULL); }
	      ;


rule : RULE ident { $$ = newcall('r', $2); }
     ;

/*
stmts : stmt { }
      | stmts stmt { }
      ;

stmt : var_decl | func_decl
     | expr { }
     ;

block : stmts TDOT
      | stmt TDOT {  }
      ;

func_decl : RULE ident block { }
          ;

rule_decl : RULE ident block {  }
	        ;

question_decl : QUESETION ident { }
              ;
*/
ident : TIDENTIFIER { }
      ;
/*
numeric : TINTEGER { }
        | TDOUBLE { }
	      ;

expr : ident IS UNKNOWN
     | ident IS ident
     | ident BECOMES ident
     | ident comparison ident
     ;

if_stmt : IF ident IS UNKNOWN
	| IF ident IS ident
	;

words : letter letter
      ;

rule : RULE identifier rule_contents "." { $$ = newast('R', $1, $3); }
     ;

question : "question " identifier question_contents 
         ;

comparison : CMP
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
