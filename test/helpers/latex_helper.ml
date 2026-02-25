module MoveMap = Map.Make (Int)

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
