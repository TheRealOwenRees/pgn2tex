open Sedlexing

(* let digit = [%sedlex.regexp? '0'..'9']
let whitespace = [%sedlex.regexp? Plus (white_space | '\n' | '\r')]
let nag = [%sedlex.regexp? '$', Plus digit]
let comment = [%sedlex.regexp? '{', Star (any - '}'), '}']

type token =
  | TAG_OPEN | TAG_CLOSE
  | STRING of string
  | MOVE of string
  | COMMENT of string
  | NAG of string
  | EOF *)

type token = TAG_OPEN | TAG_CLOSE | EOF

let rec tokenize buf =
  match%sedlex buf with
  | '[' -> TAG_OPEN
  | ']' -> TAG_CLOSE
  | eof -> EOF
  | any -> tokenize buf
  | _ -> failwith "Lexing error"
