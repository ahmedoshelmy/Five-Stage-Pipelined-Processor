LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SP_REG IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        CLK, RESET, INT, STACK_EN, PUSH_POP : IN STD_LOGIC;
        sp_out : OUT unsigned(31 DOWNTO 0)
    );
END ENTITY SP_REG;

ARCHITECTURE Behavioral OF SP_REG IS
    SIGNAL sp_in : unsigned(31 DOWNTO 0);
BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        sp_out <= sp_in;
        IF RESET = '1' THEN -- Asynchronous reset
            sp_in <= to_unsigned((2 ** (ADDRESS_BITS - 1)) - 1, 32);
        ELSIF (falling_edge(CLK) AND STACK_EN = '1') THEN
            -- Synchronous behavior
            sp_in <= (sp_in - 2) WHEN PUSH_POP = '0' ELSE
                (sp_in + 2);
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;