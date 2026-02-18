default: clean build run

clean:
	dune clean

build: 
	dune build

run: 
	dune exec bin/main.exe

test:
	dune test

install-deps:
	opam install dune sedlex ounit2 ocaml-lsp-server ocamlformat

.PHONY: clean test