library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_SRC_MUX is
    generic (n : integer := 32);
     port (
            memOut, aluSrc2, next_pc      : IN unsigned     (n-1 Downto 0);
            FLUSH_MEM, FLUSH_EX           : IN std_logic ;
            PC_OUT                        : OUT unsigned     (n-1 Downto 0)
       );
end entity;


architecture archPC_SRC_MUX of PC_SRC_MUX is
begin
    process (memOut, aluSrc2, next_pc, FLUSH_MEM, FLUSH_EX)
    begin
        
            if FLUSH_MEM = '1' then
                PC_OUT <= memOut;
            elsif FLUSH_EX = '1' then
                PC_OUT <= aluSrc2;
            else
                PC_OUT <= next_pc;
            end if;
    end process;
end architecture;