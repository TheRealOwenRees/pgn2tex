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

let to_tex pgn diagram_data =
  let game = Parsing.parse_pgn pgn in
  Latex.game_to_tex game diagram_data

let () =
  let filename = "test/pgn_examples/1.pgn" in
  try
    let diagram_data =
      MoveMap.empty
      |> MoveMap.add 5
           "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3"
      |> MoveMap.add 6
           "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 3"
      |> MoveMap.add 10
           "r1bqkbnr/pp1ppppp/2n5/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 3 5"
      |> MoveMap.add 15
           "r1bqkb1r/pp1ppppp/2n5/2p5/4P3/2N2N2/PPPP1PPP/R1BQKB1R b KQkq - 5 7"
    in
    let ic = In_channel.open_text filename in
    let input_string = In_channel.input_all ic in
    let tex = to_tex input_string diagram_data in
    print_endline tex;
    close_in ic
  with
  | Sys_error msg -> Printf.eprintf "File Error: %s\n" msg
  | Failure msg -> Printf.eprintf "Parsing Error: %s\n" msg
