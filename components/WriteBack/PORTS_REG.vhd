library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PORTS_REG is
    generic (n : integer := 32);
     port (
            CLK, RESET, WR_EN             : IN unsigned     (0 Downto 0);
            outPort                       : IN unsigned     (n-1 Downto 0);
            inPort                        : OUT unsigned     (n-1 Downto 0);
       );
end entity;


architecture archPORTS_REG of PORTS_REG is
    signal inPortReg : unsigned (n-1 Downto 0) := (others => '0');
    signal outPortReg : unsigned (n-1 Downto 0):= (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            inPortReg <= (others => '0');
            outPortReg <= (others => '0');
            outPort <= (others => '0');
        elsif rising_edge(CLK) then
            inPort <= inPortReg;
            if WR_EN = '1' then
                outPortReg <= outPort;
            end if;
        end if;
    end process;
end architecture;