flexes: flexes.l flexes.y flexes.h
		bison -d flexes.y
		flex -oflexes.lex.c flexes.l
		cc -o $@ flexes.tab.c flexes.lex.c flexesfuncs.c
