(* ocaml *)
open OUnit2
open Pgn_logic

let lex_all ?(is_header = false) s =
  let lexbuf = Sedlexing.Utf8.from_string s in
  let rec loop acc =
    let tok =
      if is_header then Lexer.tokenize_header lexbuf
      else Lexer.tokenize_game lexbuf
    in
    match tok with
    | Lexer.EOF -> List.rev (Lexer.EOF :: acc)
    | t -> loop (t :: acc)
  in
  loop []

let string_of_token = function
  | Lexer.TAG_OPEN -> "TAG_OPEN"
  | Lexer.TAG_CLOSE -> "TAG_CLOSE"
  | Lexer.LPAREN -> "LPAREN"
  | Lexer.RPAREN -> "RPAREN"
  | Lexer.HEADER s -> "HEADER(" ^ s ^ ")"
  | Lexer.STRING s -> "STRING(" ^ s ^ ")"
  | Lexer.MOVE s -> "MOVE(" ^ s ^ ")"
  | Lexer.NUMBER s -> "NUMBER(" ^ s ^ ")"
  | Lexer.COMMENT s -> "COMMENT(" ^ s ^ ")"
  | Lexer.NAG s -> "NAG(" ^ s ^ ")"
  | Lexer.RESULT s -> "RESULT(" ^ s ^ ")"
  | Lexer.EOF -> "EOF"

let assert_tokens ~ctxt ~input ~is_header ~expected =
  let got = lex_all ~is_header input in
  let pp toks =
    "[" ^ String.concat "; " (List.map string_of_token toks) ^ "]"
  in
  assert_equal ~ctxt ~printer:pp expected got

let test_header_simple _ctxt =
  let input = {|Event "Casual Game"]|} in
  let expected =
    [
      Lexer.HEADER "Event";
      Lexer.STRING "Casual Game";
      Lexer.TAG_CLOSE;
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:true ~expected

let test_header_escaped_string _ctxt =
  let input = {|Site "My \"Quoted\" Site"]|} in
  let expected =
    [
      Lexer.HEADER "Site";
      Lexer.STRING {|My "Quoted" Site|};
      Lexer.TAG_CLOSE;
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:true ~expected

let test_numbers_and_moves _ctxt =
  let input = "1. e4 e5 2... Nf3 Nc6" in
  let expected =
    [
      Lexer.NUMBER "1.";
      Lexer.MOVE "e4";
      Lexer.MOVE "e5";
      Lexer.NUMBER "2...";
      Lexer.MOVE "Nf3";
      Lexer.MOVE "Nc6";
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_castling_and_results _ctxt =
  let input = "1. O-O O-O-O 1-0" in
  let expected =
    [
      Lexer.NUMBER "1.";
      Lexer.MOVE "O-O";
      Lexer.MOVE "O-O-O";
      Lexer.RESULT "1-0";
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_nags _ctxt =
  let input = "1. e4 $1 $23 Nf3 *" in
  let expected =
    [
      Lexer.NUMBER "1.";
      Lexer.MOVE "e4";
      Lexer.NAG "$1";
      Lexer.NAG "$23";
      Lexer.MOVE "Nf3";
      Lexer.RESULT "*";
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_parentheses_and_comments _ctxt =
  let input = "1. e4 (e5) {a comment} 1/2-1/2" in
  let expected =
    [
      Lexer.NUMBER "1.";
      Lexer.MOVE "e4";
      Lexer.LPAREN;
      Lexer.MOVE "e5";
      Lexer.RPAREN;
      Lexer.COMMENT "a comment";
      Lexer.RESULT "1/2-1/2";
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_comment_multiline _ctxt =
  let input = "1. e4 {multi\nline\ncomment} *" in
  let expected =
    [
      Lexer.NUMBER "1.";
      Lexer.MOVE "e4";
      Lexer.COMMENT "multi\nline\ncomment";
      Lexer.RESULT "*";
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_move_syntax_variants _ctxt =
  let input = "1. exd5 e8=Q+ Kxd5 a1=R#" in
  let expected =
    [
      Lexer.NUMBER "1.";
      Lexer.MOVE "exd5";
      Lexer.MOVE "e8=Q+";
      Lexer.MOVE "Kxd5";
      Lexer.MOVE "a1=R#";
      Lexer.EOF;
    ]
  in
  assert_tokens ~ctxt:_ctxt ~input ~is_header:false ~expected

let test_king_side_zero_letter_o _ctxt =
  (* Current lexer matches 'O-O' with capital letter 'O' specifically. *)
  let input = "1. O-O *" in
  let expected =
    [ Lexer.NUMBER "1."; Lexer.MOVE "O-O"; Lexer.RESULT "*"; Lexer.EOF ]
  in
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
       ]

let () = run_test_tt_main suite
