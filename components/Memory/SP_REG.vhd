library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY PC_REG IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        CLK, RESET, INT, STACK_EN, PUSH_POP : IN STD_LOGIC;
        sp_in : IN unsigned(ADDRESS_BITS - 1 DOWNTO 0);
        sp_out : OUT unsigned(ADDRESS_BITS - 1 DOWNTO 0)
    );
END ENTITY PC_REG;

ARCHITECTURE Behavioral OF PC_REG IS

BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN -- Asynchronous reset
            sp_out <= to_unsigned((2 ** ADDRESS_BITS) - 1, ADDRESS_BITS);
        ELSIF (RISING_EDGE(CLK) and STACK_EN = '1') THEN
            -- Synchronous behavior
            sp_out <= (sp_in - 2) WHEN PUSH_POP = '1' ELSE (sp_in + 2);
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;