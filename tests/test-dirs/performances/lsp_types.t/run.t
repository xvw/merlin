  $ ocamlmerlin server stop-server
  [255]

  $ ocamlmerlin server errors -filename lsp_types.ml < lsp_types.ml | jq
  {
    "class": "return",
    "value": [],
    "notifications": [],
    "timing": {
      "clock": 1022,
      "cpu": 1018,
      "query": 5,
      "pp": 0,
      "reader": 270,
      "ppx": 0,
      "typer": 736,
      "error": 8
    },
    "heap_mbytes": 193,
    "cache": {
      "reader_phase": "miss",
      "ppx_phase": "miss",
      "typer": "miss",
      "cmt": {
        "hit": 653,
        "miss": 7
      },
      "cmi": {
        "hit": 0,
        "miss": 7
      }
    },
    "query_num": 0
  }

  $ ocamlmerlin server errors -filename lsp_types.ml < lsp_types.ml | jq
  {
    "class": "return",
    "value": [],
    "notifications": [],
    "timing": {
      "clock": 395,
      "cpu": 394,
      "query": 12,
      "pp": 0,
      "reader": 336,
      "ppx": 0,
      "typer": 40,
      "error": 7
    },
    "heap_mbytes": 305,
    "cache": {
      "reader_phase": "miss",
      "ppx_phase": "miss",
      "typer": {
        "reused": 389,
        "typed": 0
      },
      "cmt": {
        "hit": 0,
        "miss": 0
      },
      "cmi": {
        "hit": 7,
        "miss": 0
      }
    },
    "query_num": 1
  }

  $ echo "let () = () ;; " > lsp_types2.ml
  $ cat lsp_types.ml >> lsp_types2.ml

  $ ocamlmerlin server errors -filename lsp_types.ml < lsp_types2.ml | jq
  {
    "class": "return",
    "value": [],
    "notifications": [],
    "timing": {
      "clock": 1113,
      "cpu": 1111,
      "query": 4,
      "pp": 0,
      "reader": 327,
      "ppx": 0,
      "typer": 773,
      "error": 7
    },
    "heap_mbytes": 547,
    "cache": {
      "reader_phase": "miss",
      "ppx_phase": "miss",
      "typer": {
        "reused": 0,
        "typed": 390
      },
      "cmt": {
        "hit": 660,
        "miss": 0
      },
      "cmi": {
        "hit": 7,
        "miss": 0
      }
    },
    "query_num": 2
  }

  $ ocamlmerlin server stop-server
  [255]
