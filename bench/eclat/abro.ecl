(******************************************************************
simulation:
==========
$ ./eclat ../examples/abcro.ecl -arg="(true,false,true,false);(true,true,true,false);(false,false,false,true);(true,false,false,false);(true,true,false,false);(false,false,true,false);(false,false,false,true);(true,true,true,false);(false,false,false,true)"

synthesis:
=========
$ ./eclat ../examples/abcro.ecl -noprint -top="sw:4|ledr:1"
********************************************************************)

let halt() =
  loop pause end ;;

let sustain s = 
  loop emit s; pause end ;;

let loop_each (f,s) =
  loop abort ((fun () -> (f(); halt())),s) end ;;

let await_immediate s =
  trap T in loop if ?s then exit T; pause end ;;

let suspend_when_immediate(f,s) =
  suspend (if ?s then pause; f()) when s ;;

let abro (a,b,r,o) =
  loop_each((fun () -> 
    [await a || await b]; emit o),r) ;;

let main ((a,b,r) : bool * bool * bool) : bool =
  signal sa in emit sa(a);
  signal sb in emit sb(b); 
  signal sr in emit sr(r);
  signal so in 
  let _ = exec abro(sa,sb,sr,so)
          default () 
  in 
  print_int (if ?so then 1 else 0); print_string ";";
  ?so;;
