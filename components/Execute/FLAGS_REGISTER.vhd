library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FLAGS_REGISTER is
    port (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        WEN : IN STD_LOGIC;

        zeroFlag, negativeFlag, carryFlag : IN STD_LOGIC;
        zeroFlag_REG, negativeFlag_REG, carryFlag_REG : OUT STD_LOGIC
    );
end entity;

architecture archFLAGS_REGISTER of FLAGS_REGISTER is
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            zeroFlag_REG <= '0';
            negativeFlag_REG <= '0';
            carryFlag_REG <= '0';
        elsif RISING_EDGE(CLK) and WEN = '1'   then
                zeroFlag_REG <= zeroFlag;
                negativeFlag_REG <= negativeFlag;
                carryFlag_REG <= carryFlag;
        end if;
    end process;
end architecture;