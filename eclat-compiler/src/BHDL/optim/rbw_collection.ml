(** This data-flow analysis computes the WAR variables occuring 
    in a given BHDL program.
    
    In the BHDL implementation, each write-after-read variable
    need two synchronous signals now/next (i.e., registers) 
    to carry the updated value across clock cycles. 
    Other variables can be implemented with classical VHDL variables.

**)

open BHDL_syntax

module SMap = Ast.SMap

let union m1 m2 = SMap.union (fun _ _ _ -> Some ()) m1 m2
let inter m1 m2 = SMap.filter (fun x () -> SMap.mem x m2) m1
let empty = SMap.empty
let add x m = SMap.add x () m
let singleton x = SMap.singleton x ()
let diff m1 m2 =
  SMap.merge
    (fun _ v1 v2 ->
       match v1, v2 with
       | Some v, None -> Some v
       | _ -> None)
    m1 m2

let vars_a a =
  let rec collect m = function
  | A_var x -> add x m
  | A_sig_get _ -> m
  | A_vector aa
  | A_tuple aa -> List.fold_left collect m aa
  | A_letIn(x,a1,a2) ->
      let m1 = add x m in
      let m2 = collect m1 a1 in
      let m3 = collect m2 a2 in
      m3
  | (A_const _) -> m
  | A_call(_,a) ->
     collect m a
  | A_string_get(x,y) ->
     add x (add y m)
  | A_array_get(x,y) ->
     add x (add y m)
  | A_ptr_taken(x) -> add (BHDL_typing.ptr_taken x) m
  | A_array_length(x,_) -> m
  | A_encode(x,_,_)
  | A_decode(x,_) -> (* ok ? *)
      add x m
  | A_record bs ->
      List.fold_left collect m (List.map snd bs)
  | A_record_field(x,_,_) -> add x m
  in
  collect empty a

(* let check s (r,w,war) =
  Format.(fprintf std_formatter "---- %a:\nR[" BHDL_syntax.Debug.pp_s s;
  SMap.iter (fun x () -> fprintf std_formatter "%s;" x) r;
  fprintf std_formatter "]\nW[";
  SMap.iter (fun x () -> fprintf std_formatter "%s;" x) w;
  fprintf std_formatter "]\nWAR[";
  SMap.iter (fun x () -> fprintf std_formatter "%s;" x) war;
    fprintf std_formatter "]\n===================\n\n"); 

  (r,w,war) ;;*)

(* compute read-before-write variables *)
let rec compute s acc =
  match s with
  | S_skip -> (acc, empty)
  | S_continue _ -> (acc, empty)
  | S_set(x,a) ->   
      let rbw = diff (vars_a a) acc in
     (add x acc, rbw)
  | S_seq(s1,s2) ->
      let (acc1, rbw1) = compute s1 acc in
      let (acc2, rbw2) = compute s2 acc1 in
      (acc2, union rbw1 rbw2)
  | S_if(x, s1, so) ->
      let rbw = diff (singleton x) acc in
      let (_, rwb1) = compute s1 acc in
      let rwb2 = match so with
                 | None -> empty
                 | Some s2 -> let (_,rwb2) = compute s2 acc in rwb2 in
      (acc, (union rbw @@ union rwb1 rwb2))
  | S_letIn(x,a,s) ->
      compute (S_seq(S_set(x,a),s)) acc
  | S_case(x,hs,so) -> 
      let rbw = diff (singleton x) acc in
      let rbw' = List.fold_left (fun rbw (_,s1) -> let (_, rbw1) = compute s1 acc in union rbw rbw1) rbw hs in
      (match so with
      | None -> (acc, rbw')
      | Some s1 ->
          let (_, rwb1) = compute s1 acc in
          (acc, union rbw' rwb1))
  | S_fsm(_,rdy,result,_,ts,s0) ->
      let rbw = List.fold_left (fun rbw (_,s1) -> let (_, rbw1) = compute s1 acc in union rbw rbw1) empty ts in
      let (_, rwb0) = compute s0 acc in
      let acc' = add rdy @@ add result acc in
      (acc', union rbw rwb0)
  | S_sig_set(_,a) ->
      let rbw = diff (vars_a a) acc in
      (acc, rbw)
  | S_acquire_lock(x)
  | S_release_lock(x) ->
      let rbw = diff (singleton (BHDL_typing.ptr_taken x)) acc in
      (acc, rbw)
  | S_read_start(_,a) ->
      let rbw = diff (vars_a a) acc in
      (acc, rbw)
  | S_read_stop _ ->
      (empty, empty)
  | S_write_start(_,a,a_upd) ->
      let rbw1 = diff (vars_a a) acc in
      let rbw2 = diff (vars_a a_upd) acc in
      (acc, union rbw1 rbw2)
  | S_write_stop _ ->
      (empty, empty)
  | S_array_set(_,y,a) ->
      let rbw = diff (add y (vars_a a)) acc in
      (acc, rbw)
  | S_array_from_file(_,a) ->
      let rbw = diff (vars_a a) acc in
      (acc, rbw)
  | S_call(_,a) ->
      let rbw = diff (vars_a a) acc in
      (acc, rbw)
  | S_external_run(_,_,_,_,a) ->
      let rbw = diff (vars_a a) acc in
      (acc, rbw)
  | S_assert(a,_) ->
      let rbw = diff (vars_a a) acc in
      (acc, rbw)
  | S_record_update(x,y,z,a,_) ->
      let rbw = diff (add y @@ add z @@ vars_a a) acc in
      (add x acc, rbw)

let collect_main ~rdy ~result (ts,s) =
  let unused_id = "%" in
  let (_, rbw) = compute (S_fsm(unused_id,rdy,result,unused_id,ts,s)) empty in
  rbw