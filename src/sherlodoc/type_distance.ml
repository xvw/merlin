open Std

module Step = struct
  type t =
    | Type of string
    | Poly
    | Any
    | Arrow_left
    | Arrow_right
    | Product of { pos: int; len: int }
    | Argument of { pos: int; len: int }
end

type t = Step.t list list

let paths_of_type t =
  let rec aux prefix = function
    | Type_expr.Unhandled -> []
    | Poly _ -> [Step.Poly :: prefix]
    | Any -> [Step.Any :: prefix]
    | Arrow (a, b) ->
      let prefix_left = Step.Arrow_left :: prefix
      and prefix_right = Step.Arrow_right :: prefix in
      List.rev_append
        (aux prefix_left a)
        (aux prefix_right b)
    | Constr (name, args) ->
      let prefix = Step.Type name :: prefix in
      let result =
        match args with
        | []  -> [ prefix ]
        | _ :: _ ->
          let len = List.length args in
          let args_prefix = List.mapi ~f:(fun pos arg ->
              let prefix = Step.Argument { pos; len } :: prefix in
              aux prefix arg) args
           in List.rev_concat args_prefix
      in result
    | Tuple args ->
      let len = List.length args in
      let args_prefix = List.mapi ~f:(fun pos arg ->
          let prefix = Step.Product { pos; len } :: prefix in
          aux prefix arg
        ) args
      in List.rev_concat args_prefix
  in List.map ~f:List.rev (aux [] t)

let skip_entry = 10
let max_distance = 10_000

let make_cache xs ys =
  let h = List.length xs |> succ
  and w = List.length ys |> succ in
  Array.make_matrix h w (-1)

module Sign = struct
  type t =
    | Pos
    | Neg

  let negate = function
    | Pos -> Neg
    | Neg -> Pos

  let compare a b =
    match (a, b) with
    | Pos, Pos | Neg, Neg -> 0
    | Pos, Neg -> 1
    | Neg, Pos -> -1

  let equal a b =
    Int.equal (compare a b) 0
end

let distance xs ys =
  let cache = make_cache xs ys in
  let rec memo ~xsgn ~ysgn i j xs ys =
    let r = cache.(i).(j) in
    if r >= 0 then r
    else
      let r = aux ~xsgn ~ysgn i j xs ys in
      let () = cache.(i).(j) <- r in
      r
  and aux ~xsgn ~ysgn i j xs ys =
    match (xs, ys) with
    | [], _ -> 0
    | ([Step.Any ], _)
    | ([ Poly ], [(Step.Any | Poly)]) when Sign.equal xsgn ysgn -> 0
    | Arrow_left :: xs, Arrow_left :: ys ->
      let xsgn = Sign.negate xsgn
      and ysgn = Sign.negate ysgn
      in memo ~xsgn ~ysgn (succ i) (succ j) xs ys
    | _, Arrow_left :: ys ->
      let ysgn = Sign.negate ysgn in
      succ @@ memo ~xsgn ~ysgn i (succ j) xs ys
    | Arrow_left :: xs, _ ->
      let xsgn = Sign.negate xsgn in
      succ @@ memo ~xsgn ~ysgn (succ i) j xs ys
    | _, Arrow_right :: ys ->
      memo  ~xsgn ~ysgn i (succ j) xs ys
    | Arrow_right :: xs, _ ->
      memo ~xsgn ~ysgn (succ i) j xs ys
    | _, [] -> max_distance
    | Product _ :: xs, Product _ :: ys
    | Argument _ :: xs, Argument _ :: ys ->
      succ @@ memo ~xsgn ~ysgn (succ i) (succ j) xs ys
    | Product _ :: xs, ys ->
      succ @@ memo ~xsgn ~ysgn (succ i) j xs ys
    | xs, Product _ :: ys ->
      succ @@ memo ~xsgn ~ysgn i (succ j) xs ys
    | Type x :: xs', Type y :: ys' when Sign.equal xsgn ysgn ->
      let result = match Name_cost.best_match ~sub:x y with
        | None ->
          skip_entry + memo ~xsgn ~ysgn i (succ j) xs ys'
        | Some (_, cost) ->
          (cost / 3) + memo ~xsgn ~ysgn (succ i) (succ j) xs' ys'
      in result
    | xs, Type _ :: ys ->
      skip_entry + memo ~xsgn ~ysgn i (succ j) xs ys
    | xs, Argument _ :: ys -> memo ~xsgn ~ysgn i (succ j) xs ys
    | _, (Any | Poly) :: _ -> max_distance
  in
  aux ~xsgn:Sign.Pos ~ysgn:Sign.Pos 0 0 xs ys

let make_array list =
  list
  |> Array.of_list
  |> Array.map (fun lst ->
      let lst = List.mapi ~f:(fun i x -> x, i) lst in
      List.sort ~cmp:Stdlib.compare lst)

let make_heuristics arr =
  let h = Array.make (succ @@ Array.length arr) 0 in
  let () = for i = Array.length h - 2 downto 0 do
      let best = fst @@ List.hd arr.(i) in
      h.(i) <- h.(succ i) + best
    done
  in h
  

let minimize = function
  | [] -> 0
  | arr ->
    let used = Array.make (List.(length @@ hd arr)) false in
    let arr = make_array arr in
    let () = Array.sort Stdlib.compare arr in
    let heuristics = make_heuristics arr in
    let best = ref 1000
    and limit = ref 0 in
    let rec aux rem acc i =
      let () = incr limit in
      if !limit > max_distance then false
      else if rem <= 0 then
        let score = acc + (1000 * (Array.length arr - i)) in
        let () = best := Int.min score !best in
        true
      else if i >= Array.length arr then
        let score = acc + (5 * rem) in
        let () = best := Int.min score !best in
        true
      else if acc + heuristics.(i) >= !best then true
      else
        let rec find = function
          | [] -> true
          | (cost, j) :: rest ->
            let continue = if used.(j) then true
              else
                let () = used.(j) <- true in
                let continue = aux (pred rem) (acc + cost) (succ i) in
                let () = used.(j) <- false in
                continue
            in if continue then find rest else false
        in find arr.(i)
    in
    let _ = aux (Array.length used) 0 0 in
    !best
    

let compute ~query_paths ~entry =
  let entry_paths = paths_of_type entry in
  match (entry_paths, query_paths) with
  | _, [] | [], _ -> 1000
  | _ ->
    query_paths
    |> List.map ~f:(fun p -> List.map ~f:(distance p) entry_paths)
    |> minimize
