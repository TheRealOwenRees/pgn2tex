module MoveMap = Ast.MoveMap

let to_tex pgn diagram_data clock =
  let clock_string = string_of_bool clock in
  print_endline clock_string;
  let game = Parsing.parse_pgn pgn in
  Latex.game_to_tex game ~diagram_data
