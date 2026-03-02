open Sedlexing
open Parser

let digit = [%sedlex.regexp? '0' .. '9']
let letter = [%sedlex.regexp? 'a' .. 'z' | 'A' .. 'Z']
let alphabetic = [%sedlex.regexp? letter]
let move_char = [%sedlex.regexp? letter | digit | '+' | '#' | '=' | '-' | 'x']

let piece_square_char =
  [%sedlex.regexp? 'K' | 'Q' | 'R' | 'B' | 'N' | 'O' | 'a' .. 'h']

let clock_val = [%sedlex.regexp? Plus (digit | ':'), Opt ('.', Plus digit)]

let rec tokenize_header buf =
  match%sedlex buf with
  | Plus white_space -> tokenize_header buf
  | ']' -> TAG_CLOSE
  | '"' -> read_string (Buffer.create 16) buf
  | letter, Star (letter | digit | '_') -> HEADER (Utf8.lexeme buf)
  | eof -> EOF
  | _ -> failwith "Unexpected character in header"

and tokenize_game buf =
  match%sedlex buf with
  | Plus white_space -> tokenize_game buf
  | "[%clk " -> read_inline_clock buf
  | '[' -> TAG_OPEN
  | '{' -> read_comment (Buffer.create 32) buf
  | '(' -> LPAREN
  | ')' -> RPAREN
  | '$', Plus digit -> NAG (Utf8.lexeme buf)
  | Plus digit, Plus '.' -> NUMBER (Utf8.lexeme buf)
  | "1-0" | "0-1" | "1/2-1/2" | "*" -> RESULT (Utf8.lexeme buf)
  | "O-O" | "O-O-O" -> MOVE (Utf8.lexeme buf)
  | ('K' | 'Q' | 'R' | 'B' | 'N' | 'a' .. 'h'), Star move_char ->
      MOVE (Utf8.lexeme buf)
  | eof -> EOF
  | any -> tokenize_game buf
  | _ -> failwith "Unexpected character in game"

and read_string b buf =
  match%sedlex buf with
  | '"' -> STRING (Buffer.contents b)
  | '\\', '"' ->
      Buffer.add_char b '"';
      read_string b buf
  | any ->
      Buffer.add_string b (Utf8.lexeme buf);
      read_string b buf
  | _ -> failwith "Unterminated string"

and read_inline_clock buf =
  match%sedlex buf with
  | clock_val ->
      let time = Utf8.lexeme buf in
      begin match%sedlex buf with
      | ']' -> CLOCK time
      | _ -> failwith "Malformed inline clock: expected closing ']'"
      end
  | _ -> failwith "Malformed inline clock value"

and read_comment b buf =
  match%sedlex buf with
  | Plus white_space -> read_comment b buf
  | "[%clk " -> read_comment_clock buf
  | "[%" -> skip_bracket_tag buf b
  | '}' -> COMMENT (Buffer.contents b)
  | eof -> failwith "Unterminated comment"
  | any ->
      Buffer.add_string b (Utf8.lexeme buf);
      read_comment_content b buf
  | _ -> failwith "Malformed comment"

and read_comment_clock buf =
  match%sedlex buf with
  | clock_val ->
      let time = Utf8.lexeme buf in
      begin match%sedlex buf with
      | ']' -> begin
          match%sedlex buf with
          | Star white_space, '}' -> CLOCK time
          | _ -> failwith "Expected closing '}' after clock comment"
        end
      | _ -> failwith "Malformed clock in comment: expected ']'"
      end
  | _ -> failwith "Malformed clock value"

and read_comment_content b buf =
  match%sedlex buf with
  | "[%" -> skip_bracket_tag buf b
  | '}' -> COMMENT (String.trim (Buffer.contents b))
  | eof -> failwith "Unterminated comment"
  | any ->
      Buffer.add_string b (Utf8.lexeme buf);
      read_comment_content b buf
  | _ -> failwith "Malformed comment"

and skip_bracket_tag buf b =
  match%sedlex buf with
  | ']' -> read_comment_content b buf
  | eof -> failwith "Unterminated [% tag inside comment"
  | any -> skip_bracket_tag buf b
  | _ -> failwith "Malformed comment"
