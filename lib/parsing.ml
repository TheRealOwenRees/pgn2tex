open Ast

let in_header = ref false

let next_token buf =
  if !in_header then
    let tok = Lexer.tokenize_header buf in
    match tok with
    | Parser.TAG_CLOSE ->
        in_header := false;
        Parser.TAG_CLOSE
    | _ -> tok
  else
    let tok = Lexer.tokenize_game buf in
    match tok with
    | Parser.TAG_OPEN ->
        in_header := true;
        Parser.TAG_OPEN
    | _ -> tok

let parse_pgn s =
  let buf = Sedlexing.Utf8.from_string s in
  in_header := false;
  let provider () =
    let tok = next_token buf in
    let start_pos, end_pos = Sedlexing.lexing_positions buf in
    (tok, start_pos, end_pos)
  in
  try MenhirLib.Convert.Simplified.traditional2revised Parser.main provider
  with _ -> failwith "Parse error"
