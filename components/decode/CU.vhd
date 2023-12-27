LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity CU is
    port (
        int : in  std_logic;
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
        is_jz          : out unsigned(0 downto 0);
        is_std          : out unsigned(0 downto 0);
        read_reg_two   : out unsigned(0 downto 0)
    );
END ENTITY CU;

ARCHITECTURE ArchCU OF CU IS
    ---------------- instruction bits start ---------------------
    -- nop
    CONSTANT nop_bits : unsigned(6 DOWNTO 0) := "0000000";
    -- alu one operand
    CONSTANT not_bits : unsigned(6 DOWNTO 0) := "0010001";
    CONSTANT neg_bits : unsigned(6 DOWNTO 0) := "0010010";
    CONSTANT inc_bits : unsigned(6 DOWNTO 0) := "0010011";
    CONSTANT dec_bits : unsigned(6 DOWNTO 0) := "0010100";
    -- alu two operand
    CONSTANT add_bits : unsigned(6 DOWNTO 0) := "0011001";
    CONSTANT sub_bits : unsigned(6 DOWNTO 0) := "0011010";
    CONSTANT and_bits : unsigned(6 DOWNTO 0) := "0011011";
    CONSTANT or_bits : unsigned(6 DOWNTO 0) := "0011100";
    CONSTANT xor_bits : unsigned(6 DOWNTO 0) := "0011101";
    CONSTANT swap_bits : unsigned(6 DOWNTO 0) := "0011110";
    CONSTANT cmp_bits : unsigned(6 DOWNTO 0) := "0011111";
    -- immediate
    CONSTANT addi_bits : unsigned(6 DOWNTO 0) := "0100001";
    CONSTANT bitset_bits : unsigned(6 DOWNTO 0) := "0100010";
    CONSTANT rcl_bits : unsigned(6 DOWNTO 0) := "0100100";
    CONSTANT rcr_bits : unsigned(6 DOWNTO 0) := "0100101";
    CONSTANT ldm_bits : unsigned(6 DOWNTO 0) := "0101000";
    -- conditional jump
    CONSTANT jz_bits : unsigned(6 DOWNTO 0) := "0110000";
    -- unconditional jump
    CONSTANT jmp_bits : unsigned(6 DOWNTO 0) := "1001000";
    CONSTANT call_bits : unsigned(6 DOWNTO 0) := "1000100";
    CONSTANT ret_bits : unsigned(6 DOWNTO 0) := "1000010";
    CONSTANT rti_bits : unsigned(6 DOWNTO 0) := "1000001";
    -- data operations
    CONSTANT ldd_bits : unsigned(6 DOWNTO 0) := "1011100";
    CONSTANT std_bits : unsigned(6 DOWNTO 0) := "1010100";
    CONSTANT pop_bits : unsigned(6 DOWNTO 0) := "1011010";
    CONSTANT push_bits : unsigned(6 DOWNTO 0) := "1010010";
    CONSTANT in_bits : unsigned(6 DOWNTO 0) := "1011001";
    CONSTANT out_bits : unsigned(6 DOWNTO 0) := "1010001";
    -- memory security
    CONSTANT free_bits : unsigned(6 DOWNTO 0) := "1101000";
    CONSTANT protect_bits : unsigned(6 DOWNTO 0) := "1100000";
    -- input signals
    CONSTANT reset_bits : unsigned(6 DOWNTO 0) := "1111000";
    CONSTANT interrupt_bits : unsigned(6 DOWNTO 0) := "1110000";
    ---------------- instruction bits end ---------------------

    ---------------- alu functions start ---------------------
    -- no operands operations
    CONSTANT alu_nop : unsigned(3 DOWNTO 0) := x"0";
    -- one operands operations
    CONSTANT alu_not : unsigned(3 DOWNTO 0) := x"1";
    CONSTANT alu_neg : unsigned(3 DOWNTO 0) := x"2";
    CONSTANT alu_inc : unsigned(3 DOWNTO 0) := x"3";
    CONSTANT alu_dec : unsigned(3 DOWNTO 0) := x"4";
    -- play with one operand
    CONSTANT alu_bitset : unsigned(3 DOWNTO 0) := x"5";
    CONSTANT alu_rcl : unsigned(3 DOWNTO 0) := x"6";
    CONSTANT alu_rcr : unsigned(3 DOWNTO 0) := x"7";
    -- two operands operations
    CONSTANT alu_add : unsigned(3 DOWNTO 0) := x"9";
    CONSTANT alu_sub : unsigned(3 DOWNTO 0) := x"A"; -- aluIn1 - aluIn2
    CONSTANT alu_and : unsigned(3 DOWNTO 0) := x"B";
    CONSTANT alu_or : unsigned(3 DOWNTO 0) := x"C";
    CONSTANT alu_xor : unsigned(3 DOWNTO 0) := x"D";
    -- buffers
    CONSTANT alu_buff1 : unsigned(3 DOWNTO 0) := x"E"; -- same as SWAP => output = aluIn1
    CONSTANT alu_buff2 : unsigned(3 DOWNTO 0) := x"F";
    ---------------- alu functions end ---------------------

    ---------------- constants start ---------------------
    CONSTANT rd : unsigned(0 DOWNTO 0) := "1";
    CONSTANT rs : unsigned(0 DOWNTO 0) := "0";
    CONSTANT one_op : unsigned(0 DOWNTO 0) := "0";
    CONSTANT two_op : unsigned(0 DOWNTO 0) := "1";
    -- wb src
    CONSTANT mem_out : unsigned(1 DOWNTO 0) := "00";
    CONSTANT alu_out : unsigned(1 DOWNTO 0) := "01";
    CONSTANT immediate : unsigned(1 DOWNTO 0) := "10";
    CONSTANT inport_out : unsigned(1 DOWNTO 0) := "11";
    -- wb src
    CONSTANT reg : unsigned(1 DOWNTO 0) := "00";
    CONSTANT imm : unsigned(1 DOWNTO 0) := "01";
    CONSTANT pc_plus_one : unsigned(1 DOWNTO 0) := "10";
    CONSTANT push : unsigned(0 DOWNTO 0) := "0";
    CONSTANT pop : unsigned(0 DOWNTO 0) := "1";
    CONSTANT call : unsigned(0 DOWNTO 0) := "0";
    CONSTANT jmp : unsigned(0 DOWNTO 0) := "1";
    ---------------- constants end ---------------------
BEGIN
    PROCESS (instruction) IS
    BEGIN
        REPORT "instruction: " & to_string(instruction);
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
        is_jz         <= "0";
        is_std         <= "0";
        -- if (int = '1') then            
        --     wb_src        <= mem_out;
        --     stack_en      <= "1";
        --     mem_read      <= "1";
        --     mem_write     <= "1";
        --     push_pop      <= push;
        -- else 
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
                    is_jz <= "1";
                when jmp_bits =>
                    rs1_rd         <= rd;
                    alu_op        <= alu_buff2;
                    call_jmp      <= jmp;
                    read_reg_one  <= "1";
                    
                when call_bits =>
                    rs1_rd         <= rd;
                    read_reg_one  <= "1";
                    alu_op        <= alu_buff1;
                    alu_src       <= pc_plus_one;
                    stack_en      <= "1";
                    mem_write     <= "1";
                    push_pop      <= push;
                    call_jmp      <= "1";
                    is_std <= "1";

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
                    ret           <= "1";
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
                    is_std <= "1";
                when pop_bits =>
                    reg_one_write <= "1";
                    wb_src        <= mem_out;
                    stack_en      <= "1";
                    mem_read      <= "1";
                    push_pop      <= pop;
                    alu_op        <= alu_buff1;
                when push_bits =>
                    rs1_rd         <= rd;
                    stack_en      <= "1";
                    mem_write     <= "1";
                    push_pop      <= push;
                    read_reg_one  <= "1";
                    alu_op        <= alu_buff1;
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
        -- end if;
    end process;
end architecture ArchCU;
