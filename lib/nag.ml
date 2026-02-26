let nag_to_tex nag =
  match nag with
  (* Move Assessments *)
  | "$1" -> "!" (* Good move *)
  | "$2" -> "?" (* Poor move *)
  | "$3" -> "!!" (* Very good move *)
  | "$4" -> "??" (* Very poor move *)
  | "$5" -> "!?" (* Speculative move *)
  | "$6" -> "?!" (* Questionable move *)
  (* | 7 -> "\\Box"  Forced move *)
  (* | 8 -> "{\\tiny \\textceltel}" Singular move *)
  (* | 9 -> "{\\tiny !!}"  Worst move *)
  (* Positional Assessments *)
  | "$10" -> "=" (* Drawish / Equal *)
  (* | 11 -> "=" Equal/Quiet *)
  | "$13" -> "\\infty" (* Unclear *)
  | "$14" -> "\\wbetter" (* White slight advantage *)
  | "$15" -> "\\bbetter" (* Black slight advantage *)
  | "$16" -> "\\ensuremath{\\pm}" (* White moderate advantage *)
  | "$17" -> "\\ensuremath{\\mp}" (* Black moderate advantage *)
  | "$18" -> "+-" (* White decisive advantage *)
  | "$19" -> "-+" (* Black decisive advantage *)
  (* Common Positional Symbols *)
  | "$22" -> "\\zugzwang"
  | "$32" -> "\\development"
  | "$36" -> "\\initiative"
  | "$40" -> "\\attack"
  | "$44" -> "\\compensation"
  | "$132" -> "\\counterplay"
  (* | 146 -> "N" Novelty *)
  (* Fallback for others: just print the $ number as a comment or ignore *)
  | n -> ""
