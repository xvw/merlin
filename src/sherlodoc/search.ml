open Std

type trie =
    T of string * Longident.t * trie list Lazy.t

let make_trie env modules =
  let rec walk env lident =
    Env.fold_modules (fun name _ mdl acc ->
        match mdl.Types.md_type with
        | Types.Mty_alias _ -> acc
        | _ ->
          let lident = Longident.Ldot (lident, name) in
          T (name, lident, lazy (walk env lident)) :: acc
      ) (Some lident) env []
  in
  List.fold_left
    ~init:[]
    ~f:(fun acc name ->
        let lident = Longident.Lident name in
        match Env.find_module_by_name lident env with
        | exception _ -> acc
        | _ -> T (name, lident, lazy (walk env lident)) :: acc)
    modules

let cost Query_parser.{typ; words} path entry =
  let cost = Option.map ~f:(fun t ->
      let query_paths = Type_distance.paths_of_type t in
      Type_distance.compute ~query_paths ~entry
    ) typ |> Option.value ~default:1000
  in
  let path = Format.asprintf "%a" Printtyp.path path in
  let matches = Name_cost.best_matches words path in
  5 * (matches + cost) + (String.length path)


let run ?(limit = 20) env query trie =
  let fold_values dir acc =
    Env.fold_values (fun _ path desc acc ->
        let typ = Type_expr.of_ocaml desc.Types.val_type in
        let cost = cost query path typ in
        if cost <= 1 || cost > 3000 then acc
        else (cost, path, desc) :: acc
      ) dir env acc
  in
  let rec walk acc (T (_, dir, children)) =
    let force () =
      let _ = Env.find_module_by_name in
      Lazy.force children
    in
    match force () with
    | computed_children ->
      let init = fold_values (Some dir) acc in
      List.fold_left ~f:walk ~init computed_children
    | exception Not_found -> acc
  in
  let init = fold_values None [] in
  trie
  |> List.fold_left ~init ~f:walk
  |> List.sort ~cmp:(fun (cost_a, _, _) (cost_b, _, _) ->
        Int.compare cost_a cost_b)
  |> List.take_n limit
