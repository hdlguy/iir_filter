ALL_EXE = main
all: $(ALL_EXE) 

HLSINCLUDE=/opt/Xilinx/Vitis_HLS/2021.1/include/

CC=g++
#CFLAGS=-I. -I$(HLSINCLUDE) -Wall
CFLAGS=-I. -I$(HLSINCLUDE)

printvars:
	echo $(CFLAGS)
	echo $(HLSINCLUDE)

DEPS = Makefile iir.hpp

main: iir_tb.o
	$(CC) -g -o $@ $^ -lm

clean:
	rm -rf *.o $(ALL_EXE) 

#pattern rules
%.o: %.cpp $(DEPS)
#%.o: %.cpp
	$(CC) $(CFLAGS) -g -c -o $@ $<


