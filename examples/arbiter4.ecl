(** ./eclat -causality ../examples/arbiter4.ecl -top="sw:4|ledr:4" 

NB: causality analysis is quite long

*)

let every_immediate (s,f) =
  await_immediate(s); loop_each (f,s) ;;

let cell ((requestIn, grantIn, tokenIn),
          (grantOut, tokenOut, ackOut)) =
  signal s in
  [ loop emit s(?grantIn or ?tokenIn); pause end
  ||
     every_immediate(s,fun () ->
       if ?requestIn then emit ackOut else emit grantOut)
  ||
     every_immediate(tokenIn,(fun () ->
       pause;
       emit tokenOut)) ] ;;

(** A dummy module to through a token in the ring at the first instant **)
let init_token (token) =
  emit token ;;


(** The module that implements the bus arbiter with 4 cells process running
    in parallel and concurently for a bus access. 
 **)
let arbiter4 ((requestIn1, requestIn2, requestIn3, requestIn4),
              (ackOut1, ackOut2, ackOut3, ackOut4)) =
   signal g1, g2, g3, g4, t1, t2, t3, t4 in
   [ init_token(t1) ||
     cell((requestIn1, g1, t1),(g2, t2, ackOut1)) ||
     cell((requestIn2, g2, t2),(g3, t3, ackOut2)) ||
     cell((requestIn3, g3, t3),(g4, t4, ackOut3)) ||
     cell((requestIn4, g4, t4),(g1, t1, ackOut4)) ] ;;


let main ((r1,r2,r3,r4) : bool * bool * bool * bool) : (bool * bool * bool * bool) =
  signal sr1,sr2,sr3,sr4 in 
  emit sr1(r1);
  emit sr2(r2);
  emit sr3(r3);
  emit sr4(r4);
  signal a1,a2,a3,a4 in
  let _ = exec arbiter4((sr1,sr2,sr3,sr4), (a1,a2,a3,a4)) default () in
  (?a1,?a2,?a3,?a4) ;;