library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PORTS_REG is
    generic (n : integer := 32);
     port (
            CLK, RESET, WR_EN_IN, WR_EN_OUT  : IN unsigned     (0 Downto 0);
            inPort, outPort               : IN unsigned     (n-1 Downto 0);
            inPortReg, outPortReg         : OUT unsigned     (n-1 Downto 0)
       );
end entity;


architecture archPORTS_REG of PORTS_REG is
begin
    process (CLK, RESET)
    begin
        if (RESET = "1") then
            inPortReg <= (others => '0');
            outPortReg <= (others => '0');
        elsif (CLK = "1" and WR_EN_IN = "1") then
            inPortReg <= inPort;
        elsif (CLK = "1" and WR_EN_OUT = "1") then
            outPortReg <= outPort;
        end if;

    end process;
end architecture;