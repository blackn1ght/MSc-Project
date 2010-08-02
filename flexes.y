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
%token <s> TIDENTIFIER


%token TCOMMA TDOT TSCOLON TSTOP TQEND
%token TPLUS TMINUS TMUL TDIV
%token TIF TTHEN TIS TBECOMES TAND TOR TNOT
%token TDO TASK TBECAUSE TINPUT
%token TLPAREN TRPAREN
%token NL
%token UNKNOWN

%type <a> program rule ident
%type <sl> symlist

%nonassoc <fn> CMP

%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%

program : rule { $$ = newast('p', $1, NULL); }
	      ;


rule : TRULE ident symlist { $$ = newrule('r', $2, $3, NULL); }
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


symlist : TIDENTIFIER               { $$ = newsymlist($1, NULL); }
        | TIDENTIFIER ', ' symlist  { $$ = newsymlist($1, $3); }
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
