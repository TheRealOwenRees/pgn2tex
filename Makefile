default: clean build run

clean:
	dune clean

build: 
	dune build

run: 
	dune exec bin/main.exe