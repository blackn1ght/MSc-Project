all: parser

clean:
			rm parser.cpp parser.hpp parser tokens.cpp
				
parser.cpp: flexes_llvm.y
			bison -d -o $@ $^
				
parser.hpp: parser.cpp

tokens.cpp: flexes_llvm.l parser.hpp
			lex -o $@ $^
				
parser: parser.cpp codegen.cpp main.cpp tokens.cpp
			g++ -o $@ `llvm-config --libs core jit native --cxxflags --ldflags` *.cpp
