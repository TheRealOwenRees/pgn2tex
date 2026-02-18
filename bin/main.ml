open Pgn_logic

let rec run_lexer is_header lexbuf =
  let token =
    if is_header then Lexer.tokenize_header lexbuf
    else Lexer.tokenize_game lexbuf
  in

  (* Print result *)
  (match token with
  | Lexer.TAG_OPEN -> print_endline "TAG_OPEN ["
  | Lexer.TAG_CLOSE -> print_endline "TAG_CLOSE ]"
  | Lexer.HEADER s -> Printf.printf "HEADER: %s\n" s
  | Lexer.STRING s -> Printf.printf "STRING: \"%s\"\n" s
  | Lexer.MOVE s -> Printf.printf "MOVE: %s\n" s
  | Lexer.NUMBER s -> Printf.printf "NUMBER: %s\n" s
  | Lexer.EOF -> print_endline "EOF");

  (* Update state and loop *)
  match token with
  | Lexer.EOF -> ()
  | Lexer.TAG_OPEN -> run_lexer true lexbuf (* Enter header mode *)
  | Lexer.TAG_CLOSE -> run_lexer false lexbuf (* Enter game mode *)
  | _ -> run_lexer is_header lexbuf

let () =
  let input =
    "[Event \"Example\"] [Site \"GitHub\"] [Round \"1\"] 1. e4 e5 2. Nf3"
  in
  let lexbuf = Sedlexing.Utf8.from_string input in
  run_lexer false lexbuf
