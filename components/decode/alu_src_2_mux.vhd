library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_src_2_mux is
    port (
        rd2, pc : in unsigned(31 downto 0);
        imm : in unsigned(15 downto 0);
        alu_src : in unsigned(1 downto 0);
        alu_src_2 : out unsigned(31 downto 0)
    );
end entity alu_src_2_mux;

architecture arch_mux of alu_src_2_mux is
begin
    process (alu_src, rd2, imm, pc) is
    begin
        case alu_src is
            when "00" =>
                alu_src_2 <= rd2;
            when "01" =>
                alu_src_2 <= resize(imm, 32);
            when "10" =>
                alu_src_2 <= pc + 1;
            when others =>
                alu_src_2 <= (others => 'X');
        end case;
    end process;
end architecture arch_mux;