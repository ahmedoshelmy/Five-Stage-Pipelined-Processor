library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rs2_rd_mux is
    port (
        rs2, rd   : in  unsigned(2 downto 0);
        rs2_rd    : in  unsigned(0 downto 0);
        ra2       : out unsigned(2 downto 0)
    );
end entity rs2_rd_mux;

architecture arch_mux_rs2_rd of rs2_rd_mux is
begin
    process (rs2, rd, rs2_rd) is
    begin
        case rs2_rd is
            when "0" =>
                ra2 <=             rs2;
            when "1" =>
                ra2 <=              rd;
            when others =>
                ra2 <= (others => 'X');
        end case;
    end process;
end architecture arch_mux_rs2_rd;