library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    generic (
        reg_width : integer := 32;
        reg_count : integer := 8
    );
    port (
        clk, rst, reg_one_write, reg_two_write, stack_en : in  unsigned                  (0 downto 0);
        ra1, ra2, wa1, wa2                               : in  unsigned                  (2 downto 0);
        wd1, wd2                                         : in  unsigned        (reg_width-1 downto 0);
        write_sp_data                                    : in  unsigned        (reg_width-1 downto 0);   
        write_pc_data                                    : in  std_logic_vector(reg_width-1 downto 0);
        reset_pc_data                                    : in  std_logic_vector(reg_width-1 downto 0);
        rd1, rd2, read_sp_data                           : out unsigned        (reg_width-1 downto 0);
        read_pc_data                                     : out std_logic_vector(reg_width-1 downto 0)
    );
end entity regfile;

architecture ArchRegFile of regFile is
    type reg_array is array (0 to REG_COUNT-1) of unsigned   (REG_WIDTH-1 downto 0);
    signal reg_file : reg_array                              := (others => (others => '0'));
    signal pc       : std_logic_vector(REG_WIDTH-1 downto 0) :=             (others => '0');
    signal sp       : unsigned(REG_WIDTH-1 downto 0)         :=             (others => '0');

begin
    rd1 <= reg_file(to_integer(unsigned(ra1)));
    rd2 <= reg_file(to_integer(unsigned(ra2)));
    read_pc_data <= pc;
    read_sp_data <= sp;

    process (clk) is
    begin
        if (clk'event and clk = "0") then
            if (rst = "1") then
                sp <= to_unsigned(4095, sp'length);
                reg_file <= (others => (others => '0'));
            end if;
            if (reg_one_write = "1" and rst = "0") then
                reg_file(to_integer(unsigned(wa1))) <= wd1;
            end if;
            if (reg_two_write = "1" and rst = "0") then
                reg_file(to_integer(unsigned(wa2))) <= wd2;
            end if;
            if (stack_en = "1" and rst = "0") then
                sp <= write_sp_data;
            end if;
        end if;
        if (clk'event and clk = "1") then
            if (rst = "1") then
                pc <= reset_pc_data;
            else
                pc <= write_pc_data;
            end if;
        end if;
    end process;
end architecture ArchRegFile;