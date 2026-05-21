-- code generated from the following source code:
--   stdlib.ecl
--   ../examples/abcro.ecl
--
-- with the following command:
--
--    ./eclat ../examples/abcro.ecl -noprint -top=sw:4|ledr:1

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;


entity main is
  
  port(signal clk    : in std_logic;
       signal reset  : in std_logic;
       signal argument : in Values.t(0 to 3);
       signal result : out Values.t(0 to 0));
       
end entity;
architecture rtl of main is

  type \t_state_$v166\ is (IDLE272);
  signal \state_$v166%now\, \state_$v166%next\: \t_state_$v166\;
  type \t_state_$13900\ is (\IDLE_$13900\, \$1383\);
  signal \state_$13900%now\, \state_$13900%next\: \t_state_$13900\;
  type \t_state_$13901\ is (\IDLE_$13901\, \$1388\);
  signal \state_$13901%now\, \state_$13901%next\: \t_state_$13901\;
  type \t_state_$1391inner\ is (\$V210\, \$1376\, \$1390\);
  signal \state_$1391inner%now\, \state_$1391inner%next\: \t_state_$1391inner\;
  type \t_state_$13980\ is (\IDLE_$13980\, \$1391\);
  signal \state_$13980%now\, \state_$13980%next\: \t_state_$13980\;
  type \t_state_$13981\ is (\IDLE_$13981\, \$1396\);
  signal \state_$13981%now\, \state_$13981%next\: \t_state_$13981\;
  type \t_state_$14300\ is (\IDLE_$14300\, \$1398\);
  signal \state_$14300%now\, \state_$14300%next\: \t_state_$14300\;
  type \t_state_$14200\ is (\IDLE_$14200\, \$1413\);
  signal \state_$14200%now\, \state_$14200%next\: \t_state_$14200\;
  type \t_state_$14201\ is (\IDLE_$14201\, \$1418\);
  signal \state_$14201%now\, \state_$14201%next\: \t_state_$14201\;
  type \t_state_$1421inner\ is (\$V258\, \$1406\, \$1420\);
  signal \state_$1421inner%now\, \state_$1421inner%next\: \t_state_$1421inner\;
  type \t_state_$14280\ is (\IDLE_$14280\, \$1421\);
  signal \state_$14280%now\, \state_$14280%next\: \t_state_$14280\;
  type \t_state_$14281\ is (\IDLE_$14281\, \$1426\);
  signal \state_$14281%now\, \state_$14281%next\: \t_state_$14281\;
  type \t_state_$14301\ is (\IDLE_$14301\, \$1428\);
  signal \state_$14301%now\, \state_$14301%next\: \t_state_$14301\;
  type t_state_id172 is (IDLE_ID172, \$1430\);
  signal \state_id172%now\, \state_id172%next\: t_state_id172;
  type \t_state_$v167\ is (\IDLE_$V167\);
  signal \state_$v167%now\, \state_$v167%next\: \t_state_$v167\;
  signal \result_$13980%next\, \result_$13980%now\, \result_$14280%next\, 
         \result_$14280%now\ : Values.t(0 to 1) := (others => '0');
  signal \$1436_T\, \$v211\, \rdy_$14281262\, \$1438_T\, \rdy_$14280224\, 
         \$1435_T\, \$1432_T\, \rdy_$14300174\, \$1393_T\, \$1356_sb\, 
         \$1410_T\, \$1366_t\, go205, \rdy_$13900197\, go247, 
         \rdy_$14281237\, rdy177, \rdy_$13901203\, \$1362_so\, \$1400_T\, 
         \$1423_T\, \$1360_sr\, \$1370_T\, rdy225, rdy273, \$1385_T\, 
         \rdy_$14200245\, \$1415_T\, go169, \rdy_$13981214\, \rdy_$14280242\, 
         \$1437_T\, \$1380_T\, \rdy_$13980176\, \rdy_$13901181\, \$1358_sc\, 
         \rdy_$14201229\, rdy243, rdy_id172173, \$v259\, \rdy_$v167168\, 
         \rdy_$14201251\, go199, go264, \$1439_T\, go216, rdy195, \$1354_sa\, 
         \rdy_$14200226\, \rdy_$13900178\, \$1434_T\, \rdy_$14301222\, 
         \rdy_$13980194\, \$1433_T\, \rdy_$13981189\, go253, 
         \result_$14200%next\, \result_$14200%now\, \result_$13900%next\, 
         \result_$13900%now\, \result_$13901%next\, \result_$13901%now\, 
         \result_$13981%next\, \result_$13981%now\, \result_$14201%next\, 
         \result_$14201%now\, \result_$14281%next\, \result_$14281%now\, 
         \result_$14301%next\, \result_$14301%now\, \result_$14300%next\, 
         \result_$14300%now\ : Values.t(0 to 0) := (others => '0');
  
  begin
    process (reset,clk)
      begin
      if reset = '1' then
        \result_$14300%now\ <= (others => '0');
        \result_$14301%now\ <= (others => '0');
        \result_$14281%now\ <= (others => '0');
        \result_$14280%now\ <= (others => '0');
        \result_$13980%now\ <= (others => '0');
        \result_$14201%now\ <= (others => '0');
        \result_$13981%now\ <= (others => '0');
        \result_$13901%now\ <= (others => '0');
        \result_$13900%now\ <= (others => '0');
        \result_$14200%now\ <= (others => '0');
        \state_$v166%now\ <= IDLE272;
        \state_$13900%now\ <= \IDLE_$13900\;
        \state_$13901%now\ <= \IDLE_$13901\;
        \state_$1391inner%now\ <= \$V210\;
        \state_$13980%now\ <= \IDLE_$13980\;
        \state_$13981%now\ <= \IDLE_$13981\;
        \state_$14300%now\ <= \IDLE_$14300\;
        \state_$14200%now\ <= \IDLE_$14200\;
        \state_$14201%now\ <= \IDLE_$14201\;
        \state_$1421inner%now\ <= \$V258\;
        \state_$14280%now\ <= \IDLE_$14280\;
        \state_$14281%now\ <= \IDLE_$14281\;
        \state_$14301%now\ <= \IDLE_$14301\;
        \state_id172%now\ <= IDLE_ID172;
        \state_$v167%now\ <= \IDLE_$V167\;
      elsif (rising_edge(clk)) then
        \result_$14300%now\ <= \result_$14300%next\;
        \result_$14301%now\ <= \result_$14301%next\;
        \result_$14281%now\ <= \result_$14281%next\;
        \result_$14280%now\ <= \result_$14280%next\;
        \result_$13980%now\ <= \result_$13980%next\;
        \result_$14201%now\ <= \result_$14201%next\;
        \result_$13981%now\ <= \result_$13981%next\;
        \result_$13901%now\ <= \result_$13901%next\;
        \result_$13900%now\ <= \result_$13900%next\;
        \result_$14200%now\ <= \result_$14200%next\;
        \state_$13900%now\ <= \state_$13900%next\;
        \state_$13901%now\ <= \state_$13901%next\;
        \state_$1391inner%now\ <= \state_$1391inner%next\;
        \state_$13980%now\ <= \state_$13980%next\;
        \state_$13981%now\ <= \state_$13981%next\;
        \state_$14300%now\ <= \state_$14300%next\;
        \state_$14200%now\ <= \state_$14200%next\;
        \state_$14201%now\ <= \state_$14201%next\;
        \state_$1421inner%now\ <= \state_$1421inner%next\;
        \state_$14280%now\ <= \state_$14280%next\;
        \state_$14281%now\ <= \state_$14281%next\;
        \state_$14301%now\ <= \state_$14301%next\;
        \state_id172%now\ <= \state_id172%next\;
        \state_$v167%now\ <= \state_$v167%next\;
        \state_$v166%now\ <= \state_$v166%next\;
      end if;
    end process;
      
      process(argument,\state_$v166%now\,\state_$13900%now\,\state_$13901%now\,\state_$1391inner%now\,\state_$13980%now\,\state_$13981%now\,\state_$14300%now\,\state_$14200%now\,\state_$14201%now\,\state_$1421inner%now\,\state_$14280%now\,\state_$14281%now\,\state_$14301%now\,\state_id172%now\,\state_$v167%now\, \result_$14300%now\, \result_$14301%now\, \result_$14281%now\, \result_$14280%now\, \result_$13980%now\, \result_$14201%now\, \result_$13981%now\, \result_$13901%now\, \result_$13900%now\, \result_$14200%now\, go253, \rdy_$13981189\, \$1433_T\, \rdy_$13980194\, \rdy_$14301222\, \$1434_T\, \rdy_$13900178\, \rdy_$14200226\, \$1354_sa\, rdy195, go216, \$1439_T\, go264, go199, \rdy_$14201251\, \rdy_$v167168\, \$v259\, rdy_id172173, rdy243, \rdy_$14201229\, \$1358_sc\, \rdy_$13901181\, \rdy_$13980176\, \$1380_T\, \$1437_T\, \rdy_$14280242\, \rdy_$13981214\, go169, \$1415_T\, \rdy_$14200245\, \$1385_T\, rdy273, rdy225, \$1370_T\, \$1360_sr\, \$1423_T\, \$1400_T\, \$1362_so\, \rdy_$13901203\, rdy177, \rdy_$14281237\, go247, \rdy_$13900197\, go205, \$1366_t\, \$1410_T\, \$1356_sb\, \$1393_T\, \rdy_$14300174\, \$1432_T\, \$1435_T\, \rdy_$14280224\, \$1438_T\, \rdy_$14281262\, \$v211\, \$1436_T\)
        variable \$1367\, \$1363_w\, \$1402\, \$1407\, \result_$13980\, 
                 \result_$14280\, \$1372\, \$1377\ : Values.t(0 to 1) := (others => '0');
        variable z175, \$1371\, \$1401\, z223 : Values.t(0 to 2) := (others => '0');
        variable \$1431_argument\ : Values.t(0 to 3) := (others => '0');
        variable \result_$14200\, \$v206\, \$v208\, \result_$13900\, \$v180\, 
                 \$v184\, \$v248\, \result_$13901\, \$1411\, \$1378\, 
                 \$v241\, \$v249\, z198, \$1404\, \$1379\, \$1403\, z204, 
                 \$v256\, \$1353_r\, z215, \$1408\, \$1416\, \$1374\, 
                 \$1422\, \$v254\, \$v260\, \$v271\, \$1412\, \$1368\, 
                 \$1373\, \$v209\, \$v232\, z196, \$v213\, \result_$13981\, 
                 \$v239\, \$1425\, \$v193\, \$v170\, \$v231\, \$1424\, 
                 \$1394\, \$v255\, z252, \$v261\, \$1369\, \$v257\, 
                 \$1351_b\, \$1352_c\, \$1381\, \$v200\, \result_$14201\, 
                 \$v212\, \$1364\, z246, \$v207\, \$v218\, \$1392\, 
                 \$1350_a\, \$v220\, \$v268\, \$v265\, \$1382\, \$v217\, 
                 \$v192\, \$v250\, \$1387\, \result_$v166\, \$v219\, z244, 
                 \$1395\, result_id172, \$v191\, \$v183\, \$v201\, \$v202\, 
                 \$v228\, \$1409\, \result_$14281\, \$v266\, \$1417\, 
                 \$v240\, \$v267\, \$v269\, \$v171\, z263, \$v270\, \$v235\, 
                 \$v187\, \$1386\, \result_$14301\, \$v221\, \result_$14300\ : Values.t(0 to 0) := (others => '0');
        variable \$1365_Int.print\ : Values.t(0 to 31) := (others => '0');
        variable \state_$v166\ : \t_state_$v166\;
        variable \state_$13900\ : \t_state_$13900\;
        variable \state_$13901\ : \t_state_$13901\;
        variable \state_$1391inner\ : \t_state_$1391inner\;
        variable \state_$13980\ : \t_state_$13980\;
        variable \state_$13981\ : \t_state_$13981\;
        variable \state_$14300\ : \t_state_$14300\;
        variable \state_$14200\ : \t_state_$14200\;
        variable \state_$14201\ : \t_state_$14201\;
        variable \state_$1421inner\ : \t_state_$1421inner\;
        variable \state_$14280\ : \t_state_$14280\;
        variable \state_$14281\ : \t_state_$14281\;
        variable \state_$14301\ : \t_state_$14301\;
        variable state_id172 : t_state_id172;
        variable \state_$v167\ : \t_state_$v167\;
        
    begin
      go253 <= (others => '0');
      \rdy_$13981189\ <= (others => '0');
      \$1433_T\ <= (others => '0');
      \rdy_$13980194\ <= (others => '0');
      \rdy_$14301222\ <= (others => '0');
      \$1434_T\ <= (others => '0');
      \rdy_$13900178\ <= (others => '0');
      \rdy_$14200226\ <= (others => '0');
      \$1354_sa\ <= (others => '0');
      rdy195 <= (others => '0');
      go216 <= (others => '0');
      \$1439_T\ <= (others => '0');
      go264 <= (others => '0');
      go199 <= (others => '0');
      \rdy_$14201251\ <= (others => '0');
      \rdy_$v167168\ <= (others => '0');
      \$v259\ <= (others => '0');
      rdy_id172173 <= (others => '0');
      rdy243 <= (others => '0');
      \rdy_$14201229\ <= (others => '0');
      \$1358_sc\ <= (others => '0');
      \rdy_$13901181\ <= (others => '0');
      \rdy_$13980176\ <= (others => '0');
      \$1380_T\ <= (others => '0');
      \$1437_T\ <= (others => '0');
      \rdy_$14280242\ <= (others => '0');
      \rdy_$13981214\ <= (others => '0');
      go169 <= (others => '0');
      \$1415_T\ <= (others => '0');
      \rdy_$14200245\ <= (others => '0');
      \$1385_T\ <= (others => '0');
      rdy273 <= (others => '0');
      rdy225 <= (others => '0');
      \$1370_T\ <= (others => '0');
      \$1360_sr\ <= (others => '0');
      \$1423_T\ <= (others => '0');
      \$1400_T\ <= (others => '0');
      \$1362_so\ <= (others => '0');
      \rdy_$13901203\ <= (others => '0');
      rdy177 <= (others => '0');
      \rdy_$14281237\ <= (others => '0');
      go247 <= (others => '0');
      \rdy_$13900197\ <= (others => '0');
      go205 <= (others => '0');
      \$1366_t\ <= (others => '0');
      \$1410_T\ <= (others => '0');
      \$1356_sb\ <= (others => '0');
      \$1393_T\ <= (others => '0');
      \rdy_$14300174\ <= (others => '0');
      \$1432_T\ <= (others => '0');
      \$1435_T\ <= (others => '0');
      \rdy_$14280224\ <= (others => '0');
      \$1438_T\ <= (others => '0');
      \rdy_$14281262\ <= (others => '0');
      \$v211\ <= (others => '0');
      \$1436_T\ <= (others => '0');\result_$14300\ := \result_$14300%now\;
      \result_$14301\ := \result_$14301%now\;
      \result_$14281\ := \result_$14281%now\;
      \result_$14280\ := \result_$14280%now\;
      \result_$13980\ := \result_$13980%now\;
      \result_$14201\ := \result_$14201%now\;
      \result_$13981\ := \result_$13981%now\;
      \result_$13901\ := \result_$13901%now\;
      \result_$13900\ := \result_$13900%now\;
      \result_$14200\ := \result_$14200%now\;
      \state_$v166\ := \state_$v166%now\;
      \state_$13900\ := \state_$13900%now\;
      \state_$13901\ := \state_$13901%now\;
      \state_$1391inner\ := \state_$1391inner%now\;
      \state_$13980\ := \state_$13980%now\;
      \state_$13981\ := \state_$13981%now\;
      \state_$14300\ := \state_$14300%now\;
      \state_$14200\ := \state_$14200%now\;
      \state_$14201\ := \state_$14201%now\;
      \state_$1421inner\ := \state_$1421inner%now\;
      \state_$14280\ := \state_$14280%now\;
      \state_$14281\ := \state_$14281%now\;
      \state_$14301\ := \state_$14301%now\;
      state_id172 := \state_id172%now\;
      \state_$v167\ := \state_$v167%now\;
      \$v221\ := (others => '0');
      \$1386\ := (others => '0');
      \$v187\ := (others => '0');
      \$1365_Int.print\ := (others => '0');
      \$v235\ := (others => '0');
      \$v270\ := (others => '0');
      z263 := (others => '0');
      \$v171\ := (others => '0');
      \$v269\ := (others => '0');
      \$1377\ := (others => '0');
      \$v267\ := (others => '0');
      \$v240\ := (others => '0');
      \$1417\ := (others => '0');
      \$v266\ := (others => '0');
      \$1409\ := (others => '0');
      \$v228\ := (others => '0');
      \$v202\ := (others => '0');
      \$v201\ := (others => '0');
      \$v183\ := (others => '0');
      \$v191\ := (others => '0');
      result_id172 := (others => '0');
      \$1395\ := (others => '0');
      z244 := (others => '0');
      \$v219\ := (others => '0');
      \result_$v166\ := (others => '0');
      \$1372\ := (others => '0');
      \$1387\ := (others => '0');
      \$v250\ := (others => '0');
      \$v192\ := (others => '0');
      \$v217\ := (others => '0');
      \$1382\ := (others => '0');
      \$v265\ := (others => '0');
      z223 := (others => '0');
      \$v268\ := (others => '0');
      \$v220\ := (others => '0');
      \$1350_a\ := (others => '0');
      \$1392\ := (others => '0');
      \$v218\ := (others => '0');
      \$v207\ := (others => '0');
      \$1401\ := (others => '0');
      z246 := (others => '0');
      \$1364\ := (others => '0');
      \$v212\ := (others => '0');
      \$v200\ := (others => '0');
      \$1381\ := (others => '0');
      \$1431_argument\ := (others => '0');
      \$1352_c\ := (others => '0');
      \$1351_b\ := (others => '0');
      \$v257\ := (others => '0');
      \$1369\ := (others => '0');
      \$v261\ := (others => '0');
      z252 := (others => '0');
      \$v255\ := (others => '0');
      \$1394\ := (others => '0');
      \$1424\ := (others => '0');
      \$v231\ := (others => '0');
      \$v170\ := (others => '0');
      \$v193\ := (others => '0');
      \$1425\ := (others => '0');
      \$v239\ := (others => '0');
      \$1407\ := (others => '0');
      \$v213\ := (others => '0');
      z196 := (others => '0');
      \$v232\ := (others => '0');
      \$v209\ := (others => '0');
      \$1373\ := (others => '0');
      \$1368\ := (others => '0');
      \$1412\ := (others => '0');
      \$v271\ := (others => '0');
      \$v260\ := (others => '0');
      \$v254\ := (others => '0');
      \$1422\ := (others => '0');
      \$1374\ := (others => '0');
      \$1416\ := (others => '0');
      \$1408\ := (others => '0');
      z215 := (others => '0');
      \$1353_r\ := (others => '0');
      \$v256\ := (others => '0');
      \$1371\ := (others => '0');
      z204 := (others => '0');
      \$1403\ := (others => '0');
      \$1379\ := (others => '0');
      \$1404\ := (others => '0');
      z198 := (others => '0');
      \$1402\ := (others => '0');
      \$v249\ := (others => '0');
      \$v241\ := (others => '0');
      \$1378\ := (others => '0');
      \$1411\ := (others => '0');
      \$v248\ := (others => '0');
      z175 := (others => '0');
      \$v184\ := (others => '0');
      \$v180\ := (others => '0');
      \$v208\ := (others => '0');
      \$v206\ := (others => '0');
      \$1363_w\ := (others => '0');
      \$1367\ := (others => '0');
       -- case \state_$v166\ is when IDLE272 =>
       -- case \state_$v167\ is when \IDLE_$V167\ =>
      \$1431_argument\ := argument;
      \$1350_a\ := ""&\$1431_argument\(0);
      \$1351_b\ := ""&\$1431_argument\(1);
      \$1352_c\ := ""&\$1431_argument\(2);
      \$1353_r\ := ""&\$1431_argument\(3);
      \$1354_sa\ <= \$1350_a\;
      \$1356_sb\ <= \$1351_b\;
      \$1358_sc\ <= \$1352_c\;
      \$1360_sr\ <= \$1353_r\;
      case state_id172 is
      when \$1430\ =>
        case \state_$14300\ is
        when \$1398\ =>
          case \state_$13980\ is
          when \$1391\ =>
            \$v213\ := \$1360_sr\;
            if \$v213\(0) = '1' then
              
            else
              case \state_$1391inner\ is
              when \$1376\ =>
                z196 := work.values.val_unit;
                \state_$1391inner\ := \$1376\;
              when \$1390\ =>
                case \state_$13900\ is
                when \$1383\ =>
                  \$1382\ := \$1354_sa\;
                  \$v201\ := \$1382\;
                  if \$v201\(0) = '1' then
                    \$1380_T\ <= work.Values.val_true;
                  else
                    \result_$13900\ := work.values.val_unit;
                    go199 <= work.Values.val_true;
                  end if;
                when \IDLE_$13900\ =>
                  \rdy_$13900197\ <= work.Values.val_true;
                end case;
                
                case \state_$13901\ is
                when \$1388\ =>
                  \$1387\ := \$1356_sb\;
                  \$v207\ := \$1387\;
                  if \$v207\(0) = '1' then
                    \$1385_T\ <= work.Values.val_true;
                  else
                    \result_$13901\ := work.values.val_unit;
                    go205 <= work.Values.val_true;
                  end if;
                when \IDLE_$13901\ =>
                  \rdy_$13901203\ <= work.Values.val_true;
                end case;
                
              when \$V210\ =>
                
              end case;
              
            end if;
          when \IDLE_$13980\ =>
            \rdy_$13980194\ <= work.Values.val_true;
          end case;
          
          case \state_$13981\ is
          when \$1396\ =>
            \$1395\ := \$1360_sr\;
            \$v218\ := \$1395\;
            if \$v218\(0) = '1' then
              \$1393_T\ <= work.Values.val_true;
            else
              \$1392\ := work.values.val_unit;
              go216 <= work.Values.val_true;
            end if;
          when \IDLE_$13981\ =>
            \rdy_$13981214\ <= work.Values.val_true;
          end case;
          
        when \IDLE_$14300\ =>
          \rdy_$14300174\ <= work.Values.val_true;
        end case;
        
        case \state_$14301\ is
        when \$1428\ =>
          case \state_$14280\ is
          when \$1421\ =>
            \$v261\ := \$1360_sr\;
            if \$v261\(0) = '1' then
              
            else
              case \state_$1421inner\ is
              when \$1406\ =>
                z244 := work.values.val_unit;
                \state_$1421inner\ := \$1406\;
              when \$1420\ =>
                case \state_$14200\ is
                when \$1413\ =>
                  \$1412\ := \$1366_t\;
                  \$v249\ := \$1412\;
                  if \$v249\(0) = '1' then
                    \$1410_T\ <= work.Values.val_true;
                  else
                    \result_$14200\ := work.values.val_unit;
                    go247 <= work.Values.val_true;
                  end if;
                when \IDLE_$14200\ =>
                  \rdy_$14200245\ <= work.Values.val_true;
                end case;
                
                case \state_$14201\ is
                when \$1418\ =>
                  \$1417\ := \$1358_sc\;
                  \$v255\ := \$1417\;
                  if \$v255\(0) = '1' then
                    \$1415_T\ <= work.Values.val_true;
                  else
                    \result_$14201\ := work.values.val_unit;
                    go253 <= work.Values.val_true;
                  end if;
                when \IDLE_$14201\ =>
                  \rdy_$14201251\ <= work.Values.val_true;
                end case;
                
              when \$V258\ =>
                
              end case;
              
            end if;
          when \IDLE_$14280\ =>
            \rdy_$14280242\ <= work.Values.val_true;
          end case;
          
          case \state_$14281\ is
          when \$1426\ =>
            \$1425\ := \$1360_sr\;
            \$v266\ := \$1425\;
            if \$v266\(0) = '1' then
              \$1423_T\ <= work.Values.val_true;
            else
              \$1422\ := work.values.val_unit;
              go264 <= work.Values.val_true;
            end if;
          when \IDLE_$14281\ =>
            \rdy_$14281262\ <= work.Values.val_true;
          end case;
          
        when \IDLE_$14301\ =>
          \rdy_$14301222\ <= work.Values.val_true;
        end case;
        
      when IDLE_ID172 =>
        \$1381\ := work.values.val_unit;
        \state_$13900\ := \$1383\;
        \$1386\ := work.values.val_unit;
        \state_$13901\ := \$1388\;
        \$1394\ := work.values.val_unit;
        \state_$13981\ := \$1396\;
        \$1411\ := work.values.val_unit;
        \state_$14200\ := \$1413\;
        \$1416\ := work.values.val_unit;
        \state_$14201\ := \$1418\;
        \$1424\ := work.values.val_unit;
        \state_$14281\ := \$1426\;
      end case;
      
      \$v200\ := go199;
      if \$v200\(0) = '1' then
        z198 := work.values.val_unit;
        \state_$13900\ := \$1383\;
      end if;
      \$v202\ := \$1380_T\;
      if \$v202\(0) = '1' then
        \rdy_$13900197\ <= work.Values.val_true;
        \state_$13900\ := \IDLE_$13900\;
      end if;
      \$v206\ := go205;
      if \$v206\(0) = '1' then
        z204 := work.values.val_unit;
        \state_$13901\ := \$1388\;
      end if;
      \$v208\ := \$1385_T\;
      if \$v208\(0) = '1' then
        \rdy_$13901203\ <= work.Values.val_true;
        \state_$13901\ := \IDLE_$13901\;
      end if;
      \$v209\ := work.Bool.land(\rdy_$13900197\, \rdy_$13901203\);
      if \$v209\(0) = '1' then
        \$1377\ := \result_$13900\ & \result_$13901\;
        \$1378\ := ""&\$1377\(0);
        \$1379\ := ""&\$1377\(1);
        \$1366_t\ <= work.Values.val_true;
        \$1374\ := work.values.val_unit;
        \state_$1391inner\ := \$1376\;
      else
        \state_$1391inner\ := \$1390\;
      end if;
      \$v212\ := rdy195;
      if \$v212\(0) = '1' then
        \$1370_T\ <= work.Values.val_true;
      else
        \state_$13980\ := \$1391\;
      end if;
      \$v217\ := go216;
      if \$v217\(0) = '1' then
        z215 := work.values.val_unit;
        \state_$13981\ := \$1396\;
      end if;
      \$v219\ := \$1393_T\;
      if \$v219\(0) = '1' then
        \$1370_T\ <= work.Values.val_true;
      end if;
      \$v220\ := work.Bool.land(\rdy_$13980194\, \rdy_$13981214\);
      if \$v220\(0) = '1' then
        \$1371\ := \result_$13980\ & \result_$13981\;
        \$1372\ := \$1371\(0 to 1);
        \$1373\ := ""&\$1371\(2);
        \result_$14300\ := work.values.val_unit;
        \$1370_T\ <= work.Values.val_true;
      else
        \state_$14300\ := \$1398\;
      end if;
      \$v221\ := \$1370_T\;
      if \$v221\(0) = '1' then
        \result_$13900\ := work.values.val_unit;
        \state_$13900\ := \$1383\;
        \result_$13901\ := work.values.val_unit;
        \state_$13901\ := \$1388\;
        \result_$13981\ := work.values.val_unit;
        \state_$13981\ := \$1396\;
      end if;
      \$v180\ := \$1433_T\;
      if \$v180\(0) = '1' then
        \rdy_$13900178\ <= work.Values.val_true;
        \state_$13900\ := \IDLE_$13900\;
      end if;
      \$v183\ := \$1434_T\;
      if \$v183\(0) = '1' then
        \rdy_$13901181\ <= work.Values.val_true;
        \state_$13901\ := \IDLE_$13901\;
      end if;
      \$v184\ := work.Bool.land(\rdy_$13900178\, \rdy_$13901181\);
      if \$v184\(0) = '1' then
        \result_$13980\ := \result_$13900\ & \result_$13901\;
        rdy177 <= work.Values.val_true;
      else
        \state_$1391inner\ := \$1390\;
      end if;
      \$v187\ := rdy177;
      if \$v187\(0) = '1' then
        \rdy_$13980176\ <= work.Values.val_true;
        \state_$13980\ := \IDLE_$13980\;
      else
        \state_$13980\ := \$1391\;
      end if;
      \$v191\ := \$1435_T\;
      if \$v191\(0) = '1' then
        \rdy_$13981189\ <= work.Values.val_true;
        \state_$13981\ := \IDLE_$13981\;
      end if;
      \$v192\ := work.Bool.land(\rdy_$13980176\, \rdy_$13981189\);
      if \$v192\(0) = '1' then
        z175 := \result_$13980\ & \result_$13981\;
        \$1432_T\ <= work.Values.val_true;
      else
        \state_$14300\ := \$1398\;
      end if;
      \$v193\ := \$1432_T\;
      if \$v193\(0) = '1' then
        
      end if;
      \$v248\ := go247;
      if \$v248\(0) = '1' then
        z246 := work.values.val_unit;
        \state_$14200\ := \$1413\;
      end if;
      \$v250\ := \$1410_T\;
      if \$v250\(0) = '1' then
        \rdy_$14200245\ <= work.Values.val_true;
        \state_$14200\ := \IDLE_$14200\;
      end if;
      \$v254\ := go253;
      if \$v254\(0) = '1' then
        z252 := work.values.val_unit;
        \state_$14201\ := \$1418\;
      end if;
      \$v256\ := \$1415_T\;
      if \$v256\(0) = '1' then
        \rdy_$14201251\ <= work.Values.val_true;
        \state_$14201\ := \IDLE_$14201\;
      end if;
      \$v257\ := work.Bool.land(\rdy_$14200245\, \rdy_$14201251\);
      if \$v257\(0) = '1' then
        \$1407\ := \result_$14200\ & \result_$14201\;
        \$1408\ := ""&\$1407\(0);
        \$1409\ := ""&\$1407\(1);
        \$1362_so\ <= work.Values.val_true;
        \$1404\ := work.values.val_unit;
        \state_$1421inner\ := \$1406\;
      else
        \state_$1421inner\ := \$1420\;
      end if;
      \$v260\ := rdy243;
      if \$v260\(0) = '1' then
        \$1400_T\ <= work.Values.val_true;
      else
        \state_$14280\ := \$1421\;
      end if;
      \$v265\ := go264;
      if \$v265\(0) = '1' then
        z263 := work.values.val_unit;
        \state_$14281\ := \$1426\;
      end if;
      \$v267\ := \$1423_T\;
      if \$v267\(0) = '1' then
        \$1400_T\ <= work.Values.val_true;
      end if;
      \$v268\ := work.Bool.land(\rdy_$14280242\, \rdy_$14281262\);
      if \$v268\(0) = '1' then
        \$1401\ := \result_$14280\ & \result_$14281\;
        \$1402\ := \$1401\(0 to 1);
        \$1403\ := ""&\$1401\(2);
        \result_$14301\ := work.values.val_unit;
        \$1400_T\ <= work.Values.val_true;
      else
        \state_$14301\ := \$1428\;
      end if;
      \$v269\ := \$1400_T\;
      if \$v269\(0) = '1' then
        \result_$14200\ := work.values.val_unit;
        \state_$14200\ := \$1413\;
        \result_$14201\ := work.values.val_unit;
        \state_$14201\ := \$1418\;
        \result_$14281\ := work.values.val_unit;
        \state_$14281\ := \$1426\;
      end if;
      \$v228\ := \$1437_T\;
      if \$v228\(0) = '1' then
        \rdy_$14200226\ <= work.Values.val_true;
        \state_$14200\ := \IDLE_$14200\;
      end if;
      \$v231\ := \$1438_T\;
      if \$v231\(0) = '1' then
        \rdy_$14201229\ <= work.Values.val_true;
        \state_$14201\ := \IDLE_$14201\;
      end if;
      \$v232\ := work.Bool.land(\rdy_$14200226\, \rdy_$14201229\);
      if \$v232\(0) = '1' then
        \result_$14280\ := \result_$14200\ & \result_$14201\;
        rdy225 <= work.Values.val_true;
      else
        \state_$1421inner\ := \$1420\;
      end if;
      \$v235\ := rdy225;
      if \$v235\(0) = '1' then
        \rdy_$14280224\ <= work.Values.val_true;
        \state_$14280\ := \IDLE_$14280\;
      else
        \state_$14280\ := \$1421\;
      end if;
      \$v239\ := \$1439_T\;
      if \$v239\(0) = '1' then
        \rdy_$14281237\ <= work.Values.val_true;
        \state_$14281\ := \IDLE_$14281\;
      end if;
      \$v240\ := work.Bool.land(\rdy_$14280224\, \rdy_$14281237\);
      if \$v240\(0) = '1' then
        z223 := \result_$14280\ & \result_$14281\;
        \$1436_T\ <= work.Values.val_true;
      else
        \state_$14301\ := \$1428\;
      end if;
      \$v241\ := \$1436_T\;
      if \$v241\(0) = '1' then
        
      end if;
      \$v270\ := work.Bool.land(\rdy_$14300174\, \rdy_$14301222\);
      if \$v270\(0) = '1' then
        \$1367\ := \result_$14300\ & \result_$14301\;
        \$1368\ := ""&\$1367\(0);
        \$1369\ := ""&\$1367\(1);
        result_id172 := work.values.val_unit;
        rdy_id172173 <= work.Values.val_true;
        state_id172 := IDLE_ID172;
      else
        state_id172 := \$1430\;
      end if;
      \$v271\ := rdy_id172173;
      if \$v271\(0) = '1' then
        \$1363_w\ := result_id172 & rdy_id172173;
      else
        \$1363_w\ := work.values.val_unit & rdy_id172173;
      end if;
      \$1364\ := \$1362_so\;
      \$v171\ := \$1364\;
      if \$v171\(0) = '1' then
        \$1365_Int.print\ := "00000000000000000000000000000001";
        go169 <= work.Values.val_true;
      else
        \$1365_Int.print\ := "00000000000000000000000000000000";
        go169 <= work.Values.val_true;
      end if;
      -- end case;
      
      \$v170\ := go169;
      if \$v170\(0) = '1' then
        \result_$v166\ := \$1362_so\;
        \rdy_$v167168\ <= work.Values.val_true;
        \state_$v167\ := \IDLE_$V167\;
      end if;
      -- end case;
      \state_$v166%next\ <= \state_$v166\;
      \state_$13900%next\ <= \state_$13900\;
      \state_$13901%next\ <= \state_$13901\;
      \state_$1391inner%next\ <= \state_$1391inner\;
      \state_$13980%next\ <= \state_$13980\;
      \state_$13981%next\ <= \state_$13981\;
      \state_$14300%next\ <= \state_$14300\;
      \state_$14200%next\ <= \state_$14200\;
      \state_$14201%next\ <= \state_$14201\;
      \state_$1421inner%next\ <= \state_$1421inner\;
      \state_$14280%next\ <= \state_$14280\;
      \state_$14281%next\ <= \state_$14281\;
      \state_$14301%next\ <= \state_$14301\;
      \state_id172%next\ <= state_id172;
      \state_$v167%next\ <= \state_$v167\;
      \result_$14300%next\ <= \result_$14300\;
      \result_$14301%next\ <= \result_$14301\;
      \result_$14281%next\ <= \result_$14281\;
      \result_$14280%next\ <= \result_$14280\;
      \result_$13980%next\ <= \result_$13980\;
      \result_$14201%next\ <= \result_$14201\;
      \result_$13981%next\ <= \result_$13981\;
      \result_$13901%next\ <= \result_$13901\;
      \result_$13900%next\ <= \result_$13900\;
      \result_$14200%next\ <= \result_$14200\;
      
      
      result <= \result_$v166\;
      end process;
      
  end architecture;
