open Pgn_logic
open Parser

let rec run_lexer is_header lexbuf =
  let token =
    if is_header then Lexer.tokenize_header lexbuf
    else Lexer.tokenize_game lexbuf
  in

  (* Print result *)
  (match token with
  | TAG_OPEN -> print_endline "TAG_OPEN ["
  | TAG_CLOSE -> print_endline "TAG_CLOSE ]"
  | LPAREN -> print_endline "LPAREN ( "
  | RPAREN -> print_endline "RPAREN ) "
  | HEADER s -> Printf.printf "HEADER: %s\n" s
  | STRING s -> Printf.printf "STRING: \"%s\"\n" s
  | MOVE s -> Printf.printf "MOVE: %s\n" s
  | NUMBER s -> Printf.printf "NUMBER: %s\n" s
  | COMMENT s -> Printf.printf "COMMENT: %s\n" s
  | NAG s -> Printf.printf "NAG: %s\n" s
  | RESULT s -> Printf.printf "RESULT: %s\n" s
  | CLOCK s -> Printf.printf "CLOCK: %s\n" s
  | EOF -> print_endline "EOF");

  (* Update state and loop *)
  match token with
  | EOF -> ()
  | TAG_OPEN -> run_lexer true lexbuf (* Enter header mode *)
  | TAG_CLOSE -> run_lexer false lexbuf (* Enter game mode *)
  | _ -> run_lexer is_header lexbuf

let () =
  let filename = "test/pgn_examples/1.pgn" in
  try
    let ic = In_channel.open_text filename in
    let lexbuf = Sedlexing.Utf8.from_channel ic in
    print_endline ("--- Lexing: " ^ filename ^ " ---");
    run_lexer false lexbuf;
    close_in ic
  with Sys_error msg ->
    Printf.eprintf "Error: Could not find or read file: %s\n" msg
