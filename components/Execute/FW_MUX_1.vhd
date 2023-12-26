LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FW_MUX_1 IS
    PORT (
        -- IN PORT
        in_port_ex_mem : IN unsigned (31 DOWNTO 0);
        in_port_mem_wb : IN unsigned (31 DOWNTO 0);

        -- inputs from D/EX
        rd1_d_ex : IN unsigned (31 DOWNTO 0);
        -- inputs from EX/MEM
        alu_out_ex, alu_src_2_ex : IN unsigned (31 DOWNTO 0);
        -- inputs from MEM/WB
        alu_out_mem, alu_src_2_mem, mem_out : IN unsigned (31 DOWNTO 0);
        -- inputs from FU
        alu_src_1_sel : IN unsigned (2 DOWNTO 0);
        -- ouputs 
        alu_src_1 : OUT unsigned (31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE archFW_MUX_1 OF FW_MUX_1 IS
BEGIN
    PROCESS (rd1_d_ex, alu_out_ex, alu_src_2_ex, alu_out_mem, alu_src_2_mem, mem_out, alu_src_1_sel)
    BEGIN
        CASE alu_src_1_sel IS
            WHEN "000" => alu_src_1 <= rd1_d_ex; -- NO FORWARDING 
            WHEN "001" => alu_src_1 <= alu_out_ex; -- ALU OUT  
            WHEN "010" => alu_src_1 <= alu_src_2_ex; --ALU SRC 2 FROM PREV
            WHEN "011" => alu_src_1 <= alu_out_mem; -- ALU OUT MEM WB  
            WHEN "100" => alu_src_1 <= in_port_ex_mem; -- IN PORT DATA FROM PREV  
            WHEN "110" => alu_src_1 <= in_port_mem_wb; -- IN PORT DATA FROM PREV  
            WHEN "101" => alu_src_1 <= mem_out; -- MEM OUT
            WHEN "110" => alu_src_1 <= alu_src_2_mem; -- ALU SRC2 FROM BEFORE PREV
            WHEN OTHERS => alu_src_1 <= (OTHERS => '0'); -- NO 
        END CASE;
    END PROCESS;
END ARCHITECTURE;