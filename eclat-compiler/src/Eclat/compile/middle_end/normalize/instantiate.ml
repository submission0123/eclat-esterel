open Ast
open Ast_subst
open Ast_rename

let gen_label () = gensym ~prefix:"label" ()

let rec instantiate ?(with_par=false) ?(with_pauses=false) ?(with_suspend=false) ?(with_trap=false) e =
  let inst = instantiate ~with_par ~with_pauses ~with_suspend in
  match e with
  | E_run(f,e1,_) -> E_run(f,inst e1,gen_label ())
  | E_pause (l,e1) -> 
      let l' = if with_pauses then gen_label () else l in
      E_pause (l',inst e1)
  | E_par (l,es) -> 
      let l' = if with_par then gen_label () else l in
      E_par (l',List.map inst es)
  | E_trap (tyB,l) -> 
      let l' = if with_trap then gen_label () else l in
      E_trap (tyB,l')
  | E_suspend(l,e,x) -> E_suspend((if with_suspend then gen_label() else l),inst e,x)
  | E_exec(e1,e2,eo,_) ->
      E_exec(inst e1,inst e2,Option.map inst eo,gen_label ())
  | E_reg((p,tyB,e1),e0,_) ->
      E_reg((p,tyB,inst e1),inst e0,gen_label ())
  | e -> Ast_mapper.map inst e

let instantiate_pi pi =
  {pi with main = instantiate pi.main }
