open OUnit2
open Pgn_logic
open Ast
open Nag

let ae expected actual = assert_equal ~printer:(fun x -> x) expected actual

let test_direct_nags =
  [
    ("$1" >:: fun _ -> ae "!" (nag_to_tex "$1"));
    ("$2" >:: fun _ -> ae "?" (nag_to_tex "$2"));
    ("$3" >:: fun _ -> ae "!!" (nag_to_tex "$3"));
    ("$4" >:: fun _ -> ae "??" (nag_to_tex "$4"));
    ("$5" >:: fun _ -> ae "!?" (nag_to_tex "$5"));
    ("$6" >:: fun _ -> ae "?!" (nag_to_tex "$6"));
    ("$10" >:: fun _ -> ae "=" (nag_to_tex "$10"));
    ("$13" >:: fun _ -> ae "\\infty" (nag_to_tex "$13"));
    ("$14" >:: fun _ -> ae "\\wbetter" (nag_to_tex "$14"));
    ("$15" >:: fun _ -> ae "\\bbetter" (nag_to_tex "$15"));
    ("$16" >:: fun _ -> ae "\\ensuremath{\\pm}" (nag_to_tex "$16"));
    ("$17" >:: fun _ -> ae "\\ensuremath{\\mp}" (nag_to_tex "$17"));
    ("$22" >:: fun _ -> ae "\\zugzwang" (nag_to_tex "$22"));
    ("$32" >:: fun _ -> ae "\\development" (nag_to_tex "$32"));
    ("$36" >:: fun _ -> ae "\\initiative" (nag_to_tex "$36"));
    ("$40" >:: fun _ -> ae "\\attack" (nag_to_tex "$40"));
    ("$44" >:: fun _ -> ae "\\compensation" (nag_to_tex "$44"));
    ("$132" >:: fun _ -> ae "\\counterplay" (nag_to_tex "$132"));
  ]

let suite = "nag test" >::: [ "direct nags" >::: test_direct_nags ]
