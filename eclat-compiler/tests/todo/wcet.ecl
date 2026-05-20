
> let par_get(x,y) = (get(x,0) || get(y,0));;
val par_get : forall ~v1 ?v2 ~v3 ?v4  . ((~v1 array<?v2> * ~v3 array<?v4>) -> (~v1 * ~v3)) | 0

> let par_get1() = 
   let x = create<1>() in
   (par_get(x,x) || par_get(x,x));;
val par_get1 : forall ~v1  . (unit -[4]-> ((~v1 * ~v1) * (~v1 * ~v1))) | 0


> let par_get1() = 
   let x = create<1>() in
   ((par_get:'a-[2]->'b)(x,x) || par_get(x,x));;
val par_get1 : forall ~v1  . (unit -[2]-> ((~v1 * ~v1) * (~v1 * ~v1))) | 0


