#include <iostream>
#include <fstream>
#include <string>
#include "node.h"
extern NBlock* programBlock;
extern int yyparse();

int main(int argc, char **argv)
{
	if (argc > 1) {
		extern FILE* yyin;
		if(!(yyin = fopen(argv[1], "r"))) {
			perror(argv[1]);
			return (1);
		}
	}
	
	yyparse();
	std::cout << programBlock << std::endl;
	return 0;
}
