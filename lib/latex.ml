open Ast

(* Helper to safely escape LaTeX special characters.
   Crucial for checkmate moves like a1=R# which must become a1=R\# *)
let escape_tex s =
  let b = Buffer.create (String.length s) in
  String.iter
    (fun c ->
      match c with
      | '#' -> Buffer.add_string b "\\#"
      | '%' -> Buffer.add_string b "\\%"
      | '{' -> Buffer.add_string b "\\{"
      | '}' -> Buffer.add_string b "\\}"
      | '_' -> Buffer.add_string b "\\_"
      | '&' -> Buffer.add_string b "\\&"
      | _ -> Buffer.add_char b c)
    s;
  Buffer.contents b

let rec item_to_tex = function
  | Number n -> "\\textbf{" ^ n ^ "}"
  | Move m -> "\\textbf{" ^ escape_tex m ^ "}"
  | Comment c -> "\\newline " ^ escape_tex c ^ "\\par"
  | Result r -> "\\textbf{" ^ r ^ "}"
  | Variation vs -> "( " ^ render_game vs ^ " )"
  | _ -> ""

and render_game items =
  let rec aux = function
    | [] -> ""
    | [ last ] -> item_to_tex last
    | head :: tail ->
        let rendered_head = item_to_tex head in
        (* If an item renders as empty (like Clock), don't add an extra space *)
        if rendered_head = "" then aux tail else rendered_head ^ " " ^ aux tail
  in
  String.trim (aux items)

(* and render_game items =
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
    | Comment c :: rest ->
        (* Comment on newline - need to change when dealing with comments before / after*)
        "\\newline" ^ " " ^ item_to_tex (Comment c) ^ "\\par" ^ aux rest
    | head :: tail -> item_to_tex head ^ aux tail
  in
  aux items *)
