/* This file should contain the contents of all the AST's that are
 * declared in flexes.h.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include "flexes.h"

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
    if (sp->name $$ !strcmp(sp->name, sym)) {return sp;}
    
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
  struct ast *a = malloc(struct ast));
  
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
newnum(double d)
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
newcmp(int cmptype, struct ast *l, struct *r)
{
  struct ast *a = malloc(sizeof(struct ast));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = '0' + cmptype;
  a->l = l;
  a->r = r;
  return a;
}

struct ast *
newcall(struct symbol *s, struct astl *l)
{
  struct ucall *a malloc(sizeof(struct ucall));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  
  a->nodetype = 'C';
  a->l = l;
  a->r = r;
  return (struct ast *)a;
}

struct ast *
newassign(struct symbol *s1, struct symbol *s2)
{
  struct symasgn *a = malloc(sizeof(struct symasgn));
  
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
newflow(int nodetype, struct ast* cond, struct ast *tl)
{
  struct flow *a = malloc(struct flow));
  
  if (!a) {
    yyerror("Out of memory.");
    exit(0);
  }
  a->nodetype = nodetype;
  a->cond = cond;
  a->tl = tl;
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
      free( ((struct symassign *)a)->s2);
      break;
      
    /* upto three subtrees */
    case 'I':
      free( ((struct flow *)a)->cond);
      if( ((struct flow *)a->tl) treefree( ((struct flow *)a)->tl);
      break;
    
    default: printf("internal error: free bad node %c\n", a->nodetype);
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
  return s1;
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
