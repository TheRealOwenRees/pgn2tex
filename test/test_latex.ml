open OUnit2
open Pgn_logic
open Ast
open Helpers

let test_number_to_latex_direct _ctxt =
  let item = Number "1." in
  let expected = "\\textbf{1.}" in
  let actual = Latex.item_to_tex true 0 item in

  assert_equal ~printer:(fun x -> x) expected actual

let test_move_to_latex_direct _ctxt =
  let item = Move "e4" in
  let expected = "\\textbf{e4}" in
  let actual = Latex.item_to_tex true 0 item in

  assert_equal ~printer:(fun x -> x) expected actual

let test_comment_to_latex_direct _ctxt =
  let comment = "some comment here" in
  let item = Comment comment in
  let expected = "\\newline " ^ comment ^ "\\par" in
  let actual = Latex.item_to_tex true 0 item in

  assert_equal ~printer:(fun x -> x) expected actual

let test_basic_pgn _ctxt =
  let pgn = "1. e4 e5" in
  let parsed_game = Parsing.parse_pgn pgn in

  match parsed_game.content with
  | items ->
      let expected = "\\textbf{1.} \\textbf{e4} \\textbf{e5}" in
      let actual = Latex.render_game true items in
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
      let actual = Latex.render_game true items in
      assert_equal ~printer:(fun x -> x) expected actual

let test_variation_pgn _ctxt =
  let pgn = "1. e4 (1. d4 d5) 1... e5" in
  let parsed_game = Parsing.parse_pgn pgn in
  let expected =
    "\\textbf{1.} \\textbf{e4} ( 1. d4 d5 ) \\textbf{1...} \\textbf{e5}"
  in
  let actual = Latex.render_game true parsed_game.content in
  assert_equal ~printer:(fun x -> x) expected actual

(* let test_basic_pgn_file_with_comments _ctxt =
  let filename = "pgn_examples/1.pgn" in
  try
    let ic = In_channel.open_text filename in

    let actual =
      ic |> In_channel.input_all |> Parsing.parse_pgn |> Latex.game_to_tex
    in
    let expected = Latex_helper.pgn1_expected in

    assert_equal ~printer:(fun x -> x) actual expected;

    close_in ic
  with Sys_error _ -> assert_failure "Could not open file" *)

let suite =
  "latex tests"
  >::: [
         "number_to_latex_direct" >:: test_number_to_latex_direct;
         "move_to_latex_direct" >:: test_move_to_latex_direct;
         "comment_to_latex_direct" >:: test_comment_to_latex_direct;
         "basic_pgn" >:: test_basic_pgn;
         "basic_longer_pgn" >:: test_basic_longer_pgn;
         "variation_pgn" >:: test_variation_pgn;
         (* "basic_pgn_file_with_comments" >:: test_basic_pgn_file_with_comments; *)
       ]

let () = run_test_tt_main suite
