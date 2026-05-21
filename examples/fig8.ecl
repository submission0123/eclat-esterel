let count(en,n) : int<8> =
  let x = if en then (reg (fun c -> c + 1) init 0)
          else 0
  in x * n ;;

 let main = count ;;
 
(********************************************************************
synthesis:
==========
$ ./eclat ../examples/fig8.ecl -top="sw:9|ledr:8"
*)
