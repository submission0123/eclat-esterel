(******************************************************************
simulation:
==========
$ ./eclat ../examples/abcro.ecl -arg="(true,false,true,false);(true,true,true,false);(false,false,false,true);(true,false,false,false);(true,true,false,false);(false,false,true,false);(false,false,false,true);(true,true,true,false);(false,false,false,false)"

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

let abcro(a,b,c,r,o) =
  signal t in 
  [ abro(a,b,r,t) || abro(t,c,r,o) ] ;;

let abcdero(a,b,c,d,e,r,o) =
  signal t in 
  [ abcro(a,b,c,r,t) || abcro(t,d,e,r,o) ] ;;

let abcdero2(a,b,c,d,e,f,g,h,i,r,o) =
  signal t in 
  [ abcdero(a,b,c,d,e,r,t) || abcdero(t,f,g,h,i,r,o) ] ;;

let main ((a,b,c,d,e,f,g,h,i,r) : bool * bool * bool * bool * bool * bool * bool * bool * bool * bool) : bool =
  signal sa in emit sa(a);
  signal sb in emit sb(b); 
  signal sc in emit sc(c);
   signal sd in emit sd(d);
    signal se in emit se(e); 
    signal sf in emit sf(f); 
    signal sg in emit sg(g); 
    signal sh in emit sh(h); 
    signal si in emit si(i); 
  signal sr in emit sr(r);
  signal so in 
  let _ = exec abcdero2(sa,sb,sc,sd,se,sf,sg,sh,si,sr,so)
          default () 
  in 
  print_int (if ?so then 1 else 0); print_string ";";
  ?so;;