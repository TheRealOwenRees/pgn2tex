open OUnit2
open Pgn_logic
open Ast
open Helpers

let ae expected actual = assert_equal ~printer:(fun x -> x) expected actual

let test_number_to_latex_direct _ctxt =
  let item = Number "1." in
  let expected = "\\textbf{1.}" in
  let actual = Latex.item_to_tex true 0 item in
  ae expected actual

let test_move_to_latex_direct _ctxt =
  let item = Move "e4" in
  let expected = "\\textbf{e4}" in
  let actual = Latex.item_to_tex true 0 item in
  ae expected actual

let test_comment_to_latex_direct _ctxt =
  let comment = "some comment here" in
  let item = Comment comment in
  let expected = "\\newline " ^ comment ^ "\\par" in
  let actual = Latex.item_to_tex true 0 item in
  ae expected actual

let test_basic_pgn _ctxt =
  let pgn = "1. e4 e5" in
  let parsed_game = Parsing.parse_pgn pgn in

  match parsed_game.content with
  | items ->
      let expected = "\\textbf{1.} \\textbf{e4} \\textbf{e5}" in
      let actual = Latex.render_game true items in
      ae expected actual

let test_basic_longer_pgn _ctxt =
  let pgn = "1. e4 e5 2. Nf3 Nf6 3. Bb5" in
  let parsed_game = Parsing.parse_pgn pgn in

  match parsed_game.content with
  | items ->
      let expected =
        "\\textbf{1.} \\textbf{e4} \\textbf{e5} \\textbf{2.} \\textbf{Nf3} \
         \\textbf{Nf6} \\textbf{3.} \\textbf{Bb5}"
      in
      let actual = Latex.render_game true items in
      ae expected actual

let test_variation_pgn _ctxt =
  let pgn = "1. e4 (1. d4 d5) 1... e5" in
  let parsed_game = Parsing.parse_pgn pgn in
  let expected =
    "\\textbf{1.} \\textbf{e4} ( 1. d4 d5 ) \\textbf{1...} \\textbf{e5}"
  in
  let actual = Latex.render_game true parsed_game.content in
  ae expected actual

let test_black_move_after_comment _ctxt =
  let pgn = "1. e4 {some comment} e5" in
  let parsed_game = Parsing.parse_pgn pgn in
  let expected =
    "\\textbf{1.} \\textbf{e4} \\newline some comment\\par \
     \\textbf{\\ldots{}e5}"
  in
  let actual = Latex.render_game true parsed_game.content in
  ae expected actual

let test_diagram_placement _ctxt =
  let pgn = "1.e4 e5 2.Nf3 Nc6 3.Bb5 a3" in
  let parsed_game = Parsing.parse_pgn pgn in
  let rendered_game =
    Latex.render_game true ~diagram_data:Helpers.Latex_helper.diagram_data
      parsed_game.content
  in
  let expected =
    {|\textbf{1.} \textbf{e4} \textbf{e5} \textbf{2.} \textbf{Nf3} \textbf{Nc6} \textbf{3.} \textbf{Bb5}
\par\nobreak\medskip\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip
 \textbf{\ldots{}}\textbf{a3}
\par\nobreak\medskip\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 3, vmargin=false]\par\medskip|}
  in
  ae expected rendered_game

let test_player_elo =
  [
    ( "White ELO" >:: fun _ ->
      ae "(1432)" (Latex_helpers.build_elo_string "1432") );
    ( "Black ELO" >:: fun _ ->
      ae "(1233)" (Latex_helpers.build_elo_string "1233") );
    ("Empty ELO" >:: fun _ -> ae "" (Latex_helpers.build_elo_string ""));
  ]

let test_date_site =
  [
    ( "Date and Site" >:: fun _ ->
      ae "\\date{1991.01.01, Kherson}"
        (Latex_helpers.build_date_site_string "1991.01.01" "Kherson") );
    ( "Date and no site" >:: fun _ ->
      ae "\\date{1991.01.01}"
        (Latex_helpers.build_date_site_string "1991.01.01" "") );
    ( "No date but site" >:: fun _ ->
      ae "\\date{Kherson}" (Latex_helpers.build_date_site_string "" "Kherson")
    );
    ( "No date and no site" >:: fun _ ->
      ae "\\date{}" (Latex_helpers.build_date_site_string "" "") );
  ]

let test_title =
  [
    ( "Event only" >:: fun _ ->
      ae "\\title{some event}"
        (Latex_helpers.build_title_string "some event" "" "") );
    ( "Title and subtitle" >:: fun _ ->
      ae "\\title{Some title}\\\\[2ex]\\large{Some subtitle}"
        (Latex_helpers.build_title_string "irrelevant" "Some title"
           "Some subtitle") );
  ]

let test_author =
  [
    ( "Author only" >:: fun _ ->
      ae "\\author{Some author}"
        (Latex_helpers.build_author_string "Some author" "" "" "" "") );
    ( "Nothing" >:: fun _ ->
      ae "\\author{}" (Latex_helpers.build_author_string "" "" "" "" "") );
  ]

let test_diagram _ctxt =
  match Latex_helpers.get_diagram 5 Helpers.Latex_helper.diagram_data with
  | Some actual ->
      let expected =
        "\n\\par\\nobreak\\medskip\\chessboard[setfen="
        ^ "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3"
        ^ ", vmargin=false]\\par\\medskip\n"
      in
      ae expected actual
  | None -> assert_failure "Diagram for ply 5 was not found"

let test_diagram_clock _ctxt =
  match
    Latex_helpers.get_diagram 5 Helpers.Latex_helper.diagram_data ~clock:true
      ~white_time:"1:00" ~black_time:"0:21"
  with
  | Some actual ->
      let expected =
        {|\par\medskip\noindent\begin{minipage}{\linewidth}0:21\par\nopagebreak\smallskip
\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\nopagebreak\vspace{1em}
1:00\end{minipage}\par\medskip|}
      in
      ae expected actual
  | None -> assert_failure "Diagram for ply 5 was not found"

let test_no_diagram _ctxt =
  let result = Latex_helpers.get_diagram 99 Helpers.Latex_helper.diagram_data in

  match result with
  | None -> ()
  | Some actual ->
      assert_failure
        ("Expected None for ply 99, but got a diagram string instead: " ^ actual)

let suite =
  "latex tests"
  >::: [
         "number_to_latex_direct" >:: test_number_to_latex_direct;
         "move_to_latex_direct" >:: test_move_to_latex_direct;
         "comment_to_latex_direct" >:: test_comment_to_latex_direct;
         "basic_pgn" >:: test_basic_pgn;
         "basic_longer_pgn" >:: test_basic_longer_pgn;
         "variation_pgn" >:: test_variation_pgn;
         "black_move_after_comment" >:: test_black_move_after_comment;
         "diagram_placement" >:: test_diagram_placement;
         "elo tests" >::: test_player_elo;
         "date & site tests" >::: test_date_site;
         "title tests" >::: test_title;
         "author tests" >::: test_author;
         "diagram_test" >:: test_diagram;
         "diagram_clock" >:: test_diagram_clock;
         "no_diagram" >:: test_no_diagram;
       ]

let () = run_test_tt_main suite
