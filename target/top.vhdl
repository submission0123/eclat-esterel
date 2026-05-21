-- code generated from the following source code:
--   stdlib.ecl
--   ../examples/abcro.ecl
--
-- with the following command:
--
--    ./eclat ../examples/abcro.ecl -noprint -top=sw:4|ledr:1

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.all;


entity top is
  port (signal clk : in std_logic;
        signal sw : in std_logic_vector(0 to 3);
        signal ledr : out std_logic
  );
end entity;

architecture rtl of top is

    component main is
        port (signal clk : in std_logic;
              signal reset : in std_logic;
              signal argument : in Values.t(0 to 3);
              signal result : out Values.t(0 to 0)
        );
    end component;
    signal RST : std_logic := '1';
    signal argument : Values.t(0 to 3);
    signal result : Values.t(0 to 0);
    signal ready : Values.t (0 to 0);
    begin
        process (clk)
            begin
            if (rising_edge(clk)) then
                if RST = '1' then
                    RST <= '0';
                end if;
            end if;
        end process;
argument <= sw;
main_CC : component main
        port map (clk => clk,
                  reset => RST,
                  --rdy => ready,
                  argument => argument,
                  result => result
                  );
ledr <= result(0);

end architecture;

