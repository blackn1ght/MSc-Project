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
	struct symlist *syms;	/* list of dummy args */
};

/* symtable of fixed size */
#define NHASH 9997
struct symbol symtab[NHASH];

struct symbol *lookup(char*);

/* list of symbols, for an argument list */
struct symlist {
	struct symbol *sym;
	struct symlist *next;
};

struct symlist *newsymlist(struct symbol *sym, struct symlist *next);
void symlistfree(struct symlist *sl);

/* Node Types
 * r : Rule
 * q : Question
 * i : if statement
 * = : assignment
 * e : expression
 */

enum func {
  F_rule = 1,
  F_action,
  F_question
};

struct ast {
	int nodetype;
	struct ast *l;
	struct ast *r;
};

struct flow {     /* If - the if-then in flex has no else clause.*/
	int nodetype;
	struct ast *cond;	/* The condition */
	struct ast *tl;		/* Then branch */
};

struct quest {
  int nodetype;   /* Question */
  struct symbol *q;
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

/* Build an AST */
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newcmp(int cmptype, struct ast *l, struct ast *r);
struct ast *newassign(struct symbol *s1, struct symbol *s2);
struct ast *newnum(double d);
struct ast *newflow(int nodetype, struct ast *cond, struct ast *l);
struct ast *newcall(int nodetype, struct ast *s);

struct ast *newquestion(struct symbol *name, struct ast *stmts);
struct ast *newrule(struct symbol *name, struct ast *stmts);
struct ast *newwrite(struct ast *s);
struct ast *newsentence(struct symbol *s);

/* Evaulate an AST */
double eval(struct ast *);

/* Delete and free up memory from an AST */
void treefree(struct ast *);

extern int yylineno;
void yyerror(char *s, ...);
