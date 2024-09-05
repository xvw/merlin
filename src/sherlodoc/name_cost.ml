open Std

let prefix_at ~sub s j =
  let rec aux ~case ~sub i s j =
    if i >= String.length sub then
      Some case
    else if Char.equal sub.[i] s.[j] then
      aux ~case ~sub (succ i) s (succ j)
    else if Char.equal sub.[i] (Char.lowercase_ascii s.[j]) then
      aux ~case:(case + 3) ~sub (succ i) s (succ j)
    else if Char.equal (Char.lowercase_ascii sub.[i]) s.[j] then
      aux ~case:(case + 10) ~sub (succ i) s (succ j)
    else None
  in aux ~case:0 ~sub 0 s j
  
let find_all ~sub s =
  let rec aux j acc =
    if j + String.length sub > String.length s then acc
    else
      let acc = match prefix_at ~sub s j with
        | None -> acc
        | Some cost -> (j, cost) :: acc
      in aux (succ j) acc
  in aux 0 []

let word_boundary s i =
  if i < 0 then 0
  else if i >= String.length s || List.mem s.[i] ~set:[ '.'; '('; ')' ] then 1
  else if s.[i] = '_' then 3
  else 10

let best_match ?(after = 0) ~sub str =
  List.fold_left
    ~init:None
    ~f:(fun acc (i, case_cost) ->
        let left = word_boundary str (pred i)
        and right = word_boundary str (i + String.length sub) / 3
        and cost_after = if i >= after then 0 else 10 in
        let cost = case_cost + left + right + cost_after in
        match acc with
        | Some (_, other_cost) when other_cost < cost -> acc
        | Some _ | None -> Some (i, cost))
    (find_all ~sub str)
  
let best_matches words str =
  let _, found, not_found =
    List.fold_left
      ~f:(fun (i, found, not_found) sub ->
          let len = String.length sub in
          match best_match ~after:i ~sub str with
          | None -> i, found, not_found + len + 50
          | Some (i, cost) -> i + len, found + cost, not_found
        )
      ~init:(0, 0, 0)
      words
  in found + not_found
