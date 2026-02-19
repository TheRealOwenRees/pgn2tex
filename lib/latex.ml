open Ast

let rec item_to_tex = function
  | Number n -> "\\textbf{" ^ n ^ "}"
  | Move m -> "\\textbf{" ^ m ^ "}"
  | Comment s -> s
  | _ -> ""

let render_game items =
  let rec aux = function
    | [] -> ""
    | [ last ] -> item_to_tex last
    | Number n :: Move m :: rest ->
        (* Space between "1." and "e4" *)
        item_to_tex (Number n) ^ " " ^ aux (Move m :: rest)
    | Move m1 :: Move m2 :: rest ->
        (* Space between "e4" and "e5" *)
        item_to_tex (Move m1) ^ " " ^ aux (Move m2 :: rest)
    | Move m :: Number n :: rest ->
        (* Space before the next move number *)
        item_to_tex (Move m) ^ " " ^ aux (Number n :: rest)
    | head :: tail -> item_to_tex head ^ aux tail
  in
  aux items
