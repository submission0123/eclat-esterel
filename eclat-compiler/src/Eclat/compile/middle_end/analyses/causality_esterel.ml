(* after chapter 7 of : https://www-sop.inria.fr/members/Gerard.Berry/Papers/EsterelConstructiveBook.pdf *)
type x = string
type partial_event = (x * char) list

module S = Map.Make(String)
module K = Map.Make(Int)

(* For Must, the set K is
either empty, if we cannot derive any Must information, or a singleton {k},
if we can derive that p must return k. It is impossible that p must return
more than one completion code. *)

(* let must p (e:partial_event) =
   let s = must_s p e in
   let k = must_k p e in
   (s,k) ;;*)

(* The function Cannotm(p,E) is used to prune out false paths. *)
(* Here, the results S and K are respectively the set of signals that p cannot
emit and the set of completion codes that p cannot exit when the input
event is E. The extra argument m ∈ {+,⊥} tells whether it is known that
the statement p must be executed in the event E *)
(* The case m = − will never occur in the recursion since Cannot 
will only be called for potentially executable statements.
Technically, it is simpler to defi *)
(* let cannot_m m p e =
  et s = cannot_m_s p e in
   let k = cannot_m_k p e in
   (s,k) ;;*)

(* set complement of cannot_m m p e *)
(* The set Canm_k (p,E) may be any subset of
the potential completion set K(p) defined in Section 6.6.  *)
(* let can_m m p e =*)

type sigv = Unknown | Known of Ast.c

let bot = '0' ;;
let s_union = S.union (fun x v1 v2 -> if v1 = v2 then Some (v1) else Some Unknown)
let s_inter s1 s2 = S.filter (fun x _ -> S.mem x s2) s1
let k_union = K.union (fun x () () -> Some ())
let sk_union (s1,k1) (s2,k2) = 
  s_union s1 s2, k_union k1 k2

let s_find x s = 
  match S.find_opt x s with
  | None -> bot
  | Some x -> x

let max_set k k' =
  K.fold
    (fun x () acc ->
      K.fold
        (fun y () acc2 ->
          K.add (max x y) () acc2)
        k'
        acc)
    k
    K.empty

open Ast

let causality_error () = 
  Prelude.Errors.error (fun fmt -> Format.fprintf fmt "causality error")


let remove_in_sk x (s,k) =
  S.iter (fun x v ->
         if v = Unknown then causality_error ()) s;
  S.remove x s, k

let rec must e pevent : sigv S.t * _ =
  match e with
  | E_const _ | Ast.E_sig_get _
  | E_app _ (* assume a combinational function *) -> (S.empty,K.singleton 0 ())
  | E_pause _ -> (S.empty,K.singleton 1 ())
  | E_exit _ ->  (S.empty,K.singleton 2 ())
  | E_emit(s,E_const c) -> (S.singleton s (Known c),K.singleton 0 ())
  | E_emit(s,_) -> (S.singleton s Unknown,K.singleton 0 ())
  | E_if(E_sig_get(s),e1,e2) ->
       (match s_find s pevent with
       | '+' -> must e1 pevent
       | '-' -> must e2 pevent
       | _ -> (S.empty,K.empty))
  | E_suspend(l,e1,x) -> must e1 pevent
  | E_letIn(P_var s,_,E_sig_create _, e1) ->
      let sset = must_s e1 (S.add s bot pevent) in
      if S.mem s sset then (remove_in_sk s @@ must e1 (S.add s '+' pevent))
      else let sset2 = can_m_s '+' e1 (S.add s bot pevent) in
      if not(S.mem s sset2) then (remove_in_sk s @@ must e1 (S.add s '-' pevent)) else
      (remove_in_sk s @@ must e1 (S.add s bot pevent)) 
  | E_letIn(P_var f,_,E_trap(_,l),e2) -> 
      (* toto shift *)
      must e2 pevent
  | E_letIn(p,_,e1,e2) ->
      let k = must_k e1 pevent in
      if not(K.mem 0 k) then must e1 pevent else
      (s_union (must_s e1 pevent) (must_s e2 pevent), must_k e2 pevent)
  | E_loop(e1) -> must e1 pevent
  | E_par(l,[e1;e2]) ->
      s_union (must_s e1 pevent) (must_s e2 pevent),
      max_set (must_k e1 pevent) (must_k e2 pevent)
  | E_if(_,e1,e2) ->
      let (s1,k1) = can_m bot e1 pevent in
      let (s2,k2) = can_m bot e2 pevent in
      let s = s_inter s1 s2 in
      if S.is_empty s then
        (S.empty,k_union k1 k2)
      else Prelude.Errors.error (fun fmt -> Format.fprintf fmt "the program is rejected because may not respect causality@,")
  | E_exec(e1,e0,eo,_) ->
      let (s1,k1) = must e1 pevent in
      let (s2,k2) = must e0 pevent in
      let (s3,k3) = match eo with 
                    | None -> (S.empty,K.empty)
                    | Some e2 -> must e2 pevent in
      (s_union s1 (s_union s2 s3),k_union k1 (k_union k2 k3))
  | e -> Ast_pprint.pp_exp Format.std_formatter e; assert false

(* trap & shift *)
and must_s e pevent = 
  let (s,_) = must e pevent in s
and must_k e pevent = 
  let (_,k) = must e pevent in k
and can_m_s m e pevent =
  let (s,_) = can_m m e pevent in s
and can_m_k m e pevent =
   let (_,k) = can_m m e pevent in k
and can_m m e pevent : sigv S.t * _ =
  match e with
  | E_const _ | Ast.E_sig_get _
  | E_app _ (* assume a combinational function *) -> (S.empty,K.singleton 0 ())
  | E_pause _ -> (S.empty,K.singleton 1 ())
  | E_exit _ ->  (S.empty,K.singleton 2 ())
  | E_emit(s,E_const c) -> (S.singleton s (Known c),K.singleton 0 ())
  | E_emit(s,_) -> (S.singleton s Unknown,K.singleton 0 ())
  | E_if(E_sig_get(s),e1,e2) ->
       (match s_find s pevent with
       | '+' -> can_m m e1 pevent
       | '-' -> can_m m e2 pevent
       | _ -> let (s1,k1) = can_m bot e1 pevent in
              let (s2,k2) = can_m bot e2 pevent in
              (s_union s1 s2,k_union k1 k2))
  | E_suspend(l,e1,x) -> can_m m e1 pevent
  | E_letIn(P_var s,_,E_sig_create _, e1) -> 
     if m = '+' && (let sset = must_s e1 (SMap.add s bot pevent) in S.mem s sset)
     then (remove_in_sk s @@ can_m '+' e1 (SMap.add s '+' pevent)) else
     let sset2 = can_m_s m e1 (SMap.add s bot pevent) in
     if not(S.mem s sset2) then remove_in_sk s @@ can_m m e1 (SMap.add s '-' pevent) else
     (* typo in https://www-sop.inria.fr/members/Gerard.Berry/Papers/EsterelConstructiveBook.pdf *)
     (remove_in_sk s @@ can_m m e1 (SMap.add s bot pevent))
  | E_letIn(P_var f,_,E_trap(_,l),e2) -> 
      (* toto shift *)
      can_m m e2 pevent
  | E_letIn(p,_,e1,e2) ->
      let k = can_m_k m e1 pevent in
      if not(K.mem 0 k) then can_m m e1 pevent else
      let m' = if m = '+' && (let mk = must_k e1 pevent in K.mem 0 mk) then '+' else bot in
      s_union (can_m_s m e1 pevent) (can_m_s m' e2 pevent),
      k_union (K.remove 0 @@ can_m_k m e1 pevent) (can_m_k m' e2 pevent)
  | E_loop(e1) -> can_m m e1 pevent 
  | E_par(l,[e1;e2]) ->
      s_union (can_m_s m e1 pevent) (can_m_s m e2 pevent),
      max_set (can_m_k m e1 pevent) (can_m_k m e2 pevent)
  | E_if(_,e1,e2) ->
      let (s1,k1) = can_m bot e1 pevent in
      let (s2,k2) = can_m bot e2 pevent in
      (s_union s1 s2,k_union k1 k2)
  | E_exec(e1,e0,eo,_) ->
      let (s1,k1) = can_m bot e1 pevent in
      let (s2,k2) = can_m bot e0 pevent in
      let (s3,k3) = match eo with 
                    | None -> (S.empty,K.empty)
                    | Some e2 -> can_m bot e2 pevent in
      (s_union s1 (s_union s2 s3),k_union k1 (k_union k2 k3))
  | e -> Ast_pprint.pp_exp Format.std_formatter e; assert false

let print ~msg (s,k) = 
  S.iter (fun x _ -> Printf.printf "%s," x) s;
  print_string msg;
  print_newline ();
  K.iter (fun n () -> Printf.printf "%d," n) k;
  print_newline ()

let rec propagate = function 
  | E_letIn(P_var x, _, E_sig_get(s), e1) ->
      propagate @@ Ast_subst.subst_e x (E_sig_get(s)) e1
  | e -> Ast_mapper.map propagate e

let main e =
  let e = propagate e in
  let (s,k) = must e S.empty in
  if K.is_empty k then causality_error ();;
