LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUXTOMEMORY IS
    GENERIC (
        RAM_WORD_WIDTH : INTEGER := 16;
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        CLK : IN STD_LOGIC;
        PUSH_POP : IN STD_LOGIC;
        STACK_EN : IN STD_LOGIC;
        SP : IN STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0); -- Stack Pointer
        EA : IN STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0); -- Effective Address
        SP_OUT : OUT STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0);
        ADDRESS_MEM_IN : OUT STD_LOGIC_VECTOR(RAM_WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY MUXTOMEMORY;

ARCHITECTURE ARCHMUXTOMEMORY OF MUXTOMEMORY IS
    SIGNAL SP_int : INTEGER; -- Internal signal for arithmetic operations
BEGIN

    PROCESS (CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF STACK_EN = '1' THEN
                IF PUSH_POP = '1' THEN -- POP
                    SP_int <= TO_INTEGER(unsigned(SP)) + 1;
                    ADDRESS_MEM_IN <= STD_LOGIC_VECTOR(TO_UNSIGNED(SP_int, RAM_WORD_WIDTH));
                    SP_OUT <= STD_LOGIC_VECTOR(TO_UNSIGNED(SP_int, RAM_WORD_WIDTH));
                ELSE
                    SP_OUT <= SP;
                    ADDRESS_MEM_IN <= SP;
                END IF;
            ELSE
                SP_OUT <= SP;
                ADDRESS_MEM_IN <= EA;
            END IF;
        END IF;
    END PROCESS;
END ARCHMUXTOMEMORY;