let await s = await: s;;
(*let abort (f,s) = abort: (f()) when s;;
*)

(*let await s =
  trap T in 
  loop pause; if ?s then exit T else () end ;;
*)
let abort (f,s) =
  trap T in [ (suspend f() when s; exit T) || (await s; exit T )] ;;
