
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TIDENTIFIER = 258,
     TSTRING = 259,
     TNAME = 260,
     TINUMBER = 261,
     TIINTEGER = 262,
     TNUMBER = 263,
     TBECOMES = 264,
     TNOT = 265,
     TGROUP = 266,
     TLPAREN = 267,
     TRPAREN = 268,
     TCOMMA = 269,
     TNL = 270,
     TCHOOSE = 271,
     TIF = 272,
     TRULE = 273,
     TQUESTION = 274,
     TACTION = 275,
     TINPUT = 276,
     TSTOP = 277,
     TQEND = 278,
     TAND = 279,
     TOR = 280,
     TTHEN = 281,
     TASK = 282,
     TBECAUSE = 283,
     TDO = 284,
     TWRITE = 285,
     TEND = 286,
     TPLUS = 287,
     TMINUS = 288,
     TMUL = 289,
     TDIV = 290,
     CMP = 291
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 7 "flexes.y"

	struct ast *a;
	double d;
	struct symbol *s;
	int fn;



/* Line 1676 of yacc.c  */
#line 97 "flexes.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


