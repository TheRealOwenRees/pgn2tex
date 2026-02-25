open OUnit2

let () =
  let all =
    "all tests" >::: [ Test_lexer.suite; Test_latex.suite; Test_pgn2tex.suite ]
  in
  run_test_tt_main all
