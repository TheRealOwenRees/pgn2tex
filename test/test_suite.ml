(* ocaml *)
open OUnit2

let () =
  let all = "all tests" >::: [ Test_lexer.suite ] in
  run_test_tt_main all
