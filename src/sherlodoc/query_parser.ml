type parsed = {
  words: string list;
  typ: Type_expr.t option
}

let balance_parens str =
  let rec aux i open_parens close_parens =
    if i >= String.length str then
      open_parens, close_parens
    else
      match str.[i] with
      | '(' -> aux (succ i) (succ open_parens) close_parens
      | ')' when open_parens > 0 -> aux (succ i) (pred open_parens) close_parens
      | ')' -> aux (succ i) open_parens (succ close_parens)
      | _ -> aux (succ i) open_parens close_parens
  in
  let (op, cp) = aux 0 0 0 in
  String.make cp '(' ^ str ^ String.make op ')'

let naive_of_string str =
  List.filter (fun s -> String.length s > 0) (String.split_on_char ' ' str)

let guess_type_search str =
  String.length str >= 1 &&
  (Char.equal str.[0] '\''
   || String.contains str '-'
   || String.contains str '(')
  

let to_string {words; typ} =
  let words = String.concat " " words in
  match typ with
  | Some typ -> words ^ " : " ^ Type_expr.to_string typ
  | None -> words ^ " : <no type>"

let of_string str =
  let query_name, typ =
    match String.index_opt str ':' with
    | None ->
      if guess_type_search str then
        let str = balance_parens str in
        ("", Type_expr_util.of_string str)
      else str, None
    | Some loc ->
      let str_name = String.sub str 0 loc
      and str_type = String.sub str (succ loc) (String.length str - loc - 1) in
      let str_type = balance_parens str_type in
      str_name, Type_expr_util.of_string str_type
  in
  let words = naive_of_string query_name in
  { words; typ}
  
