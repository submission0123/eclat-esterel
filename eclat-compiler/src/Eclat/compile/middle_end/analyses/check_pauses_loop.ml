open Ast
open Ast_subst

let rec find env e =
  match e with
  | E_letIn(_,_,E_trap _,e2) -> 
      let n = find env e2 in
      if n > 0 && No_exit.no_exit (surface e2) then n else 0
  | E_letIn(P_var f,_,E_fix _,e2) ->
      find (SMap.add f () env) e2
  | E_letIn(_,_,e1,e2) ->
      find env e1 + find env e2
  | E_if(_,e1,e2) ->
      min (find env e1) (find env e2)
  | E_app(E_var f,_) -> if SMap.mem f env then 1 else 0
  | E_loop _ -> 1
  | E_par(_,es) -> List.fold_left min max_int @@ List.map (find env) es
  | E_pause _ -> 1
  | E_suspend(_,e1,_) -> find env e1
  | E_await _ -> 1
  | E_abort(e1,_,_) -> min (find env e1) 1
  | E_get _ | E_set _ -> 0
  | E_array_get _ | E_array_set _ -> 1
  | _ -> 0

and surface e =
  match e with
  | E_letIn(p,ty,E_sig_create a,e2) ->
      E_letIn(p,ty,E_sig_create a,surface e2)
  | E_letIn(p,ty,e1,e2) ->
      if has_pause e1 then surface e1 else E_letIn(p,ty,surface e1,surface e2)
  | e -> Ast_mapper.map surface e


and has_pause e = find SMap.empty e > 0

let check e =
  let exception Found in
  let rec loop e =
    match e with
    | E_loop(e1) -> if has_pause e1 then () else raise Found
    | e -> Ast_mapper.iter loop e
  in 
  try (loop e; true) 
  with Found -> false
