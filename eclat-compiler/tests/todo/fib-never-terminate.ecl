 let scan(f,x,x0) =
   reg (fun acc -> f(acc,x)) init x0 ;;
 
 let prefix_sum(i) = scan((+), i, 0) ;;

 let fib(n) =
   let rec aux(n,a,b) =
     if n = 0 then b else aux(n-1,b,a+b)
   in aux(n) ;;

 let sum_fib(i) =
   let (v,rdy) = exec fib(i) default 0 in
   prefix_sum(v) ;;

let main (i,en) =
  if en then sum_fib(i) else 42 ;;