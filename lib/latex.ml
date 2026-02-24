open Ast

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

let get_tag_value key tags ~default =
  match List.find_opt (fun t -> t.key = key) tags with
  | Some t -> t.value
  | None -> default

let tags_to_tex tags =
  let white = get_tag_value "White" tags ~default:"Unknown" in
  let black = get_tag_value "Black" tags ~default:"Unknown" in
  let event = get_tag_value "Event" tags ~default:"Chess Game" in
  let date = get_tag_value "Date" tags ~default:"" in

  let title_tex = "\\title{" ^ escape_tex event ^ "}" in
  let author_tex =
    "\\author{" ^ escape_tex white ^ " vs. " ^ escape_tex black ^ "}"
  in

  let date_tex =
    if date = "" || date = "????.??.??" then ""
    else "\\date{" ^ escape_tex date ^ "}\n"
  in
  title_tex ^ "\n" ^ author_tex ^ "\n" ^ date_tex
  ^ "\\maketitle\n\\newchessgame"

let rec item_to_tex is_mainline ply = function
  | Number n -> if is_mainline then "\\textbf{" ^ n ^ "}" else n
  | Move m ->
      if is_mainline then "\\textbf{" ^ escape_tex m ^ "}" else escape_tex m
  | Comment c ->
      if is_mainline then "\\newline " ^ escape_tex c ^ "\\par"
      else escape_tex c
  | Result r -> "\\textbf{" ^ r ^ "}"
  | Variation v -> "( " ^ render_game false v ^ " )"
  | _ -> ""

and render_game is_mainline items =
  let rec aux ply = function
    | [] -> ""
    (* | [ last ] -> item_to_tex is_mainline last *)
    | Comment c :: Move m :: tail when is_mainline && ply mod 2 != 0 ->
        let rendered_comment = "\\newline " ^ escape_tex c ^ "\\par" in
        let rendered_move = "\\textbf{..." ^ escape_tex m ^ "}" in
        rendered_comment ^ " " ^ rendered_move ^ " " ^ aux (ply + 1) tail
    | head :: tail ->
        let next_ply =
          match head with Move _ when is_mainline -> ply + 1 | _ -> ply
        in

        let rendered_head = item_to_tex is_mainline next_ply head in
        let rest = aux next_ply tail in

        if rendered_head = "" then rest else rendered_head ^ " " ^ rest
  in
  String.trim (aux 0 items)

let game_to_tex game =
  let header_tex = tags_to_tex game.tags in
  let content_tex = render_game true game.content in

  let result_tex =
    match game.result with Some r -> " \\textbf{" ^ r ^ "}" | None -> ""
  in

  header_tex ^ "\n" ^ content_tex ^ result_tex
