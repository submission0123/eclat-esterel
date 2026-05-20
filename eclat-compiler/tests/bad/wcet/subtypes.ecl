let f =
  ((fun () -> pause()) : unit -[0]-> unit) ;;

let g : unit -[0]-> unit = (fun () -> pause()) ;;

let main = f ;;