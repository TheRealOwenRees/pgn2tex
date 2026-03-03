module MoveMap = Ast.MoveMap

(* escape strings for LaTeX *)
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

(* ELO string builder *)
let build_elo_string elo = if String.length elo > 0 then "(" ^ elo ^ ")" else ""

(* Author string builder *)
let build_author_string author white black white_elo black_elo =
  match (author, white, black) with
  | "", "", "" -> "\\author{}"
  | "", white, black ->
      "\\author{" ^ escape_tex white ^ " " ^ build_elo_string white_elo ^ "\\\\"
      ^ escape_tex black ^ " " ^ build_elo_string black_elo ^ "}"
  | author, "", "" -> "\\author{" ^ escape_tex author ^ "}"
  | _ -> ""

(* Title string builder *)
let build_title_string event title subtitle =
  match (event, title, subtitle) with
  | event, "", "" -> "\\title{" ^ escape_tex event ^ "}"
  | _event, title, subtitle ->
      "\\title{" ^ title ^ "}\\\\[2ex]\\large{" ^ subtitle ^ "}"

(* Date and Site string builder *)
let build_date_site_string date site =
  match (date, site) with
  | "", "" -> "\\date{}"
  | "", s -> "\\date{" ^ s ^ "}"
  | d, "" -> "\\date{" ^ d ^ "}"
  | d, s -> "\\date{" ^ d ^ ", " ^ s ^ "}"

(* generate a diagram with or without clock times from the passed in Map (JSON in JS) *)
let get_diagram ?(clock = false) ?(white_time = "0:00") ?(black_time = "0:00")
    ply diagram_data =
  match MoveMap.find_opt ply diagram_data with
  | None -> None
  | Some fen ->
      if not clock then
        Some
          ("\n\\par\\nobreak\\medskip\\chessboard[setfen=" ^ fen
         ^ ", vmargin=false]\\par\\medskip\n")
      else
        Some
          ("\\par\\medskip\\noindent" ^ "\\begin{minipage}{\\linewidth}"
         ^ black_time ^ "\\par\\nopagebreak\\smallskip\n"
         ^ "\\chessboard[setfen=" ^ fen
         ^ ", vmargin=false]\\par\\nopagebreak\\vspace{1em}\n" ^ white_time
         ^ "\\end{minipage}\\par\\medskip")
