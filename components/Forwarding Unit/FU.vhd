LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY FU IS
    PORT (
        -- Inputs from D/EX Register
        rsrc1_d_ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rsrc2_d_ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_reg_1 : IN STD_LOGIC;
        read_reg_2 : IN STD_LOGIC;
        -- Inputs from EX/MEM Register
        reg_w1_ex_mem : IN STD_LOGIC;
        reg_w2_ex_mem : IN STD_LOGIC;
        rdst1_ex_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        rdst2_ex_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        wb_src_ex_mem : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- (ALU - MEM - IMM)
        ior_ex_mem : IN STD_LOGIC; -- IO READ SIGNAL
        -- Inputs from MEM/WB Register
        reg_w1_mem_wb : IN STD_LOGIC;
        reg_w2_mem_wb : IN STD_LOGIC;
        ior_mem_wb : IN STD_LOGIC; -- IO READ SIGNAL
        rdst1_mem_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        rdst2_mem_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        wb_src_mem_wb : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

        -- Selectors 
        rsrc1_d_ex_sel : OUT UNSIGNED(2 DOWNTO 0);
        rsrc2_d_ex_sel : OUT UNSIGNED(2 DOWNTO 0)
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
    PROCESS (ALL)
    BEGIN
        
        IF (read_reg_1 = '0') THEN
            rsrc1_d_ex_sel <= "000";
        ELSIF ((rsrc1_d_ex = rdst1_ex_mem) AND (ior_ex_mem = '1') AND (wb_src_ex_mem = "11")) THEN
            rsrc1_d_ex_sel <= "100"; -- IN PORT IN PREV 
        ELSIF ((rsrc1_d_ex = rdst1_ex_mem) AND (reg_w1_ex_mem = '1') AND (wb_src_ex_mem = "01")) THEN
            rsrc1_d_ex_sel <= "001"; -- ALU_OUT
        ELSIF ((rsrc1_d_ex = rdst2_ex_mem) AND (reg_w2_ex_mem = '1')) THEN
            rsrc1_d_ex_sel <= "010"; -- ALU_SRC2_EX_MEM
        ELSIF ((rsrc1_d_ex = rdst1_mem_wb) AND (ior_mem_wb = '1') AND (wb_src_mem_wb = "11")) THEN
            rsrc1_d_ex_sel <= "110"; -- IN PORT IN BEFORE PREV
        ELSIF ((rsrc1_d_ex = rdst1_mem_wb) AND (reg_w1_mem_wb = '1') AND (wb_src_mem_wb = "01")) THEN
            rsrc1_d_ex_sel <= "011"; -- ALU OUT
        ELSIF ((rsrc1_d_ex = rdst1_mem_wb) AND (reg_w1_mem_wb = '1') AND (wb_src_mem_wb = "00")) THEN
            rsrc1_d_ex_sel <= "101"; -- MEM OUT
        ELSIF ((rsrc1_d_ex = rdst2_mem_wb) AND (reg_w2_mem_wb = '1')) THEN
            rsrc1_d_ex_sel <= "111"; -- ALU_SRC2_MEM_WB
        ELSE
            rsrc1_d_ex_sel <= "000";
        END IF;
    END PROCESS;

    PROCESS (ALL)
    BEGIN
        IF (read_reg_2 = '0') THEN
            rsrc2_d_ex_sel <= "000"; -- NO FORWARDING
        ELSIF ((rsrc2_d_ex = rdst1_ex_mem) AND (ior_ex_mem = '1') AND (wb_src_ex_mem = "11")) THEN
            rsrc2_d_ex_sel <= "100"; -- IN PORT IN PREV 
        ELSIF ((rsrc2_d_ex = rdst1_ex_mem) AND (reg_w1_ex_mem = '1') AND (wb_src_ex_mem = "01")) THEN
            rsrc2_d_ex_sel <= "001"; -- ALU_OUT
        ELSIF ((rsrc2_d_ex = rdst2_ex_mem) AND (reg_w2_ex_mem = '1')) THEN
            rsrc2_d_ex_sel <= "010"; -- ALU_SRC2_EX_MEM
        ELSIF ((rsrc2_d_ex = rdst1_mem_wb) AND (ior_mem_wb = '1') AND (wb_src_mem_wb = "11")) THEN
            rsrc2_d_ex_sel <= "110"; -- IN PORT IN BEFORE PREV
        ELSIF ((rsrc2_d_ex = rdst1_mem_wb) AND (reg_w1_mem_wb = '1') AND (wb_src_mem_wb = "01")) THEN
            rsrc2_d_ex_sel <= "011"; -- ALU OUT
        ELSIF ((rsrc2_d_ex = rdst1_mem_wb) AND (reg_w1_mem_wb = '1') AND (wb_src_mem_wb = "00")) THEN
            rsrc2_d_ex_sel <= "101"; -- MEM OUT
        ELSIF ((rsrc2_d_ex = rdst2_mem_wb) AND (reg_w2_mem_wb = '1')) THEN
            rsrc2_d_ex_sel <= "111"; -- ALU_SRC2_MEM_WB
        ELSE
            rsrc2_d_ex_sel <= "000";
        END IF;
    END PROCESS;

END ARCHITECTURE ArchFU;