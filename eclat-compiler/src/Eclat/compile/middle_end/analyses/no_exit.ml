open Ast
open Ast_subst

let no_exit e =
  let exception Found in
  let rec loop e =
    match e with
    | E_exit _ -> raise Found
    | e -> Ast_mapper.iter loop e
  in 
  try (loop e; true) 
  with Found -> false ;;
