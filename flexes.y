%{
# include <stdio.h>
# include <stdlib.h>
# include "flexes.h"
%}

%union {
	Node *node;
	NBlock *block;
	NExpression *expr;
	NStatement *stmt;
	NIdentifier *ident;
	NVariableDeclaration *var_decl;
	std::vector<NVariableDeclaration*> *varvec;
	std::vector<NExpression*> *exprvec;
	std::string *string;
	int token;
}

/* Define terminal symbols (tokens).
   This should match the tokens in the flexes.l file.
   Need to define the node type they represent.
*/

%token <d> NUMBER
%token <fn> FUNC

%token <string> TIDENTIFIER TINTEGER TDOUBLE
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TCOMMA TDOT TSCOLON
%token <token> TPLUS TMINUS TMUL TDIV
%token <token> IF THEN IS BECOMES AND OR NOT
%token <token> RULE QUESTION ACTION
%token <token> DO ASK BECAUSE INPUT
%token <token> NL
%token UNKNOWN


/* Define the type of node our nonterminal symbols represent.
   The types refer to the %union declaration above.
*/

%type <ident> ident
%type <expr> numeric expr		/* Needed? */
%type <varvec> func_decl_args		/* Needed? */
%type <exprvec> call_args		/* Needed? */
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl
%type <token> comparison

/* Operator precdence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%

program : stmts { programBlock = $1; }
	;

stmts : stmt { $$ = new NBlock(); $$->statements.push_back($<stmt>1); }
      | stmts stmt { $1->statements.push_back($<stmt>2); }
      ;

stmt : var_decl | func_decl
     | expr { $$ = new NExpressionStatement(*$1); }
     ;

block : stmts TDOT
      | stmt TDOT { $$ = new NBlock(); }
      ;

func_decl : RULE ident block { $$ = new NFunctionDeclaration(*$1, *$2, *$4, *$6); delete $4; }
          ;

rule_decl : RULE ident block { $$ = NRuleDeclaration(*$1, *$2, *$4, *$6); delete $4; }
	  ;

question_decl : QUESETION ident

ident : TIDENTIFIER { $$ = new NIdentifier(*$1); delete $1; }
      ;

numeric : TINTEGER { $$ = new TInteger(atol($1->c_str())); delete $1; }
        | TDOUBLE { $$ = new NDouble(atof($1->c_str())); delete $1; }
	;

expr : ident IS UNKNOWN
     | ident IS ident
     | ident BECOMES ident
     | ident comparison iden
     ;

if-stmt : IF ident IS UNKNOWN
	| IF ident IS ident

words : letter letter
      ;

rule: RULE identifier rule_contents "." { $$ = newast('R', $1, $3); }
;

question: "question " identifier question_contents ("." | ";")

comparison : TCEQ | TCNE | TCLT | TCLE | TCGT | TCGE
	   : TPLUS | TMINUS | TMUL | TDIV
	   ;

letter: "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J"
      | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T"
      | "U" | "V" | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d"
      | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n"
      | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x"
      | "y" | "z"
;

digit: "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
;
%%
