%{
  open Ast
%}

%token TAG_OPEN TAG_CLOSE LPAREN RPAREN EOF
%token <string> HEADER STRING MOVE NUMBER COMMENT RESULT CLOCK NAG

%start <Ast.game> main

%%

main:
  | ts = tags; c = content; r = option(RESULT); EOF 
    { { tags = ts; content = c; result = r } }

tags:
  | TAG_OPEN; k = HEADER; v = STRING; TAG_CLOSE; rest = tags 
    { { key = k; value = v } :: rest }
  | (* empty *)
    { [] }

content:
  | i = item; rest = content 
    { i :: rest }
  | (* empty *)
    { [] }

item:
  | m = MOVE   { Move m }
  | n = NUMBER { Number n }
  | c = CLOCK  { Clock c }
  | g = NAG    { Nag g }
  | c = COMMENT { Comment c }
  | r = RESULT  { Result r }
  | LPAREN; v = content; RPAREN { Variation v }
