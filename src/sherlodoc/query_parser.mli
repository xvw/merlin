type parsed = {
  words: string list;
  typ: Type_expr.t option
}

val of_string : string -> parsed
val to_string : parsed -> string
