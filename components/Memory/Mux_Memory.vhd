LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUXTOMEMORY IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        STACK_EN, PUSH_POP : IN unsigned(0 downto 0);
        SP : IN unsigned(31 DOWNTO 0); -- Stack Pointer
        EA : IN unsigned(ADDRESS_BITS - 1 DOWNTO 0); -- Effective Address
        
        ADDRESS_MEM_IN : OUT unsigned(ADDRESS_BITS - 1 DOWNTO 0)
    );
END ENTITY MUXTOMEMORY;

ARCHITECTURE ARCHMUXTOMEMORY OF MUXTOMEMORY IS
BEGIN
PROCESS (PUSH_POP, STACK_EN, SP, EA)
    variable SP_int : unsigned (31 DOWNTO 0); -- Internal signal for arithmetic operations
    BEGIN
        SP_int := (SP - 1) when PUSH_POP = "1" else (SP + 1);
        ADDRESS_MEM_IN <= SP_int(ADDRESS_BITS - 1 DOWNTO 0) when STACK_EN = "1" else EA;
    END PROCESS;
END ARCHMUXTOMEMORY;