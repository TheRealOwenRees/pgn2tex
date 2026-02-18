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
  | Lexer.LPAREN -> print_endline "LPAREN ( "
  | Lexer.RPAREN -> print_endline "RPAREN ) "
  | Lexer.HEADER s -> Printf.printf "HEADER: %s\n" s
  | Lexer.STRING s -> Printf.printf "STRING: \"%s\"\n" s
  | Lexer.MOVE s -> Printf.printf "MOVE: %s\n" s
  | Lexer.NUMBER s -> Printf.printf "NUMBER: %s\n" s
  | Lexer.COMMENT s -> Printf.printf "COMMENT: %s\n" s
  | Lexer.NAG s -> Printf.printf "NAG: %s\n" s
  | Lexer.RESULT s -> Printf.printf "RESULT: %s\n" s
  | Lexer.CLOCK s -> Printf.printf "CLOCK: %s\n" s
  | Lexer.EOF -> print_endline "EOF");

  (* Update state and loop *)
  match token with
  | Lexer.EOF -> ()
  | Lexer.TAG_OPEN -> run_lexer true lexbuf (* Enter header mode *)
  | Lexer.TAG_CLOSE -> run_lexer false lexbuf (* Enter game mode *)
  | _ -> run_lexer is_header lexbuf

let () =
  let filename = "test/pgn_examples/2.pgn" in
  try
    let ic = In_channel.open_text filename in
    let lexbuf = Sedlexing.Utf8.from_channel ic in
    print_endline ("--- Lexing: " ^ filename ^ " ---");
    run_lexer false lexbuf;
    close_in ic
  with Sys_error msg ->
    Printf.eprintf "Error: Could not find or read file: %s\n" msg
