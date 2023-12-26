library ieee;
use ieee.std_logic_1164.all;

entity BRANCH_UNIT_EX is
     port (
           IS_CALL_JMP        : IN std_logic;
           IS_JZ              : IN std_logic;
           ZERO_FLAG          : IN std_logic;

           IS_JMP_TKN         : OUT std_logic
    );
end entity;

architecture archBRANCH_UNIT_EX of BRANCH_UNIT_EX is
begin
    process (IS_CALL_JMP, IS_JZ, ZERO_FLAG)
    begin
        report "====> JUMP & IS_CALL_JMP: " & to_string(IS_CALL_JMP) & " " & to_string(IS_JZ) & " " & to_string(ZERO_FLAG);
        IS_JMP_TKN <= (IS_CALL_JMP) or (IS_JZ and ZERO_FLAG);
    end process;
end architecture;
