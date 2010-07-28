/*
 * Thomas Cowell - 05017742
 * Univeristy of Glamorgan
 *
 * flexes.h
 * Header file for the Abstract Syntax Trees (AST)'s
 *
 */

extern int yylineno;
void yyerror(char *s, ...);

struct symbol {		/* variable name */
	char *name;
	double value;
	struct ast *func;	/* stmt for the function */
	struct symlist *syms	/* list of dummy args */
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

struct ast {
	int nodetype;
	struct ast *l;
	struct ast *r;
};

struct flow {
	int nodetype;		/* If */
	struct ast *cond;	/* The condition */
	struct ast *tl;		/* Then branch */
};

struct call {
	int nodetype;		/* Question or Rule */
	struct symbol *s;	/* Name, code block */
};

struct assign {
	int nodetype;		/* Assignment (becomes) */
	struct symbol *s;
	struct ast *v;		/* value */
};

struct numval {
	int nodetype;		/* Number */
	double number;
};

/* Build an AST */
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newcmp(int cmptype, struct ast *l, struct ast *r);
struct ast *newasgn(struct symbol *s, struct ast *v);
struct ast *newnum(double d);
struct ast *newflow(int nodetype, struct ast *cond, struct ast *l);

struct ast *newrule(int nodetype, struct ast *id);

/* Evaulate an AST */
double eval(struct ast *);

/* Delete and free up memory from an AST */
void treefree(struct ast *);
