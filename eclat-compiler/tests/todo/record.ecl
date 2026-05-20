type ~a t = {data:~a; valid:bool} ;;

let some(n:'a) : ~a t = {data = n ; valid = true } ;;

let none() : ~a t = { 
  data = Default.create(); 
  valid = false
}

let pipe x f g = o where
   rec t = f(x)
   and o = g(fby(none(),t)) ;;

 let snd(x,_) = x;;

let f v =
  snd(exec if v.valid
       then (pause(); some(v.data+1)) 
       else none()
  default none()) ;;

let g v =
  snd(exec if v.valid
       then (pause();pause(); some(v.data*2)) 
       else none()
  default none()) ;;

let main z =
  pipe z f (fun a ->
  pipe a g (fun b -> print_int b.data;b));;

