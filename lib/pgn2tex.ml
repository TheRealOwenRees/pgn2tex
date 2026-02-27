module MoveMap = Ast.MoveMap

let to_tex pgn ~diagram_data ~clock =
  let game = Parsing.parse_pgn pgn in
  Latex.game_to_tex game ~diagram_data ~clock
