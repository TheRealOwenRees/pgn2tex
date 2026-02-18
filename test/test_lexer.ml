open OUnit2
open Pgn_logic
open Parser

let lex_all ?(is_header = false) s =
  let lexbuf = Sedlexing.Utf8.from_string s in
  let rec loop acc =
    let tok =
      if is_header then Lexer.tokenize_header lexbuf
      else Lexer.tokenize_game lexbuf
    in
    match tok with EOF -> List.rev (EOF :: acc) | t -> loop (t :: acc)
  in
  loop []

let string_of_token = function
  | TAG_OPEN -> "TAG_OPEN"
  | TAG_CLOSE -> "TAG_CLOSE"
  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | HEADER s -> "HEADER(" ^ s ^ ")"
  | STRING s -> "STRING(" ^ s ^ ")"
  | MOVE s -> "MOVE(" ^ s ^ ")"
  | NUMBER s -> "NUMBER(" ^ s ^ ")"
  | COMMENT s -> "COMMENT(" ^ s ^ ")"
  | NAG s -> "NAG(" ^ s ^ ")"
  | RESULT s -> "RESULT(" ^ s ^ ")"
  | CLOCK s -> "CLOCK(" ^ s ^ ")"
  | EOF -> "EOF"

let assert_tokens ~ctxt ~input ~is_header ~expected =
  let got = lex_all ~is_header input in
  let pp toks =
    "[" ^ String.concat "; " (List.map string_of_token toks) ^ "]"
  in
  assert_equal ~ctxt ~printer:pp expected got

let test_header_simple _ctxt =
  let input = {|Event "Casual Game"]|} in
  let expected = [ HEADER "Event"; STRING "Casual Game"; TAG_CLOSE; EOF ] in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:true ~expected

let test_header_escaped_string _ctxt =
  let input = {|Site "My \"Quoted\" Site"]|} in
  let expected =
    [ HEADER "Site"; STRING {|My "Quoted" Site|}; TAG_CLOSE; EOF ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:true ~expected

let test_numbers_and_moves _ctxt =
  let input = "1. e4 e5 2... Nf3 Nc6" in
  let expected =
    [
      NUMBER "1.";
      MOVE "e4";
      MOVE "e5";
      NUMBER "2...";
      MOVE "Nf3";
      MOVE "Nc6";
      EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_castling_and_results _ctxt =
  let input = "1. O-O O-O-O 1-0" in
  let expected = [ NUMBER "1."; MOVE "O-O"; MOVE "O-O-O"; RESULT "1-0"; EOF ] in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_nags _ctxt =
  let input = "1. e4$1 $23 Nf3 *" in
  let expected =
    [ NUMBER "1."; MOVE "e4"; NAG "$1"; NAG "$23"; MOVE "Nf3"; RESULT "*"; EOF ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_parentheses_and_comments _ctxt =
  let input = "1. e4 (e5) {a comment} 1/2-1/2" in
  let expected =
    [
      NUMBER "1.";
      MOVE "e4";
      LPAREN;
      MOVE "e5";
      RPAREN;
      COMMENT "a comment";
      RESULT "1/2-1/2";
      EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_comment_multiline _ctxt =
  let input = "1. e4 {multi\nline\ncomment} *" in
  let expected =
    [ NUMBER "1."; MOVE "e4"; COMMENT "multi\nline\ncomment"; RESULT "*"; EOF ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_move_syntax_variants _ctxt =
  let input = "1. exd5 e8=Q+ Kxd5 a1=R#" in
  let expected =
    [ NUMBER "1."; MOVE "exd5"; MOVE "e8=Q+"; MOVE "Kxd5"; MOVE "a1=R#"; EOF ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_king_side_zero_letter_o _ctxt =
  let input = "1. O-O *" in
  let expected = [ NUMBER "1."; MOVE "O-O"; RESULT "*"; EOF ] in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_unterminated_comment_raises _ctxt =
  let input = "1. e4 {oops" in
  let lexbuf = Sedlexing.Utf8.from_string input in
  let exn_opt =
    try
      ignore (Lexer.tokenize_game lexbuf);
      ignore (Lexer.tokenize_game lexbuf);
      ignore (Lexer.tokenize_game lexbuf);
      (* this should try to read comment *)
      None
    with exn -> Some exn
  in
  assert_bool "Expected exception on unterminated comment"
    (Option.is_some exn_opt)

let test_clock_times _ctxt =
  let input =
    "1. d4 { [%clk 0:10:00] } 1... Nf6 { [%clk 0:10:00] } 2. Nf3 { [%clk \
     0:10:00] } 2... d5 { [%clk 0:10:01] } 3. e3 { [%clk 0:10:01] } 3... e6 { \
     [%clk 0:10:02] } { D05 Queen's Pawn Game: Colle System }"
  in
  let expected =
    [
      NUMBER "1.";
      MOVE "d4";
      CLOCK "0:10:00";
      NUMBER "1...";
      MOVE "Nf6";
      CLOCK "0:10:00";
      NUMBER "2.";
      MOVE "Nf3";
      CLOCK "0:10:00";
      NUMBER "2...";
      MOVE "d5";
      CLOCK "0:10:01";
      NUMBER "3.";
      MOVE "e3";
      CLOCK "0:10:01";
      NUMBER "3...";
      MOVE "e6";
      CLOCK "0:10:02";
      COMMENT "D05 Queen's Pawn Game: Colle System";
      EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_clock_inline _ctxt =
  let input = "1. d4 [%clk 0:10:00] Nf3 *" in
  let expected =
    [ NUMBER "1."; MOVE "d4"; CLOCK "0:10:00"; MOVE "Nf3"; RESULT "*"; EOF ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_clock_in_comment _ctxt =
  let input = "1. d4 {[%clk 0:10:00]} Nf3 *" in
  let expected =
    [ NUMBER "1."; MOVE "d4"; CLOCK "0:10:00"; MOVE "Nf3"; RESULT "*"; EOF ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let suite =
  "lexer tests"
  >::: [
         "header_simple" >:: test_header_simple;
         "header_escaped_string" >:: test_header_escaped_string;
         "numbers_and_moves" >:: test_numbers_and_moves;
         "castling_and_results" >:: test_castling_and_results;
         "nags" >:: test_nags;
         "parentheses_and_comments" >:: test_parentheses_and_comments;
         "comment_multiline" >:: test_comment_multiline;
         "move_syntax_variants" >:: test_move_syntax_variants;
         "king_side_zero_letter_o" >:: test_king_side_zero_letter_o;
         "unterminated_comment_raises" >:: test_unterminated_comment_raises;
         "clock_times" >:: test_clock_times;
         "clock_inline" >:: test_clock_inline;
         "clock_in_comment" >:: test_clock_in_comment;
       ]

let () = run_test_tt_main suite
