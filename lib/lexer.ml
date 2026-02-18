open Sedlexing

let digit = [%sedlex.regexp? '0' .. '9']
let letter = [%sedlex.regexp? 'a' .. 'z' | 'A' .. 'Z']
let alphabetic = [%sedlex.regexp? letter]
let move_char = [%sedlex.regexp? letter | digit | '+' | '#' | '=' | '-' | 'x']

let piece_square_char =
  [%sedlex.regexp? 'K' | 'Q' | 'R' | 'B' | 'N' | 'O' | 'a' .. 'h']

type token =
  | TAG_OPEN
  | TAG_CLOSE
  | HEADER of string
  | STRING of string
  | MOVE of string
  | NUMBER of string
  | COMMENT of string
  | EOF

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
  | '[' -> TAG_OPEN
  | '{' -> read_comment (Buffer.create 32) buf
  | Plus digit, Plus '.' -> NUMBER (Utf8.lexeme buf)
  | "O-O" | "O-O-O" -> MOVE (Utf8.lexeme buf)
  | ('K' | 'Q' | 'R' | 'B' | 'N' | 'a' .. 'h'), Star move_char ->
      MOVE (Utf8.lexeme buf)
  | eof -> EOF
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

and read_comment b buf =
  match%sedlex buf with
  | '}' -> COMMENT (Buffer.contents b)
  | eof -> failwith "Unterminated comment"
  | any ->
      Buffer.add_string b (Utf8.lexeme buf);
      read_comment b buf
  | _ -> failwith "Lexing error in comment"
