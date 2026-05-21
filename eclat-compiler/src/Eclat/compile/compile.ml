open BHDL_syntax
open Gen_BHDL

let globalize_flag = ref true

let check_instantaneous_loops_flag = ref true
let check_causality_flag = ref false

let nonormalization = ref false

let target = ref "../target"

let ocaml_output_flag = ref false

module D = Display_internal_steps

let print_elaborated_code_flag = ref true


let compile ?(vhdl_comment="") ?(prop_fsm=true) arg_list name ty fmt pi =
  let pi = if !nonormalization then Inline.inl_pi pi 
           else Middle_end.compile ~globalize:!globalize_flag arg_list ty pi 
  in

  D.display_pi D.MiddleEnd pi;

  let pi = Rename_main_arg.rename_main_arg_pi pi in
  
  if !check_instantaneous_loops_flag then 
    if Check_pauses_loop.check pi.main 
    then () else Prelude.Errors.error (fun fmt -> Format.fprintf fmt "instantaneous loop detected"); 
  
  if !check_causality_flag 
    then Causality_esterel.main pi.main;

  let (id,rdy,result,idle,fsm,_) = 
    Gen_BHDL.main (Ast.gensym()) ~is_zero:(not @@ !Typing.relax_flag) pi in
  Count_externals.count_externals_fsm fsm;

  let statics = pi.genv.statics |> List.filter (function 
    | (_,Ast.Static_array_of _) -> true 
    | (_,Ast.Static_array _) -> true 
    | _ -> false)
        |>
    List.map (function
              | x,Ast.Static_array_of (ty,_) ->
                  x,BHDL_syntax.Static_array_of (BHDL_typing.translate_ty ty)
              | x,Ast.Static_array(c,n) ->
                  x,BHDL_syntax.Static_array(Gen_BHDL.to_c ~genv:pi.genv c,n)
              | _ -> assert false (* already expanded *)
           ) in

  Display_target.(display Fsm fsm);

  let fsm = if prop_fsm then BHDL_propagation.propagation_fsm fsm else fsm in

  let fsm = Flat_let_atom.flat_let_atom fsm in
  Display_target.(display Flat fsm);

  let _typing_env = BHDL_typing.typing_circuit ~statics ~genv:pi.genv ty (rdy,result,fsm) in

  let fsm = List_machines.list_machines fsm in

  let state_var = "state_"^id in
  let argument = "argument" in
  (* let fsm = Remove_assigned_but_not_read_vars.clean_fsm ~rdy ~result fsm _typing_env in *)
  let typing_env = BHDL_typing.typing_circuit ~statics ~genv:pi.genv ty (rdy,result,fsm) in

  let rbw = Rbw_collection.collect_main ~rdy ~result fsm in

  let (argument,result) = 
      Gen_vhdl.pp_component fmt ~registers:rbw ~vhdl_comment ~name 
                                  ~genv:pi.genv ~state_var
                                ~argument ~result ~idle ~rdy ~statics 
                                typing_env (let infos = SMap.empty in infos) fsm
  in

  if !ocaml_output_flag then (
    let oc_c = open_out (!target^"/ml/"^name^"_step.ml") in
    let fmt_c = Format.formatter_of_out_channel oc_c in
    let arg_list_comp = List.map (to_a ~genv:pi.genv) arg_list in
    Gen_ocaml.pp_component fmt_c ~vhdl_comment ~name
                                    ~operators:pi.genv.operators
                                    ~externals:pi.genv.externals ~state_var
                                  ~argument ~result ~idle ~rdy ~statics 
                                  typing_env (let infos = SMap.empty in infos) fsm arg_list_comp;
    close_out oc_c;
      Format.fprintf Format.std_formatter
      "ocaml code generated in %s/ml/%s_step.ml"
        !target name;
  );

  (argument,result,typing_env)
