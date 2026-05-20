open Ast

open Ast

let rec flat  e =
  match e with
  | E_par(l,es) -> 
      Ast_mapper.map flat @@
      let es' = List.concat @@ List.map (fun e -> match e with E_par(_,es) -> es | _ -> [e]) es in
      if List.compare_lengths es es' = 0 then e else
      let pss = List.map (fun e -> match e with E_par(_,es) -> List.map (fun _ -> P_var (Ast.gensym ())) es | _ -> [P_var (Ast.gensym ())]) es' in
      let p = group_ps @@ List.concat pss in
      let p' = group_ps @@ List.map (fun ps -> P_tuple ps) pss in
      E_letIn(p,Types.new_ty_unknown(),E_par(l,es'), Pattern.pat2exp p')
   | e -> 
     Ast_mapper.map flat e


let flat_pi pi =
  let main = flat pi.main in
  {pi with main}