let map<<?k>>(f,(src:~a array<?n+1>),(dst:~a array<?n+1>)) =
  for i = 0 to length(src) - 1 by ?k do
    set(dst, i, f(get(src,i)))
  done ;;

(** pipelined map:
let map<<?k>>(f,(src:~a array<?n+1>),(dst:~a array<?n+1>)) =
  let v = ref (get(src,0)) in
  for i = 1 to length(src) - 1 do
    [ set(dst, i, f(!v)) || v := get(src,i) ]
  done;
  set(dst,length(src)-1,f(!v))
  ;;
 **)

let reduce<<?k>>(f,(src:~a array<?n+1>),(v:~b)) : ~b =
  let acc = ref v in
  for i = 0 to length(src) - 1 by ?k do
    acc := f(get(src,i),!acc)
  done;
  !acc ;;

let wait <<?n>> = (* wait ?n cycles *)
  for i = 1 to int<<?n>> do () done ;;

let foo i =
  wait<<100>>; i+1;;

let prog <<?n>> =
  let src = create<?n>() in
  let dst = create<?n>() in
  for i = 1 to length(src) - 1 do set(src,i-1,i) done;
  map<<5>>(foo,src,dst);
  reduce<<2>>((+),dst,0);;

let prog128() = prog<<128>> ;;

let chrono () =
  reg (fun c -> c + 1) init (-1) ;;

let main () =
  let cy = chrono () in
  let (_,rdy) = exec prog128() default 0 in
  if rdy then (print_string "execution time: "; print_int cy; print_newline ()) ;;
