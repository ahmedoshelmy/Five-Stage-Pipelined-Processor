library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY PC_REG IS
    PORT (
        CLK, RESET, INT, WEN : IN STD_LOGIC;
        RST_val, INT_val, PC_IN : IN unsigned(11 DOWNTO 0);
        PC_OUT : OUT unsigned(11 DOWNTO 0)
    );
END ENTITY PC_REG;

ARCHITECTURE Behavioral OF PC_REG IS

BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN -- Asynchronous reset
            PC_OUT <= RST_val;
        ELSIF (RISING_EDGE(CLK) and WEN = '1') THEN
            -- Synchronous behavior
            IF INT = '0' THEN
                PC_OUT <= PC_IN;
            ELSE
                PC_OUT <= INT_val;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;