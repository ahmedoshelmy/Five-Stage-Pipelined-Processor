LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY IF_ID_REGISTER IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        INT : IN STD_LOGIC;
        imm_en : IN STD_LOGIC;

        INSTRUCTION : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ENABLE : IN STD_LOGIC;
        
        int_if_id : OUT STD_LOGIC;
        INSTRUCTION_IF_EX : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_IF_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY IF_ID_REGISTER;

ARCHITECTURE Behavioral OF IF_ID_REGISTER IS

BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            -- Asynchronous reset
            INSTRUCTION_IF_EX <= (OTHERS => '0');
            PC_IF_EX <= (OTHERS => '0');
        ELSIF RISING_EDGE(CLK) and ENABLE = '1'  THEN
            -- Synchronous behavior
                IF imm_en = '1' THEN
                    INSTRUCTION_IF_EX <= x"0000";
                    PC_IF_EX <= x"00000000";
                ELSIF INT = '1' THEN
                    INSTRUCTION_IF_EX <= x"F000"; -- Interrupt opcode
                    PC_IF_EX <= PC;
                    int_if_id <= '1';
                ELSE
                    INSTRUCTION_IF_EX <= INSTRUCTION;
                    PC_IF_EX <= PC;
                    int_if_id <= '0';
                END IF;
            -- ELSE
            --     INSTRUCTION_IF_EX <= (OTHERS => '0');
            --     PC_IF_EX <= (OTHERS => '0');
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;