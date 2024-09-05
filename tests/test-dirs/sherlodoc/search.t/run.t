  $ $MERLIN single search-by-type -filename ./search.ml \
  > -position 5:25 -limit 10 -query "string -> int option" |
  > jq '.value[] | {name,type,cost,in_stdlib}'
  {
    "name": "int_of_string_opt",
    "type": "string -> int option",
    "cost": 22,
    "in_stdlib": false
  }
  {
    "name": "int_of_string_opt",
    "type": "string -> int option",
    "cost": 22,
    "in_stdlib": false
  }
  {
    "name": "Stdlib__Int32.of_string_opt",
    "type": "string -> int32 option",
    "cost": 37,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__Int64.of_string_opt",
    "type": "string -> int64 option",
    "cost": 37,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__Nativeint.of_string_opt",
    "type": "string -> nativeint option",
    "cost": 51,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__String.index_opt",
    "type": "string -> char -> int option",
    "cost": 54,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__String.rindex_opt",
    "type": "string -> char -> int option",
    "cost": 55,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__StringLabels.index_opt",
    "type": "string -> char -> int option",
    "cost": 60,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__StringLabels.rindex_opt",
    "type": "string -> char -> int option",
    "cost": 61,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__String.index_from_opt",
    "type": "string -> int -> char -> int option",
    "cost": 84,
    "in_stdlib": true
  }


  $ $MERLIN single search-by-type -filename ./search.ml \
  > -position 5:25 -limit 10 -query "('a -> 'b) -> 'a list -> 'b list" |
  > jq '.value[] | {name,type,cost,in_stdlib}'
  {
    "name": "Stdlib__List.map",
    "type": "('a -> 'b) -> 'a list -> 'b list",
    "cost": 36,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.rev_map",
    "type": "('a -> 'b) -> 'a list -> 'b list",
    "cost": 40,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.map",
    "type": "f:('a -> 'b) -> 'a list -> 'b list",
    "cost": 42,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.rev_map",
    "type": "f:('a -> 'b) -> 'a list -> 'b list",
    "cost": 46,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.mapi",
    "type": "(int -> 'a -> 'b) -> 'a list -> 'b list",
    "cost": 72,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.mapi",
    "type": "f:(int -> 'a -> 'b) -> 'a list -> 'b list",
    "cost": 78,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.map2",
    "type": "('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list",
    "cost": 87,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.rev_map2",
    "type": "('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list",
    "cost": 91,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.map2",
    "type": "f:('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list",
    "cost": 93,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.filter_map",
    "type": "('a -> 'b option) -> 'a list -> 'b list",
    "cost": 93,
    "in_stdlib": true
  }

  $ $MERLIN single search-by-type -filename ./search.ml \
  > -position 5:25 -limit 10 -query "List : ('a -> 'b) -> 'a list -> 'b list" |
  > jq '.value[] | {name,type,cost,in_stdlib}'
  {
    "name": "Stdlib__List.map",
    "type": "('a -> 'b) -> 'a list -> 'b list",
    "cost": 51,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.rev_map",
    "type": "('a -> 'b) -> 'a list -> 'b list",
    "cost": 55,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.map",
    "type": "f:('a -> 'b) -> 'a list -> 'b list",
    "cost": 72,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.rev_map",
    "type": "f:('a -> 'b) -> 'a list -> 'b list",
    "cost": 76,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.mapi",
    "type": "(int -> 'a -> 'b) -> 'a list -> 'b list",
    "cost": 87,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.map2",
    "type": "('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list",
    "cost": 102,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.rev_map2",
    "type": "('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list",
    "cost": 106,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.mapi",
    "type": "f:(int -> 'a -> 'b) -> 'a list -> 'b list",
    "cost": 108,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.filter_map",
    "type": "('a -> 'b option) -> 'a list -> 'b list",
    "cost": 108,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.concat_map",
    "type": "('a -> 'b list) -> 'a list -> 'b list",
    "cost": 108,
    "in_stdlib": true
  }


  $ $MERLIN single search-by-type -filename ./search.ml \
  > -position 5:25 -limit 10 -query "'a -> ('a, 'b) Hashtbl.t -> 'b option" |
  > jq '.value[] | {name,type,cost,in_stdlib}'
  {
    "name": "Stdlib__Hashtbl.find_opt",
    "type": "('a, 'b) Stdlib__Hashtbl.t -> 'a -> 'b option",
    "cost": 79,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__MoreLabels.Hashtbl.find_opt",
    "type": "('a, 'b) Stdlib__MoreLabels.Hashtbl.t -> 'a -> 'b option",
    "cost": 80,
    "in_stdlib": true
  }



  $ $MERLIN single search-by-type -filename ./search.ml \
  > -position 5:25 -limit 10 -query "In_channel : list list -> list" |
  > jq '.value[] | {name,type,cost,in_stdlib}'
  {
    "name": "Stdlib__List.concat",
    "type": "'a list list -> 'a list",
    "cost": 324,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__List.flatten",
    "type": "'a list list -> 'a list",
    "cost": 325,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.concat",
    "type": "'a list list -> 'a list",
    "cost": 330,
    "in_stdlib": true
  }
  {
    "name": "Stdlib__ListLabels.flatten",
    "type": "'a list list -> 'a list",
    "cost": 331,
    "in_stdlib": true
  }

