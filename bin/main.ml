open Pgn_logic

let print_token = function
  | Lexer.TAG_OPEN -> print_endline "TAG_OPEN ([)"
  | Lexer.TAG_CLOSE -> print_endline "TAG_CLOSE (])"
  | Lexer.EOF -> print_endline "EOF"

let rec run_lexer lexbuf =
  let token = Lexer.tokenize lexbuf in
  print_token token;
  if token <> EOF then run_lexer lexbuf

let () =
  let input = "[Event \"Example\"] [Site \"GitHub\"]" in
  let lexbuf = Sedlexing.Utf8.from_string input in
  run_lexer lexbuf
