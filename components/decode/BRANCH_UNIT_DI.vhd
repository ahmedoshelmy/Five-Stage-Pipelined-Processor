library ieee;
use ieee.std_logic_1164.all;

entity BRANCH_UNIT_DI is
     port (
           IS_CALL_JMP        : IN std_logic;

           IS_JMP_TKN         : OUT std_logic
    );
end entity;

architecture archBRANCH_UNIT_DI of BRANCH_UNIT_DI is
begin
    process (IS_CALL_JMP)
    begin
        IS_JMP_TKN <= (IS_CALL_JMP);
    end process;
end architecture;
