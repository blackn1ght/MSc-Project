/* This file should contain the contents of all the AST's that are
 * declared in flexes.h.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include "flexes.h"
#include "flexes.tab.h"

/* Symbol table */
static unsigned
symhash(char *sym)
{
  unsigned int hash = 0;
  unsigned c;
  
  while (c = *sym++) hash = hash*9 ^ c;
  
  return hash;
}

struct symbol *
lookup(char *sym)
{
  struct symbol *sp = &symtab[symhash(sym)%NHASH];
  int scount = NHASH;
  
  while (--scount >= 0) {
    if (sp->name && !strcmp(sp->name, sym)) { return sp; }
    
    if (!sp->name) {
      sp->name = strdup(sym);
      sp->d_value = 0;
      sp->c_value = strdup(sym);
      sp->func = NULL;
      sp->syms = NULL;
      return sp;
    }
    
    if (++sp >= symtab+NHASH) sp = symtab; /* try the next entry */
  }
  
  yyerror("symbol table overflow\n");
  abort(); /* tried them all, table is full */
}

struct ast *
newast(int nodetype, struct ast *l, struct ast *r)
{
  struct ast *a = malloc(sizeof(struct ast));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = nodetype;
  a->l = l;
  a->r = r;
  return a;
}

struct ast *
num(double d)
{
  struct numval *a = malloc(sizeof(struct numval));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = 'K';
  a->number = d;
  return (struct ast *)a;
}

struct ast *
newcmp(int cmptype, struct symbol *l, struct symbol *r)
{
  struct s_compare *a = malloc(sizeof(struct s_compare));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->cmptype = '0' + cmptype;
  a->l = l;
  a->r = r;
  return (struct ast *)a;
}

struct ast *
newassign(struct symbol *s1, struct symbol *s2)
{
  struct assign *a = malloc(sizeof(struct assign));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  a->nodetype = 'B';  /* becomes */
  a->s1 = s1;
  a->s2 = s2;
  return (struct ast *)a;
}

struct ast *
variable(struct symbol *s)
{
  struct s_ref *a = malloc(sizeof(struct s_ref));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = 'N';
  a->s = s;
  return (struct ast *)a;
}

struct ast *
flow(int nodetype, struct ast* cond, struct ast *tl)
{
  struct s_flow *a = malloc(sizeof(struct s_flow));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  a->nodetype = nodetype;
  a->cond = cond;
  a->tl = tl;
  return (struct ast *)a;
}

struct ast *
rule(struct symbol *name, struct ast *stmts)
{
  struct s_rule *a = malloc(sizeof(struct s_rule));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = 'R';
  a->name = name;
  a->stmts = stmts;
  
  return (struct ast *)a;
}

struct ast *
question(struct symbol *name, struct symbol *question, struct symbol *input, struct symbol *because)
{
  struct s_question *a = malloc(sizeof(struct s_question));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = 'Q';
  a->name = name;
  a->question = question;
  a->input = input;
  a->because = because;
  
  return (struct ast *)a;
}

struct ast *
dowrite(struct symbol *sentence)
{
  struct s_dowrite *a = malloc(sizeof(struct s_dowrite));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = 'W';
  a->sentence = sentence;
 
  return (struct ast *)a;
}

/* Free a tree of AST's */
void treefree(struct ast *a)
{
  switch(a->nodetype) {
    /* two subtrees */
    case '+':
    case '-':
    case '*':
    case '/':
    case '1': case '2': case '3': case '4': case '5': case '6':
    case 'L':
      treefree(a->r);
      
    /* no subtree */
    case 'K': case 'N':
      break;
    
    case 'B':
      free( ((struct assign *)a)->s2);
      break;
      
    /* upto three subtrees */
    case 'I':
      free( ((struct s_flow *)a)->cond);
      if (((struct s_flow *)a)->tl) treefree(((struct s_flow *)a)->tl);
      break;
    
    default: printf("internal error: free bad node %c\n", a->nodetype);
      break;
  }
  
  free(a); /* always free the node itself */
}

struct symlist *
newsymlist(struct symbol *sym, struct symlist *next)
{
  struct symlist *sl = malloc(sizeof(struct symlist));
  
  if (!sl) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  sl->sym = sym;
  sl->next = next;
  return sl;
}

/* free a list of symbols */
void
symlistfree(struct symlist *sl)
{
  struct symlist *nsl;
  
  while(sl) {
    nsl = sl->next;
    free(sl);
    sl = nsl;
  }
}

double
eval(struct ast *a)
{
  double v;
  
  switch (a->nodetype)
  {
    case 'R':
      printf("Rule detected.\n");
      break;
    default: printf("Other detected.\n");
      break;
  }
}

void
yyerror(char *s, ...)
{
  va_list ap;
  va_start(ap, s);

  fprintf(stderr, "%d: error: ", yylineno);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

main(argc, argv)
int argc;
char **argv;
{
    
    if (argc > 1) {
        printf("File: ", argv[1], "\n");
        /*
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        } */
    }
    
    yyparse();
    printf("\n\t-- FILE READ --\n");
}

