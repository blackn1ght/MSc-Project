flexes_llvm:	parser.cpp flexes_llvm.y flexes_llvm.l tokens.cpp main.cpp
				bison -d -o parser.cpp flexes_llvm.y
				lex -o tokens.cpp flexes_llvm.l
				g++ -D __STDC_LIMIT_MACROS=1  -o flexes `llvm-config --libs core jit native --cxxflags ldflags` *.cpp
