To compile into Verilog :
```
$ ./esterel -Lblif bench/foo.strl
$ yosys -p "read_blif foo.blif; write_verilog foo.v"
```

Then replace each:
```
  \$_FF_  _002_ (
    .D(GO_12_0_),
    .Q(PAUSE_REG_12_)
  );
```

by:
```
  \$ff  _002_ (
    .clk(clk),
    .D(GO_12_0_),
    .Q(PAUSE_REG_12_)
  );
```
