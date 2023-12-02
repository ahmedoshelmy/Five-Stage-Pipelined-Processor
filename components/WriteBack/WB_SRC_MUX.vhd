library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WB_SRC_MUX is
    generic (n : integer := 32);
     port (
            memOut, aluOut, imm, inPort   : IN unsigned     (n-1 Downto 0);
            wbSrc                         : IN unsigned     (1 Downto 0);
            regWriteData                  : OUT unsigned    (n-1 Downto 0)
       );
end entity;


architecture archWB_SRC_MUX of WB_SRC_MUX is
begin
    process (memOut, aluOut, imm, inPort, wbSrc)
    begin
            case wbSrc is
                when "00" => regWriteData <= memOut;
                when "01" => regWriteData <= aluOut;
                when "10" => regWriteData <= imm;
                when "11" => regWriteData <= inPort;
                when others => regWriteData <= (others => '0');
            end case;
    end process;
end architecture;