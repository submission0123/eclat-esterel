(* ./eclat -arg="1;2;3;4;5;6" -relax *)

let none() = Default.create() ;;

let next_time(f,x,d) =
  if fby(false, true) then f(x) else d ;;

let pipe a f g =
  let (next_b, next_c) = reg (fun (b, c) ->
      (f(a) || next_time(g, b, c))
    ) init (none(),none())
  in next_c ;;

let f(x) = for i = 0 to 10 do print_string "A:"; print_int i done; x + 1 ;;
let g(x) = for i = 0 to 5  do print_string "B:"; print_int i done; x * 2 ;;
let h(x) = for i = 0 to 8  do print_string "C:"; print_int i done; x + 100 ;;
let u(x) = for i = 0 to 12 do print_string "D:"; print_int i done; x * 3 ;;

let main a =
    print_string "========================";
    print_newline();
    pipe a f (fun b ->
    pipe b g (fun c ->
    pipe c h u)) ;;
