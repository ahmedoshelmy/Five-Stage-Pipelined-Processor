LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

entity io is
    generic (
        reg_width : integer := 32
    );
    port (
        inport, data_in : in unsigned(reg_width-1 downto 0);
        outport, data_out : out unsigned(reg_width-1 downto 0);
        ior, iow : in unsigned(0 downto 0);
        clk, reset : in std_logic
    );
end entity io;

architecture archIO of io is
    signal inport_data, outport_data : unsigned(reg_width-1 downto 0);
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            inport_data <= (others => '0');
            outport_data <= (others => '0');
        elsif (clk'event and clk = '0') then
            if (ior = "1") then
                inport_data <= inport;
            end if;
            if (iow = "1") then
                outport_data <= data_in;
            end if;
        end if;
    end process;
    outport <= outport_data;
    data_out <= inport_data;
end architecture archIO;