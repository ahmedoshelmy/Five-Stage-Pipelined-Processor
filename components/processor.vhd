LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processor IS
    PORT (
        clk, reset, interrupt : IN STD_LOGIC;
        port_in : IN unsigned(31 DOWNTO 0);
        port_out : OUT unsigned(31 DOWNTO 0)
    );
END ENTITY processor;

ARCHITECTURE archProcessor OF processor IS
    ------------------------- fetch stage signals start -------------------
    SIGNAL pc : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction_if_ex : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    signal int_if_id : STD_LOGIC := '0';
    SIGNAL pc_if_ex : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL next_pc_src : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    ------------------------- fetch stage signals end ---------------------

    ------------------------- decode stage signals start ------------------
    SIGNAL ra1 : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ra2 : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wa1 : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wa2 : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd1 : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd2 : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_src_2 : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    signal int_id_ex : STD_LOGIC := '0';
    SIGNAL rd1_id_ex : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd2_id_ex : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_src_2_id_ex : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ra1_id_ex : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ra2_id_ex : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wa1_id_ex : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wa2_id_ex : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_one_write_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL reg_two_write_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL stack_en_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_read_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_write_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL call_jmp_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL is_jz_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL ret_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL push_pop_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL out_port_en_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL ior_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL iow_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_free_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_protect_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL read_reg_one_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL read_reg_two_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL imm_en_id_ex : unsigned (0 DOWNTO 0) := "0";
    SIGNAL alu_op_id_ex : unsigned (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wb_src_id_ex : unsigned (1 DOWNTO 0) := (OTHERS => '0');
    ------------------------- decode stage signals end --------------------

    ------------------------- execute stage signals start --------------------
    SIGNAL alu_src_2_FW_MUX : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_src_1_FW_MUX : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL flags_in_alu : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL flags_out_alu : unsigned (2 DOWNTO 0) := (OTHERS => '0');

    SIGNAL alu_out_ex : signed (31 DOWNTO 0) := (OTHERS => '0');
    -- output from pipeline reg
    signal push_pc_ex_mem : unsigned(0 downto 0) := "0";
    SIGNAL alu_out_ex_mem : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_src_2_ex_mem : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    signal flags_ex_mem : unsigned(2 downto 0) := (others => '0');
    SIGNAL ra1_ex_mem : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ra2_ex_mem : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd1_ex_mem : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd2_ex_mem : unsigned (2 DOWNTO 0) := (OTHERS => '0');

    SIGNAL reg_one_write_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL reg_two_write_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL wb_src_ex_mem : unsigned (1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stack_en_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_read_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_write_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL push_pop_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL out_port_en_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL ior_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL iow_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL inport_data_ex_mem : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_free_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL mem_protect_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL read_reg_one_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL read_reg_two_ex_mem : unsigned (0 DOWNTO 0) := "0";
    SIGNAL ret_ex_mem : unsigned (0 DOWNTO 0) := "0";

    ------------------------- execute stage signals end --------------------

    ------------------------- forwarding unit signals start ------------------
    SIGNAL alu_src_1_SEL : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_src_2_SEL : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    ------------------------- forwarding unit signals end ------------------

    ------------------------- memory stage signals start -----------------
    SIGNAL address_mem_in : unsigned (11 DOWNTO 0); -- out of mux to memory
    SIGNAL sp : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    -- signal stack_en_ex_mem      : unsigned         (0 downto 0) :=             "0";
    SIGNAL write_sp_data_ex_mem : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_rst_val, pc_int_val : unsigned(31 DOWNTO 0) := (OTHERS => '0');

    SIGNAL mem_out_DMEM : unsigned(31 DOWNTO 0) := (OTHERS => '0');

    -- output from pipeline reg
    SIGNAL alu_out_mem_wb : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL alu_src_2_mem_wb : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_out_mem_wb : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ra1_mem_wb : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ra2_mem_wb : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd1_mem_wb : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd2_mem_wb : unsigned (2 DOWNTO 0) := (OTHERS => '0');

    SIGNAL reg_one_write_mem_wb : unsigned (0 DOWNTO 0) := "0";
    SIGNAL reg_two_write_mem_wb : unsigned (0 DOWNTO 0) := "0";
    SIGNAL wb_src_mem_wb : unsigned (1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL out_port_en_mem_wb : unsigned (0 DOWNTO 0) := "0";
    SIGNAL ior_mem_wb : unsigned (0 DOWNTO 0) := "0";
    SIGNAL iow_mem_wb : unsigned (0 DOWNTO 0) := "0";
    SIGNAL inport_data_mem_wb : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_reg_one_mem_wb : unsigned (0 DOWNTO 0) := "0";
    SIGNAL read_reg_two_mem_wb : unsigned (0 DOWNTO 0) := "0";

    signal push_pc : unsigned(0 downto 0) := "0";
    ------------------------- write back stage signals start --------------
    SIGNAL regWriteData : unsigned (31 DOWNTO 0) := (OTHERS => '0'); --output from wb mux
    SIGNAL inport, outport : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    --signal alu_src_2_mem_wb     : unsigned        (31 downto 0) := (others => '0');
    --signal reg_one_write_mem_wb : unsigned         (0 downto 0) :=             "0";
    --signal reg_two_write_mem_wb : unsigned         (0 downto 0) :=             "0";
    ------------------------- write back stage signals end ----------------

    ------------------------- control signals start -----------------------
    SIGNAL imm_en : STD_LOGIC := '0';
    SIGNAL stall : STD_LOGIC := '0';
    SIGNAL reg_one_write : unsigned(0 DOWNTO 0) := "0";
    SIGNAL reg_two_write : unsigned(0 DOWNTO 0) := "0";
    SIGNAL rs1_rd : unsigned(0 DOWNTO 0) := "0";
    SIGNAL rs2_rd : unsigned(0 DOWNTO 0) := "0";
    SIGNAL alu_src : unsigned(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL out_port_en : unsigned(0 DOWNTO 0) := "0";
    SIGNAL ior : unsigned(0 DOWNTO 0) := "0";
    SIGNAL iow : unsigned(0 DOWNTO 0) := "0";
    SIGNAL one_two_op : unsigned(0 DOWNTO 0) := "0";
    SIGNAL alu_op : unsigned(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wb_src : unsigned(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stack_en : unsigned(0 DOWNTO 0) := "0";
    SIGNAL mem_read : unsigned(0 DOWNTO 0) := "0";
    SIGNAL mem_write : unsigned(0 DOWNTO 0) := "0";
    SIGNAL mem_free : unsigned(0 DOWNTO 0) := "0";
    SIGNAL mem_protect : unsigned(0 DOWNTO 0) := "0";
    SIGNAL push_pop : unsigned(0 DOWNTO 0) := "0";
    SIGNAL call_jmp : unsigned(0 DOWNTO 0) := "0";
    SIGNAL ret : unsigned(0 DOWNTO 0) := "0";
    SIGNAL read_reg_one : unsigned(0 DOWNTO 0) := "0";
    SIGNAL is_jz : unsigned(0 DOWNTO 0) := "0";
    SIGNAL read_reg_two : unsigned(0 DOWNTO 0) := "0";
    ------------------------- control signals end -------------------------

    ------------------------- internal signals start ----------------------
    signal push_pc_std_logic : std_logic := '0';
    SIGNAL instruction_internal : unsigned (6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL imm_en_internal : unsigned (0 DOWNTO 0) := "0";
    SIGNAL rs1_internal : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rs2_internal : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd_internal : unsigned (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk_internal : unsigned (0 DOWNTO 0) := "0";
    SIGNAL reset_internal : unsigned (0 DOWNTO 0) := "0";
    SIGNAL imm_internal : unsigned(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_internal : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stall_internal : unsigned (0 DOWNTO 0) := "0";
    SIGNAL alu_out_unsigned : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_out_DME_in, pc_rst_val_in, pc_int_val_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    ------------------------- internal signals end ------------------------

    ------------------------- Branching signals start ---------------------
    SIGNAL flush_ex : STD_LOGIC := '0';
    SIGNAL flush_mem : STD_LOGIC := '0';
    ------------------------- Branching signals end ---------------------

    ------------------------- I/O signals start -------------------------
    SIGNAL inport_data : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    ------------------------- I/O signals end ---------------------------

    ------------------------- Mocking External devices ------------------
    -- for input port
    SIGNAL inport_external_device : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL inport_en_external_device : unsigned(0 DOWNTO 0) := (OTHERS => '0');

    -- ============================ ============================ ============================
    -- ============================ ============================ ============================
    -- ============================ ============================ ============================
    -- ============================ ==== COMPONENTS ============ ============================
    -- ============================ ============================ ============================

    ------------------------- fetch stage start ---------------------------
    COMPONENT instruction_memory IS
        PORT (
            clk, reset : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT IF_ID_REGISTER IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            int : IN STD_LOGIC;
            imm_en : IN STD_LOGIC;

            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            enable : IN STD_LOGIC;

            int_if_id : OUT STD_LOGIC;
            instruction_if_ex : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc_if_ex : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT IF_ID_REGISTER;

    COMPONENT PC_REG IS
        PORT (
            CLK, RESET, INT, WEN : IN STD_LOGIC;
            RST_val, INT_val, PC_IN : IN unsigned(11 DOWNTO 0);
            PC_OUT : OUT unsigned(11 DOWNTO 0)
        );
    END COMPONENT PC_REG;

    COMPONENT PC_SRC_MUX IS
        PORT (
            memOut, aluSrc2, next_pc : IN unsigned (31 DOWNTO 0);
            FLUSH_MEM, FLUSH_EX : IN STD_LOGIC;
            PC_OUT : OUT unsigned (31 DOWNTO 0)
        );
    END COMPONENT;
    ------------------------- fetch stage end ---------------------------

    ------------------------- decode stage start ------------------------
    COMPONENT alu_src_2_mux IS
        PORT (
            rd2, pc : IN unsigned(31 DOWNTO 0);
            imm : IN unsigned(15 DOWNTO 0);
            alu_src : IN unsigned (1 DOWNTO 0);
            alu_src_2 : OUT unsigned(31 DOWNTO 0)
        );
    END COMPONENT alu_src_2_mux;

    COMPONENT rs1_rd_mux IS
        PORT (
            rs1, rd : IN unsigned(2 DOWNTO 0);
            rs1_rd : IN unsigned(0 DOWNTO 0);
            ra1 : OUT unsigned(2 DOWNTO 0)
        );
    END COMPONENT rs1_rd_mux;

    COMPONENT rs2_rd_mux IS
        PORT (
            rs2, rd : IN unsigned(2 DOWNTO 0);
            rs2_rd : IN unsigned(0 DOWNTO 0);
            ra2 : OUT unsigned(2 DOWNTO 0)
        );
    END COMPONENT rs2_rd_mux;

    COMPONENT cu IS
        PORT (
            int : IN STD_LOGIC;
            instruction : IN unsigned(6 DOWNTO 0);
            reg_one_write : OUT unsigned(0 DOWNTO 0);
            reg_two_write : OUT unsigned(0 DOWNTO 0);
            rs1_rd, rs2_rd : OUT unsigned(0 DOWNTO 0);
            alu_src : OUT unsigned(1 DOWNTO 0);
            out_port_en : OUT unsigned(0 DOWNTO 0);
            ior, iow : OUT unsigned(0 DOWNTO 0);
            one_two_op : OUT unsigned(0 DOWNTO 0);
            alu_op : OUT unsigned(3 DOWNTO 0);
            wb_src : OUT unsigned(1 DOWNTO 0);
            imm_en : OUT unsigned(0 DOWNTO 0);
            stack_en : OUT unsigned(0 DOWNTO 0);
            mem_read : OUT unsigned(0 DOWNTO 0);
            mem_write : OUT unsigned(0 DOWNTO 0);
            mem_free : OUT unsigned(0 DOWNTO 0);
            mem_protect : OUT unsigned(0 DOWNTO 0);
            push_pop : OUT unsigned(0 DOWNTO 0);
            call_jmp : OUT unsigned(0 DOWNTO 0);
            ret : OUT unsigned(0 DOWNTO 0);
            read_reg_one : OUT unsigned(0 DOWNTO 0);
            is_jz : OUT unsigned(0 DOWNTO 0);
            read_reg_two : OUT unsigned(0 DOWNTO 0)
        );
    END COMPONENT cu;

    COMPONENT hdu IS
        PORT (
            old_dst, cur_ra_one, cur_ra_two : IN unsigned(2 DOWNTO 0);
            reg_write_one, mem_read, read_reg_one, read_reg_two : IN unsigned(0 DOWNTO 0);
            stall : OUT unsigned(0 DOWNTO 0)
        );
    END COMPONENT hdu;

    COMPONENT id_ex_register IS
        PORT (
            clk, reset, en : IN unsigned (0 DOWNTO 0);
            int_in : IN STD_LOGIC;
            rd1_in, alu_src_2_in : IN unsigned(31 DOWNTO 0);
            ra1_in, ra2_in, rdst1_in, rdst2_in : IN unsigned (2 DOWNTO 0);
            reg_one_write_in, reg_two_write_in, stack_en_in : IN unsigned (0 DOWNTO 0);
            mem_read_in, mem_write_in, call_jmp_in, ret_in : IN unsigned (0 DOWNTO 0);
            is_jz_in : IN unsigned (0 DOWNTO 0);
            push_pop_in, out_port_en_in : IN unsigned (0 DOWNTO 0);
            ior_in, iow_in : IN unsigned (0 DOWNTO 0);
            mem_free_in, mem_protect_in : IN unsigned (0 DOWNTO 0);
            read_reg_one_in, read_reg_two_in, imm_en_in : IN unsigned (0 DOWNTO 0);
            alu_op_in : IN unsigned (3 DOWNTO 0);
            wb_src_in : IN unsigned (1 DOWNTO 0);
            int_out : OUT STD_LOGIC;
            rd1_out, alu_src_2_out : OUT unsigned(31 DOWNTO 0);
            ra1_out, ra2_out, rdst1_out, rdst2_out : OUT unsigned (2 DOWNTO 0);
            reg_one_write_out, reg_two_write_out, stack_en_out : OUT unsigned (0 DOWNTO 0);
            mem_read_out, mem_write_out, call_jmp_out, ret_out : OUT unsigned (0 DOWNTO 0);
            push_pop_out, out_port_en_out : OUT unsigned (0 DOWNTO 0);
            ior_out, iow_out : OUT unsigned (0 DOWNTO 0);
            mem_free_out, mem_protect_out : OUT unsigned (0 DOWNTO 0);
            read_reg_one_out, read_reg_two_out, imm_en_out : OUT unsigned (0 DOWNTO 0);
            alu_op_out : OUT unsigned (3 DOWNTO 0);
            wb_src_out : OUT unsigned (1 DOWNTO 0);
            is_jz_out : OUT unsigned (0 DOWNTO 0)
        );
    END COMPONENT id_ex_register;

    COMPONENT regfile IS
        GENERIC (
            reg_width : INTEGER := 32;
            reg_count : INTEGER := 8
        );
        PORT (
            clk, rst, reg_one_write, reg_two_write : IN unsigned (0 DOWNTO 0);
            ra1, ra2, wa1, wa2 : IN unsigned (2 DOWNTO 0);
            wd1, wd2 : IN unsigned (reg_width - 1 DOWNTO 0);
            rd1, rd2 : OUT unsigned (reg_width - 1 DOWNTO 0)
        );
    END COMPONENT regfile;
    ------------------------- decode stage end --------------------------

    ------------------------- execute stage start -----------------------
    COMPONENT FW_MUX_1 IS
        PORT (
            in_port_ex_mem : IN unsigned (31 DOWNTO 0);
            in_port_mem_wb : IN unsigned (31 DOWNTO 0);
            -- inputs from D/EX
            rd1_d_ex : IN unsigned (31 DOWNTO 0);
            -- inputs from EX/MEM
            alu_out_ex, alu_src_2_ex : IN unsigned (31 DOWNTO 0);
            -- inputs from MEM/WB
            alu_out_mem, alu_src_2_mem, mem_out : IN unsigned (31 DOWNTO 0);
            -- inputs from FU
            alu_src_1_sel : IN unsigned (2 DOWNTO 0);
            -- ouputs 
            alu_src_1 : OUT unsigned (31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT FW_MUX_2 IS
        PORT (
            in_port_ex_mem : IN unsigned (31 DOWNTO 0);
            in_port_mem_wb : IN unsigned (31 DOWNTO 0);
            -- inputs from D/EX
            alu_src_2_d : IN unsigned (31 DOWNTO 0);
            -- inputs from EX/MEM
            alu_out_ex, alu_src_2_ex : IN unsigned (31 DOWNTO 0);
            -- inputs from MEM/WB
            alu_out_mem, alu_src_2_mem, mem_out : IN unsigned (31 DOWNTO 0);
            -- inputs from FU
            alu_src_2_sel : IN unsigned (2 DOWNTO 0);
            -- ouputs 
            alu_src_2 : OUT unsigned (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT alu IS
        GENERIC (n : INTEGER := 32);
        PORT (
            aluin1, aluin2 : IN signed (31 DOWNTO 0);
            func : IN unsigned (3 DOWNTO 0);
            flagsin : IN unsigned (2 DOWNTO 0);
            flagsout : OUT unsigned (2 DOWNTO 0);
            aluout : OUT signed (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT BRANCH_UNIT_EX IS
        PORT (
            is_call_jmp : IN STD_LOGIC;
            is_jz : IN STD_LOGIC;
            zero_flag : IN STD_LOGIC;

            is_jmp_tkn : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ex_mem_register IS
        GENERIC (
            regwidth : INTEGER := 32;
            regaddrwidth : INTEGER := 3
        );
        PORT (
            clk, reset : IN unsigned (0 DOWNTO 0);
            push_pc: IN unsigned(0 DOWNTO 0);
            alu_out : IN unsigned(regWidth - 1 DOWNTO 0);
            alu_src_2 : IN unsigned(regWidth - 1 DOWNTO 0);
            flags : IN unsigned(2 downto 0);

            ra1, ra2, rdst1, rdst2 : IN unsigned(regAddrWidth - 1 DOWNTO 0);
            -- control signals
            reg_one_write, reg_two_write : IN unsigned (0 DOWNTO 0);
            stack_en, mem_read, mem_write : IN unsigned (0 DOWNTO 0);
            ret, push_pop, out_port_en : IN unsigned (0 DOWNTO 0);
            ior, iow : IN unsigned (0 DOWNTO 0);
            inport_data : IN unsigned (31 DOWNTO 0);
            mem_free, mem_protect : IN unsigned (0 DOWNTO 0);
            wb_src : IN unsigned (1 DOWNTO 0);
            read_reg_one, read_reg_two : IN unsigned (0 DOWNTO 0);

            -- outputs
            push_pc_out : OUT unsigned(0 DOWNTO 0);
            alu_out_out : OUT unsigned(regWidth - 1 DOWNTO 0);
            alu_src_2_out : OUT unsigned(regWidth - 1 DOWNTO 0);
            flags_out : OUT unsigned(2 downto 0);

            ra1_out, ra2_out, rdst1_out, rdst2_out : OUT unsigned(regAddrWidth - 1 DOWNTO 0);
            -- control signals
            reg_one_write_out, reg_two_write_out : OUT unsigned (0 DOWNTO 0);
            stack_en_out, mem_read_out, mem_write_out : OUT unsigned (0 DOWNTO 0);
            ret_out, push_pop_out, out_port_en_out : OUT unsigned (0 DOWNTO 0);
            ior_out, iow_out : OUT unsigned (0 DOWNTO 0);
            inport_data_out : OUT unsigned (31 DOWNTO 0);
            mem_free_out, mem_protect_out : OUT unsigned (0 DOWNTO 0);
            wb_src_out : OUT unsigned (1 DOWNTO 0);
            read_reg_one_out, read_reg_two_out : OUT unsigned (0 DOWNTO 0)
        );
    END COMPONENT ex_mem_register;

    COMPONENT flags_register IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            wen : IN STD_LOGIC;

            zeroflag, negativeflag, carryflag : IN STD_LOGIC;
            zeroflag_reg, negativeflag_reg, carryflag_reg : OUT STD_LOGIC
        );
    END COMPONENT;
    ------------------------- execute stage end -------------------------

    ------------------------- memory stage start ------------------------

    COMPONENT SP_REG IS
        GENERIC (
            ADDRESS_BITS : INTEGER := 12
        );
        PORT (
            clk, reset, int, stack_en, push_pop : IN STD_LOGIC;
            sp_out : OUT unsigned(ADDRESS_BITS - 1 DOWNTO 0)
        );
    END COMPONENT SP_REG;

    COMPONENT muxtomemory IS
        GENERIC (
            address_bits : INTEGER := 12
        );
        PORT (
            push_pop : IN unsigned;
            stack_en : IN unsigned;
            sp : IN unsigned(31 DOWNTO 0); -- stack pointer
            ea : IN unsigned(address_bits - 1 DOWNTO 0); -- effective address
            address_mem_in : OUT unsigned(address_bits - 1 DOWNTO 0)
        );
    END COMPONENT muxtomemory;
    COMPONENT BRANCH_UNIT_MEM IS
        PORT (
            IS_RET_RTI : IN STD_LOGIC;

            IS_JMP_TKN : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT memory IS
        GENERIC (
            cache_word_width : INTEGER := 16;
            address_bits : INTEGER := 12
        );
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            push_pc : IN unsigned(0 DOWNTO 0);
            memr, memw : IN STD_LOGIC;
            protect, free : IN STD_LOGIC;
            address_bus : IN STD_LOGIC_VECTOR(address_bits - 1 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            alu_src_2 : in unsigned(31 downto 0);
            memout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc_rst_val, pc_int_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT memory;

    COMPONENT mem_wb_register IS
        GENERIC (
            regwidth : INTEGER := 32;
            regaddrwidth : INTEGER := 3
        );
        PORT (
            clk, reset : IN unsigned (0 DOWNTO 0);
            ALU_OUT, ALU_SRC_2, MEM_OUT : IN unsigned(regWidth - 1 DOWNTO 0);
            ra1, ra2, rdst1, rdst2 : IN unsigned(regAddrWidth - 1 DOWNTO 0);
            reg_one_write, reg_two_write : IN unsigned (0 DOWNTO 0);
            wb_src : IN unsigned (1 DOWNTO 0);
            out_port_en : IN unsigned (0 DOWNTO 0);
            ior, iow : IN unsigned (0 DOWNTO 0);
            inport_data : IN unsigned (31 DOWNTO 0);
            read_reg_one, read_reg_two : IN unsigned (0 DOWNTO 0);

            -- outputs
            ALU_OUT_out, ALU_SRC_2_out, MEM_OUT_out : OUT unsigned(regWidth - 1 DOWNTO 0);
            ra1_out, ra2_out, rdst1_out, rdst2_out : OUT unsigned(regAddrWidth - 1 DOWNTO 0);
            reg_one_write_out, reg_two_write_out : OUT unsigned (0 DOWNTO 0);
            wb_src_out : OUT unsigned (1 DOWNTO 0);
            out_port_en_out : OUT unsigned (0 DOWNTO 0);
            ior_out, iow_out : OUT unsigned (0 DOWNTO 0);
            inport_data_out : OUT unsigned (31 DOWNTO 0);
            read_reg_one_out, read_reg_two_out : OUT unsigned (0 DOWNTO 0)
        );
    END COMPONENT mem_wb_register;

    -- ------------------------- memory stage end --------------------------

    -- ------------------------- write back stage start --------------------
    COMPONENT ports_reg IS
        GENERIC (n : INTEGER := 32);
        PORT (
            clk, reset, wr_en_in, wr_en_out : IN unsigned (0 DOWNTO 0);
            inport, outport : IN unsigned (n - 1 DOWNTO 0);
            inPortReg, outPortReg : OUT unsigned (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT wb_src_mux IS
        GENERIC (n : INTEGER := 32);
        PORT (
            memout, aluout, imm, inport : IN unsigned (n - 1 DOWNTO 0);
            wbsrc : IN unsigned (1 DOWNTO 0);
            regwritedata : OUT unsigned (n - 1 DOWNTO 0)
        );
    END COMPONENT;
    ------------------------- write back stage end ----------------------

    ------------------------- other components start --------------------
    COMPONENT io IS
        GENERIC (
            reg_width : INTEGER := 32
        );
        PORT (
            inport, data_in : IN unsigned(reg_width - 1 DOWNTO 0);
            outport, data_out : OUT unsigned(reg_width - 1 DOWNTO 0);
            ior, iow : IN unsigned(0 DOWNTO 0);
            clk, reset : IN STD_LOGIC
        );
    END COMPONENT io;
    
    COMPONENT FU IS
    PORT (
        -- Inputs from D/EX Register
        rsrc1_d_ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rsrc2_d_ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_reg_1 : IN STD_LOGIC;
            read_reg_2 : IN STD_LOGIC;
            -- Inputs from EX/MEM Register
            reg_w1_ex_mem : IN STD_LOGIC;
            reg_w2_ex_mem : IN STD_LOGIC;
            rdst1_ex_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            rdst2_ex_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            wb_src_ex_mem : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- (ALU - MEM - IMM)
            ior_ex_mem : IN STD_LOGIC; -- IO READ SIGNAL
            -- Inputs from MEM/WB Register
            reg_w1_mem_wb : IN STD_LOGIC;
            reg_w2_mem_wb : IN STD_LOGIC;
            ior_mem_wb : IN STD_LOGIC; -- IO READ SIGNAL
            rdst1_mem_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            rdst2_mem_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            wb_src_mem_wb : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            
            -- Selectors 
            rsrc1_d_ex_sel : OUT UNSIGNED(2 DOWNTO 0);
            rsrc2_d_ex_sel : OUT UNSIGNED(2 DOWNTO 0)
            );
            
            END COMPONENT FU;

    component icu is
        port (
            int, clk, reset : in std_logic;
            push_pc : out unsigned(0 downto 0)
        );
    end component icu;
            ---------------------------- other components end --------------------
BEGIN
    ------------------------- fetch stage port maps start ----------------
    fetchMux : PC_SRC_MUX PORT MAP(
        memOut => mem_out_DMEM,
        aluSrc2 => (alu_src_1_FW_MUX),
        next_pc => (pc + 1),

        FLUSH_MEM => flush_mem,
        FLUSH_EX => flush_ex,
        PC_OUT => next_pc_src
    );
    -- push_pc_std_logic <= std_logic(push_pc);
    fetchPcEG : PC_REG PORT MAP(
        CLK => clk,
        RESET => reset,
        INT => interrupt,
        WEN => "not"(stall),
        RST_val => pc_rst_val(11 DOWNTO 0),
        INT_val => pc_int_val(11 DOWNTO 0),
        PC_IN => next_pc_src(11 DOWNTO 0),
        PC_OUT => pc(11 DOWNTO 0)
    );

    fetchIMEM : instruction_memory PORT MAP(
        clk => clk,
        reset => reset,
        address => STD_LOGIC_VECTOR(pc(11 DOWNTO 0)),
        dataout => instruction
    );

    fetchPipeREG : IF_ID_REGISTER PORT MAP(
        clk => clk,
        reset => (reset OR (NOT interrupt AND (FLUSH_EX OR FLUSH_MEM))),
        int => interrupt,
        imm_en => imm_en_internal(0),
        instruction => instruction,
        pc => STD_LOGIC_VECTOR(pc),
        enable => "not"(stall),
        int_if_id => int_if_id,
        instruction_if_ex => instruction_if_ex,
        pc_if_ex => pc_if_ex
    );
    ------------------------- fetch stage port maps end ------------------

    ------------------------- decode stage port maps start ---------------
    instruction_internal <= unsigned(instruction_if_ex(15 DOWNTO 13) & instruction_if_ex(3 DOWNTO 0));
    imm_en <= imm_en_internal(0); -- cool trick to convert std_logic to unsigned
    decode_CU : cu PORT MAP(
        int => int_if_id,
        instruction => instruction_internal,
        reg_one_write => reg_one_write,
        reg_two_write => reg_two_write,
        rs1_rd => rs1_rd,
        rs2_rd => rs2_rd,
        alu_src => alu_src,
        out_port_en => out_port_en,
        ior => ior,
        iow => iow,
        one_two_op => one_two_op,
        alu_op => alu_op,
        wb_src => wb_src,
        imm_en => imm_en_internal,
        stack_en => stack_en,
        mem_read => mem_read,
        mem_write => mem_write,
        mem_free => mem_free,
        mem_protect => mem_protect,
        push_pop => push_pop,
        call_jmp => call_jmp,
        ret => ret,
        read_reg_one => read_reg_one,
        is_jz => is_jz,
        read_reg_two => read_reg_two
    );

    rs1_internal <= unsigned(instruction_if_ex(9 DOWNTO 7));
    rd_internal <= unsigned(instruction_if_ex(12 DOWNTO 10));
    decode_RS1MUX : rs1_rd_mux PORT MAP(
        rs1 => rs1_internal,
        rd => rd_internal,
        rs1_rd => rs1_rd,
        ra1 => ra1
    );

    rs2_internal <= unsigned(instruction_if_ex(6 DOWNTO 4));
    decode_RS2MUX : rs2_rd_mux PORT MAP(
        rs2 => rs2_internal,
        rd => rd_internal,
        rs2_rd => rs2_rd,
        ra2 => ra2
    );

    clk_internal <= "" & clk;
    reset_internal <= "" & reset;
    decode_REGFILE : regFile PORT MAP(
        clk => clk_internal,
        rst => reset_internal,
        reg_one_write => reg_one_write_mem_wb,
        reg_two_write => reg_two_write_mem_wb,
        ra1 => ra1,
        ra2 => ra2,
        wa1 => rd1_mem_wb,
        wa2 => rd2_mem_wb,
        wd1 => regWriteData, -- from wb_src_mux
        wd2 => alu_src_2_mem_wb, -- from mem_wb buffer
        rd1 => rd1,
        rd2 => rd2
    );

    imm_internal <= unsigned(instruction);
    pc_internal <= unsigned(pc);
    decode_ALU_SRC_MUX : alu_src_2_mux PORT MAP(
        rd2 => rd2,
        pc => pc_internal,
        imm => imm_internal,
        alu_src => alu_src,
        alu_src_2 => alu_src_2
    );

    stall_internal <= "" & stall;
    decodePipeReg : id_ex_register PORT MAP(
        clk => clk_internal,
        reset => reset_internal,
        en => "not"(stall_internal),
        int_in => int_if_id,
        rd1_in => rd1,
        alu_src_2_in => alu_src_2,
        ra1_in => ra1,
        ra2_in => ra2,
        rdst1_in => rd_internal,
        rdst2_in => rs1_internal,
        reg_one_write_in => reg_one_write,
        reg_two_write_in => reg_two_write,
        stack_en_in => stack_en,
        mem_read_in => mem_read,
        mem_write_in => mem_write,
        call_jmp_in => call_jmp,
        is_jz_in => is_jz,
        ret_in => ret,
        push_pop_in => push_pop,
        out_port_en_in => out_port_en,
        ior_in => ior,
        iow_in => iow,
        mem_free_in => mem_free,
        mem_protect_in => mem_protect,
        read_reg_one_in => read_reg_one,
        read_reg_two_in => read_reg_two,
        imm_en_in => imm_en_internal,
        alu_op_in => alu_op,
        wb_src_in => wb_src,

        int_out => int_id_ex,
        rd1_out => rd1_id_ex,
        alu_src_2_out => alu_src_2_id_ex,
        ra1_out => ra1_id_ex,
        ra2_out => ra2_id_ex,
        rdst1_out => wa1_id_ex,
        rdst2_out => wa2_id_ex,
        reg_one_write_out => reg_one_write_id_ex,
        reg_two_write_out => reg_two_write_id_ex,
        stack_en_out => stack_en_id_ex,
        mem_read_out => mem_read_id_ex,
        mem_write_out => mem_write_id_ex,
        call_jmp_out => call_jmp_id_ex,
        is_jz_out => is_jz_id_ex,
        ret_out => ret_id_ex,
        push_pop_out => push_pop_id_ex,
        out_port_en_out => out_port_en_id_ex,
        ior_out => ior_id_ex,
        iow_out => iow_id_ex,
        mem_free_out => mem_free_id_ex,
        mem_protect_out => mem_protect_id_ex,
        read_reg_one_out => read_reg_one_id_ex,
        read_reg_two_out => read_reg_two_id_ex,
        imm_en_out => imm_en_id_ex,
        alu_op_out => alu_op_id_ex,
        wb_src_out => wb_src_id_ex
    );
    ------------------------- decode stage port maps end -----------------

    ------------------------- execute stage port maps start ------------------
    executeMuxAluSrc1 : FW_MUX_1 PORT MAP(
        in_port_ex_mem => inport_data_ex_mem,
        in_port_mem_wb => inport_data_mem_wb,
        -- inputs from D/EX
        rd1_d_ex => rd1_id_ex,
        -- inputs from EX/MEM
        alu_out_ex => alu_out_ex_mem,
        alu_src_2_ex => alu_src_2_ex_mem,
        -- inputs from MEM/WB
        alu_out_mem => alu_out_mem_wb,
        alu_src_2_mem => alu_src_2_mem_wb,
        mem_out => mem_out_mem_wb,
        -- inputs from FU
        alu_src_1_sel => alu_src_1_SEL,
        -- ouputs 
        alu_src_1 => alu_src_1_FW_MUX
    );

    executeMuxAluSrc2 : FW_MUX_2 PORT MAP(
        in_port_ex_mem => inport_data_ex_mem,
        in_port_mem_wb => inport_data_mem_wb,
        -- inputs from D/EX
        alu_src_2_d => alu_src_2_id_ex,
        -- inputs from EX/MEM
        alu_out_ex => alu_out_ex_mem,
        alu_src_2_ex => alu_src_2_ex_mem,
        -- inputs from MEM/WB
        alu_out_mem => alu_out_mem_wb,
        alu_src_2_mem => alu_src_2_mem_wb,
        mem_out => mem_out_mem_wb,
        -- inputs from FU
        alu_src_2_sel => alu_src_2_SEL,
        -- ouputs 
        alu_src_2 => alu_src_2_FW_MUX
    );

    executeALU : alu GENERIC MAP(
        32) PORT MAP (
        aluin1 => signed(alu_src_1_FW_MUX),
        aluin2 => signed(alu_src_2_FW_MUX),
        func => alu_op_id_ex,
        flagsin => flags_in_alu,
        flagsout => flags_out_alu,
        aluout => alu_out_ex
    );
    executeBU : BRANCH_UNIT_EX PORT MAP(
        is_call_jmp => call_jmp_id_ex(0),
        is_jz => is_jz_id_ex(0),
        zero_flag => flags_in_alu(0),

        is_jmp_tkn => flush_ex
    );

    executeFlagsReg : flags_register PORT MAP(
        clk => clk,
        reset => reset,
        wen => NOT flush_mem,
        zeroflag => flags_out_alu(0),
        negativeflag => flags_out_alu(1),
        carryflag => flags_out_alu(2),

        zeroflag_reg => flags_in_alu(0),
        negativeflag_reg => flags_in_alu(1),
        carryflag_reg => flags_in_alu(2)
    );

    alu_out_unsigned <= unsigned(alu_out_ex);
    executePipeReg : ex_mem_register GENERIC MAP(
        32, 3) PORT MAP (
        -- inputs
        clk => clk_internal,
        reset => reset_internal,
        push_pc => push_pc,
        alu_out => alu_out_unsigned,
        alu_src_2 => alu_src_2_FW_MUX,
        flags => flags_in_alu,
        ra1 => ra1_id_ex,
        ra2 => ra2_id_ex,
        rdst1 => wa1_id_ex,
        rdst2 => wa2_id_ex,
        reg_one_write => reg_one_write_id_ex,
        reg_two_write => reg_two_write_id_ex,
        stack_en => stack_en_id_ex,
        mem_read => mem_read_id_ex,
        mem_write => mem_write_id_ex,
        ret => ret_id_ex,
        push_pop => push_pop_id_ex,
        out_port_en => out_port_en_id_ex,
        ior => ior_id_ex,
        iow => iow_id_ex,
        inport_data => inport_data,
        mem_free => mem_free_id_ex,
        mem_protect => mem_protect_id_ex,
        wb_src => wb_src_id_ex,
        read_reg_one => read_reg_one_id_ex,
        read_reg_two => read_reg_two_id_ex,

        -- outputs
        push_pc_out => push_pc_ex_mem,
        alu_out_out => alu_out_ex_mem,
        alu_src_2_out => alu_src_2_ex_mem,
        flags_out => flags_ex_mem,
        ra1_out => ra1_ex_mem,
        ra2_out => ra2_ex_mem,
        rdst1_out => rd1_ex_mem,
        rdst2_out => rd2_ex_mem,
        reg_one_write_out => reg_one_write_ex_mem,
        reg_two_write_out => reg_two_write_ex_mem,
        stack_en_out => stack_en_ex_mem,
        mem_read_out => mem_read_ex_mem,
        mem_write_out => mem_write_ex_mem,
        ret_out => ret_ex_mem,
        push_pop_out => push_pop_ex_mem,
        out_port_en_out => out_port_en_ex_mem,
        ior_out => ior_ex_mem,
        iow_out => iow_ex_mem,
        inport_data_out => inport_data_ex_mem,
        mem_free_out => mem_free_ex_mem,
        mem_protect_out => mem_protect_ex_mem,
        wb_src_out => wb_src_ex_mem,
        read_reg_one_out => read_reg_one_ex_mem,
        read_reg_two_out => read_reg_two_ex_mem
    );
    ------------------------- execute stage port maps end ------------------

    ------------------------- memory stage port maps start ------------------

    memorySP : SP_REG PORT MAP(
        clk => clk,
        reset => reset,
        int => interrupt,
        stack_en => stack_en_ex_mem(0),
        push_pop => push_pop_ex_mem(0),
        sp_out => sp
    );
    memoryMuxAddr : muxtomemory GENERIC MAP(
        12) PORT MAP (
        push_pop => push_pop_ex_mem,
        stack_en => stack_en_ex_mem,
        sp => sp,
        ea => alu_src_2_ex_mem(11 DOWNTO 0),
        address_mem_in => address_mem_in
    );

    memoryBranchMem : BRANCH_UNIT_MEM PORT MAP(
        IS_RET_RTI => ret_ex_mem(0),

        IS_JMP_TKN => flush_mem
    );

    memoryDataMemory : memory GENERIC MAP(
        16, 12) PORT MAP (
        rst => reset,
        clk => clk,
        push_pc => push_pc_ex_mem,
        memr => mem_read_ex_mem(0),
        memw => mem_write_ex_mem(0),
        protect => mem_protect_ex_mem(0),
        free => mem_free_ex_mem(0),
        address_bus => STD_LOGIC_VECTOR(address_mem_in),
        datain => STD_LOGIC_VECTOR(alu_out_ex_mem),
        -- outputs
        memout => mem_out_DME_in,
        alu_src_2 => flags_ex_mem & alu_src_2_ex_mem(28 downto 0),
        pc_rst_val => pc_rst_val_in,
        pc_int_val => pc_int_val_in
    );
    mem_out_DMEM <= unsigned(mem_out_DME_in);
    pc_rst_val <= unsigned(pc_rst_val_in);
    pc_int_val <= unsigned(pc_int_val_in);

    memoryPipeReg : mem_wb_register GENERIC MAP(
        32, 3) PORT MAP (
        clk => clk_internal,
        reset => reset_internal,
        ALU_OUT => alu_out_ex_mem,
        ALU_SRC_2 => alu_src_2_ex_mem,
        MEM_OUT => mem_out_DMEM,
        ra1 => ra1_ex_mem,
        ra2 => ra2_ex_mem,
        rdst1 => rd1_ex_mem,
        rdst2 => rd2_ex_mem,
        reg_one_write => reg_one_write_ex_mem,
        reg_two_write => reg_two_write_ex_mem,
        out_port_en => out_port_en_ex_mem,
        ior => ior_ex_mem,
        iow => iow_ex_mem,
        inport_data => inport_data_ex_mem,
        wb_src => wb_src_ex_mem,
        read_reg_one => read_reg_one_ex_mem,
        read_reg_two => read_reg_two_ex_mem,

        ALU_OUT_out => alu_out_mem_wb,
        ALU_SRC_2_out => alu_src_2_mem_wb,
        MEM_OUT_out => mem_out_mem_wb,
        ra1_out => ra1_mem_wb,
        ra2_out => ra2_mem_wb,
        rdst1_out => rd1_mem_wb,
        rdst2_out => rd2_mem_wb,
        reg_one_write_out => reg_one_write_mem_wb,
        reg_two_write_out => reg_two_write_mem_wb,
        out_port_en_out => out_port_en_mem_wb,
        ior_out => ior_mem_wb,
        iow_out => iow_mem_wb,
        inport_data_out => inport_data_mem_wb,
        wb_src_out => wb_src_mem_wb,
        read_reg_one_out => read_reg_one_mem_wb,
        read_reg_two_out => read_reg_two_mem_wb
    );

    ------------------------- memory stage port maps end ------------------
    ------------------------- wb stage port maps start ------------------
    wb_PORTS : ports_reg
    GENERIC MAP(32)
    PORT MAP(
        clk => clk_internal,
        reset => reset_internal,
        wr_en_in => inport_en_external_device,
        wr_en_out => out_port_en_mem_wb,
        inport => inport_external_device,
        outport => alu_out_mem_wb,
        inPortReg => inport,
        outPortReg => outport
    );

    wb_STAGE_SRC_MUX : wb_src_mux
    GENERIC MAP(32)
    PORT MAP(
        memout => mem_out_mem_wb,
        aluout => alu_out_mem_wb,
        imm => alu_src_2_mem_wb,
        inport => inport_data_mem_wb,
        wbsrc => wb_src_mem_wb,
        regwritedata => regWriteData
    );

    ------------------------- wb stage port maps end ------------------

    ------------------------- other components port map start ---------
    i_o : io GENERIC MAP(
        32) PORT MAP (
        inport => port_in,
        data_in => rd1_id_ex,
        ior => ior_id_ex,
        iow => iow_id_ex,
        outport => port_out,
        data_out => inport_data,
        clk => clk,
        reset => reset
    );

    int_cu: icu port map (
        clk => clk,
        reset => reset,
        int => int_id_ex,
        push_pc => push_pc
    );

    F_U : FU PORT MAP(
        rsrc1_d_ex => STD_LOGIC_VECTOR(ra1_id_ex),
        rsrc2_d_ex => STD_LOGIC_VECTOR(ra2_id_ex),
        read_reg_1 => read_reg_one_id_ex(0),
        read_reg_2 => read_reg_two_id_ex(0),
        reg_w1_ex_mem => reg_one_write_ex_mem(0),
        reg_w2_ex_mem => reg_two_write_ex_mem(0),
        rdst1_ex_mem => STD_LOGIC_VECTOR(rd1_ex_mem),
        rdst2_ex_mem => STD_LOGIC_VECTOR(rd2_ex_mem),
        wb_src_ex_mem => STD_LOGIC_VECTOR(wb_src_ex_mem),
        ior_ex_mem => ior_ex_mem(0),
        reg_w1_mem_wb => reg_one_write_mem_wb(0),
        reg_w2_mem_wb => reg_two_write_mem_wb(0),
        ior_mem_wb => ior_mem_wb(0),
        rdst1_mem_wb => STD_LOGIC_VECTOR(rd1_mem_wb),
        rdst2_mem_wb => STD_LOGIC_VECTOR(rd2_mem_wb),
        wb_src_mem_wb => STD_LOGIC_VECTOR(wb_src_mem_wb),
        rsrc1_d_ex_sel => alu_src_1_SEL,
        rsrc2_d_ex_sel => alu_src_2_SEL
        );
        ------------------------- other components port map end -----------
        
END ARCHITECTURE archProcessor;