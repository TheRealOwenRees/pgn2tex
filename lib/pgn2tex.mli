module MoveMap : Map.S with type key = int

val to_tex : string -> string MoveMap.t -> string
