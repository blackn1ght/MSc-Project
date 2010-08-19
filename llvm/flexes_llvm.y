%{
	#include "node.h"
	NBlock *programBlock;		/* Top level root node of our final AST */
	
	extern int yylex();
	void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}

%union {
	Node *node;
	NBlock *block;
	NExpression *expr;
	NStatement *stmt;
	NIdentifier *ident;
	std::vector<NExpression*> *exprvec;
	std::string *string;
	int token;   
}

/* The tokens */
%token <string> TIDENTIFIER TINTEGER TDOUBLE TSTRING
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL TBECOMES TIS TNOT
%token <token> TLPAREN TRPAREN TCOMMA TDOT
%token <token> TIF TRULE TQUESTION TACTION TINPUT TSTOP TQEND
%token <token> TAND TOR TTHEN TASK TBECAUSE TDO TWRITE
%token <token> TPLUS TMINUS TMUL TDIV


%type <ident> ident
%type <expr> expr number sentence
%type <block> program programs stmts block question_block
%type <stmt> stmt
%type <token> comparison

%left TPLUS TMINUS
%left TMUL TDIV

%start block

%%

block: programs       { programBlock = $1; }
     ;

programs : program { $$ = new NBlock();  }
         | programs program action { $$ = new NBlock(); }
         ;
         
program : rule							{ $$ = new NBlock(); }
        | question question_block		{ $$ = new NBlock(); }
        ;

rule : TRULE ident stmts TDOT   { }
     ;

question : TQUESTION ident sentence TQEND TINPUT ident TSTOP                         { }
         | TQUESTION ident sentence TQEND TINPUT ident TQEND TBECAUSE sentence TSTOP { }
         ;
         
question_block : sentence TQEND TINPUT ident TSTOP		{ $$ = new NBlock(); }
			   | sentence TQEND TINPUT ident TQEND TBECAUSE sentence TSTOP { $$ = new NBlock(); }
			   ;

action : TACTION ident stmts TDOT { }
       ;

stmts : stmt { $$ = new NBlock(); $$->statements.push_back($<stmt>1); }
      | stmts stmt  { $1->statements.push_back($<stmt>2); }
      ;

stmt : TRULE ident expr	TDOT	{ $$ = new NMethodDeclaration($1, *$2, *$3); }
	 | TQUESTION ident			{ $$ = new NMethodDeclaration($1, *$2, NULL); }
	 | expr { $$ = new NExpressionStatement(*$1); }
	 ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident TBECOMES expr   		{ $$ = new NAssignment(*$<ident>1, *$3); }
	 | TASK TLPAREN ident TRPAREN	{ $$ = new NMethodCall(*$1, *$3); delete $3; }
     | TAND expr                    { /* and expression */ }
     | number
     | ident                  		{ $<ident>$ = $1; }
     | expr comparison expr        	{ $$ = new NBinaryOperator(*$1, $2, *$3 } 
     | TLPAREN expr TRPAREN   		{ $$ = $2; }
     | TIF expr TTHEN expr			{ $$ = new NDecisionStatement(*$2, *$4); }
     | TDO TASK ident				{ $$ = new NMethodCall($3, NULL); }
     | TDO TWRITE TLPAREN ident TRPAREN 		{ }
     | TDO TWRITE '\'' sentence '\'' TRPAREN	{ }
     ;

ident : TIDENTIFIER           { $$ - new NIdentifier(*$1); delete $1; }
      ;
      
sentence : TSTRING          { $$ = new NSentence($1); delete $1; }
         ;
         
comparison : TCEQ | TCNE | TCLT | TCGT | TCGE | TIS | TEQUAL | TIS TNOT
		   ;
		   
number : TDOUBLE		{ $$ = new NDouble(atof($1->c_str())); delete $1; }
		| TINTEGER		{ $$ = new NInteger(atol($1->c_str())); delete $1; }
	   ;

%%
