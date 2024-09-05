type t

val paths_of_type : Type_expr.t -> t
val compute : query_paths:t -> entry:Type_expr.t -> int
