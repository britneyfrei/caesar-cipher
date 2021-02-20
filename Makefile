BIN = rotx

all:
	gcc -g -O0 $(BIN).s -o $(BIN)
