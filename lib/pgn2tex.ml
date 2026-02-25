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

let to_tex pgn diagram_data =
  let game = Parsing.parse_pgn pgn in
  Latex.game_to_tex game diagram_data
