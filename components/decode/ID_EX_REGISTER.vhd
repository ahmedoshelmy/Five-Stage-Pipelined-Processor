library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_REGISTER is
    port (
        clk, reset, en                                      : in  unsigned (0 downto 0);
        rd1_in, alu_src_2_in                                : in  unsigned(31 downto 0);
        ra1_in, ra2_in                                      : in  unsigned (2 downto 0);
        reg_one_write_in, reg_two_write_in, stack_en_in     : in  unsigned (0 downto 0);
        mem_read_in, mem_write_in, call_jmp_in, ret_in      : in  unsigned (0 downto 0);
        push_pop_in, out_port_en_in                         : in  unsigned (0 downto 0);
        alu_op_in                                           : in  unsigned (3 downto 0);
        wb_src_in                                           : in  unsigned (1 downto 0);        
        rd1_out, alu_src_2_out                              : out unsigned(31 downto 0);
        ra1_out, ra2_out                                    : out unsigned (2 downto 0);
        reg_one_write_out, reg_two_write_out, stack_en_out  : out unsigned (0 downto 0);
        mem_read_out, mem_write_out, call_jmp_out, ret_out  : out unsigned (0 downto 0);
        push_pop_out, out_port_en_out                       : out unsigned (0 downto 0);
        alu_op_out                                          : out unsigned (3 downto 0);
        wb_src_out                                          : out unsigned (1 downto 0)
    );
end entity ID_EX_REGISTER;

architecture ID_EX_REGISTER_ARCHITECTURE of ID_EX_REGISTER is
    signal rd1, alu_src_2 : unsigned(31 downto 0);
    signal ra1, ra2       : unsigned(2 downto 0);
    signal reg_one_write, reg_two_write, stack_en : unsigned(0 downto 0);
    signal mem_read, mem_write, call_jmp, ret : unsigned(0 downto 0);
    signal push_pop, out_port_en : unsigned(0 downto 0);
    signal alu_op : unsigned(3 downto 0);
    signal wb_src : unsigned(1 downto 0);
begin
    rd1_out <= rd1 when en = "1"
    else (others => '0');
    alu_src_2_out <= alu_src_2 when en = "1"
    else (others => '0');
    ra1_out <= ra1 when en = "1"
    else (others => '0');
    ra2_out <= ra2 when en = "1"
    else (others => '0');
    reg_one_write_out <= reg_one_write when en = "1"
    else (others => '0');
    reg_two_write_out <= reg_two_write when en = "1"
    else (others => '0');
    stack_en_out <= stack_en when en = "1"
    else (others => '0');
    mem_read_out <= mem_read when en = "1"
    else (others => '0');
    mem_write_out <= mem_write when en = "1"
    else (others => '0');
    call_jmp_out <= call_jmp when en = "1"
    else (others => '0');
    ret_out <= ret when en = "1"
    else (others => '0');
    push_pop_out <= push_pop when en = "1"
    else (others => '0');
    out_port_en_out <= out_port_en when en = "1"
    else (others => '0');
    alu_op_out <= alu_op when en = "1"
    else (others => '0');
    wb_src_out <= wb_src when en = "1"
    else (others => '0');

    process (clk) is        
    begin
        if (clk'event and clk = "1") then
            if (reset = "1") then
                rd1 <= (others => '0');
                alu_src_2 <= (others => '0');
                ra1 <= (others => '0');
                ra2 <= (others => '0');
                reg_one_write <= (others => '0');
                reg_two_write <= (others => '0');
                stack_en <= (others => '0');
                mem_read <= (others => '0');
                mem_write <= (others => '0');
                call_jmp <= (others => '0');
                ret <= (others => '0');
                push_pop <= (others => '0');
                out_port_en <= (others => '0');
                alu_op <= (others => '0');
                wb_src <= (others => '0');
            elsif (en = "1") then
                rd1 <= rd1_in;
                alu_src_2 <= alu_src_2_in;
                ra1 <= ra1_in;
                ra2 <= ra2_in;
                reg_one_write <= reg_one_write_in;
                reg_two_write <= reg_two_write_in;
                stack_en <= stack_en_in;
                mem_read <= mem_read_in;
                mem_write <= mem_write_in;
                call_jmp <= call_jmp_in;
                ret <= ret_in;
                push_pop <= push_pop_in;
                out_port_en <= out_port_en_in;
                alu_op <= alu_op_in;
                wb_src <= wb_src_in;
            end if;
        end if;        
    end process;
end architecture ID_EX_REGISTER_ARCHITECTURE;