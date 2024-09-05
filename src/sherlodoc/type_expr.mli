type t =
    Arrow of t * t
  | Constr of string * t list
  | Tuple of t list
  | Poly of string
  | Any
  | Unhandled

val tuple : t list -> t
val equal : t -> t -> bool
val to_string : t -> string
val of_ocaml : Types.type_expr -> t
