library ieee;
use ieee.std_logic_1164.all;

entity BRANCH_UNIT_MEM is
     port (
           IS_RET_RTI          : IN std_logic;

           IS_JMP_TKN         : OUT std_logic
    );
end entity;

architecture archBRANCH_UNIT_MEM of BRANCH_UNIT_MEM is
begin
    process ( IS_RET_RTI)
    begin
        IS_JMP_TKN <=  IS_RET_RTI;
    end process;
end architecture;
