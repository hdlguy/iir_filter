all: inv_4x4_test

inv_4x4_test: inv_4x4_tb.o inv_4x4.o
	g++ inv_4x4_tb.o inv_4x4.o -o inv_4x4_test

inv_4x4_tb.o: inv_4x4_tb.cpp inv_4x4.hpp
	g++ -std=c++11 -c inv_4x4_tb.cpp

inv_4x4.o: inv_4x4.cpp inv_4x4.hpp
	g++ -c inv_4x4.cpp

clean:
	rm -rf *o inv_4x4_test
