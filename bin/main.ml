open Pgn_logic
open Parser
module MoveMap = Map.Make (Int)

let rec run_lexer is_header lexbuf =
  let token =
    if is_header then Lexer.tokenize_header lexbuf
    else Lexer.tokenize_game lexbuf
  in

  match token with
  | EOF -> ()
  | TAG_OPEN -> run_lexer true lexbuf (* Enter header mode *)
  | TAG_CLOSE -> run_lexer false lexbuf (* Enter game mode *)
  | _ -> run_lexer is_header lexbuf

let to_tex pgn = pgn |> Parsing.parse_pgn |> Latex.game_to_tex

let () =
  let filename = "test/pgn_examples/1.pgn" in
  try
    let ic = In_channel.open_text filename in
    let tex = In_channel.input_all ic |> to_tex in
    print_endline tex;
    close_in ic
  with Sys_error msg ->
    Printf.eprintf "Error: Could not find or read file: %s\n" msg
