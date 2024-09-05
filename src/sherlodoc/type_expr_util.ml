let of_string str =
  let lexbuf = Lexing.from_string str in
  try
    let result = Type_parser.main Type_lexer.token lexbuf in
    Some result
  with _ -> None
