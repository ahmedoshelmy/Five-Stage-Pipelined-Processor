
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

entity regfile is
    generic (
        reg_width : integer := 32;
        reg_count : integer := 8
    );
    port (
        clk, rst, reg_one_write, reg_two_write : in  unsigned                  (0 downto 0);
        ra1, ra2, wa1, wa2                               : in  unsigned                  (2 downto 0);
        wd1, wd2                                         : in  unsigned        (reg_width-1 downto 0);
        rd1, rd2                           : out unsigned        (reg_width-1 downto 0)
    );
end entity regfile;

architecture ArchRegFile of regFile is
    type reg_array is array (0 to REG_COUNT-1) of unsigned   (REG_WIDTH-1 downto 0);
    signal registers : reg_array  := (others => (others => '0'));
begin
    
    process (clk, rst) 
    begin
        if (rst = "1") then
            -- REMOVE THIS LINE 
            --registers <= (others => (others => '0'));
            registers(0) <= x"00000000";
            registers(1) <= x"00000005";
            registers(2) <= x"00000019";
            registers(3) <= x"0000FFFD";
            registers(4) <= x"0000F320";
            registers(5) <= x"00000005";
            registers(6) <= x"00000000";
            registers(7) <= x"00000000";
        -- sync behaviour of neg edge
        elsif (clk'event and clk = "0") then
            if (reg_one_write = "1") then
                report "Writing to register " & integer'image(to_integer(wa1)) & " with value " & integer'image(to_integer(wd1)) & " at time " & time'image(now);
                registers(to_integer(wa1)) <= wd1;
            end if;
            if (reg_two_write = "1") then
                registers(to_integer(unsigned(wa2))) <= wd2;
            end if;
        end if;
            
    end process;
    rd1 <= registers(to_integer(ra1));
    rd2 <= registers(to_integer(ra2));
end architecture ArchRegFile;
        

        