default: clean build

clean:
	dune clean

build: 
	dune build bin/pgn2tex.cjs --profile release

test:
	dune runtest

install-deps:
	opam install dune sedlex menhir js_of_ocaml js_of_ocaml-ppx ounit2 ocaml-lsp-server ocamlformat

check:
	opam lint
	dune build @fmt @install @runtest @lint

# bench:
# 	ocamlopt -o benchmarks/strings unix.cmxa benchmarks/strings.ml
# 	benchmarks/strings

.PHONY: clean test