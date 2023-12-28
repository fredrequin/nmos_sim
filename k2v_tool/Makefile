all: k2v

kicad.tab.cpp kicad.tab.hpp: kicad.y
	bison --defines=kicad.tab.hpp --output=kicad.tab.cpp kicad.y

lex.yy.cpp: kicad.l kicad.tab.hpp
	flex --outfile=lex.yy.cpp kicad.l

k2v: lex.yy.cpp kicad.tab.cpp kicad.tab.hpp kicad_st.hpp
	g++ -std=gnu++0x kicad.tab.cpp lex.yy.cpp -lfl -o k2v

clean:
	rm k2v kicad.tab.cpp lex.yy.cpp kicad.tab.hpp
