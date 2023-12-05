library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
    port (
        clk, reset, interrupt : in  std_logic;
        port_in               : in  std_logic_vector(31 downto 0);
        port_out              : out std_logic_vector(31 downto 0)
    );
end entity processor;

architecture archProcessor of processor is
------------------------- fetch stage signals start -------------------
    signal pc                : unsigned(31 downto 0) := (others => '0');
    signal instruction       : std_logic_vector(15 downto 0) := (others => '0');
    signal instruction_if_ex : std_logic_vector(15 downto 0) := (others => '0');
    signal pc_if_ex          : std_logic_vector(31 downto 0) := (others => '0');
    signal next_pc_src       : unsigned(31 downto 0) := (others => '0');
------------------------- fetch stage signals end ---------------------

------------------------- decode stage signals start ------------------
    signal ra1                 : unsigned (2 downto 0) := (others => '0');
    signal ra2                 : unsigned (2 downto 0) := (others => '0');
    signal wa1                 : unsigned (2 downto 0) := (others => '0');
    signal wa2                 : unsigned (2 downto 0) := (others => '0');
    signal rd1                 : unsigned(31 downto 0) := (others => '0');
    signal rd2                 : unsigned(31 downto 0) := (others => '0');
    signal alu_src_2           : unsigned(31 downto 0) := (others => '0');
    signal rd1_id_ex           : unsigned(31 downto 0) := (others => '0');
    signal rd2_id_ex           : unsigned(31 downto 0) := (others => '0');
    signal alu_src_2_id_ex     : unsigned(31 downto 0) := (others => '0');
    signal ra1_id_ex           : unsigned (2 downto 0) := (others => '0');
    signal ra2_id_ex           : unsigned (2 downto 0) := (others => '0');
    signal wa1_id_ex           : unsigned (2 downto 0) := (others => '0');
    signal wa2_id_ex           : unsigned (2 downto 0) := (others => '0');
    signal reg_one_write_id_ex : unsigned (0 downto 0) :=             "0";
    signal reg_two_write_id_ex : unsigned (0 downto 0) :=             "0";
    signal stack_en_id_ex      : unsigned (0 downto 0) :=             "0";
    signal mem_read_id_ex      : unsigned (0 downto 0) :=             "0";
    signal mem_write_id_ex     : unsigned (0 downto 0) :=             "0";
    signal call_jmp_id_ex      : unsigned (0 downto 0) :=             "0";
    signal ret_id_ex           : unsigned (0 downto 0) :=             "0";
    signal push_pop_id_ex      : unsigned (0 downto 0) :=             "0";
    signal out_port_en_id_ex   : unsigned (0 downto 0) :=             "0";
    signal mem_free_id_ex      : unsigned (0 downto 0) :=             "0";
    signal mem_protect_id_ex   : unsigned (0 downto 0) :=             "0";
    signal read_reg_one_id_ex  : unsigned (0 downto 0) :=             "0";
    signal read_reg_two_id_ex  : unsigned (0 downto 0) :=             "0";
    signal alu_op_id_ex        : unsigned (3 downto 0) := (others => '0');
    signal wb_src_id_ex        : unsigned (1 downto 0) := (others => '0');
------------------------- decode stage signals end --------------------

------------------------- execute stage signals start --------------------
    signal alu_src_2_FW_MUX   : unsigned        (31 downto 0) := (others => '0');
    signal alu_src_1_FW_MUX   : unsigned        (31 downto 0) := (others => '0');
    signal flags_in_alu       : unsigned        (2 downto 0) := (others => '0');
    signal flags_out_alu       : unsigned        (2 downto 0) := (others => '0');

    signal alu_out_ex     : signed        (31 downto 0) := (others => '0');
    -- output from pipeline reg
    signal alu_out_ex_mem     : unsigned        (31 downto 0) := (others => '0');
    signal alu_src_2_ex_mem   : unsigned        (31 downto 0) := (others => '0');
    signal ra1_ex_mem         : unsigned        (2 downto 0) := (others => '0');
    signal ra2_ex_mem         : unsigned        (2 downto 0) := (others => '0');
    signal rd1_ex_mem         : unsigned        (2 downto 0) := (others => '0');
    signal rd2_ex_mem         : unsigned        (2 downto 0) := (others => '0');

    signal reg_one_write_ex_mem : unsigned (0 downto 0) :=             "0";
    signal reg_two_write_ex_mem : unsigned (0 downto 0) :=             "0";
    signal wb_src_ex_mem        : unsigned (1 downto 0) := (others => '0');
    signal stack_en_ex_mem       : unsigned (0 downto 0) :=             "0";
    signal mem_read_ex_mem      : unsigned (0 downto 0) :=             "0";
    signal mem_write_ex_mem     : unsigned (0 downto 0) :=             "0";
    signal push_pop_ex_mem      : unsigned (0 downto 0) :=             "0";
    signal out_port_en_ex_mem    : unsigned (0 downto 0) :=             "0";
    signal mem_free_ex_mem       : unsigned (0 downto 0) :=             "0";
    signal mem_protect_ex_mem    : unsigned (0 downto 0) :=             "0";
    signal read_reg_one_ex_mem  : unsigned (0 downto 0) :=             "0";
    signal read_reg_two_ex_mem  : unsigned (0 downto 0) :=             "0";
    signal ret_ex_mem            : unsigned (0 downto 0) :=             "0";

------------------------- execute stage signals end --------------------

------------------------- forwarding unit signals start ------------------
    signal alu_src_1_SEL   : unsigned        (2 downto 0) := (others => '0');
    signal alu_src_2_SEL   : unsigned        (2 downto 0) := (others => '0');
------------------------- forwarding unit signals end ------------------

------------------------- memory stage signals start -----------------
    signal sp                   : unsigned        (31 downto 0) := (others => '0');
    -- signal stack_en_ex_mem      : unsigned         (0 downto 0) :=             "0";
    signal write_sp_data_ex_mem : unsigned        (31 downto 0) := (others => '0');  
    signal pc_rst_val, pc_int_val  : unsigned(31 downto 0) := (others => '0'); 
    
    signal mem_out_DMEM         : unsigned(31 downto 0) := (others => '0');

    signal alu_out_mem_wb     : unsigned        (31 downto 0) := (others => '0');
    signal alu_src_2_mem_wb   : unsigned        (31 downto 0) := (others => '0');
    signal mem_out_mem_wb   : unsigned        (31 downto 0) := (others => '0');
------------------------- write back stage signals start --------------
    signal wa1_mem_wb           : unsigned         (2 downto 0) := (others => '0');
    signal wa2_mem_wb           : unsigned         (2 downto 0) := (others => '0');
    signal regWriteData         : unsigned        (31 downto 0) := (others => '0');
    --signal alu_src_2_mem_wb     : unsigned        (31 downto 0) := (others => '0');
    signal reg_one_write_mem_wb : unsigned         (0 downto 0) :=             "0";
    signal reg_two_write_mem_wb : unsigned         (0 downto 0) :=             "0";
    signal pc_mem_wb            : std_logic_vector(31 downto 0) := (others => '0');
------------------------- write back stage signals end ----------------
    
------------------------- control signals start -----------------------
    signal imm_en        : std_logic            :=             '0';
    signal stall         : std_logic            :=             '0';
    signal reg_one_write : unsigned(0 downto 0) :=             "0";
    signal reg_two_write : unsigned(0 downto 0) :=             "0";
    signal rs1_rd        : unsigned(0 downto 0) :=             "0";
    signal rs2_rd        : unsigned(0 downto 0) :=             "0";
    signal alu_src       : unsigned(1 downto 0) := (others => '0');
    signal out_port_en   : unsigned(0 downto 0) :=             "0";
    signal one_two_op    : unsigned(0 downto 0) :=             "0";
    signal alu_op        : unsigned(3 downto 0) := (others => '0');
    signal wb_src        : unsigned(1 downto 0) := (others => '0');
    signal stack_en      : unsigned(0 downto 0) :=             "0";
    signal mem_read      : unsigned(0 downto 0) :=             "0";
    signal mem_write     : unsigned(0 downto 0) :=             "0";
    signal mem_free      : unsigned(0 downto 0) :=             "0";
    signal mem_protect   : unsigned(0 downto 0) :=             "0";
    signal push_pop      : unsigned(0 downto 0) :=             "0";
    signal call_jmp      : unsigned(0 downto 0) :=             "0";
    signal ret           : unsigned(0 downto 0) :=             "0";
    signal read_reg_one  : unsigned(0 downto 0) :=             "0";
    signal read_reg_two  : unsigned(0 downto 0) :=             "0";
------------------------- control signals end -------------------------

------------------------- internal signals start ----------------------
    signal instruction_internal : unsigned (6 downto 0) := (others => '0');
    signal imm_en_internal      : unsigned (0 downto 0) :=             "0";
    signal rs1_internal         : unsigned (2 downto 0) := (others => '0');
    signal rs2_internal         : unsigned (2 downto 0) := (others => '0');
    signal rd_internal          : unsigned (2 downto 0) := (others => '0');
    signal clk_internal         : unsigned (0 downto 0) :=             "0";
    signal reset_internal       : unsigned (0 downto 0) :=             "0";
    signal imm_internal         : unsigned(15 downto 0) := (others => '0');
    signal pc_internal          : unsigned(31 downto 0) := (others => '0');
    signal stall_internal       : unsigned (0 downto 0) :=             "0";
    signal alu_out_unsigned     : unsigned(31 downto 0) := (others => '0');
------------------------- internal signals end ------------------------

------------------------- Branching signals start ---------------------
signal flush_ex : std_logic := '0';
signal flush_mem : std_logic := '0';
------------------------- Branching signals end ---------------------

------------------------- fetch stage start ---------------------------
    component instruction_memory is
        port (
            clk, reset : in std_logic;
            address : in std_logic_vector(11 downto 0);
            dataout : out std_logic_vector(15 downto 0)
        );
    end component;

    component if_ex_register is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            int   : in std_logic;

            instruction : in std_logic_vector(15 downto 0);
            pc : in std_logic_vector(31 downto 0);
            enable : in std_logic;
            
            instruction_if_ex : out std_logic_vector(15 downto 0);
            pc_if_ex : out std_logic_vector(31 downto 0)
        );
    end component if_ex_register;

    component PC_REG IS
    PORT (
        CLK, RESET, INT, WEN : IN STD_LOGIC;
        RST_val, INT_val, PC_IN : IN unsigned(11 DOWNTO 0);
        PC_OUT : OUT unsigned(11 DOWNTO 0)
    );
    END component PC_REG;

    component PC_SRC_MUX is
         port (
                memOut, aluSrc2, next_pc      : IN unsigned     (31 Downto 0);
                FLUSH_MEM, FLUSH_EX           : IN std_logic ;
                PC_OUT                        : OUT unsigned     (31 Downto 0)
           );
    end component;
------------------------- fetch stage end ---------------------------

------------------------- decode stage start ------------------------
    component alu_src_2_mux is
        port (
            rd2, pc   : in  unsigned(31 downto 0);
            imm       : in  unsigned(15 downto 0);
            alu_src   : in  unsigned (1 downto 0);
            alu_src_2 : out unsigned(31 downto 0)
        );
    end component alu_src_2_mux;

    component rs1_rd_mux is
        port (
            rs1, rd   : in  unsigned(2 downto 0);
            rs1_rd    : in  unsigned(0 downto 0);
            ra1       : out unsigned(2 downto 0)
        );
    end component rs1_rd_mux;

    component rs2_rd_mux is
        port (
            rs2, rd   : in  unsigned(2 downto 0);
            rs2_rd    : in  unsigned(0 downto 0);
            ra2       : out unsigned(2 downto 0)
        );
    end component rs2_rd_mux;

    component cu is
        port (
            instruction    : in  unsigned(6 downto 0);
            reg_one_write  : out unsigned(0 downto 0);
            reg_two_write  : out unsigned(0 downto 0);
            rs1_rd, rs2_rd : out unsigned(0 downto 0);
            alu_src        : out unsigned(1 downto 0);
            out_port_en    : out unsigned(0 downto 0);
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
    end component cu;

    component hdu is
        port (
            old_dst, cur_ra_one, cur_ra_two                     : in  unsigned(2 downto 0);
            reg_write_one, mem_read, read_reg_one, read_reg_two : in  unsigned(0 downto 0);
            stall                                               : out unsigned(0 downto 0)
        );
    end component hdu;

    component id_ex_register is
        port (
            clk, reset, en                                      : in  unsigned (0 downto 0);
            rd1_in, alu_src_2_in                                : in  unsigned(31 downto 0);
            ra1_in, ra2_in, rdst1_in, rdst2_in                  : in  unsigned (2 downto 0);
            reg_one_write_in, reg_two_write_in, stack_en_in     : in  unsigned (0 downto 0);
            mem_read_in, mem_write_in, call_jmp_in, ret_in      : in  unsigned (0 downto 0);
            push_pop_in, out_port_en_in                         : in  unsigned (0 downto 0);
            mem_free_in, mem_protect_in                         : in  unsigned (0 downto 0);
            read_reg_one_in, read_reg_two_in                    : in  unsigned (0 downto 0);
            alu_op_in                                           : in  unsigned (3 downto 0);
            wb_src_in                                           : in  unsigned (1 downto 0);        
            rd1_out, alu_src_2_out                              : out unsigned(31 downto 0);
            ra1_out, ra2_out, rdst1_out, rdst2_out              : out unsigned (2 downto 0);
            reg_one_write_out, reg_two_write_out, stack_en_out  : out unsigned (0 downto 0);
            mem_read_out, mem_write_out, call_jmp_out, ret_out  : out unsigned (0 downto 0);
            push_pop_out, out_port_en_out                       : out unsigned (0 downto 0);
            mem_free_out, mem_protect_out                       : out unsigned (0 downto 0);
            read_reg_one_out, read_reg_two_out                  : out unsigned (0 downto 0);
            alu_op_out                                          : out unsigned (3 downto 0);
            wb_src_out                                          : out unsigned (1 downto 0)
        );
    end component id_ex_register;

    component regfile is
        generic (
            reg_width : integer := 32;
            reg_count : integer := 8
        );
        port (
            clk, rst, reg_one_write, reg_two_write, stack_en : in  unsigned                  (0 downto 0);
            ra1, ra2, wa1, wa2                               : in  unsigned                  (2 downto 0);
            wd1, wd2                                         : in  unsigned        (reg_width-1 downto 0);
            write_sp_data                                    : in  unsigned        (reg_width-1 downto 0);   
            rd1, rd2, read_sp_data                           : out unsigned        (reg_width-1 downto 0)
        );
    end component regfile;
------------------------- decode stage end --------------------------

-- ------------------------- execute stage start -----------------------
    component FW_MUX_1 is
        port (
                -- inputs from D/EX
                rd1_d_ex                                : IN unsigned     (31 Downto 0);
                -- inputs from EX/MEM
                alu_out_ex, alu_src_2_ex                : IN unsigned     (31 Downto 0);
                -- inputs from MEM/WB
                alu_out_mem, alu_src_2_mem, mem_out     : IN unsigned     (31 Downto 0);
                -- inputs from FU
                alu_src_1_sel                           : IN unsigned     (2 Downto 0);
                -- ouputs 
                alu_src_1                               : OUT unsigned    (31 Downto 0)
        );
    end component;
    component FW_MUX_2 is
         port (
                -- inputs from D/EX
                alu_src_2_d                             : IN unsigned     (31 Downto 0);
                -- inputs from EX/MEM
                alu_out_ex, alu_src_2_ex                : IN unsigned     (31 Downto 0);
                -- inputs from MEM/WB
                alu_out_mem, alu_src_2_mem, mem_out     : IN unsigned     (31 Downto 0);
                -- inputs from FU
                alu_src_2_sel                           : IN unsigned     (2 Downto 0);
                -- ouputs 
                alu_src_2                               : OUT unsigned    (31 Downto 0)
           );
    end component;
    
    component alu is
        generic (n : integer := 32);
        port (
            aluin1, aluin2  : in signed     (31 downto 0);
            func            : in unsigned   (3 downto 0);
            flagsin         : in unsigned  (2 downto 0);
            flagsout        : out unsigned  (2 downto 0);
            aluout          : out signed    (31 downto 0)
        );
    end component;

--     component branch_unit is
--         port (
--             is_call_jmp        : in std_logic;
--             is_jz              : in std_logic;
--             zero_flag          : in std_logic;

--             is_jmp_tkn         : out std_logic
--        );
--     end component;

    component ex_mem_register is
        generic (
            regwidth : integer := 32;
            regaddrwidth : integer := 3
        );
        port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        alu_out :   IN unsigned(regWidth-1 DOWNTO 0);
        alu_src_2 : IN unsigned(regWidth-1 DOWNTO 0);

        ra1, ra2, rdst1, rdst2 : IN unsigned(regAddrWidth-1 DOWNTO 0); 
        -- control signals
        reg_one_write, reg_two_write       : IN unsigned (0 downto 0);
        stack_en, mem_read,  mem_write     : IN unsigned (0 downto 0);
        ret, push_pop, out_port_en         : IN unsigned (0 downto 0);
        mem_free, mem_protect              : IN unsigned (0 downto 0);
        wb_src                             : IN unsigned (1 downto 0);
        read_reg_one, read_reg_two         : IN  unsigned (0 downto 0);



        -- outputs
        alu_out_out :   out unsigned(regWidth-1 DOWNTO 0);
        alu_src_2_out : out unsigned(regWidth-1 DOWNTO 0);

        ra1_out, ra2_out, rdst1_out, rdst2_out : out unsigned(regAddrWidth-1 DOWNTO 0); 
        -- control signals
        reg_one_write_out, reg_two_write_out       : out unsigned (0 downto 0);
        stack_en_out, mem_read_out,  mem_write_out     : out unsigned (0 downto 0);
        ret_out, push_pop_out, out_port_en_out         : out unsigned (0 downto 0);
        mem_free_out, mem_protect_out              : out unsigned (0 downto 0);
        wb_src_out                             : out unsigned (1 downto 0);
        read_reg_one_out, read_reg_two_out         : out  unsigned (0 downto 0)
    );
    end component ex_mem_register;

    component flags_register is
        port (
            clk : in std_logic;
            reset : in std_logic;
            wen : in std_logic;
    
            zeroflag, negativeflag, carryflag : in std_logic;
            zeroflag_reg, negativeflag_reg, carryflag_reg : out std_logic
        );
    end component;
-- ------------------------- execute stage end -------------------------

-- ------------------------- memory stage start ------------------------
--     component incrementer is
--         generic (
--             width : integer := 4
--         );
--         port (
--             in_value : in std_logic_vector(width - 1 downto 0);
--             out_value : out std_logic_vector(width - 1 downto 0)
--         );
--     end component incrementer;

--     component mem_wb_register is
--         port (
--             clk : in std_logic;
--             reset : in std_logic;

--             alu_out : in std_logic_vector(31 downto 0);
--             mem_out : in std_logic_vector(31 downto 0);
--             alu_src_2 : in std_logic_vector(31 downto 0);
--             reg_addr1, reg_addr2 : in std_logic_vector(2 downto 0); 
--             reg_write_1, reg_write_2 : in std_logic;
--             wb_src : in std_logic_vector(1 downto 0);
--             out_port_en : in std_logic;
            
--             reg_alu_out : out std_logic_vector(31 downto 0);
--             reg_mem_out : out std_logic_vector(31 downto 0);
--             reg_alu_src_2 : out std_logic_vector(31 downto 0);
--             reg_addr1_reg, reg_addr2_reg : out std_logic_vector(2 downto 0);
--             reg_write_1_reg, reg_write_2_reg : out std_logic;
--             reg_wb_src : out std_logic_vector(1 downto 0);
--             out_port_en_reg : out std_logic
--         );
--     end component mem_wb_register;

--     component memory is
--         generic (
--             cache_word_width : integer := 16;
--             address_bits : integer := 12
--         );
--         port (
--             en : in std_logic;
--             rst : in std_logic;
--             clk : in std_logic;
--             memr : in std_logic;
--             memw : in std_logic;
--             address_bus : in std_logic_vector(address_bits - 1 downto 0);
--             datain : in std_logic_vector(cache_word_width downto 0);
--             memout : out std_logic_vector(cache_word_width - 1 downto 0);
--             pc_rst_val, pc_int_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--         );
--     end component memory;

--     component muxtomemory is
--         generic (
--             ram_word_width : integer := 16;
--             address_bits : integer := 12
--         );
--         port (
--             clk : in std_logic;
--             push_pop : in std_logic;
--             stack_en : in std_logic;
--             sp : in std_logic_vector(address_bits - 1 downto 0); -- stack pointer
--             ea : in std_logic_vector(address_bits - 1 downto 0); -- effective address
--             sp_out : out std_logic_vector(address_bits - 1 downto 0);
--             address_mem_in : out std_logic_vector(ram_word_width - 1 downto 0)
--         );
--     end component muxtomemory;
-- ------------------------- memory stage end --------------------------

-- ------------------------- write back stage start --------------------
--     component ports_reg is
--         generic (n : integer := 32);
--         port (
--             clk, reset, wr_en             : in unsigned     (0 downto 0);
--             outport                       : in unsigned     (n-1 downto 0);
--             inport                        : out unsigned     (n-1 downto 0)
--         );
--     end component;

--     component wb_src_mux is
--         generic (n : integer := 32);
--         port (
--             memout, aluout, imm, inport   : in unsigned     (n-1 downto 0);
--             wbsrc                         : in unsigned     (1 downto 0);
--             regwritedata                  : out unsigned    (n-1 downto 0)
--         );
--     end component;
-- ------------------------- write back stage end ----------------------
begin
------------------------- fetch stage port maps start ----------------
    fetchMux: PC_SRC_MUX port map (
        memOut => mem_out_DMEM,
        aluSrc2 => alu_src_2_FW_MUX,
        next_pc => (pc+1),

        FLUSH_MEM => flush_mem,
        FLUSH_EX => flush_ex,
        PC_OUT => next_pc_src
    );
    fetchPcEG: PC_REG port map (
        CLK => clk,
        RESET => reset,
        INT => interrupt,
        WEN => "not"(stall),
        RST_val => pc_rst_val(11 downto 0),
        INT_val => pc_int_val(11 downto 0),
        PC_IN => next_pc_src(11 downto 0),
        PC_OUT => pc(11 downto 0)
    );

    fetchIMEM: instruction_memory port map (
        clk => clk,
        reset => reset,
        address => std_logic_vector(pc(11 downto 0)),
        dataout => instruction
    );

    fetchPipeREG: if_ex_register port map (
        clk => clk,
        reset => (reset or (not interrupt and (FLUSH_EX or FLUSH_MEM or imm_en))),
        int => interrupt,
        instruction => instruction,
        pc => std_logic_vector(pc),
        enable => "not"(stall),
        instruction_if_ex => instruction_if_ex,
        pc_if_ex => pc_if_ex
    );
------------------------- fetch stage port maps end ------------------

------------------------- decode stage port maps start ---------------
    instruction_internal <= unsigned(instruction_if_ex(15 downto 13) & instruction_if_ex(3 downto 0));
    imm_en_internal <= "" & imm_en; -- cool trick to convert std_logic to unsigned
    decode_CU: cu port map (
        instruction => instruction_internal,
        reg_one_write => reg_one_write,
        reg_two_write => reg_two_write,
        rs1_rd => rs1_rd,
        rs2_rd => rs2_rd,
        alu_src => alu_src,
        out_port_en => out_port_en,
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
        read_reg_two => read_reg_two
    );

    rs1_internal <= unsigned(instruction_if_ex(9 downto 7));
    rd_internal <= unsigned(instruction_if_ex(12 downto 10));
    decode_RS1MUX: rs1_rd_mux port map (
        rs1 => rs1_internal,
        rd => rd_internal,
        rs1_rd => rs1_rd,
        ra1 => ra1
    );

    rs2_internal <= unsigned(instruction_if_ex(6 downto 4));
    decode_RS2MUX: rs2_rd_mux port map (
        rs2 => rs2_internal,
        rd => rd_internal,
        rs2_rd => rs2_rd,
        ra2 => ra2
    );
    
    clk_internal <= "" & clk;
    reset_internal <= "" & reset;
    decode_REGFILE: regFile port map (
        clk => clk_internal,
        rst => reset_internal,
        reg_one_write => reg_one_write_mem_wb,
        reg_two_write => reg_two_write_mem_wb,
        stack_en => stack_en_ex_mem,
        ra1 => ra1,
        ra2 => ra2,
        wa1 => wa1_mem_wb,
        wa2 => wa2_mem_wb,
        wd1 => regWriteData, -- from wb_src_mux
        wd2 => alu_src_2_mem_wb, -- from mem_wb buffer
        write_sp_data => write_sp_data_ex_mem,
        rd1 => rd1,
        rd2 => rd2,
        read_sp_data => sp
    );

    imm_internal <= unsigned(instruction);
    pc_internal <= unsigned(pc);
    decode_ALU_SRC_MUX: alu_src_2_mux port map (
        rd2 => rd2,
        pc => pc_internal,
        imm => imm_internal,
        alu_src => alu_src,
        alu_src_2 => alu_src_2
    );

    stall_internal <= "" & stall;
    decodePipeReg: id_ex_register port map (
        clk => clk_internal,
        reset => reset_internal,
        en => "not"(stall_internal),
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
        ret_in => ret,
        push_pop_in => push_pop,
        out_port_en_in => out_port_en,
        mem_free_in => mem_free,
        mem_protect_in => mem_protect,
        read_reg_one_in => read_reg_one,
        read_reg_two_in => read_reg_two,
        alu_op_in => alu_op,
        wb_src_in => wb_src,

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
        ret_out => ret_id_ex,
        push_pop_out => push_pop_id_ex,
        out_port_en_out => out_port_en_id_ex,
        mem_free_out => mem_free_id_ex,
        mem_protect_out => mem_protect_id_ex,
        read_reg_one_out => read_reg_one_id_ex,
        read_reg_two_out => read_reg_two_id_ex,
        alu_op_out => alu_op_id_ex,
        wb_src_out => wb_src_id_ex
    );
------------------------- decode stage port maps end -----------------

------------------------- execute stage port maps start ------------------
------------------------- execute stage port maps end ------------------
    executeMuxAluSrc1: FW_MUX_1  port map (
        -- inputs from D/EX
        rd1_d_ex  => rd1_id_ex,
        -- inputs from EX/MEM
        alu_out_ex => alu_out_ex_mem, 
        alu_src_2_ex =>    alu_src_2_ex_mem,
        -- inputs from MEM/WB
        alu_out_mem => alu_out_mem_wb,
        alu_src_2_mem => alu_src_2_mem_wb,
        mem_out     => mem_out_mem_wb,
        -- inputs from FU
        alu_src_1_sel => alu_src_1_SEL,
        -- ouputs 
        alu_src_1  => alu_src_1_FW_MUX
    );

    executeMuxAluSrc2: FW_MUX_2  port map (
        -- inputs from D/EX
        alu_src_2_d  => alu_src_2_id_ex,
        -- inputs from EX/MEM
        alu_out_ex => alu_out_ex_mem, 
        alu_src_2_ex =>    alu_src_2_ex_mem,
        -- inputs from MEM/WB
        alu_out_mem => alu_out_mem_wb,
        alu_src_2_mem => alu_src_2_mem_wb,
        mem_out     => mem_out_mem_wb,
        -- inputs from FU
        alu_src_2_sel => alu_src_2_SEL,
        -- ouputs 
        alu_src_2  => alu_src_2_FW_MUX
    );

    alu_out_unsigned <= unsigned(alu_out_ex);
    executeALU: alu generic map(32) port map (
        aluin1 => signed(alu_src_1_FW_MUX),
        aluin2 => signed(alu_src_2_FW_MUX),
        func => alu_op_id_ex,
        flagsin => flags_in_alu,
        flagsout => flags_out_alu,
        aluout => alu_out_ex
    );

    executeFlagsReg: flags_register   port map (
        clk => clk,
        reset => reset,
        wen => not flush_mem,
        zeroflag => flags_out_alu(0),
        negativeflag => flags_out_alu(1),
        carryflag => flags_out_alu(2),

        zeroflag_reg => flags_in_alu(0),
        negativeflag_reg => flags_in_alu(1),
        carryflag_reg => flags_in_alu(2)
    );

    executePipeReg: ex_mem_register  generic map(32, 3) port map (
        -- inputs
        clk => clk,
        reset => reset,
        alu_out => alu_out_unsigned,
        alu_src_2 => alu_src_2_FW_MUX,

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
        mem_free => mem_free_id_ex,
        mem_protect => mem_protect_id_ex,
        wb_src => wb_src_id_ex,
        read_reg_one => read_reg_one_id_ex,
        read_reg_two => read_reg_two_id_ex,
        
        -- outputs
        alu_out_out => alu_out_ex_mem,
        alu_src_2_out => alu_src_2_ex_mem,
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
        mem_free_out => mem_free_ex_mem,
        mem_protect_out => mem_protect_ex_mem,
        wb_src_out => wb_src_ex_mem,
        read_reg_one_out => read_reg_one_ex_mem,
        read_reg_two_out => read_reg_two_ex_mem
    );
end architecture archProcessor;