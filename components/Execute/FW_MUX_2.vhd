LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FW_MUX_2 IS
    PORT (
        -- IN PORT
        in_port_ex_mem : IN unsigned (31 DOWNTO 0);
        in_port_mem_wb : IN unsigned (31 DOWNTO 0);
        -- inputs from D/EX
        alu_src_2_d : IN unsigned (31 DOWNTO 0);
        -- inputs from EX/MEM
        alu_out_ex, alu_src_2_ex : IN unsigned (31 DOWNTO 0);
        -- inputs from MEM/WB
        alu_out_mem, alu_src_2_mem, mem_out : IN unsigned (31 DOWNTO 0);
        -- inputs from FU
        alu_src_2_sel : IN unsigned (2 DOWNTO 0);
        -- ouputs 
        alu_src_2 : OUT unsigned (31 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE archFW_MUX_2 OF FW_MUX_2 IS
BEGIN
    PROCESS (alu_src_2_d, alu_out_ex, alu_src_2_ex, alu_out_mem, alu_src_2_mem, mem_out, alu_src_2_sel)
    BEGIN
        CASE alu_src_2_sel IS
            WHEN "000" => alu_src_2 <= alu_src_2_d;
            WHEN "001" => alu_src_2 <= alu_out_ex;
            WHEN "010" => alu_src_2 <= alu_src_2_ex;
            WHEN "011" => alu_src_2 <= alu_out_mem;
            WHEN "100" => alu_src_2 <= in_port_ex_mem;
            WHEN "110" => alu_src_2 <= in_port_mem_wb;
            WHEN "101" => alu_src_2 <= mem_out;
            WHEN "110" => alu_src_2 <= alu_src_2_mem;
            WHEN OTHERS => alu_src_2 <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END ARCHITECTURE;