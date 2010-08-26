/*
 * Thomas Cowell - 05017742
 * Univeristy of Glamorgan
 *
 * flexes.h
 * Header file for the Abstract Syntax Trees (AST)'s
 *
 * + - * /
 * 0 - 7 comparison ops
 * L expression or statement list
 * I IF statement
 * N symbol ref
 * B assignment (becomes)
 * S list of symbols
 * C rule/question/action
 * P input
 * U because (question optional answer)
 * D do (do something)
 */

extern int yylineno;
void yyerror(char *s, ...);
  
struct symbol {		/* variable name */
	char *name;
	double d_value;
	char *c_value;
	struct ast *func;	/* stmt for the function */
	struct symlist *syms;
};

/* symtable of fixed size */
#define NHASH 9997
struct symbol symtab[NHASH];
struct symbol *lookup(char*);

struct symlist *newsymlist(struct symbol *sym, struct symlist *next);
void symlistfree(struct symlist *sl);


/* Node Types
 * r : Rule
 * q : Question
 * i : if statement
 * = : assignment
 * e : expression
 */

struct ast {
	int nodetype;
	struct ast *l;
	struct ast *r;
};

struct s_flow {     /* If - the if-then in flex has no else clause.*/
	int nodetype;		/* Type i */
	struct ast *cond;	/* The condition */
	struct ast *tl;		/* Then branch */
};

struct ucall {     /* Stores a question, rule or action */
	int nodetype;		/* Question or Rule */
	struct symbol *s;	/* Name, code block */
};

struct assign {
	int nodetype;		/* Assignment (becomes) */
	struct symbol *s1;
	struct symbol *s2;
};

struct numval {
	int nodetype;		/* Number */
	double number;
};

struct s_compare {
  int cmptype;
  struct symbol *l;
  struct symbol *r;
};

struct s_ref {
  int nodetype;
  struct symbol *s;
};

struct s_rule {
  int nodetype;
  struct symbol *name;
  struct ast *stmts;
};

struct s_question {
  int nodetype;
  struct symbol *question;
  struct symbol *input;
  struct symbol *because;
};

struct s_dowrite {
  int nodetype;
  struct symbol *sentence;
};

struct s_function {
	int nodetype;
	struct symbol *name;
	struct ast *statements;
};

/* Build an AST */
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newcmp(int cmptype, struct symbol *l, struct symbol *r);
struct ast *newassign(struct symbol *s1, struct symbol *s2);
struct ast *num(double d);
struct ast *flow(int nodetype, struct ast *cond, struct ast *l);

struct ast *function(int nodetype, struct symbol *name, struct ast *statements);
struct ast *question_block(struct symbol *question, struct symbol *input, struct symbol *because);

struct ast *dowrite(struct symbol *sentence);
struct ast *sentence(struct symbol *s);
struct ast *variable(struct symbol *s);

/* Evaulate an AST */
double eval(struct ast *);

/* Delete and free up memory from an AST */
void treefree(struct ast *);

extern int yylineno;
void yyerror(char *s, ...);
