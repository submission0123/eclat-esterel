let rec wait(n) =
  if n = 1 then () else wait(n-1) ;;

let counter() =
  reg (fun c -> c + 1) init 0 ;;

let main(stop,n) =
  if stop then 42 else
  let (o,rdy) = exec (let () = if n <= 0 then () 
                               else wait(n)
                      in counter()) 
                      default 0
  in o ;;


let test_main(stop,n) =
  print_string "stop:"; print_int (if stop then 1 else 0); print_newline();  
  print_string "n:"; print_int n; print_newline();
  let o = main(stop,n) in
  print_string "main(stop,n):"; print_int o; print_newline(); print_string "------------------------"; print_newline ();
  o;;
  
  
(********************************************************************
simulation:
==========
$ ./eclat ../examples/fig3.ecl -main=test_main -arg="(false,0);(false,0);(false,0);(false,0);(false,3);(false,3);(false,1);(false,1);(false,1);(false,1);(false,1);(false,2);(false,1);(false,2);(false,3);(false,3);(true,2);(true,0);(true,0);(false,0);(false,0)"
$ make simul NAME=test_main
ghdl -a  stdlib.vhdl 
ghdl -a  test_main.vhdl
ghdl -a  tb_test_main.vhdl
ghdl -e  tb_test_main
ghdl -r  tb_test_main --vcd=tb.vcd --stop-time=200ns
stop:0 
n:0 
main(stop,n):1 
------------------------ 
stop:0 
n:0 
main(stop,n):2 
------------------------ 
stop:0 
n:0 
main(stop,n):3 
------------------------ 
stop:0 
n:0 
main(stop,n):4 
------------------------ 
stop:0 
n:3 
main(stop,n):0 
------------------------ 
stop:0 
n:3 
main(stop,n):0 
------------------------ 
stop:0 
n:1 
main(stop,n):0 
------------------------ 
stop:0 
n:1 
main(stop,n):5 
------------------------ 
stop:0 
n:1 
main(stop,n):0 
------------------------ 
stop:0 
n:1 
main(stop,n):6 
------------------------ 
stop:0 
n:1 
main(stop,n):0 
------------------------ 
stop:0 
n:2 
main(stop,n):7 
------------------------ 
stop:0 
n:1 
main(stop,n):0 
------------------------ 
stop:0 
n:2 
main(stop,n):8 
------------------------ 
stop:0 
n:3 
main(stop,n):0 
------------------------ 
stop:0 
n:3 
main(stop,n):0 
------------------------ 
stop:1 
n:2 
main(stop,n):42 
------------------------ 
stop:1 
n:0 
main(stop,n):42 
------------------------ 
stop:1 
n:0 
main(stop,n):42 
------------------------ 
stop:0 
n:0 
main(stop,n):0 
------------------------ 
ghdl:info: simulation stopped by --stop-time @200ns
$
********************************************************************)

