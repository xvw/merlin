open Std

type t =
  | Arrow of t * t
  | Constr of string * t list
  | Tuple of t list
  | Poly of string
  | Any
  | Unhandled

let rec of_ocaml ocaml_typ =
  match Types.get_desc ocaml_typ with
  | Types.Tvar _ -> Any
  | Tarrow (_, a, b, _) ->
    Arrow (of_ocaml a, of_ocaml b)
  | Ttuple elts ->
    Tuple (List.map ~f:of_ocaml elts)
  | Tconstr (p, args, _) ->
    let name = Format.asprintf "%a"Printtyp.path p in
    Constr (name, List.map ~f:of_ocaml args)
  | _ -> Unhandled

let rec equal a b =
  match (a, b) with
  | Unhandled, Unhandled
  | Any, Any -> true
  | Poly a, Poly b -> String.equal a b
  | Tuple a, Tuple b -> List.equal ~eq:equal a b
  | Constr (ka, ra), Constr (kb, rb) ->
    String.equal ka kb && List.equal ~eq:equal ra rb
  | Arrow (ia, oa), Arrow (ib, ob) ->
    equal ia ib && equal oa ob
  | _ -> false

let tuple = function
  | [] -> Any
  | [ x ] -> x
  | xs -> Tuple xs

let parens x = "(" ^ x ^ ")"

let unhandled = "???"

let rec to_string = function
  | Unhandled -> unhandled
  | Any -> "_"
  | Poly name -> "'" ^ name
  | Arrow (a, b) -> with_parens a ^ " -> " ^ to_string b
  | Constr (t, []) -> t
  | Constr (t, [x]) -> with_parens x ^ " " ^ t
  | Constr (t, xs) -> (parens @@ as_list xs) ^ " " ^ t
  | Tuple xs -> as_tuple xs
and with_parens = function
  | (Arrow _ | Tuple _) as t -> parens @@ to_string t
  | t -> to_string t
and as_list = function
  | [] -> unhandled
  | [ x ] -> to_string x
  | x :: xs -> to_string x ^ ", " ^ as_list xs
and as_tuple = function
  | [] -> unhandled
  | [ x ] -> with_parens x
  | x :: xs -> with_parens x ^ " * " ^ as_tuple xs

