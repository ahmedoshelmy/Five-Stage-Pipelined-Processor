library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity hdu is
    port (
        old_dst, cur_ra_one, cur_ra_two                     : in  unsigned(2 downto 0);
        reg_write_one, mem_read, read_reg_one, read_reg_two : in  unsigned(0 downto 0);
        stall                                               : out std_logic
    );
end entity hdu;

architecture ArchHDU of hdu is
begin
    process (old_dst, cur_ra_one, cur_ra_two, reg_write_one, mem_read, read_reg_one, read_reg_two) is
    begin
        if (reg_write_one = "1" and mem_read = "1") then
            if (read_reg_one = "1" and cur_ra_one = old_dst) then
                stall <= '1';
            elsif (read_reg_two = "1" and cur_ra_two = old_dst) then
                stall <= '1';
            else
                stall <= '0';
            end if;
        else
            stall <= '0';
        end if;
    end process;
end architecture ArchHDU;