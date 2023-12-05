library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FW_MUX_2 is
     port (
            -- inputs from D/EX
            alu_src_2_d                             : IN unsigned     (31 Downto 0);
            -- inputs from EX/MEM
            alu_out_ex, alu_src_2_ex                : IN unsigned     (31 Downto 0);
            -- inputs from MEM/WB
            alu_out_mem, alu_src_2_mem, mem_out     : IN unsigned     (31 Downto 0);
            -- inputs from FU
            alu_src_2_sel                           : IN unsigned     (2 Downto 0);
            -- ouputs 
            alu_src_2                               : OUT unsigned    (31 Downto 0)
       );
end entity;


architecture archFW_MUX_2 of FW_MUX_2 is
begin
    process (alu_src_2_d, alu_out_ex, alu_src_2_ex , alu_out_mem, alu_src_2_mem, mem_out, alu_src_2_sel)
    begin
            case alu_src_2_sel is
                when "000" => alu_src_2 <= alu_src_2_d;
                when "001" => alu_src_2 <= alu_out_ex;
                when "010" => alu_src_2 <= alu_src_2_ex;
                when "011" => alu_src_2 <= alu_out_mem;
                when "101" => alu_src_2 <= mem_out;
                when "110" => alu_src_2 <= alu_src_2_mem;
                when others => alu_src_2 <= (others => '0');
            end case;
    end process;
end architecture;