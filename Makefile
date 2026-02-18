default: clean build run

clean:
	dune clean

build: 
	dune build

run: 
	dune exec bin/main.exe

test:
	dune runtest

install-deps:
	opam install dune sedlex menhir js_of_ocaml-compiler ounit2 ocaml-lsp-server ocamlformat

build-js:
	dune build bin/main.bc.js --profile release

run-js:
	node _build/default/bin/main.bc.js

js: build-js

.PHONY: clean test