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
  | Variation v -> "( " ^ render_game v ^ " )"
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
