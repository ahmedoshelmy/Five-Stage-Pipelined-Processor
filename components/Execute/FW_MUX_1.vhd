library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FW_MUX_1 is
     port (
            -- inputs from D/EX
            rd1_d_ex                                : IN unsigned     (31 Downto 0);
            -- inputs from EX/MEM
            alu_out_ex, alu_src_2_ex                : IN unsigned     (31 Downto 0);
            -- inputs from MEM/WB
            alu_out_mem, alu_src_2_mem, mem_out     : IN unsigned     (31 Downto 0);
            -- inputs from FU
            alu_src_1_sel                           : IN unsigned     (2 Downto 0);
            -- ouputs 
            alu_src_1                               : OUT unsigned    (31 Downto 0)
       );
end entity;


architecture archFW_MUX_1 of FW_MUX_1 is
begin
    process (rd1_d_ex, alu_out_ex, alu_src_2_ex , alu_out_mem, alu_src_2_mem, mem_out, alu_src_1_sel)
    begin
            case alu_src_1_sel is
                when "000" => alu_src_1 <= rd1_d_ex;
                when "001" => alu_src_1 <= alu_out_ex;
                when "010" => alu_src_1 <= alu_src_2_ex;
                when "011" => alu_src_1 <= alu_out_mem;
                when "101" => alu_src_1 <= mem_out;
                when "110" => alu_src_1 <= alu_src_2_mem;
                when others => alu_src_1 <= (others => '0');
            end case;
    end process;
end architecture;