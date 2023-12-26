library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
    port (
        instruction    : in  unsigned(6 downto 0);
        reg_one_write  : out unsigned(0 downto 0);
        reg_two_write  : out unsigned(0 downto 0);
        rs1_rd, rs2_rd : out unsigned(0 downto 0);
        alu_src        : out unsigned(1 downto 0);
        out_port_en    : out unsigned(0 downto 0);
        ior, iow       : out unsigned(0 downto 0);
        one_two_op     : out unsigned(0 downto 0);
        alu_op         : out unsigned(3 downto 0);
        wb_src         : out unsigned(1 downto 0);
        imm_en         : out unsigned(0 downto 0);
        stack_en       : out unsigned(0 downto 0);
        mem_read       : out unsigned(0 downto 0);
        mem_write      : out unsigned(0 downto 0);
        mem_free       : out unsigned(0 downto 0);
        mem_protect    : out unsigned(0 downto 0);
        push_pop       : out unsigned(0 downto 0);
        call_jmp       : out unsigned(0 downto 0);
        ret            : out unsigned(0 downto 0);
        read_reg_one   : out unsigned(0 downto 0);
        read_reg_two   : out unsigned(0 downto 0)
    );
end entity CU;

architecture ArchCU of CU is
    ---------------- instruction bits start ---------------------
    -- nop
    constant nop_bits       : unsigned(6 downto 0) := "0000000";
    -- alu one operand
    constant not_bits       : unsigned(6 downto 0) := "0010001";
    constant neg_bits       : unsigned(6 downto 0) := "0010010";
    constant inc_bits       : unsigned(6 downto 0) := "0010011";
    constant dec_bits       : unsigned(6 downto 0) := "0010100";
    -- alu two operand
    constant add_bits       : unsigned(6 downto 0) := "0011001";
    constant sub_bits       : unsigned(6 downto 0) := "0011010";
    constant and_bits       : unsigned(6 downto 0) := "0011011";
    constant or_bits        : unsigned(6 downto 0) := "0011100";
    constant xor_bits       : unsigned(6 downto 0) := "0011101";
    constant swap_bits      : unsigned(6 downto 0) := "0011110";
    constant cmp_bits       : unsigned(6 downto 0) := "0011111";
    -- immediate
    constant addi_bits      : unsigned(6 downto 0) := "0100001";
    constant bitset_bits    : unsigned(6 downto 0) := "0100010";
    constant rcl_bits       : unsigned(6 downto 0) := "0100100";
    constant rcr_bits       : unsigned(6 downto 0) := "0100101";
    constant ldm_bits       : unsigned(6 downto 0) := "0101000";
    -- conditional jump
    constant jz_bits        : unsigned(6 downto 0) := "0110000";
    -- unconditional jump
    constant jmp_bits       : unsigned(6 downto 0) := "1001000";
    constant call_bits      : unsigned(6 downto 0) := "1000100";
    constant ret_bits       : unsigned(6 downto 0) := "1000010";
    constant rti_bits       : unsigned(6 downto 0) := "1000001";
    -- data operations
    constant ldd_bits       : unsigned(6 downto 0) := "1011100";
    constant std_bits       : unsigned(6 downto 0) := "1010100";
    constant pop_bits       : unsigned(6 downto 0) := "1011010";
    constant push_bits      : unsigned(6 downto 0) := "1010010";
    constant in_bits        : unsigned(6 downto 0) := "1011001";
    constant out_bits       : unsigned(6 downto 0) := "1010001";
    -- memory security
    constant free_bits      : unsigned(6 downto 0) := "1101000";
    constant protect_bits   : unsigned(6 downto 0) := "1100000";
    -- input signals
    constant reset_bits     : unsigned(6 downto 0) := "1111000";
    constant interrupt_bits : unsigned(6 downto 0) := "1110000";
    ---------------- instruction bits end ---------------------

    ---------------- alu functions start ---------------------
    -- no operands operations
    constant alu_nop        : unsigned(3 Downto 0) := x"0";
    -- one operands operations
    constant alu_not        : unsigned(3 Downto 0) := x"1";
    constant alu_neg        : unsigned(3 Downto 0) := x"2";
    constant alu_inc        : unsigned(3 Downto 0) := x"3";
    constant alu_dec        : unsigned(3 Downto 0) := x"4";
    -- play with one operand
    constant alu_bitset     : unsigned(3 Downto 0) := x"5";
    constant alu_rcl        : unsigned(3 Downto 0) := x"6";
    constant alu_rcr        : unsigned(3 Downto 0) := x"7";
    -- two operands operations
    constant alu_add        : unsigned(3 Downto 0) := x"9";
    constant alu_sub        : unsigned(3 Downto 0) := x"A"; -- aluIn1 - aluIn2
    constant alu_and        : unsigned(3 Downto 0) := x"B";
    constant alu_or         : unsigned(3 Downto 0) := x"C";
    constant alu_xor        : unsigned(3 Downto 0) := x"D";
    -- buffers
    constant alu_buff1      : unsigned(3 Downto 0) := x"E"; -- same as SWAP => output = aluIn1
    constant alu_buff2      : unsigned(3 Downto 0) := x"F";
    ---------------- alu functions end ---------------------

    ---------------- constants start ---------------------
    constant rd             : unsigned(0 downto 0) := "1";
    constant rs             : unsigned(0 downto 0) := "0";
    constant one_op         : unsigned(0 downto 0) := "0";
    constant two_op         : unsigned(0 downto 0) := "1";
    -- wb src
    constant mem_out        : unsigned(1 downto 0) := "00";
    constant alu_out        : unsigned(1 downto 0) := "01";
    constant immediate      : unsigned(1 downto 0) := "10";
    constant inport_out     : unsigned(1 downto 0) := "11";
    -- wb src
    constant reg            : unsigned(1 downto 0) := "00";
    constant imm            : unsigned(1 downto 0) := "01";
    constant pc_plus_one    : unsigned(1 downto 0) := "10";
    constant push           : unsigned(0 downto 0) := "0";
    constant pop            : unsigned(0 downto 0) := "1";
    constant call           : unsigned(0 downto 0) := "0";
    constant jmp            : unsigned(0 downto 0) := "1";
    ---------------- constants end ---------------------
begin
    process (instruction) is
    begin
        reg_one_write <= "0";
        reg_two_write <= "0";
        rs1_rd        <= rs;
        rs2_rd        <= rs;
        alu_src       <= reg;
        out_port_en   <= "0";
        ior           <= "0";
        iow           <= "0";
        one_two_op    <= one_op;
        alu_op        <= alu_nop;
        wb_src        <= alu_out;
        imm_en        <= "0";
        stack_en      <= "0";
        mem_read      <= "0";
        mem_write     <= "0";
        mem_free      <= "0";
        mem_protect   <= "0";
        push_pop      <= "0";
        call_jmp      <= call;
        ret           <= "0";
        read_reg_one  <= "0";
        read_reg_two  <= "0";
        case instruction is
            when not_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_op        <= alu_not;
                read_reg_one  <= "1";
            when neg_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_op        <= alu_neg;
                read_reg_one  <= "1";
            when inc_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_op        <= alu_inc;
                read_reg_one  <= "1";
            when dec_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_op        <= alu_dec;
                read_reg_one  <= "1";
            when add_bits =>
                reg_one_write <= "1";
                one_two_op    <= two_op;
                alu_op        <= alu_add;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when sub_bits =>
                reg_one_write <= "1";
                one_two_op    <= two_op;
                alu_op        <= alu_sub;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when and_bits =>
                reg_one_write <= "1";
                one_two_op    <= two_op;
                alu_op        <= alu_and;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when or_bits =>
                reg_one_write <= "1";
                one_two_op    <= two_op;
                alu_op        <= alu_or;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when xor_bits =>
                reg_one_write <= "1";
                one_two_op    <= two_op;
                alu_op        <= alu_xor;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when swap_bits =>
                reg_one_write <= "1";
                reg_two_write <= "1";
                rs2_rd         <= rd;
                one_two_op    <= two_op;
                alu_op        <= alu_buff1;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when cmp_bits =>
                rs2_rd         <= rd;
                one_two_op    <= two_op;
                alu_op        <= alu_sub;
                read_reg_one  <= "1";
                read_reg_two  <= "1";
            when addi_bits =>
                reg_one_write <= "1";
                alu_src       <= imm;
                one_two_op    <= two_op;
                alu_op        <= alu_add;
                imm_en        <= "1";
                read_reg_one  <= "1";
            when bitset_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_src       <= imm;
                one_two_op    <= two_op;
                alu_op        <= alu_bitset;
                imm_en        <= "1";
                read_reg_one  <= "1";
            when rcl_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_src       <= imm;
                one_two_op    <= two_op;
                alu_op        <= alu_rcl;
                imm_en        <= "1";
                read_reg_one  <= "1";
            when rcr_bits =>
                reg_one_write <= "1";
                rs1_rd         <= rd;
                alu_src       <= imm;
                one_two_op    <= two_op;
                alu_op        <= alu_rcr;
                imm_en        <= "1";
                read_reg_one  <= "1";
            when ldm_bits =>
                reg_one_write <= "1";
                alu_src       <= imm;
                wb_src        <= immediate;
                imm_en        <= "1";
            when jz_bits =>
                rs1_rd         <= rd;
                alu_op        <= alu_buff2;
                read_reg_one  <= "1";
            when jmp_bits =>
                rs1_rd         <= rd;
                alu_op        <= alu_buff2;
                call_jmp      <= jmp;
                read_reg_one  <= "1";
            when call_bits =>
                rs1_rd         <= rd;
                alu_op        <= alu_nop;
                alu_src       <= pc_plus_one;
                stack_en      <= "1";
                mem_write     <= "1";
                push_pop      <= push;
                read_reg_one  <= "1";
            when ret_bits =>
                wb_src        <= mem_out;
                stack_en      <= "1";
                mem_read      <= "1";
                push_pop      <= pop;
                ret           <= "1";
            when rti_bits =>
                wb_src        <= mem_out;
                stack_en      <= "1";
                mem_read      <= "1";
                push_pop      <= pop;
            when ldd_bits =>
                reg_one_write <= "1";
                alu_src       <= imm;
                wb_src        <= mem_out;
                imm_en        <= "1";
                mem_read      <= "1";
            when std_bits =>
                rs1_rd         <= rd;
                alu_src       <= imm;
                alu_op        <= alu_buff1;
                imm_en        <= "1";
                mem_write     <= "1";
                read_reg_one  <= "1";
            when pop_bits =>
                reg_one_write <= "1";
                wb_src        <= mem_out;
                stack_en      <= "1";
                mem_read      <= "1";
                push_pop      <= pop;
            when push_bits =>
                rs1_rd         <= rd;
                stack_en      <= "1";
                mem_write     <= "1";
                push_pop      <= push;
                read_reg_one  <= "1";
            when in_bits =>
                reg_one_write <= "1";
                alu_op        <= alu_buff2;
                wb_src        <= inport_out;
                ior           <= "1";
            when out_bits =>
                rs1_rd         <= rd;
                out_port_en   <= "1";
                alu_op        <= alu_buff1;
                read_reg_one  <= "1";
                iow           <= "1";
            when free_bits =>
                rs1_rd         <= rd;
                mem_free      <= "1";
                read_reg_one  <= "1";
            when protect_bits =>
                rs2_rd         <= rd;
                -- rs1_rd         <= rd;
                mem_protect   <= "1";
                read_reg_one  <= "1";
            when reset_bits =>
                wb_src        <= mem_out;
                mem_read      <= "1";
            when interrupt_bits =>
                wb_src        <= mem_out;
                stack_en      <= "1";
                mem_read      <= "1";
                mem_write     <= "1";
                push_pop      <= push;
            when others =>
        end case;
    end process;
end architecture ArchCU;