open BHDL_syntax

let ref_set_lock_flag = ref false

let optim_share_continuation = ref true

let parallel_variant = ref true

module NameC = Naming_convention

module SMap = Map.Make(String)

(** each function definition (refered by its name [f]) is associated to
    a mapping between instance numbers of [f] and their corresponding
    continuations (i.e., target instructions). *)
module IMap = Map.Make(Int)

let (++) = Ast.(++)

let (+++) s1 s2 =
  IMap.fold IMap.add s1 s2

let (++>) s1 s2 =
  SMap.union (fun x s1 s2 -> Some (s1 +++ s2)) s1 s2

(** warning: (++>) has the same type than (++) but behaves differently *)

let mk_int n size =
  assert (n >= 0 && size > 0);
  (Int {value=n;tsize=TSize (max 1 size)})

let new_instance =
  let c  = ref 0 in
  (fun () -> incr c; !c)

let let_plug_s (a:a) (f : x -> s) : s =
  match a with
  | A_var x -> f x
  | _ ->
    let y = Ast.gensym () in
    S_letIn(y,a,f y)

let let_plug_a (a:a) (f : x -> a) : a =
  match a with
  | A_var x -> f x
  | _ ->
    let y = Ast.gensym () in
    A_letIn(y,a,f y)

let gen_external_id =
  let c  = ref 0 in
  (fun () -> incr c; !c)



(** currently, instance numbers are encoded using 12 bits.
    TODO(enhancement): use an enumeration type instead. *)
let id_size = 12 ;;

let contains_return s =
  let rec aux s =
  match s with
  | S_continue(_,q) ->
      NameC.is_return q
  | S_skip
  | S_acquire_lock _ 
  | S_release_lock _
  | S_read_start _
  | S_read_stop _
  | S_write_start _
  | S_write_stop _
  | S_call _
  | S_set _
  | S_sig_set _
  | S_array_set _ 
  | S_array_from_file _
  | S_assert _ -> false
  | S_letIn(_,_,s1) -> aux s1
  | S_seq(s1,s2) -> aux s1 || aux s2
  | S_if(_,s1,so2) -> aux s1 || (match so2 with None -> false | Some s -> aux s)
  | S_case(_,hs,so) ->
      List.exists (fun (_,s) -> aux s) hs || (match so with None -> false | Some s1 -> aux s1)
  | S_fsm _ -> false
  | S_external_run _ -> false
  | S_record_update _ -> false in
  aux s


let rec insert_kont w s =
  let rec aux s =
    match s with
    | S_continue(id,q0) ->
        if NameC.is_return q0 then
          let rq0 = NameC.return_name q0 in
          (match SMap.find_opt q0 w with
           | None -> S_continue(id,rq0)
           | Some u ->
           let l = List.of_seq (IMap.to_seq u) in
           (match l with
            | [] -> S_skip
            | [(_,k)] -> aux k
            | (_,k)::tt when List.for_all (fun (_,k') ->
                               (* would be possible with physical equality ? *)
                               k = k') tt ->
               aux k
            | _ -> assert ((1 lsl id_size) > List.length l);
               S_case(NameC.instance_id_of_fun rq0,
                   (List.map (fun (m,k) ->
                              [mk_int m id_size], aux k
                        ) l),Some S_skip)))
        else s
    | S_if(z,s1,so) ->
        S_if(z,aux s1,Option.map aux so)
    | S_case(z,hs,so) -> S_case(z,List.map (fun (c,si) -> c, aux si) hs,Option.map aux so)
    | S_seq(s1,s2) ->  S_seq(aux s1,aux s2)
    | S_letIn(x,a,s) -> S_letIn(x,a,aux s)
    | S_fsm _ as s -> s (* already compiled *)
    | S_skip
    | S_acquire_lock _ 
    | S_release_lock _
    | S_read_start _
    | S_read_stop _
    | S_write_start _
    | S_write_stop _
    | S_call _
    | S_set _
    | S_external_run _ 
    | S_array_set _ 
    | S_sig_set _
    | S_array_from_file _
    | S_assert _
    | S_record_update _ -> s
  in
  aux s

let loop_insert_kont wmain s =
  let rec loop s =
    let has_changed = ref false in
    let s' = if contains_return s then ( 
              has_changed := true;
              insert_kont wmain s) else s in
    if (!has_changed) then loop s' else s'
  in loop s

let make_fsm state rdy x idle w ts s s_star =
  let wmain = SMap.add idle IMap.empty w in
  let s' = loop_insert_kont wmain s in
  let ts' = List.map (fun (q,s) -> q,loop_insert_kont wmain s) (SMap.bindings ts) in
  seq_ (S_fsm(state,rdy,x,idle,ts',s')) (loop_insert_kont wmain s_star)


let renaming e1 =
  let open Ast in
  let xs = vars_of_smap @@ Free_vars.fv ~get_sig:false ~get_arrays:false e1 in
  let ys = List.map (fun x -> Ast.gensym ~prefix:x ()) xs in
  let group xs = group_ps @@ List.map (fun x -> P_var x) xs in
  let px = group xs in
  let py = group ys in
  let e1' = Ast_subst.subst_p_e px (Pattern.pat2exp py) e1 in
  E_letIn(py,Types.new_ty_unknown(),(Pattern.pat2exp px),e1')



let find_ctor x sums =
  let (n,sum,t) = Types.find_ctor x sums in
  let t = Types.canon_tyB t in
  let arg_size = List.fold_left (max) 0 @@ List.map (fun (_,t) -> BHDL_typing.(size_ty (translate_tyB (Types.canon_tyB t)))) sum in
  let sz = BHDL_typing.compute_tag_size sum in
  let n = if !Types.one_hot_encoding_flag then (1 lsl n) else n in
  (mk_int n sz,arg_size,BHDL_typing.translate_tyB t)


let side_effect ~externals e =
  let open Ast in
  let exception Found in
  let rec loop e =
    match e with
    | E_get _ | E_set _ | E_array_get _ | E_array_set _ 
    | E_array_get_start _ | E_array_get_end _ 
    | E_array_set_immediate _ | E_array_from_file _ ->
        raise Found
    |E_app(e1,_) ->
      (match un_deco e1 with
      | E_const(Op op) ->
          if Instantaneous.op_combinational ~externals op then () else raise Found
      | _ -> Ast_mapper.iter loop e)
    | e -> Ast_mapper.iter loop e
  in 
  try (loop e; false) 
  with Found -> true

let rec to_c ~genv = function
| Ast.Unit -> Unit
| Ast.Int (n,tz) -> Int {value=n;tsize=BHDL_typing.translate_size tz}
| Ast.Bool b -> Bool b
| Ast.Char c -> Char c
| Ast.String s -> String s
| Ast.C_tuple cs -> CTuple (List.map (to_c ~genv) cs)
| Ast.C_vector cs -> CVector (List.map (to_c ~genv) cs)
| Ast.C_size sz -> 
    (match Types.canon_size sz with
     | Sz_lit n -> CSize n
     | _ -> CSize 32) (* todo: deal with the default size elsewhere *)
| Ast.C_appInj(x,c,tyB) ->
    let n,arg_size,ty_n = find_ctor x Ast.(genv.sums) in
    CTuple[n;C_encode(to_c ~genv c,arg_size)]
| Ast.Inj _ -> assert false (* no partial application in the generated code *)
| Ast.(Op op) ->
    Format.(fprintf std_formatter "-->%a" Ast_pprint.pp_op op);  assert false
| Ast.V_loc _ -> assert false
| Ast.Get | Ast.Set | Ast.Ref -> assert false

let to_op = function
| Ast.TyConstr ty -> TyConstr (BHDL_typing.translate_ty ty)
| Ast.Runtime (External_fun(x,ty)) -> Runtime (External_fun(x,ty))
| Ast.Runtime p -> Runtime p
| Ast.GetTuple {pos=i;arity=n} -> GetTuple (i,n,new_tvar())
| Ast.Int_of_size _ -> assert false


let rec to_a ~genv (e:Ast.e) : a =
  match e with
  | Ast.E_var x -> A_var x
  | Ast.E_const c -> A_const (to_c ~genv c)
  | Ast.E_app(E_const(Op((Runtime (External_fun (x,_))) as op)),e1) ->
      (match e1 with
      | E_tuple _ ->
         A_call(to_op op,to_a ~genv e1)
      | _ -> 
        match SMap.find_opt x genv.operators with
        | Some(ty,_) ->
            let targ = match Types.canon_ty ty with
                       | Ty_fun(targ,_,_) -> targ
                       | _ -> assert false in
            let n = match Types.canon_ty targ with
                    | Ty_base(TyB_tuple tyBs) -> List.length tyBs
                    | Ty_base(_) -> 1
                    | _ -> assert false (* ill-typed *) in
            if n = 1 then A_call(to_op op,to_a ~genv e1) else 
            let xs = List.init n (fun x -> Ast.gensym ~prefix:"tmp" ()) in
            let_plug_a (to_a ~genv e1) @@ (fun z ->
              let rec loop i = function
              | [] -> A_call(to_op op,A_tuple(List.map (fun y -> A_var y) xs))
              | x::xs ->
                 A_letIn(x,A_call((to_op @@ GetTuple{pos=i;arity=n}),A_var z), loop (i+1) xs)
              in loop 0 xs
            )
        | None -> assert false (* ill-typed *))
  | Ast.E_app(E_const(Op op),e) ->
      A_call(to_op op,to_a ~genv e)
  | Ast.E_if(e1,e2,e3) -> A_call(If,A_tuple [to_a ~genv e1;to_a ~genv e2;to_a ~genv e3])
  | Ast.E_tuple(es) -> A_tuple (List.map (to_a ~genv) es)
  | Ast.E_letIn(P_var x,_,e1,e2) -> A_letIn(x,to_a ~genv e1,to_a ~genv e2)
  | Ast.E_array_length(x,_) -> A_array_length(x,new_tvar())
  | E_app(E_const(Inj y),e) ->
      let_plug_a (to_a ~genv e) @@ (fun z ->
        let n,arg_size,ty_n = find_ctor y genv.sums in
        A_tuple[A_const(n);A_encode(z,ty_n,arg_size)])
  | Ast.E_vector(es) -> A_vector (List.map (to_a ~genv) es)  
  | Ast.E_sig_get x -> A_sig_get x
  | Ast.E_record b_list ->
     let l = List.sort (fun (x,_) (x',_) -> compare x x') b_list in
     A_record (List.map (fun (x,a) -> x, to_a ~genv a) l)
  | Ast.E_record_field(e1,y,tyB) ->
      let t = BHDL_typing.translate_tyB (Types.canon_tyB tyB) in (* canonize tyB is important *)
      let_plug_a (to_a ~genv e1) @@ fun z -> A_record_field(z,y,t)
  | _ ->
      Format.fprintf Format.std_formatter "--> %a\n"  Ast_pprint.pp_exp  e; assert false


let rec seq_list_ ss = match ss with 
  | [] -> S_skip
  | [s] -> s
  | s::ss' -> seq_ s (seq_list_ ss')

let rec conjonction_atoms alist =
  match alist with
  | [] -> A_const (Bool true)
  | [a1;a2] -> A_call(Runtime (External_fun("Bool.land",Types.new_ty_unknown())), A_tuple(alist))
  | a1::alist' -> let a2 = conjonction_atoms alist' in 
                  A_call(Runtime (External_fun("Bool.land",Types.new_ty_unknown())), A_tuple([a1;a2]))

let rec disjonction_traps vlist = S_skip (*
  match vlist with
  | [] -> A_const (Bool false)
  | [s1;s2] -> A_call(Runtime (External_fun("Bool.lor",Types.new_ty_unknown())), A_tuple([A_var s1;A_var s2]))
  | s1::vlist' -> let a2 = disjonction_traps vlist' in 
                  A_call(Runtime (External_fun("Bool.lor",Types.new_ty_unknown())), A_tuple([A_var s1;a2]))
 *)

let replace_arg e =
  match e with
  | Ast.E_fix(f,(P_var x,_,e1)) -> Ast_subst.subst_e x (E_var (NameC.formal_param_of_fun f)) e1
  | e -> e

(* Debug/Display *)
let [@warning "-26"] show q w =
   SMap.iter (fun x s -> Printf.printf "%s {%s : [" q x;
                        IMap.iter (fun i _ -> Printf.printf "%d," i) s;
                        Printf.printf "]}\n") w


(** [to_s state ~statics ~externals gs e x k] translates expression [e] 
    to a target instruction setting a result in variable [x], 
    then executing instruction [k].
    [gs] is the names of the functions accessible 
    from [e] by a tail-call *)
let rec to_s state ~genv gs e x k =
  let return_ s = seq_ s k in
  if Instantaneous.combinational ~externals:Ast.(genv.operators) e then 
    SMap.empty,SMap.empty,return_ (set_ x (to_a ~genv e)), S_skip
  else
  match e with
  | Ast.E_if(a,e1,e2) ->
      (** [IF] **)
      let go = Ast.gensym ~prefix:"go" () in
      let s_star = let_plug_s (A_sig_get go) (fun z -> S_if(z, k, None)) in
      let k' = (S_sig_set(go,A_const (Bool true))) in
      let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 x k' in
      let w2,ts2,s2,s_star2 = to_s state ~genv gs e2 x k' in
      let z = Ast.gensym () in
      (w1++>w2),(ts1 ++ ts2),S_letIn(z,to_a ~genv a,S_if(z,s1,Some s2)),seq_ s_star1 (seq_ s_star2 s_star)
  | E_case(a,hs,e_els) ->
      (** [CASE] **)
      let go = Ast.gensym ~prefix:"go" () in
      let s_star_go = let_plug_s (A_sig_get go) (fun z -> S_if(z, k, None)) in
      let k' = (S_sig_set(go,A_const (Bool true))) in
      let ws,tss,hs',s_stars = Prelude.map_split4 (fun (cs,e) ->
                                 let w,ts,s,s_star = to_s state ~genv gs e x k' in
                                 w,ts,(List.map (to_c ~genv) cs,s),s_star
                             ) hs
      in
      let ts = List.fold_left (++) SMap.empty tss in
      let w1,ts1,s1,s_star_1 = to_s state ~genv gs e_els x k' in
      let w' = List.fold_left (++>) w1 ws in
      let s_plus = seq_ (seq_ (seq_list_ s_stars) s_star_1) s_star_go in
      w',ts1 ++ ts,(let z = Ast.gensym () in
                    S_letIn(z,to_a ~genv a, S_case(z,hs',Some s1))),s_plus
  | E_match(a,hs,eo) -> 
      (** [MATCH] **)
      let go = Ast.gensym ~prefix:"go" () in
      let s_star_go = let_plug_s (A_sig_get go) (fun z -> S_if(z, k, None)) in
      let k' = (S_sig_set(go,A_const (Bool true))) in

      let z2 = Ast.gensym () in
      let ws,tss,hs',s_stars = 
        Prelude.map_split4 (fun (inj,(py,e)) ->
                                 let y = match py with Ast.P_var y -> y | _ -> assert false in
                                 let w,ts,s,s_star = to_s state ~genv gs e x k' in
                                 let n,_,ty_n = find_ctor inj genv.sums in
                                 w,ts,([n],(seq_ (set_ y (A_decode(z2,ty_n))) @@ s)),s_star
                       ) hs
      in
      let wn,tsn,so,s_star_1 = match eo with
                               | None -> SMap.empty,SMap.empty,Some S_skip, S_skip
                                        (* Some skip rather than None because
                                           the number of cases in the generated code
                                           must be a power of 2 *)
                               | Some e -> let w,ts,s,s_star = to_s state ~genv gs e x k in
                                           (w,ts,Some s,s_star)
      in
      let ts = List.fold_left (++) tsn tss in
      let w' = List.fold_left (++>) wn ws in
      let s_plus = seq_ (seq_ (seq_list_ s_stars) s_star_1) s_star_go in
      w',ts,(let z = Ast.gensym () in
             let z1 = Ast.gensym () in
             S_letIn(z,to_a ~genv a,
             S_letIn(z1,A_call((to_op @@ (GetTuple{pos=0;arity=2}),A_var z)),
             S_letIn(z2,A_call((to_op @@ (GetTuple{pos=1;arity=2}),A_var z)),
             S_case(z1,hs',so))))),s_plus
  | E_letIn(P_var y,_,E_sig_create(ey),e1) ->
      let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 x k in
      w1,ts1,(* seq_ (S_sig_set(y,to_a ~externals ~sums ey))*) s1,s_star1

  | E_letIn(P_var f,_,E_trap(_,l),e2) ->
      (****** cancel pending memory transaction *******)
      let ys = Free_vars.fv_arrays e2 in
      let ys = List.map fst @@ SMap.bindings @@ ys in
      let s_star_restart = seq_list_ @@ 
        List.map (fun x -> seq_ (S_release_lock(x)) @@ (S_write_stop(x))) ys in
      (************************************************)
      let w1,ts1,s1,s_star1 = to_s state ~genv gs e2 x (S_sig_set(f,A_const (Bool true))) in
      let s_plus = seq_ s_star1 (let_plug_s (A_sig_get f) (fun zz -> S_if(zz, (seq_ s_star_restart k),None))) in
      w1,ts1,s1,s_plus 
  | E_exit(f,_) ->
      SMap.empty, SMap.empty, (S_sig_set(f,A_const (Bool true))),S_skip
  | E_suspend(q,e1,y) ->
      let rdy = Ast.gensym ~prefix:"rdy" () in
      let inner = q^"inner" in
      let w,ts,s,s_star = to_s inner ~genv gs e1 x (S_sig_set(rdy, A_const (Bool true))) in (*todo, insert_kont *)
      let s' = S_fsm(inner,Ast.gensym(),x,Ast.gensym (),SMap.bindings ts,S_skip) in
      let s_plus = seq_ s_star (let_plug_s (A_sig_get rdy) (fun z -> S_if(z, k, None))) in
      (w,SMap.singleton q (let_plug_s (A_sig_get y) (fun z -> S_if(z, S_skip,Some(s')))),seq_ s (S_continue(state,q)),s_plus)
| E_abort(e1,y,q) -> (** y not checked in first cycle (like await) **)
      let rdy = Ast.gensym ~prefix:"rdy" () in
      let inner = q^"inner" in
      let w,ts,s,s_star = to_s inner ~genv gs e1 x (S_sig_set(rdy, A_const (Bool true))) in (*todo, insert_kont *)
      let s' = S_fsm(inner,Ast.gensym(),x,Ast.gensym (),SMap.bindings ts,S_skip) in
      let s_plus = seq_ s_star (let_plug_s (A_sig_get rdy) (fun z -> S_if(z,k, None))) in
      (w,SMap.singleton q (let_plug_s (A_sig_get y) (fun z -> S_if(z, (S_sig_set(rdy, A_const (Bool true))),Some(s')))),seq_ s (S_continue(state,q)),s_plus)

  | E_loop(e1) ->
      let e1' = Instantiate.instantiate ~with_par:false ~with_pauses:false @@ 
               Ast_rename.rename_trap_and_signals ~statics:genv.statics (Check_pauses_loop.surface e1) in
      let z = Ast.gensym ~prefix:"z" () in
      let _,_,s2,s_plus = to_s state ~genv gs e1' z S_skip in
      let w1,ts1,s1,s_star = to_s state ~genv gs e1 x s2 in
      w1,ts1, s1, seq_ s_star s_plus
  | E_pause(l,e1) ->
      let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 x (S_continue(state,l)) in
      (* let ts1' = if endloop then ts1 else SMap.add l k ts1 in *)
      let ts1' = SMap.add l k ts1 in
      (w1,ts1', s1,s_star1)
  | E_emit(x,ey) ->
       SMap.empty,SMap.empty,(return_ @@ S_sig_set(x,to_a ~genv ey)), S_skip
  | E_await(x,q) ->
      SMap.empty, SMap.singleton q (let_plug_s (A_sig_get x) (fun z -> S_if(z, k,  None))), S_continue(state,q), S_skip
  | E_letIn(P_var f,_,(E_fix(h,(p,_,e1)) as phi),e2) ->
     assert (f = h);
     let e1 = replace_arg phi in
     let f' = NameC.mark_return f in
     let w1,ts1,s1,s_star1 = to_s state ~genv (f::gs) e1 (NameC.result_of_fun f) (S_continue(state, f')) in
     let w2,ts2,s2,s_star2 = to_s state ~genv gs e2 x k in
     (w1++>w2),(SMap.add f s1 ts1)++ts2,s2,seq_ s_star1 s_star2
  | E_letIn(P_unit,_,e1,e2) ->
      (* [SEQ] *)
      let w2,ts2,s2,s_star2 = to_s state ~genv gs e2 x k in
      if Instantaneous.combinational ~externals:genv.operators e1 then (* todo: emit a warning ? *) (w2,ts2,s2,s_star2) else
      let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 (Ast.gensym ()) s2 in
      w1++>w2,ts2++ts1,s1,seq_ s_star1 s_star2
  | E_letIn(P_var y,_,e1,e2) ->
      (* [LET] *)
      let w2,ts2,s2,s_star2 = to_s state ~genv gs e2 x k in
      if Instantaneous.combinational ~externals:genv.operators e1 then
        w2,ts2,seq_ (set_ y (to_a ~genv e1)) s2,s_star2
      else
        let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 y s2 in
        w1++>w2,ts2++ts1,s1,seq_ s_star1 s_star2
  | E_app(E_var f,a) ->
      if List.mem f gs then
          (* [TAIL-CALL] *)
          let s = seq_ (set_ (NameC.formal_param_of_fun f) (to_a ~genv a)) @@
                        S_continue(state,f) in
           (SMap.empty,SMap.empty,s,S_skip)
      else
          (* [DIRECT-CALL] *)
          let n = new_instance () in
          let w = SMap.singleton (NameC.mark_return f) (IMap.singleton n (seq_ (set_ x (A_var (NameC.result_of_fun f))) k)) in
          let s = seq_ (set_ (NameC.instance_id_of_fun f) (A_const (mk_int n id_size))) @@
                  seq_ (set_ (NameC.formal_param_of_fun f) (to_a ~genv a)) @@
                       S_continue(state,f) in
          (w,SMap.empty,s,S_skip)
  | E_app(E_const(Op((Runtime _) as op)),a) ->
      (* in case of instantaneous call which is not combinatorial,
         e.g., a display function for debug  *)
      SMap.empty, SMap.empty, return_ (set_ x (A_call(to_op op,to_a ~genv a))), S_skip
                               

  | E_ref(a) -> SMap.empty, SMap.empty, 
                return_ (set_ x (to_a ~genv a)), S_skip
  | E_get(ay) -> 
      (match ay with
      | E_var y ->
         if !ref_set_lock_flag then
           let q_wait = Ast.gensym ~prefix:"get_wait" () in
           let s0 = S_if(y^"_lock", (S_continue(state,q_wait)), Some (
                           (return_ (set_ x (A_var y))))) in
            (SMap.empty, SMap.add q_wait s0 SMap.empty, s0, S_skip)
         else
           SMap.empty, SMap.empty, return_ (set_ x (A_var y)), S_skip
      | _ -> assert false)
  | E_set(ay,a) ->
      if !ref_set_lock_flag then
      (match ay with
       | E_var y ->
          let q_wait = Ast.gensym ~prefix:"get_wait" () in
          let q1 = Ast.gensym ~prefix:"get_pause" () in
          let w,ts,s,s_star = to_s state ~genv gs (E_const Unit) x k in
          let s0 = S_if(y^"_lock", 
                       S_continue(state,q_wait), Some(seq_ (set_ (y^"_lock") (A_const (Bool true))) @@
                        seq_ (set_ y (to_a ~genv a)) @@ (S_continue(state,q1)))) in
          (w, (SMap.add q1 (seq_ (set_ (y^"_lock") (A_const (Bool false))) s) @@
               SMap.add q_wait s0 ts), s0, s_star)
       | _ -> assert false) else
      (match ay with
       | E_var y ->
          let w,ts,s,s_star = to_s state ~genv gs (E_const Unit) x k in
          (w, ts, seq_ (set_ y (to_a ~genv a)) s, s_star)
       | _ -> assert false)
  | E_array_get((y,_),idx) ->
      let a = to_a ~genv idx in
      let q = Ast.gensym ~prefix:"pause_get" () in
      let ts = SMap.add q (return_ @@ 
                  seq_ (S_read_stop(x,y)) 
                       (S_release_lock(y))) SMap.empty in 
      let s = seq_ (S_acquire_lock(y)) @@
              seq_ (S_read_start(y,a)) (S_continue(state, q)) in
        let q_wait = Ast.gensym ~prefix:"q_wait" () in
        let s' = let_plug_s (A_ptr_taken(y)) @@ fun z ->
                 S_if(z, (S_continue(state,q_wait)), Some s) in
        (SMap.empty, SMap.add q_wait s' ts, s',S_skip)
  | E_array_set((y,_),idx,e_upd) ->
      let a = to_a ~genv idx in
      let a_upd = to_a ~genv e_upd in
      let q = Ast.gensym ~prefix:"pause_set" () in
      let ts = SMap.add q (
            return_ @@ (seq_ (S_write_stop(y)) @@
                        seq_ (S_release_lock(y)) @@ 
                        set_ x (A_const Unit))) SMap.empty  in
      let q_wait = Ast.gensym ~prefix:"q_wait" () in
      let s' = let_plug_s (A_ptr_taken(y)) @@ fun z ->
                 S_if(z, (S_continue(state,q_wait)),
                           Some (seq_ (S_acquire_lock(y)) @@
                                 seq_ (S_write_start(y,a,a_upd)) @@
                                      (S_continue(state,q)))) in
      (SMap.empty, SMap.add q_wait s' ts, s',S_skip)
      (* todo: pas besoin de dupliquer s': l'écriture en tant que telle ne prend que 1 cycle : on peut la faire démarrer un cycle plus tard *)

  | E_array_get_start((y,_),idx) ->
      let a = to_a ~genv idx in
      let s = (* let_plug_s (A_ptr_taken(y)) @@ fun z ->
                S_if(z, S_skip, Some(S_read_start(y,a))) *) seq_ (S_acquire_lock(y)) (S_read_start(y,a)) in
      (SMap.empty, SMap.empty, return_ s,S_skip)
  | E_array_get_end(y,_) ->
      let s = seq_ (S_release_lock(y)) (S_read_stop(x,y)) in
      (SMap.empty, SMap.empty, return_ s,S_skip)
  | E_array_set_immediate((y,_),idx,e_upd) ->
      let a = to_a ~genv idx in
      let a_upd = to_a ~genv e_upd in
      let s = S_write_start(y,a,a_upd) in
      (SMap.empty, SMap.empty, return_ s,S_skip)
  | E_array_from_file(y,e1) ->
      let a = to_a ~genv e1 in
      (* ***************************************** *)
      let s0 = return_ @@ S_array_from_file(y,a) in
      (* ***************************************** *)
      let q1 = Ast.gensym ~prefix:"pause_array_from_file" () in
      let ts = SMap.add q1 (seq_ (S_release_lock(y)) @@
                                 (return_ @@ seq_ (set_ x (A_const Unit)) s0)) 
               SMap.empty  in
      let s = (S_continue(state,q1)) in
      let q_wait = Ast.gensym ~prefix:"q_wait" () in
      let s' = let_plug_s (A_ptr_taken(y)) @@ fun z ->
                 S_if(z, (S_continue(state,q_wait)),
                           Some (seq_ (S_acquire_lock(y)) @@ s)) in
      (SMap.empty, SMap.add q_wait s' ts, s',S_skip)
   | E_reg((p,_,e1),e0,l) ->
     let y = match p with
              | P_var y -> y 
              | _ -> assert false 
      in
      let rec is_default e = 
       let exception Found in 
       try let c = Ast.e2c e in
       let rec w_c = function
                    | Ast.Unit -> ()
        | Ast.Int (0,_) -> () 
                    | Ast.Bool false -> ()
                    | Ast.C_tuple cs | Ast.C_vector cs -> List.iter w_c cs
                    | _ -> raise Found in  w_c c ; true with Ast.Not_a_constant | Found -> false
      in
      if is_default e0 then
        (** optimization, avoid extra register [l] for initialization *)
        let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 y (return_ (set_ x (A_var y))) in
        w1,ts1,s1,s_star1
      else
        let w1,ts1,s1,s_star1 = to_s state ~genv gs e1 y (return_ (set_ x (A_var y))) in
        let w0,ts0,s0,s_star0 = to_s state ~genv [] e0 y S_skip in
        w1++>w0,ts1,(seq_ (S_if(l, S_skip, Some (seq_ (set_ l (A_const (Bool true))) s0))) s1),seq_ s_star0 s_star1

  | E_exec(e1,e0,eo,l) ->
      let inner = Ast.gensym ~prefix:"inner" () in
      let rdy = Ast.gensym ~prefix:"rdy" () in
      let idle' = Ast.gensym ~prefix:"idle" () in
      let z = Ast.gensym ~prefix:"z" () in
      let e1_ren = renaming e1 in
      let w,ts,s,s_star = to_s inner ~genv [idle'] e1_ren z (seq_ (S_sig_set(rdy,A_const (Bool true))) @@ S_continue(inner,idle')) in
      let fsm = make_fsm inner rdy z idle' w ts s s_star in
      let s' = seq_ fsm @@
               seq_ (let_plug_s (A_sig_get rdy) (fun zz ->
                     S_if(zz,(set_ x @@ A_tuple[A_var z;A_const (Bool true)]),
                          Some(set_ x @@ A_tuple[to_a ~genv e0;A_const (Bool false)])))) @@ k 
      in
      let s'' = match eo with
                 | None -> s'
                 | Some e3 -> (** reinitialize the computation as soon as [e3] is [true] **)
                    seq_ (let_plug_s (to_a ~genv e3) (fun v ->
                          S_if(v, S_continue(inner,idle'), None))) s'
      in
      (SMap.empty, SMap.empty, s'',S_skip)


| E_par(q,es) ->
      let compile i e_i =
        let id = string_of_int i in
        let inner = q^id in
        let rdy = Ast.gensym ~prefix:"rdy" () in
        let idle = "idle"^id in
        let result = Ast.gensym ~prefix:"result" () in
        let w,ts,s,s_star = to_s inner ~genv [idle] e_i result 
           (seq_ (S_sig_set(rdy,A_const (Bool true))) @@ S_continue(inner,idle)) in
        let wmain = SMap.add idle IMap.empty w in
        let f s = loop_insert_kont wmain s in
        (inner,rdy,result,idle,(List.map (fun (q,s) -> q, f s) (SMap.bindings ts),f s),f s_star)
      in
      let pi_s = List.mapi compile es in
      let rdys = List.map (fun (_,rdy_i,_,_,_,_) -> A_sig_get rdy_i) pi_s in
      let ress = List.map (fun (_,_,res_i,_,_,_) -> A_var res_i) pi_s in
      let s_plus = let_plug_s (conjonction_atoms rdys) (fun z ->
                           S_if(z, (seq_ (S_set(x,(A_tuple ress))) @@ k),None)) in
      if side_effect ~externals:(genv.operators) e then 
        let ts = SMap.singleton q (
          let s_list' = List.map (fun (id_i,rdy_i,res_i,idle_i,(ts_i,s_i),s_star) -> 
                           seq_ (S_fsm(id_i,rdy_i,res_i,idle_i,ts_i,S_sig_set(rdy_i,(A_const (Bool true))))) s_star) pi_s
          in (seq_list_ s_list')
        ) in
        let s_inFsm_list = List.map (fun (id_i,rdy_i,res_i,idle_i,(ts_i,s_i),s_star) ->
                                     seq_ s_i s_star) pi_s in
        SMap.empty,ts, seq_ (seq_list_ s_inFsm_list) (S_continue(state,q)), s_plus
      else if !parallel_variant then
        (****** variant using an additional finalization signal ********)
        (****** gives slightly better results (area, register, frequency) 
                with the Quartus Prime synthesizer *********************)
        let go = Ast.gensym ~prefix:"go" () in
        let s_star = List.map (fun (_,_,_,_,_,s_star) -> s_star) pi_s |> List.fold_left seq_ S_skip in
        let s_plus = seq_ s_star @@ let_plug_s (A_sig_get go) (fun z -> S_if(z, 
                      let_plug_s (conjonction_atoms rdys) (fun z ->
                        S_if(z, (seq_ (S_set(x,(A_tuple ress))) @@ k),Some (S_continue(state,q)))), None))  in
        let ts = SMap.singleton q (
          let s_list' = List.map (fun (id_i,rdy_i,res_i,idle_i,(ts_i,s_i),_) -> 
                           (S_fsm(id_i,rdy_i,res_i,idle_i,ts_i,S_sig_set(rdy_i,(A_const (Bool true)))))) pi_s
          in seq_ (seq_list_ s_list') (S_sig_set(go,(A_const (Bool true))))
        ) in
        let s_inFsm_list = List.map (fun (id_i,rdy_i,res_i,idle_i,(ts_i,s_i),_) -> s_i) pi_s in
        SMap.empty,ts,  seq_ (seq_list_ s_inFsm_list) (S_sig_set(go,(A_const (Bool true)))),s_plus
        (****************************************************************)
      else
        let s_star = List.map (fun (_,_,_,_,_,s_star) -> s_star) pi_s |> List.fold_left seq_ S_skip in
        let ts = SMap.singleton q (
          let s_list' = List.map (fun (id_i,rdy_i,res_i,idle_i,(ts_i,s_i),_) -> 
                           (S_fsm(id_i,rdy_i,res_i,idle_i,ts_i,S_sig_set(rdy_i,(A_const (Bool true)))))) pi_s
          in (seq_list_ s_list')
        ) in
        let s_inFsm_list = List.map (fun (id_i,rdy_i,res_i,idle_i,(ts_i,s_i),_) -> s_i) pi_s in
        SMap.empty,ts,  seq_ (seq_list_ s_inFsm_list) (S_continue(state,q)),seq_ s_star s_plus
  | E_for(y,e1,e2,e3,sz,loc) ->
      let q1 = Ast.gensym ~prefix:"forloop" () in
      let s1 = seq_ (set_ y (to_a  ~genv e1)) @@ S_continue(state, q1) in
      let a2 = to_a ~genv e2 in
      let w3,ts3,s3,s_star3 = to_s state ~genv gs e3 x 
                         (seq_ (set_ y (A_call(Runtime (External_fun("Int.add",Types.new_ty_unknown())),A_tuple[A_var y;A_const (Int {value=1;tsize=(new_tvar())})]))) @@
                               (S_continue(state, q1))) in
      let s2 = let_plug_s (A_call(Runtime (External_fun("Int.le",Types.new_ty_unknown())),A_tuple[A_var y;a2])) @@ fun z ->
                S_if(z,s3,Some k) in
      w3,(SMap.add q1 s2 ts3),s1,s_star3
  | E_parfor _ -> assert false (* already expanded *)
  | E_fun _ | E_fix _ -> 
     (* can occur in case of higher order function that does not use its argument,
        e.g.: [let rec f g = f g in f (fun x -> x)].
        We can safely ignore it in this case *)
  SMap.empty,SMap.empty,return_ (set_ x (A_const Unit)), S_skip

  | E_run(f,e,l) ->
      let args = to_a ~genv e in
      let externals =
        let e1, e2 = genv.externals, genv.operators in
        List.fold_left (fun env (x,(ty,shared,loc)) -> Types.SMap.add x (ty, shared,loc) env) Types.SMap.empty e1,
        genv.operators in
      begin
        match SMap.find_opt f (fst externals) with
        | Some(ty,shared,_) ->
            (* let is_instantaneous = match Types.canon_ty ty with
                                    | Ty_fun(_,Dur_zero,_) -> true
                                    | _ -> false in*)
            let id = if shared then f else l in             
            if not(shared) then 
              let q1 = Ast.gensym ~prefix:"pause_external" () in
              let external_result = Ast.gensym ~prefix:"external_result" () in
              let external_rdy = Ast.gensym ~prefix:"external_rdy" () in
              let s = seq_ (S_external_run(f,id,external_result,external_rdy,args)) @@
                            S_if(external_rdy,return_ (set_ x (A_var external_result)),
                              Some (S_continue(state, q1))) in 
              let ts = SMap.add q1 s SMap.empty in 
              (SMap.empty, ts, s,S_skip)
            else 
              let qwait = Ast.gensym ~prefix:"external_wait_lock" () in
              let q1 = Ast.gensym ~prefix:"pause_external" () in
              let external_result = Ast.gensym ~prefix:"external_result" () in
              let external_rdy = Ast.gensym ~prefix:"external_rdy" () in
              let s = seq_ (S_external_run(f,id,external_result,external_rdy,args)) @@
                            S_if(external_rdy,return_ (seq_ (S_release_lock(f)) @@ 
                                                       set_ x (A_var external_result)),
                              Some (S_continue(state,q1))) 
              in
              let s0 = let_plug_s (A_ptr_taken(f)) @@ fun z ->
                       S_if(z,S_continue(state, qwait),
                          Some (seq_ (S_acquire_lock(f)) @@ S_continue(state, q1))) in
              let ts = SMap.add q1 s @@
                       SMap.add qwait s0 SMap.empty in 
              (SMap.empty, ts, s0,S_skip)
        | None -> assert false (* ill-typed *)
      end

  | E_assert(e1,loc) ->
      let a = to_a ~genv e1 in
      SMap.empty,SMap.empty,(return_ @@ S_assert(a,loc)), S_skip
  
  | E_record_update(e1,x2,e2,tyB) ->
      let z1 = Ast.gensym () in
      let t = BHDL_typing.translate_tyB (Types.canon_tyB tyB) in (* canonize tyB is important *)
      SMap.empty, SMap.empty,S_letIn(z1,to_a ~genv e1,(return_ @@ S_record_update(x,z1,x2,to_a ~genv e2,t))), S_skip

  | e -> Ast_pprint.pp_exp Format.std_formatter e; assert false (* todo *)

let main ?(id="state") ?(result="result_"^id) pi =
  let rdy = Ast.gensym ~prefix:"rdy" () in
  let idle = Ast.gensym ~prefix:"idle" () in
  let result = Ast.gensym ~prefix:"res" () in
  let e1_ren = renaming Ast.(pi.main) in
  let inner = Ast.gensym ~prefix:"state" () in
  let w,ts,s,s_star = to_s inner ~genv:pi.genv [idle] e1_ren result 
     (seq_ (S_sig_set(rdy,A_const (Bool true))) @@ S_continue(id,idle)) in
  let fsm = make_fsm inner rdy result idle w ts s s_star in
  id,rdy,result,idle,([],fsm), S_skip
