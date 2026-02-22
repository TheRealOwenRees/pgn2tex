open OUnit2
open Pgn_logic
open Ast

let render_game items = String.concat "" (List.map Latex.item_to_tex items)

let test_number_to_latex_direct _ctxt =
  let item = Number "1." in
  let expected = "\\textbf{1.}" in
  let actual = Latex.item_to_tex item in

  assert_equal ~printer:(fun x -> x) expected actual

let test_move_to_latex_direct _ctxt =
  let item = Move "e4" in
  let expected = "\\textbf{e4}" in
  let actual = Latex.item_to_tex item in

  assert_equal ~printer:(fun x -> x) expected actual

let test_comment_to_latex_direct _ctxt =
  let comment = "some comment here" in
  let item = Comment comment in
  let expected = comment in
  let actual = Latex.item_to_tex item in

  assert_equal ~printer:(fun x -> x) expected actual

let test_basic_pgn _ctxt =
  let pgn = "1. e4 e5" in
  let parsed_game = Parsing.parse_pgn pgn in

  match parsed_game.content with
  | items ->
      let expected = "\\textbf{1.} \\textbf{e4} \\textbf{e5}" in
      let actual = Latex.render_game items in
      assert_equal ~printer:(fun x -> x) expected actual

let test_basic_longer_pgn _ctxt =
  let pgn = "1. e4 e5 2. Nf3 Nf6 3. Bb5" in
  let parsed_game = Parsing.parse_pgn pgn in

  match parsed_game.content with
  | items ->
      let expected =
        "\\textbf{1.} \\textbf{e4} \\textbf{e5} \\textbf{2.} \\textbf{Nf3} \
         \\textbf{Nf6} \\textbf{3.} \\textbf{Bb5}"
      in
      let actual = Latex.render_game items in
      assert_equal ~printer:(fun x -> x) expected actual

let test_basic_pgn_file_with_comments _ctxt =
  let filename = "pgn_examples/1.pgn" in
  try
    let ic = In_channel.open_text filename in
    let pgn = In_channel.input_all ic in
    let parsed_game = Parsing.parse_pgn pgn in

    match parsed_game.content with
    | items ->
        let expected = "\\textbf{}" in
        let actual = Latex.render_game items in
        assert_equal ~printer:(fun x -> x) expected actual
  with Sys_error _ -> assert_failure "Could not open file"

let suite =
  "latex tests"
  >::: [
         "number_to_latex_direct" >:: test_number_to_latex_direct;
         "move_to_latex_direct" >:: test_move_to_latex_direct;
         "comment_to_latex_direct" >:: test_comment_to_latex_direct;
         "basic_pgn" >:: test_basic_pgn;
         "basic_longer_pgn" >:: test_basic_longer_pgn;
         "basic_pgn_file_with_comments" >:: test_basic_pgn_file_with_comments;
       ]

let () = run_test_tt_main suite
