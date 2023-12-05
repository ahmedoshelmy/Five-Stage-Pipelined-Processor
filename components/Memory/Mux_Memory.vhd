LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUXTOMEMORY IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        PUSH_POP : IN STD_LOGIC;
        STACK_EN : IN STD_LOGIC;
        SP : IN STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0); -- Stack Pointer
        EA : IN STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0); -- Effective Address
        
        ADDRESS_MEM_IN : OUT STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0)
    );
END ENTITY MUXTOMEMORY;

ARCHITECTURE ARCHMUXTOMEMORY OF MUXTOMEMORY IS
BEGIN
PROCESS (PUSH_POP, STACK_EN, SP, EA)
    variable SP_int : unsigned (ADDRESS_BITS - 1 DOWNTO 0); -- Internal signal for arithmetic operations
    BEGIN
        SP_int := (unsigned(SP) - 1) when PUSH_POP = '1' else (unsigned(SP) + 1);
        ADDRESS_MEM_IN <= std_logic_vector(SP_int) when STACK_EN = '1' else EA;
    END PROCESS;
END ARCHMUXTOMEMORY;