library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rs1_rd_mux is
    port (
        rs1, rd   : in  unsigned(2 downto 0);
        rs1_rd    : in  unsigned(0 downto 0);
        ra1       : out unsigned(2 downto 0)
    );
end entity rs1_rd_mux;

architecture arch_mux_rs1_rd of rs1_rd_mux is
begin
    process (rs1, rd, rs1_rd) is
    begin
        case rs1_rd is
            when "0" =>
                ra1 <=             rs1;
            when "1" =>
                ra1 <=              rd;
            when others =>
                ra1 <= (others => 'X');
        end case;
    end process;
end architecture arch_mux_rs1_rd;