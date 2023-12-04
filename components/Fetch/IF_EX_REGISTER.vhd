LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY IF_EX_REGISTER IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;

        INSTRUCTION : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMM_EN : IN STD_LOGIC;
        ENABLE : IN STD_LOGIC;
        
        INSTRUCTION_IF_EX : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_IF_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    );
END ENTITY IF_EX_REGISTER;

ARCHITECTURE Behavioral OF IF_EX_REGISTER IS

BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            -- Asynchronous reset
            INSTRUCTION_IF_EX <= (OTHERS => '0');
            PC_IF_EX <= (OTHERS => '0');
        ELSIF RISING_EDGE(CLK) THEN
            -- Synchronous behavior
            IF ENABLE = '1' THEN
                IF IMM_EN = '1' THEN
                INSTRUCTION_IF_EX <= (OTHERS => '0');
                ELSE
                INSTRUCTION_IF_EX <= INSTRUCTION;
                END IF;
                PC_IF_EX <= PC;
            -- ELSE
            --     INSTRUCTION_IF_EX <= (OTHERS => '0');
            --     PC_IF_EX <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;