-- code generated from the following source code:
--   stdlib.ecl
--   ../examples/abcro.ecl
--
-- with the following command:
--
--    ./eclat ../examples/abcro.ecl -arg=(true,false,true,false);(true,true,true,false);(false,false,false,true);(true,false,false,false);(true,true,false,false);(false,false,true,false);(false,false,false,true);(true,true,true,false);(false,false,false,true)


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;

entity tb_main is
end entity;

architecture tb of tb_main is
  component main
    port(
      signal clk    : in std_logic;
      signal reset  : in std_logic;
      signal argument : in Values.t(0 to 3);
      signal result : out Values.t(0 to 0));
end component;
  signal tb_argument: std_logic_vector(0 to 3) := (others => '0');
  signal tb_result: std_logic_vector(0 to 0);
  signal tb_next_result: std_logic_vector(0 to 0);
  signal tb_clk: std_logic;
  signal rst: std_logic;
  begin

  RESET: process
  begin
    rst <= '1';
    wait for 2 ns;
    rst <= '0';
    wait;
  end process;


  CLOCK: process
  begin
    tb_clk <= '1';
    wait for 5 ns;
    tb_clk <= '0';
    wait for 5 ns;
  end process;

  U1: main port map(tb_clk,rst,tb_argument,tb_result);
      process (RST,tb_clk) 
      begin
        if RST = '1' then
         -- tb_result <= (others => '0');
        elsif (rising_edge(tb_clk)) then
         -- tb_result <= tb_next_result;   -- resynchronize output
        end if;
      end process;

  process
  variable \$v278\ : Values.t(0 to 3) := (others => '0');
begin

      -- Start computation
    wait for 5 ns;
      \$v278\ := work.Values.val_true & work.values.val_false & work.Values.val_true & work.values.val_false;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.Values.val_true & work.Values.val_true & work.Values.val_true & work.values.val_false;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.values.val_false & work.values.val_false & work.values.val_false & work.Values.val_true;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.Values.val_true & work.values.val_false & work.values.val_false & work.values.val_false;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.Values.val_true & work.Values.val_true & work.values.val_false & work.values.val_false;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.values.val_false & work.values.val_false & work.Values.val_true & work.values.val_false;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.values.val_false & work.values.val_false & work.values.val_false & work.Values.val_true;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.Values.val_true & work.Values.val_true & work.Values.val_true & work.values.val_false;
      tb_argument <= \$v278\;
wait for 10 ns;
      \$v278\ := work.values.val_false & work.values.val_false & work.values.val_false & work.Values.val_true;
      tb_argument <= \$v278\;
wait for 10 ns;

    wait;
  end process;

  end architecture;

  
