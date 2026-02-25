open Ast
module MoveMap = Map.Make (Int)

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

let get_elo_text elo = if String.length elo > 0 then "(" ^ elo ^ ")" else ""

let get_date_site date site =
  match (date, site) with
  | "", "" -> ""
  | "", s -> s
  | d, "" -> d
  | d, s -> d ^ ", " ^ s

let get_title_text event title subtitle =
  match (event, title, subtitle) with
  | event, "", "" -> "\\title{" ^ escape_tex event ^ "}"
  | _event, title, subtitle ->
      "\\title{" ^ title ^ "}\\\\[2ex]\\large{" ^ subtitle ^ "}"

let get_author_text author white black white_elo black_elo =
  match (author, white, black) with
  | "", "", "" -> "\\author{}"
  | "", white, black ->
      "\\author{" ^ escape_tex white ^ " " ^ get_elo_text white_elo ^ " vs. "
      ^ escape_tex black ^ " " ^ get_elo_text black_elo ^ "}"
  | author, "", "" -> "\\author{" ^ escape_tex author ^ "}"
  | _ -> ""

let tags_to_tex tags =
  let white = get_tag_value "White" tags ~default:"" in
  let black = get_tag_value "Black" tags ~default:"" in
  let event = get_tag_value "Event" tags ~default:"" in
  let date = get_tag_value "Date" tags ~default:"" in
  let white_elo = get_tag_value "WhiteElo" tags ~default:"" in
  let black_elo = get_tag_value "BlackElo" tags ~default:"" in
  let site = get_tag_value "Site" tags ~default:"" in
  let title = get_tag_value "Title" tags ~default:"" in
  let subtitle = get_tag_value "Subtitle" tags ~default:"" in
  let author = get_tag_value "Author" tags ~default:"" in

  let title_tex = get_title_text event title subtitle in
  let author_tex = get_author_text author white black white_elo black_elo in

  let date_site_tex =
    match get_date_site date site with "" -> "" | s -> "\\date{" ^ s ^ "}"
  in

  title_tex ^ "\n" ^ author_tex ^ "\n" ^ date_site_tex
  ^ "\\maketitle\n\\newchessgame"

let rec item_to_tex is_mainline ply ?(diagram_data = MoveMap.empty) = function
  | Number n -> if is_mainline then "\\textbf{" ^ n ^ "}" else n
  | Move m ->
      if is_mainline then "\\textbf{" ^ escape_tex m ^ "}" else escape_tex m
  | Comment c ->
      if is_mainline then "\\newline " ^ escape_tex c ^ "\\par"
      else escape_tex c
  | Result r -> "\\textbf{" ^ r ^ "}"
  | Variation v -> "( " ^ render_game false ~diagram_data v ^ " )"
  | _ -> ""

and render_game is_mainline ?(diagram_data = MoveMap.empty) items =
  let get_diagram ply =
    match MoveMap.find_opt ply diagram_data with
    | Some fen ->
        Some
          ("\n\\par\\nobreak\\medskip\\chessboard[setfen=" ^ fen
         ^ ", vmargin=false]\\par\\medskip\n")
    | None -> None
  in

  let rec aux ply interrupted = function
    | [] -> ""
    | Comment c :: Move m :: tail when is_mainline && ply mod 2 != 0 ->
        let next_ply = ply + 1 in
        let rendered_comment = "\\newline " ^ escape_tex c ^ "\\par" in
        let rendered_move = "\\textbf{\\ldots" ^ escape_tex m ^ "}" in
        let diag_str =
          match get_diagram next_ply with Some s -> s | None -> ""
        in
        let has_diag = diag_str <> "" in
        rendered_comment ^ " " ^ rendered_move ^ diag_str ^ " "
        ^ aux next_ply has_diag tail
    | head :: tail ->
        let is_move = match head with Move _ -> true | _ -> false in
        let next_ply =
          match head with Move _ when is_mainline -> ply + 1 | _ -> ply
        in

        let prefix =
          if is_move && is_mainline && next_ply mod 2 == 0 && interrupted then
            "\\ldots"
          else ""
        in

        let rendered_head =
          let raw_head = item_to_tex is_mainline next_ply ~diagram_data head in
          if prefix <> "" && raw_head <> "" then
            "\\textbf{" ^ prefix ^ "}" ^ raw_head
          else raw_head
        in

        let diag_str =
          if is_move && is_mainline then get_diagram next_ply else None
        in

        let diag_output = match diag_str with Some s -> s | None -> "" in
        let is_comment = match head with Comment _ -> true | _ -> false in
        let next_interrupted = diag_output <> "" || is_comment in
        let rest = aux next_ply next_interrupted tail in

        if rendered_head = "" then rest
        else rendered_head ^ diag_output ^ if rest = "" then "" else " " ^ rest
  in
  String.trim (aux 0 false items)

let game_to_tex game diagram_data =
  let header_tex = tags_to_tex game.tags in
  let content_tex = render_game true ~diagram_data game.content in

  let result_tex =
    match game.result with Some r -> " \\textbf{" ^ r ^ "}" | None -> ""
  in

  header_tex ^ "\n" ^ content_tex ^ result_tex
