## FDL '06: Hardware synthesis of functional programs with Esterel constructs

The paper presents an extension of [Eclat](https://github.com/lsylvestre/eclat) with `Esterel` constructs.
Eclat is a a functional-imperative (ML-like) language with synchronous semantics
for programming FPGAs.

Installation
------------

To build from source, the pre-requisites are:

* `opam` 
* `ocaml 4.14.1`
* `menhir`
* `ocamlclean`
* for simulation: `ghdl` and `GTKWave`
* for synthesis: tested essentially with `Intel Quartus II 24 lite` 
  on a Terasic DE10-lite board (having an Intel MAX 10 FPGA)
  Vivado and Yosys backend are also supported.

Source code
-----------------

The main files involved in our extension are:

* eclat/eclat-compiler/src/Eclat/syntax/ast.ml
* eclat/eclat-compiler/src/Eclat/typing/types.ml
* eclat/eclat-compiler/src/Eclat/typing/typing.ml
* eclat/eclat-compiler/src/Eclat/compile/backend/gen_BHDL.ml                             (compilation to BHDL)
* eclat-compiler/src/Eclat/compile/middle_end/analyses/causality_esterel.ml        (ongoing work)
* eclat-compiler/src/Eclat/compile/middle_end/analyses/check_pauses_loop.ml    (detecting instantaneous loop)

Benchmarks
-----------------

Variants of the Esterel program ABCRO (../examples/abcro.ecl) have been tested using our compiler extension
*versus* the [Esterel V5 compiler](https://www-sop.inria.fr/esterel.org/files/Html/Downloads/Soft/SoftwareDownloads.htm).
Esterel V5 generates BLIF files *(Berkeley Logic Interchange Format)* that we translate to Verilog using [Yosys](https://github.com/yosyshq/yosys).

Examples
----------

```
$ cd eclat-compiler
$ make
$ ./eclat ../examples/abcro.ecl -arg="(true,false,true,false);(true,true,true,false);(false,false,false,true);(true,false,false,false);(true,true,false,false);(false,false,true,false);(false,false,false,true);(true,true,true,false);(false,false,false,true)" 
vhdl code generated in ../target/main.vhdl 
testbench generated in ../target/tb_main.vhdl for software RTL simulation using GHDL.
$ make simul NS=200
cd ../target; make NS=200
ghdl -a  stdlib.vhdl 
ghdl -a  main.vhdl
ghdl -a  tb_main.vhdl
ghdl -e  tb_main
ghdl -r  tb_main --vcd=tb.vcd --stop-time=200ns
0;1;0;0;0;1;0;1;0;0;0;0;0;0;0;0;0;0;0;0;./tb_main:info: simulation stopped by --stop-time @200ns
$ ./eclat
=== eclat toploop ===.
Enter phrases (separated by ';;') then compile with ``#q.''
> let compose(f,g,x) = f(g(x));;
val compose : forall 'v1 ~v2 $v3 ~v4 $v5  . (((~v2 -[$v5]-> ~v4) * ('v1 -[$v3]-> ~v2) * 'v1) -[$v3 + $v5]-> ~v4) | 0

> let nothing() = () ;;
val nothing : (unit => unit) | 0              // instantaneous function

>  let main () = exec loop [pause || compose(nothing,nothing,())] end default ();;
val main : (unit => (unit * bool)) | 0

> #q.
Error: instantaneous loop detected
$ ./eclat -causality
=== eclat toploop ===.
Enter phrases (separated by ';;') then compile with ``#q.''

> let main () =
    signal s in
    if ?s then () else emit s;;
val main : (unit => unit) | 0
> #q.
Error: causality error
$ ./eclat -causality
> let main x = 
   signal s in
     if x then emit s(42) else emit s(43);;
val main : (bool => unit) | 0
> #q.
Error: the program is rejected because may not respect causality
$ ./eclat
>  let main () = [pause || (pause;pause)];;
val main : (unit -[2]-> unit) | 0
> #q.
Error: This program has type (unit -[2]-> unit). It is not reactive.
```
