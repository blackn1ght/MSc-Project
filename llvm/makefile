all: flexes

clean:
				rm parser.cpp parser.hpp flexes tokens.cpp
				
parser.cpp: flexes_llvm.y
				bison -d -o $@ $^
				
parser.hpp: parser.cpp

tokens.cpp: flexes_llvm.l parser.hpp
				lex -o $@ $^
				
flexes: parser.cpp codegen.cpp main.cpp tokens.cpp
				g++ $@ `llvm-config --libs core jit native --cxxflags --ldflags` *.cpp
