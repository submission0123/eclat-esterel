let none = Default.create ;;

let sync(go,f,x) =
  let (o,rdy) = exec if go then f(x) else none() default none() in
  (o,rdy) ;;

let pipe x f g = o where
   rec (t,rdy1) = sync(f,go,x)
   and (o,rdy2) = sync(g,rdy1,x)
   and go = fby(true,rdy2) ;;


(* file , line 0, characters -1--1:
Error: 
This expression has type ('v1 -> ~a3) but was expected of basic type ~v1
 *)