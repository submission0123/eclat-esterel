

let rand_list l =
  List.nth l @@ Random.int (List.length l) ;;

let atom () = rand_list ["?n"; "?m"; "?k"] ;;

let int () = string_of_int (Random.int 10) ;;

let int_pow2 () = string_of_int (1 lsl (Random.int 4)) ;;

type t = Add | Mul | Pow

let rec size n =
  if Random.int n = 1 then atom () else
  match rand_list [Add;Mul;Pow] with
  | Add -> "(" ^ size (n) ^ "+" ^ int () ^ ")"
  | Mul -> "(" ^ int_pow2() ^ "*" ^ size (n) ^ ")"
  | Pow -> "(2^" ^ size (n) ^ ")" ;;


let gen f n =
  print_string ("let "^f^ " (x:int<" ^size (n)^">) (y:int<" ^size (n)^">) = "^ " x + y;;\n") ;;


let main n = 
  for i = 0 to 100 do
    gen ("f"^string_of_int i) n
  done

