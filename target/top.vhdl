-- code generated from the following source code:
--   stdlib.ecl
--   ../examples/bench/lib.ecl
--   ../examples/arbiter4.ecl
--
-- with the following command:
--
--    ./eclat ../examples/bench/lib.ecl ../examples/arbiter4.ecl -noprint -top=sw:4|ledr:4 -clk-top=MAX10_CLK1_50

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.all;


entity top is
  port (signal MAX10_CLK1_50 : in std_logic;
        signal sw : in std_logic_vector(0 to 3);
        signal ledr : out std_logic_vector(0 to 3)
  );
end entity;

architecture rtl of top is

    component main is
        port (signal clk : in std_logic;
              signal reset : in std_logic;
              signal argument : in Values.t(0 to 3);
              signal result : out Values.t(0 to 3)
        );
    end component;
    signal RST : std_logic := '1';
    signal argument : Values.t(0 to 3);
    signal result : Values.t(0 to 3);
    signal ready : Values.t (0 to 0);
    begin
        process (MAX10_CLK1_50)
            begin
            if (rising_edge(MAX10_CLK1_50)) then
                if RST = '1' then
                    RST <= '0';
                end if;
            end if;
        end process;
argument <= sw;
main_CC : component main
        port map (clk => MAX10_CLK1_50,
                  reset => RST,
                  --rdy => ready,
                  argument => argument,
                  result => result
                  );
ledr <= result(0 to 3);

end architecture;

