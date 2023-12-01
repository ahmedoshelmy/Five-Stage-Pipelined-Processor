library ieee;
use ieee.std_logic_1164.all;

entity BRANCH_UNIT is
     port (
           IS_CALL_JMP        : IN std_logic;
           IS_JZ              : IN std_logic;
           ZERO_FLAG          : IN std_logic;

           IS_JMP_TKN         : OUT std_logic
    );
end entity;

architecture archBRANCH_UNIT of BRANCH_UNIT is
begin
    process (IS_CALL_JMP, IS_JZ, ZERO_FLAG)
    begin
        IS_JMP_TKN <= (IS_CALL_JMP) or (IS_JZ and ZERO_FLAG);
    end process;
end architecture;
