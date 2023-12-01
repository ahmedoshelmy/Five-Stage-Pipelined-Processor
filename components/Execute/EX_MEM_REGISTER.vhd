LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY EX_MEM_REGISTER IS
generic (
    regWidth : integer := 32;
    regAddrWidth : integer := 3
);
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;

        ALU_OUT : IN STD_LOGIC_VECTOR(regWidth-1 DOWNTO 0);
        ALU_SRC_2 : IN STD_LOGIC_VECTOR(regWidth-1 DOWNTO 0);

        REG_ADDR1 : IN STD_LOGIC_VECTOR(regAddrWidth-1 DOWNTO 0); 
        REG_ADDR2 : IN STD_LOGIC_VECTOR(regAddrWidth-1 DOWNTO 0); 
        -- control signals
        REG_WRITE_1, REG_WRITE_2 : IN STD_LOGIC;
        STACK_EN, MEMR, MEMW : IN STD_LOGIC;
        PUSH_POP_SEL : IN STD_LOGIC;
        OUTPORT_EN : IN STD_LOGIC;
        WB_SRC : IN STD_LOGIC_VECTOR(1 DOWNTO 0);



        ALU_OUT_REG : OUT STD_LOGIC_VECTOR(regWidth-1 DOWNTO 0);
        ALU_SRC_2_REG : OUT STD_LOGIC_VECTOR(regWidth-1 DOWNTO 0);

        REG_ADDR1_REG : OUT STD_LOGIC_VECTOR(regAddrWidth-1 DOWNTO 0); 
        REG_ADDR2_REG : OUT STD_LOGIC_VECTOR(regAddrWidth-1 DOWNTO 0); 
        -- control signals
        REG_WRITE_1_REG, REG_WRITE_2_REG : OUT STD_LOGIC;
        STACK_EN_REG, MEMR_REG, MEMW_REG : OUT STD_LOGIC;
        PUSH_POP_SEL_REG : OUT STD_LOGIC;
        OUTPORT_EN_REG : OUT STD_LOGIC;
        WB_SRC_REG : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

    );
END ENTITY EX_MEM_REGISTER;

ARCHITECTURE Behavioral OF EX_MEM_REGISTER IS

BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            -- Synchronous reset
            ALU_OUT_REG <= (OTHERS => '0');
            ALU_SRC_2_REG <= (OTHERS => '0');
            REG_ADDR1_REG <= (OTHERS => '0');
            REG_ADDR2_REG <= (OTHERS => '0');
            REG_WRITE_1_REG <= '0';
            REG_WRITE_2_REG <= '0';
            STACK_EN_REG <= '0';
            MEMR_REG <= '0';
            MEMW_REG <= '0';
            PUSH_POP_SEL_REG <= '0';
            OUTPORT_EN_REG <= '0';
            WB_SRC_REG <= (OTHERS => '0');

        ELSIF RISING_EDGE(CLK) THEN
            -- Synchronous behavior
            ALU_OUT_REG <= ALU_OUT;
            ALU_SRC_2_REG <= ALU_SRC_2;
            REG_ADDR1_REG <= REG_ADDR1;
            REG_ADDR2_REG <= REG_ADDR2;
            REG_WRITE_1_REG <= REG_WRITE_1;
            REG_WRITE_2_REG <= REG_WRITE_2;
            STACK_EN_REG <= STACK_EN;
            MEMR_REG <= MEMR;
            MEMW_REG <= MEMW;
            PUSH_POP_SEL_REG <= PUSH_POP_SEL;
            OUTPORT_EN_REG <= OUTPORT_EN;
            WB_SRC_REG <= WB_SRC;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;