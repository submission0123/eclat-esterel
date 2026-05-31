To target Intel MAX10 target:

```
$ ./eclat ../examples/bench/lib.ecl ../examples/abro.ecl -noprint -top="gpio:3|ledr:1" -clk-top="MAX10_CLK1_50"
$ ./eclat ../examples/bench/lib.ecl ../examples/abcro.ecl -noprint -top="gpio:4|ledr:1" -clk-top="MAX10_CLK1_50"
$ ./eclat ../examples/bench/lib.ecl ../examples/abcdero.ecl -noprint -top="gpio:6|ledr:1" -clk-top="MAX10_CLK1_50"
$ ./eclat ../examples/bench/lib.ecl ../examples/abcdefghijro.ecl -noprint -top="gpio:10|ledr:1" -clk-top="MAX10_CLK1_50"
$ ./eclat ../examples/bench/lib.ecl ../examples/abcdefghijro2.ecl -noprint -top="gpio:18|ledr:1" -clk-top="MAX10_CLK1_50"
$ ./eclat ../examples/bench/lib.ecl ../examples/abcdefghijro3.ecl -noprint -top="gpio:34|ledr:1" -clk-top="MAX10_CLK1_50"
```

For each bench, import `stdlib.vhdl`, `main.vhdl`, and `top.vhdl` in the Intel Quartus Prime synthesizer.
