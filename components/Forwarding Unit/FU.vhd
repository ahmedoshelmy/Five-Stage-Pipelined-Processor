LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FU IS
    PORT (
        -- Inputs from D/EX Register
        rsrc1_d_ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rsrc2_d_ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Inputs from EX/MEM Register
        reg_w1_ex_mem : IN STD_LOGIC;
        reg_w2_ex_mem : IN STD_LOGIC;
        rdst1_ex_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        rdst2_ex_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        -- Inputs from MEM/WB Register
        reg_w1_mem_wb : IN STD_LOGIC;
        reg_w2_mem_wb : IN STD_LOGIC;
        rdst1_mem_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        rdst2_mem_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        -- Selectors 
        rsrc1_d_ex_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        rsrc2_d_ex_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );

END ENTITY FU;

--  0 : ALU , 1 : MEM , 2 : Immediate

ARCHITECTURE ArchFU OF FU IS
BEGIN
    -- Forwarding will happen when the sequence is RAW (Read After Write)
    -- 000: input instruction Rsrc == Rdst1 of (previous instruction) 
    -- 001: input instruction Rsrc == Rdst2 of (previous instruction) 
    -- 010: input instruction Rsrc == Rdst1 of (instruction before prev instruction) 
    -- 011: input instruction Rsrc == Rdst2 of (instruction before prev instruction) 
    -- 111: No forwarding
    rsrc1_d_ex_sel <= "000" WHEN ((rsrc1_d_ex = rdst1_ex_mem) AND (reg_w1_ex_mem = '1')) ELSE
        "001" WHEN ((rsrc1_d_ex = rdst2_ex_mem) AND (reg_w2_ex_mem = '1')) ELSE
        "010" WHEN ((rsrc1_d_ex = rdst1_mem_wb) AND (reg_w1_mem_wb = '1')) ELSE
        "011"WHEN ((rsrc1_d_ex = rdst2_mem_wb) AND (reg_w2_mem_wb = '1')) ELSE
        "111"
        ;
    rsrc2_d_ex_sel <= "000" WHEN ((rsrc2_d_ex = rdst1_ex_mem) AND (reg_w1_ex_mem = '1')) ELSE
        "001" WHEN ((rsrc2_d_ex = rdst2_ex_mem) AND (reg_w2_ex_mem = '1')) ELSE
        "010" WHEN ((rsrc2_d_ex = rdst1_mem_wb) AND (reg_w1_mem_wb = '1')) ELSE
        "011"WHEN ((rsrc2_d_ex = rdst2_mem_wb) AND (reg_w2_mem_wb = '1')) ELSE
        "111";

END ARCHITECTURE ArchFU;