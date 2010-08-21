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
%token <token> TLPAREN TRPAREN TCOMMA TNEWLINE
%token <token> TIF TRULE TQUESTION TACTION TINPUT TSTOP TQEND
%token <token> TAND TOR TTHEN TASK TBECAUSE TDO TWRITE TEND
%token <token> TPLUS TMINUS TMUL TDIV


%type <ident> ident
%type <expr> expr number sentence
%type <block> program programs script stmts question_block
%type <stmt> stmt rule question action
%type <token> comparison
//%type <string> sentence

%left TPLUS TMINUS
%left TMUL TDIV

%start script

%%

script: programs action      			{ programBlock = $1; printf("Script has been loaded.\n"); }
     ;

programs : program 						{ $$ = new NBlock();  }
         | programs program		 		{ $$ = new NBlock(); }
         ;
         
program : rule					{ $$ = new NBlock(); }
        | question				{ $$ = new NBlock(); }
        ;

question : TQUESTION ident question_block TSTOP		{ $$ = new NMethodDeclaration($1, *$2, *$3); }
         ;
         
question_block : sentence TQEND TINPUT ident TQEND TBECAUSE sentence { $$ = new NQuestionBlock(*$1, *$4, *$7);  }
			   ;

rule : TRULE ident stmts TSTOP  { $$ = new NMethodDeclaration($1, *$2, *$3); }
     ;


action : TACTION ident stmts TSTOP { $$ = new NMethodDeclaration($1, *$2, *$3); }
       ;

stmts : stmt 			{ $$ = new NBlock; $$->statements.push_back($<stmt>1); }
      | stmts stmt 		{ $1->statements.push_back($<stmt>2); }
      ;

stmt : expr 						{ $$ = new NExpressionStatement(*$1); }
	 | TIF expr TTHEN expr			{ $$ = new NDecisionStatement(*$2, *$4); }
     ;

/* Expressions, such as value1 becomes value2, etc */
expr : ident TBECOMES ident   		{ $$ = new NAssignment(*$1, *$3);  }
	 | ident TBECOMES sentence		{ $$ = new NAssignment(*$1, *$<ident>3);  }
     | ident comparison ident       { $$ = new NBinaryOperator(*$1, $2, *$3); }
     | ident comparison sentence	{ $$ = new NBinaryOperator(*$1, $2, *$3); }
     | number comparison number		{ $$ = new NBinaryOperator(*$1, $2, *$3); }
     | ident						{ $<ident>$ = $1; }
     | TEND							{  }
     | TAND expr                    {  }
     | TASK ident					{ $$ = new NMethodCall(*$<ident>2); }
     | TLPAREN expr TRPAREN   		{ $$ = $2; }
     | TWRITE TLPAREN ident TRPAREN 	{ }	
     | TWRITE TLPAREN sentence TRPAREN	{  }
     ;

ident : TIDENTIFIER           { $$ - new NIdentifier(*$1); delete $1;  }
      ;
      
sentence : TSTRING          { $$ = new NSentence(*$1); delete $1;  }
         ;
         
comparison : TCEQ | TCNE | TCLT | TCGT | TCGE | TIS | TEQUAL | TIS TNOT
		   ;
		   
number : TDOUBLE		{ $$ = new NDouble(atof($1->c_str())); delete $1; }
		| TINTEGER		{ $$ = new NInteger(atol($1->c_str())); delete $1; }
	   ;

%%
