module MoveMap = Map.Make (Int)

type tag = { key : string; value : string }

type item =
  | Move of string
  | Number of string
  | Clock of string
  | Nag of string
  | Comment of string
  | Result of string
  | Variation of item list

type game = { tags : tag list; content : item list; result : string option }
