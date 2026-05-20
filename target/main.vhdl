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


entity main is
  
  port(signal clk    : in std_logic;
       signal reset  : in std_logic;
       signal argument : in Values.t(0 to 3);
       signal result : out Values.t(0 to 0));
       
end entity;
architecture rtl of main is

  type \t_state_$v170\ is (IDLE276);
  signal \state_$v170%now\, \state_$v170%next\: \t_state_$v170\;
  type \t_state_$13530\ is (\IDLE_$13530\, \$1346\);
  signal \state_$13530%now\, \state_$13530%next\: \t_state_$13530\;
  type \t_state_$13531\ is (\IDLE_$13531\, \$1351\);
  signal \state_$13531%now\, \state_$13531%next\: \t_state_$13531\;
  type \t_state_$1354inner\ is (\$V214\, \$1339\, \$1353\);
  signal \state_$1354inner%now\, \state_$1354inner%next\: \t_state_$1354inner\;
  type \t_state_$13610\ is (\IDLE_$13610\, \$1354\);
  signal \state_$13610%now\, \state_$13610%next\: \t_state_$13610\;
  type \t_state_$13611\ is (\IDLE_$13611\, \$1359\);
  signal \state_$13611%now\, \state_$13611%next\: \t_state_$13611\;
  type \t_state_$13930\ is (\IDLE_$13930\, \$1361\);
  signal \state_$13930%now\, \state_$13930%next\: \t_state_$13930\;
  type \t_state_$13830\ is (\IDLE_$13830\, \$1376\);
  signal \state_$13830%now\, \state_$13830%next\: \t_state_$13830\;
  type \t_state_$13831\ is (\IDLE_$13831\, \$1381\);
  signal \state_$13831%now\, \state_$13831%next\: \t_state_$13831\;
  type \t_state_$1384inner\ is (\$V262\, \$1369\, \$1383\);
  signal \state_$1384inner%now\, \state_$1384inner%next\: \t_state_$1384inner\;
  type \t_state_$13910\ is (\IDLE_$13910\, \$1384\);
  signal \state_$13910%now\, \state_$13910%next\: \t_state_$13910\;
  type \t_state_$13911\ is (\IDLE_$13911\, \$1389\);
  signal \state_$13911%now\, \state_$13911%next\: \t_state_$13911\;
  type \t_state_$13931\ is (\IDLE_$13931\, \$1391\);
  signal \state_$13931%now\, \state_$13931%next\: \t_state_$13931\;
  type t_state_id176 is (IDLE_ID176, \$1393\);
  signal \state_id176%now\, \state_id176%next\: t_state_id176;
  type \t_state_$v171\ is (\IDLE_$V171\);
  signal \state_$v171%now\, \state_$v171%next\: \t_state_$v171\;
  signal \result_$13610%next\, \result_$13610%now\, \result_$13910%next\, 
         \result_$13910%now\ : Values.t(0 to 1) := (others => '0');
  signal rdy277, rdy199, \$1315_sa\, \rdy_$13830249\, \$1386_T\, \$1402_T\, 
         \$1397_T\, \rdy_$13831255\, \$1317_sb\, \$1363_T\, \rdy_$13911266\, 
         go209, \$1401_T\, \$1373_T\, \rdy_$13610198\, rdy247, 
         \rdy_$13531207\, \rdy_$13930178\, \rdy_$13931226\, \$1400_T\, 
         \$1356_T\, \rdy_$13830230\, go203, \rdy_$13910246\, rdy_id176177, 
         go251, \rdy_$13910228\, \$1348_T\, \$v263\, rdy229, \$1333_T\, 
         \$1378_T\, \$v215\, go257, rdy181, \$1329_t\, \rdy_$13610180\, 
         \rdy_$13530201\, \rdy_$13530182\, \rdy_$13611218\, \rdy_$13831233\, 
         go220, \$1323_so\, go173, \$1343_T\, \$1396_T\, \rdy_$13611193\, 
         \rdy_$13911241\, \rdy_$13531185\, \rdy_$v171172\, \$1398_T\, 
         \$1319_sc\, \$1399_T\, \$1395_T\, \$1321_sr\, go268, 
         \result_$13530%next\, \result_$13530%now\, \result_$13531%next\, 
         \result_$13531%now\, \result_$13911%next\, \result_$13911%now\, 
         \result_$13831%next\, \result_$13831%now\, \result_$13830%next\, 
         \result_$13830%now\, \result_$13611%next\, \result_$13611%now\ : Values.t(0 to 0) := (others => '0');
  
  begin
    process (reset,clk)
      begin
      if reset = '1' then
        \result_$13611%now\ <= (others => '0');
        \result_$13830%now\ <= (others => '0');
        \result_$13910%now\ <= (others => '0');
        \result_$13831%now\ <= (others => '0');
        \result_$13911%now\ <= (others => '0');
        \result_$13531%now\ <= (others => '0');
        \result_$13610%now\ <= (others => '0');
        \result_$13530%now\ <= (others => '0');
        \state_$v170%now\ <= IDLE276;
        \state_$13530%now\ <= \IDLE_$13530\;
        \state_$13531%now\ <= \IDLE_$13531\;
        \state_$1354inner%now\ <= \$V214\;
        \state_$13610%now\ <= \IDLE_$13610\;
        \state_$13611%now\ <= \IDLE_$13611\;
        \state_$13930%now\ <= \IDLE_$13930\;
        \state_$13830%now\ <= \IDLE_$13830\;
        \state_$13831%now\ <= \IDLE_$13831\;
        \state_$1384inner%now\ <= \$V262\;
        \state_$13910%now\ <= \IDLE_$13910\;
        \state_$13911%now\ <= \IDLE_$13911\;
        \state_$13931%now\ <= \IDLE_$13931\;
        \state_id176%now\ <= IDLE_ID176;
        \state_$v171%now\ <= \IDLE_$V171\;
      elsif (rising_edge(clk)) then
        \result_$13611%now\ <= \result_$13611%next\;
        \result_$13830%now\ <= \result_$13830%next\;
        \result_$13910%now\ <= \result_$13910%next\;
        \result_$13831%now\ <= \result_$13831%next\;
        \result_$13911%now\ <= \result_$13911%next\;
        \result_$13531%now\ <= \result_$13531%next\;
        \result_$13610%now\ <= \result_$13610%next\;
        \result_$13530%now\ <= \result_$13530%next\;
        \state_$13530%now\ <= \state_$13530%next\;
        \state_$13531%now\ <= \state_$13531%next\;
        \state_$1354inner%now\ <= \state_$1354inner%next\;
        \state_$13610%now\ <= \state_$13610%next\;
        \state_$13611%now\ <= \state_$13611%next\;
        \state_$13930%now\ <= \state_$13930%next\;
        \state_$13830%now\ <= \state_$13830%next\;
        \state_$13831%now\ <= \state_$13831%next\;
        \state_$1384inner%now\ <= \state_$1384inner%next\;
        \state_$13910%now\ <= \state_$13910%next\;
        \state_$13911%now\ <= \state_$13911%next\;
        \state_$13931%now\ <= \state_$13931%next\;
        \state_id176%now\ <= \state_id176%next\;
        \state_$v171%now\ <= \state_$v171%next\;
        \state_$v170%now\ <= \state_$v170%next\;
      end if;
    end process;
      
      process(argument,\state_$v170%now\, clk,\state_$13530%now\,\state_$13531%now\,\state_$1354inner%now\,\state_$13610%now\,\state_$13611%now\,\state_$13930%now\,\state_$13830%now\,\state_$13831%now\,\state_$1384inner%now\,\state_$13910%now\,\state_$13911%now\,\state_$13931%now\,\state_id176%now\,\state_$v171%now\, \result_$13611%now\, \result_$13830%now\, \result_$13910%now\, \result_$13831%now\, \result_$13911%now\, \result_$13531%now\, \result_$13610%now\, \result_$13530%now\, go268, \$1321_sr\, \$1395_T\, \$1399_T\, \$1319_sc\, \$1398_T\, \rdy_$v171172\, \rdy_$13531185\, \rdy_$13911241\, \rdy_$13611193\, \$1396_T\, \$1343_T\, go173, \$1323_so\, go220, \rdy_$13831233\, \rdy_$13611218\, \rdy_$13530182\, \rdy_$13530201\, \rdy_$13610180\, \$1329_t\, rdy181, go257, \$v215\, \$1378_T\, \$1333_T\, rdy229, \$v263\, \$1348_T\, \rdy_$13910228\, go251, rdy_id176177, \rdy_$13910246\, go203, \rdy_$13830230\, \$1356_T\, \$1400_T\, \rdy_$13931226\, \rdy_$13930178\, \rdy_$13531207\, rdy247, \rdy_$13610198\, \$1373_T\, \$1401_T\, go209, \rdy_$13911266\, \$1363_T\, \$1317_sb\, \rdy_$13831255\, \$1397_T\, \$1402_T\, \$1386_T\, \rdy_$13830249\, \$1315_sa\, rdy199, rdy277)
        variable \result_$13610\, \$1335\, \$1330\, \$1324_w\, 
                 \result_$13910\, \$1365\, \$1340\, \$1370\ : Values.t(0 to 1) := (others => '0');
        variable z227, \$1334\, \$1364\, z179 : Values.t(0 to 2) := (others => '0');
        variable \$1394_argument\ : Values.t(0 to 3) := (others => '0');
        variable \result_$13530\, \$1366\, \$v174\, \$1367\, \$v243\, 
                 \$v175\, \$v206\, \$v211\, z208, \$v184\, \$v275\, \$1345\, 
                 \$1312_b\, \$1357\, \$v225\, \$v258\, \$1325\, \$v216\, 
                 \$1332\, \$v188\, \$1355\, \$v223\, \$1379\, \$1350\, z202, 
                 \$1342\, \$1371\, \$1388\, \$v197\, \$v252\, \$v244\, 
                 \$1374\, \result_$13531\, \$v222\, \$v254\, \$v260\, z267, 
                 \$v271\, \$v204\, z256, \result_$13911\, \$1328\, z219, 
                 \$v210\, \$1313_c\, \$v232\, \$1349\, \$v213\, \$1375\, 
                 \$v239\, \$v236\, \$1336\, z200, \$v261\, \$v272\, 
                 \$1314_r\, \$v224\, \result_$13831\, \$v212\, \$v195\, z250, 
                 \result_$13930\, \$v274\, \$1331\, \result_$13931\, 
                 \result_$13830\, \$v196\, \$v245\, \result_$v170\, \$v265\, 
                 \$v205\, \$1327\, \$v217\, \$1358\, \$v259\, \$1387\, 
                 \$v253\, \$1372\, \$v191\, result_id176, \$1385\, \$v264\, 
                 \$1344\, z248, \result_$13611\, \$1311_a\, \$v269\, \$1337\, 
                 \$v270\, \$v235\, \$1341\, \$v273\, \$v187\, \$v221\, 
                 \$1380\ : Values.t(0 to 0) := (others => '0');
        variable \$1326\ : Values.t(0 to 31) := (others => '0');
        variable \state_$v170\ : \t_state_$v170\;
        variable \state_$13530\ : \t_state_$13530\;
        variable \state_$13531\ : \t_state_$13531\;
        variable \state_$1354inner\ : \t_state_$1354inner\;
        variable \state_$13610\ : \t_state_$13610\;
        variable \state_$13611\ : \t_state_$13611\;
        variable \state_$13930\ : \t_state_$13930\;
        variable \state_$13830\ : \t_state_$13830\;
        variable \state_$13831\ : \t_state_$13831\;
        variable \state_$1384inner\ : \t_state_$1384inner\;
        variable \state_$13910\ : \t_state_$13910\;
        variable \state_$13911\ : \t_state_$13911\;
        variable \state_$13931\ : \t_state_$13931\;
        variable state_id176 : t_state_id176;
        variable \state_$v171\ : \t_state_$v171\;
        
    begin
      go268 <= (others => '0');
      
      \$1321_sr\ <= (others => '0');
      
      \$1395_T\ <= (others => '0');
      
      \$1399_T\ <= (others => '0');
      
      \$1319_sc\ <= (others => '0');
      
      \$1398_T\ <= (others => '0');
      
      \rdy_$v171172\ <= (others => '0');
      
      \rdy_$13531185\ <= (others => '0');
      
      \rdy_$13911241\ <= (others => '0');
      
      \rdy_$13611193\ <= (others => '0');
      
      \$1396_T\ <= (others => '0');
      
      \$1343_T\ <= (others => '0');
      
      go173 <= (others => '0');
      
      \$1323_so\ <= (others => '0');
      
      go220 <= (others => '0');
      
      \rdy_$13831233\ <= (others => '0');
      
      \rdy_$13611218\ <= (others => '0');
      
      \rdy_$13530182\ <= (others => '0');
      
      \rdy_$13530201\ <= (others => '0');
      
      \rdy_$13610180\ <= (others => '0');
      
      \$1329_t\ <= (others => '0');
      
      rdy181 <= (others => '0');
      
      go257 <= (others => '0');
      
      \$v215\ <= (others => '0');
      
      \$1378_T\ <= (others => '0');
      
      \$1333_T\ <= (others => '0');
      
      rdy229 <= (others => '0');
      
      \$v263\ <= (others => '0');
      
      \$1348_T\ <= (others => '0');
      
      \rdy_$13910228\ <= (others => '0');
      
      go251 <= (others => '0');
      
      rdy_id176177 <= (others => '0');
      
      \rdy_$13910246\ <= (others => '0');
      
      go203 <= (others => '0');
      
      \rdy_$13830230\ <= (others => '0');
      
      \$1356_T\ <= (others => '0');
      
      \$1400_T\ <= (others => '0');
      
      \rdy_$13931226\ <= (others => '0');
      
      \rdy_$13930178\ <= (others => '0');
      
      \rdy_$13531207\ <= (others => '0');
      
      rdy247 <= (others => '0');
      
      \rdy_$13610198\ <= (others => '0');
      
      \$1373_T\ <= (others => '0');
      
      \$1401_T\ <= (others => '0');
      
      go209 <= (others => '0');
      
      \rdy_$13911266\ <= (others => '0');
      
      \$1363_T\ <= (others => '0');
      
      \$1317_sb\ <= (others => '0');
      
      \rdy_$13831255\ <= (others => '0');
      
      \$1397_T\ <= (others => '0');
      
      \$1402_T\ <= (others => '0');
      
      \$1386_T\ <= (others => '0');
      
      \rdy_$13830249\ <= (others => '0');
      
      \$1315_sa\ <= (others => '0');
      
      rdy199 <= (others => '0');
      
      rdy277 <= (others => '0');
      \result_$13611\ := \result_$13611%now\;
      \result_$13830\ := \result_$13830%now\;
      \result_$13910\ := \result_$13910%now\;
      \result_$13831\ := \result_$13831%now\;
      \result_$13911\ := \result_$13911%now\;
      \result_$13531\ := \result_$13531%now\;
      \result_$13610\ := \result_$13610%now\;
      \result_$13530\ := \result_$13530%now\;
      \state_$v170\ := \state_$v170%now\;
      \state_$13530\ := \state_$13530%now\;
      \state_$13531\ := \state_$13531%now\;
      \state_$1354inner\ := \state_$1354inner%now\;
      \state_$13610\ := \state_$13610%now\;
      \state_$13611\ := \state_$13611%now\;
      \state_$13930\ := \state_$13930%now\;
      \state_$13830\ := \state_$13830%now\;
      \state_$13831\ := \state_$13831%now\;
      \state_$1384inner\ := \state_$1384inner%now\;
      \state_$13910\ := \state_$13910%now\;
      \state_$13911\ := \state_$13911%now\;
      \state_$13931\ := \state_$13931%now\;
      state_id176 := \state_id176%now\;
      \state_$v171\ := \state_$v171%now\;
       -- case \state_$v170\ is when IDLE276 =>
       -- case \state_$v171\ is when \IDLE_$V171\ =>
      \$1394_argument\ := argument;
      \$1311_a\ := ""&\$1394_argument\(0);
      \$1312_b\ := ""&\$1394_argument\(1);
      \$1313_c\ := ""&\$1394_argument\(2);
      \$1314_r\ := ""&\$1394_argument\(3);
      \$1315_sa\ <= \$1311_a\;
      \$1317_sb\ <= \$1312_b\;
      \$1319_sc\ <= \$1313_c\;
      \$1321_sr\ <= \$1314_r\;
      case state_id176 is
      when \$1393\ =>
        case \state_$13930\ is
        when \$1361\ =>
          case \state_$13610\ is
          when \$1354\ =>
            \$v217\ := \$1321_sr\;
            if \$v217\(0) = '1' then
              
            else
              case \state_$1354inner\ is
              when \$1339\ =>
                z200 := work.values.val_unit;
                \state_$1354inner\ := \$1339\;
              when \$1353\ =>
                case \state_$13530\ is
                when \$1346\ =>
                  \$1345\ := \$1315_sa\;
                  \$v205\ := \$1345\;
                  if \$v205\(0) = '1' then
                    \$1343_T\ <= work.Values.val_true;
                  else
                    \result_$13530\ := work.values.val_unit;
                    go203 <= work.Values.val_true;
                  end if;
                when \IDLE_$13530\ =>
                  \rdy_$13530201\ <= work.Values.val_true;
                end case;
                
                case \state_$13531\ is
                when \$1351\ =>
                  \$1350\ := \$1317_sb\;
                  \$v211\ := \$1350\;
                  if \$v211\(0) = '1' then
                    \$1348_T\ <= work.Values.val_true;
                  else
                    \result_$13531\ := work.values.val_unit;
                    go209 <= work.Values.val_true;
                  end if;
                when \IDLE_$13531\ =>
                  \rdy_$13531207\ <= work.Values.val_true;
                end case;
                
              when \$V214\ =>
                
              end case;
              
            end if;
          when \IDLE_$13610\ =>
            \rdy_$13610198\ <= work.Values.val_true;
          end case;
          
          case \state_$13611\ is
          when \$1359\ =>
            \$1358\ := \$1321_sr\;
            \$v222\ := \$1358\;
            if \$v222\(0) = '1' then
              \$1356_T\ <= work.Values.val_true;
            else
              \$1355\ := work.values.val_unit;
              go220 <= work.Values.val_true;
            end if;
          when \IDLE_$13611\ =>
            \rdy_$13611218\ <= work.Values.val_true;
          end case;
          
        when \IDLE_$13930\ =>
          \rdy_$13930178\ <= work.Values.val_true;
        end case;
        
        case \state_$13931\ is
        when \$1391\ =>
          case \state_$13910\ is
          when \$1384\ =>
            \$v265\ := \$1321_sr\;
            if \$v265\(0) = '1' then
              
            else
              case \state_$1384inner\ is
              when \$1369\ =>
                z248 := work.values.val_unit;
                \state_$1384inner\ := \$1369\;
              when \$1383\ =>
                case \state_$13830\ is
                when \$1376\ =>
                  \$1375\ := \$1329_t\;
                  \$v253\ := \$1375\;
                  if \$v253\(0) = '1' then
                    \$1373_T\ <= work.Values.val_true;
                  else
                    \result_$13830\ := work.values.val_unit;
                    go251 <= work.Values.val_true;
                  end if;
                when \IDLE_$13830\ =>
                  \rdy_$13830249\ <= work.Values.val_true;
                end case;
                
                case \state_$13831\ is
                when \$1381\ =>
                  \$1380\ := \$1319_sc\;
                  \$v259\ := \$1380\;
                  if \$v259\(0) = '1' then
                    \$1378_T\ <= work.Values.val_true;
                  else
                    \result_$13831\ := work.values.val_unit;
                    go257 <= work.Values.val_true;
                  end if;
                when \IDLE_$13831\ =>
                  \rdy_$13831255\ <= work.Values.val_true;
                end case;
                
              when \$V262\ =>
                
              end case;
              
            end if;
          when \IDLE_$13910\ =>
            \rdy_$13910246\ <= work.Values.val_true;
          end case;
          
          case \state_$13911\ is
          when \$1389\ =>
            \$1388\ := \$1321_sr\;
            \$v270\ := \$1388\;
            if \$v270\(0) = '1' then
              \$1386_T\ <= work.Values.val_true;
            else
              \$1385\ := work.values.val_unit;
              go268 <= work.Values.val_true;
            end if;
          when \IDLE_$13911\ =>
            \rdy_$13911266\ <= work.Values.val_true;
          end case;
          
        when \IDLE_$13931\ =>
          \rdy_$13931226\ <= work.Values.val_true;
        end case;
        
      when IDLE_ID176 =>
        \$1344\ := work.values.val_unit;
        \state_$13530\ := \$1346\;
        \$1349\ := work.values.val_unit;
        \state_$13531\ := \$1351\;
        \$1357\ := work.values.val_unit;
        \state_$13611\ := \$1359\;
        \$1374\ := work.values.val_unit;
        \state_$13830\ := \$1376\;
        \$1379\ := work.values.val_unit;
        \state_$13831\ := \$1381\;
        \$1387\ := work.values.val_unit;
        \state_$13911\ := \$1389\;
      end case;
      
      \$v204\ := go203;
      if \$v204\(0) = '1' then
        z202 := work.values.val_unit;
        \state_$13530\ := \$1346\;
      end if;
      \$v206\ := \$1343_T\;
      if \$v206\(0) = '1' then
        \rdy_$13530201\ <= work.Values.val_true;
        \state_$13530\ := \IDLE_$13530\;
      end if;
      \$v210\ := go209;
      if \$v210\(0) = '1' then
        z208 := work.values.val_unit;
        \state_$13531\ := \$1351\;
      end if;
      \$v212\ := \$1348_T\;
      if \$v212\(0) = '1' then
        \rdy_$13531207\ <= work.Values.val_true;
        \state_$13531\ := \IDLE_$13531\;
      end if;
      \$v213\ := work.Bool.land(\rdy_$13530201\, \rdy_$13531207\);
      if \$v213\(0) = '1' then
        \$1340\ := \result_$13530\ & \result_$13531\;
        \$1341\ := ""&\$1340\(0);
        \$1342\ := ""&\$1340\(1);
        \$1329_t\ <= work.Values.val_true;
        \$1337\ := work.values.val_unit;
        \state_$1354inner\ := \$1339\;
      else
        \state_$1354inner\ := \$1353\;
      end if;
      \$v216\ := rdy199;
      if \$v216\(0) = '1' then
        \$1333_T\ <= work.Values.val_true;
      else
        \state_$13610\ := \$1354\;
      end if;
      \$v221\ := go220;
      if \$v221\(0) = '1' then
        z219 := work.values.val_unit;
        \state_$13611\ := \$1359\;
      end if;
      \$v223\ := \$1356_T\;
      if \$v223\(0) = '1' then
        \$1333_T\ <= work.Values.val_true;
      end if;
      \$v224\ := work.Bool.land(\rdy_$13610198\, \rdy_$13611218\);
      if \$v224\(0) = '1' then
        \$1334\ := \result_$13610\ & \result_$13611\;
        \$1335\ := \$1334\(0 to 1);
        \$1336\ := ""&\$1334\(2);
        \result_$13930\ := work.values.val_unit;
        \$1333_T\ <= work.Values.val_true;
      else
        \state_$13930\ := \$1361\;
      end if;
      \$v225\ := \$1333_T\;
      if \$v225\(0) = '1' then
        \result_$13530\ := work.values.val_unit;
        \state_$13530\ := \$1346\;
        \result_$13531\ := work.values.val_unit;
        \state_$13531\ := \$1351\;
        \result_$13611\ := work.values.val_unit;
        \state_$13611\ := \$1359\;
      end if;
      \$v184\ := \$1396_T\;
      if \$v184\(0) = '1' then
        \rdy_$13530182\ <= work.Values.val_true;
        \state_$13530\ := \IDLE_$13530\;
      end if;
      \$v187\ := \$1397_T\;
      if \$v187\(0) = '1' then
        \rdy_$13531185\ <= work.Values.val_true;
        \state_$13531\ := \IDLE_$13531\;
      end if;
      \$v188\ := work.Bool.land(\rdy_$13530182\, \rdy_$13531185\);
      if \$v188\(0) = '1' then
        \result_$13610\ := \result_$13530\ & \result_$13531\;
        rdy181 <= work.Values.val_true;
      else
        \state_$1354inner\ := \$1353\;
      end if;
      \$v191\ := rdy181;
      if \$v191\(0) = '1' then
        \rdy_$13610180\ <= work.Values.val_true;
        \state_$13610\ := \IDLE_$13610\;
      else
        \state_$13610\ := \$1354\;
      end if;
      \$v195\ := \$1398_T\;
      if \$v195\(0) = '1' then
        \rdy_$13611193\ <= work.Values.val_true;
        \state_$13611\ := \IDLE_$13611\;
      end if;
      \$v196\ := work.Bool.land(\rdy_$13610180\, \rdy_$13611193\);
      if \$v196\(0) = '1' then
        z179 := \result_$13610\ & \result_$13611\;
        \$1395_T\ <= work.Values.val_true;
      else
        \state_$13930\ := \$1361\;
      end if;
      \$v197\ := \$1395_T\;
      if \$v197\(0) = '1' then
        
      end if;
      \$v252\ := go251;
      if \$v252\(0) = '1' then
        z250 := work.values.val_unit;
        \state_$13830\ := \$1376\;
      end if;
      \$v254\ := \$1373_T\;
      if \$v254\(0) = '1' then
        \rdy_$13830249\ <= work.Values.val_true;
        \state_$13830\ := \IDLE_$13830\;
      end if;
      \$v258\ := go257;
      if \$v258\(0) = '1' then
        z256 := work.values.val_unit;
        \state_$13831\ := \$1381\;
      end if;
      \$v260\ := \$1378_T\;
      if \$v260\(0) = '1' then
        \rdy_$13831255\ <= work.Values.val_true;
        \state_$13831\ := \IDLE_$13831\;
      end if;
      \$v261\ := work.Bool.land(\rdy_$13830249\, \rdy_$13831255\);
      if \$v261\(0) = '1' then
        \$1370\ := \result_$13830\ & \result_$13831\;
        \$1371\ := ""&\$1370\(0);
        \$1372\ := ""&\$1370\(1);
        \$1323_so\ <= work.Values.val_true;
        \$1367\ := work.values.val_unit;
        \state_$1384inner\ := \$1369\;
      else
        \state_$1384inner\ := \$1383\;
      end if;
      \$v264\ := rdy247;
      if \$v264\(0) = '1' then
        \$1363_T\ <= work.Values.val_true;
      else
        \state_$13910\ := \$1384\;
      end if;
      \$v269\ := go268;
      if \$v269\(0) = '1' then
        z267 := work.values.val_unit;
        \state_$13911\ := \$1389\;
      end if;
      \$v271\ := \$1386_T\;
      if \$v271\(0) = '1' then
        \$1363_T\ <= work.Values.val_true;
      end if;
      \$v272\ := work.Bool.land(\rdy_$13910246\, \rdy_$13911266\);
      if \$v272\(0) = '1' then
        \$1364\ := \result_$13910\ & \result_$13911\;
        \$1365\ := \$1364\(0 to 1);
        \$1366\ := ""&\$1364\(2);
        \result_$13931\ := work.values.val_unit;
        \$1363_T\ <= work.Values.val_true;
      else
        \state_$13931\ := \$1391\;
      end if;
      \$v273\ := \$1363_T\;
      if \$v273\(0) = '1' then
        \result_$13830\ := work.values.val_unit;
        \state_$13830\ := \$1376\;
        \result_$13831\ := work.values.val_unit;
        \state_$13831\ := \$1381\;
        \result_$13911\ := work.values.val_unit;
        \state_$13911\ := \$1389\;
      end if;
      \$v232\ := \$1400_T\;
      if \$v232\(0) = '1' then
        \rdy_$13830230\ <= work.Values.val_true;
        \state_$13830\ := \IDLE_$13830\;
      end if;
      \$v235\ := \$1401_T\;
      if \$v235\(0) = '1' then
        \rdy_$13831233\ <= work.Values.val_true;
        \state_$13831\ := \IDLE_$13831\;
      end if;
      \$v236\ := work.Bool.land(\rdy_$13830230\, \rdy_$13831233\);
      if \$v236\(0) = '1' then
        \result_$13910\ := \result_$13830\ & \result_$13831\;
        rdy229 <= work.Values.val_true;
      else
        \state_$1384inner\ := \$1383\;
      end if;
      \$v239\ := rdy229;
      if \$v239\(0) = '1' then
        \rdy_$13910228\ <= work.Values.val_true;
        \state_$13910\ := \IDLE_$13910\;
      else
        \state_$13910\ := \$1384\;
      end if;
      \$v243\ := \$1402_T\;
      if \$v243\(0) = '1' then
        \rdy_$13911241\ <= work.Values.val_true;
        \state_$13911\ := \IDLE_$13911\;
      end if;
      \$v244\ := work.Bool.land(\rdy_$13910228\, \rdy_$13911241\);
      if \$v244\(0) = '1' then
        z227 := \result_$13910\ & \result_$13911\;
        \$1399_T\ <= work.Values.val_true;
      else
        \state_$13931\ := \$1391\;
      end if;
      \$v245\ := \$1399_T\;
      if \$v245\(0) = '1' then
        
      end if;
      \$v274\ := work.Bool.land(\rdy_$13930178\, \rdy_$13931226\);
      if \$v274\(0) = '1' then
        \$1330\ := \result_$13930\ & \result_$13931\;
        \$1331\ := ""&\$1330\(0);
        \$1332\ := ""&\$1330\(1);
        result_id176 := work.values.val_unit;
        rdy_id176177 <= work.Values.val_true;
        state_id176 := IDLE_ID176;
      else
        state_id176 := \$1393\;
      end if;
      \$v275\ := rdy_id176177;
      if \$v275\(0) = '1' then
        \$1324_w\ := result_id176 & rdy_id176177;
      else
        \$1324_w\ := work.values.val_unit & rdy_id176177;
      end if;
      \$1325\ := \$1323_so\;
      \$v175\ := \$1325\;
      if \$v175\(0) = '1' then
        \$1326\ := "00000000000000000000000000000001";
        go173 <= work.Values.val_true;
      else
        \$1326\ := "00000000000000000000000000000000";
        go173 <= work.Values.val_true;
      end if;
      -- end case;
      
      \$v174\ := go173;
      if \$v174\(0) = '1' then
        \$1327\ := work.Int.print(clk,\$1326\);
        \$1328\ := work.Print.print_string(clk,work.Util.of_string(";"));
        \result_$v170\ := \$1323_so\;
        \rdy_$v171172\ <= work.Values.val_true;
        \state_$v171\ := \IDLE_$V171\;
      end if;
      -- end case;
      \state_$v170%next\ <= \state_$v170\;
      \state_$13530%next\ <= \state_$13530\;
      \state_$13531%next\ <= \state_$13531\;
      \state_$1354inner%next\ <= \state_$1354inner\;
      \state_$13610%next\ <= \state_$13610\;
      \state_$13611%next\ <= \state_$13611\;
      \state_$13930%next\ <= \state_$13930\;
      \state_$13830%next\ <= \state_$13830\;
      \state_$13831%next\ <= \state_$13831\;
      \state_$1384inner%next\ <= \state_$1384inner\;
      \state_$13910%next\ <= \state_$13910\;
      \state_$13911%next\ <= \state_$13911\;
      \state_$13931%next\ <= \state_$13931\;
      \state_id176%next\ <= state_id176;
      \state_$v171%next\ <= \state_$v171\;
      \result_$13611%next\ <= \result_$13611\;
      \result_$13830%next\ <= \result_$13830\;
      \result_$13910%next\ <= \result_$13910\;
      \result_$13831%next\ <= \result_$13831\;
      \result_$13911%next\ <= \result_$13911\;
      \result_$13531%next\ <= \result_$13531\;
      \result_$13610%next\ <= \result_$13610\;
      \result_$13530%next\ <= \result_$13530\;
      
      
      result <= \result_$v170\;
      end process;
      
  end architecture;
