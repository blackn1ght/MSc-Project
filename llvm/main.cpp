#include <iostream>
#include <fstream>
#include <string>
#include "node.h"
extern NBlock* programBlock;
extern int yyparse();

int main(int argc, char **argv)
{
	if (argc > 1) {
		std::ifstream file(argv[1]);
		std::string line;

		if (file.is_open()) {
			while (!file.eof()) {
				getline(file, line);
				std::cout << line << std::endl;
			}
			file.close();
		}
	}
	else {
		std::cout << "Flex compiler v0.1.  Type some garbage, see what happens\n";
	}
	
	yyparse();
	std::cout << programBlock << std::endl;
	return 0;
}
