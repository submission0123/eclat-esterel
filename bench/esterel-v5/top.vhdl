-- code generated from the following source code:
--   stdlib.ecl
--   ../examples/benchs/game-of-life/v1/v1.ecl
--
-- with the following command:
--
--    ./eclat -relax ../examples/benchs/game-of-life/v1/v1.ecl -intel-max10 -main=main_intel

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.all;


entity top is
  port (signal MAX10_CLK1_50 : in std_logic;
        signal SW : in std_logic_vector(0 to 9);
		  signal GPIO : in std_logic_vector(0 to 33);
        signal KEY : in std_logic_vector(0 to 1);
        signal LEDR : out std_logic_vector(0 to 9);
        signal HEX0 : out std_logic_vector(0 to 7);
        signal HEX1 : out std_logic_vector(0 to 7);
        signal HEX2 : out std_logic_vector(0 to 7);
        signal HEX3 : out std_logic_vector(0 to 7);
        signal HEX4 : out std_logic_vector(0 to 7);
        signal HEX5 : out std_logic_vector(0 to 7)
  );
end entity;

architecture rtl of top is

    component main4 is
        port (signal clk : in std_logic;
              signal rst : in std_logic;
              signal o :out std_logic;
              signal a7,a6,a5,a4,a3,a2,a1,a0,b7,b6,b5, b4, b3,b2,b1,b0,b,c,r:in std_logic);
  end component;
    signal result : std_logic;
        signal rRST : std_logic := '1';
   
   begin
        process (MAX10_CLK1_50)
            begin

            if (rising_edge(MAX10_CLK1_50)) then
                if rRST = '1' then
                    rRST <= '0';
                end if;
            end if;
        end process;
--ii <= SW(0);
       --- ss <= KEY(0);
main_CC : component main4
        port map (clk => MAX10_CLK1_50,
                  rst => rRST,
                 	a0 => GPIO(0),
						a1 => GPIO(1),
						a2 => GPIO(2),
						a3 => GPIO(3),
						a4 => GPIO(4),
						a5 => GPIO(5),
						a6 => GPIO(6),
						a7 => GPIO(7),
						b0 => GPIO(8),
						b1 => GPIO(9),
						b2 => GPIO(10),
						b3 => GPIO(11),
						b4 => GPIO(12),
						b5 => GPIO(13),
						b6 => GPIO(14),
						b7 => GPIO(15),
                  b => GPIO(16),
						c=> GPIO(17),
						r => GPIO(18),
                 o => result
                  );
LEDR(0) <= result;
      --  LEDR(1) <= q;
end architecture;
