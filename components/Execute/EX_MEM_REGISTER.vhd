library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY EX_MEM_REGISTER IS
generic (
    regWidth : integer := 32;
    regAddrWidth : integer := 3
);
    PORT (
        clk, reset       : in  unsigned (0 downto 0);

        ALU_OUT :   IN unsigned(regWidth-1 DOWNTO 0);
        ALU_SRC_2 : IN unsigned(regWidth-1 DOWNTO 0);

        ra1, ra2, rdst1, rdst2 : IN unsigned(regAddrWidth-1 DOWNTO 0); 
        -- control signals
        reg_one_write, reg_two_write       : IN unsigned (0 downto 0);
        stack_en, mem_read,  mem_write     : IN unsigned (0 downto 0);
        ret, push_pop, out_port_en         : IN unsigned (0 downto 0);
        ior, iow                           : IN unsigned (0 downto 0);
        inport_data                        : IN unsigned (regWidth-1 DOWNTO 0);
        mem_free, mem_protect              : IN unsigned (0 downto 0);
        wb_src                             : IN unsigned (1 downto 0);
        read_reg_one, read_reg_two         : IN  unsigned (0 downto 0);



        -- outputs
        ALU_OUT_out :   out unsigned(regWidth-1 DOWNTO 0);
        ALU_SRC_2_out : out unsigned(regWidth-1 DOWNTO 0);

        ra1_out, ra2_out, rdst1_out, rdst2_out : out unsigned(regAddrWidth-1 DOWNTO 0); 
        -- control signals
        reg_one_write_out, reg_two_write_out       : out unsigned (0 downto 0);
        stack_en_out, mem_read_out,  mem_write_out     : out unsigned (0 downto 0);
        ret_out, push_pop_out, out_port_en_out         : out unsigned (0 downto 0);
        ior_out, iow_out                           : out unsigned (0 downto 0);
        inport_data_out                        : out unsigned (regWidth-1 DOWNTO 0);
        mem_free_out, mem_protect_out              : out unsigned (0 downto 0);
        wb_src_out                             : out unsigned (1 downto 0);
        read_reg_one_out, read_reg_two_out         : out  unsigned (0 downto 0)

    );
END ENTITY EX_MEM_REGISTER;

ARCHITECTURE Behavioral OF EX_MEM_REGISTER IS

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = "1" THEN
            -- Synchronous reset
            ALU_OUT_out <= (OTHERS => '0');
            ALU_SRC_2_out <= (OTHERS => '0');
            ra1_out <= (OTHERS => '0');
            ra2_out <= (OTHERS => '0');
            rdst1_out <= (OTHERS => '0');
            rdst2_out <= (OTHERS => '0');
            wb_src_out <= (OTHERS => '0');
            
            reg_one_write_out <= "0";
            reg_two_write_out <= "0";

            stack_en_out <= "0";
            mem_read_out <= "0";
            mem_write_out <= "0";

            ret_out <= "0";
            push_pop_out <= "0";
            out_port_en_out <= "0";
            ior_out <= "0";
            iow_out <= "0";
            inport_data_out <= (OTHERS => '0');

            mem_free_out <= "0";
            mem_protect_out <= "0";
                   
            read_reg_one_out <= "0";
            read_reg_two_out <= "0";
               
        elsif (clk'event and clk = "1") then
            -- Synchronous behavior
            ALU_OUT_out <= ALU_OUT;
            ALU_SRC_2_out <= ALU_SRC_2;
            ra1_out <= ra1;
            ra2_out <= ra2;
            rdst1_out <= rdst1;
            rdst2_out <= rdst2;
            wb_src_out <= wb_src;
            
            reg_one_write_out <= reg_one_write ;
            reg_two_write_out <= reg_two_write ;
            stack_en_out <= stack_en ;
            mem_read_out <= mem_read ;
            mem_write_out <= mem_write ;
            ret_out <= ret ;
            push_pop_out <= push_pop ;
            out_port_en_out <= out_port_en ;
            ior_out <= ior ;
            iow_out <= iow ;
            inport_data_out <= inport_data ;
            mem_free_out <= mem_free ;
            mem_protect_out <= mem_protect ;
            read_reg_one_out <= read_reg_one ;
            read_reg_two_out <= read_reg_two ;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;