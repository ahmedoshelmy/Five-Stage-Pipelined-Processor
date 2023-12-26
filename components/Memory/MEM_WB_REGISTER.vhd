library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MEM_WB_REGISTER IS
    generic (
        regWidth : integer := 32;
        regAddrWidth : integer := 3
    );
    PORT (
        clk, reset   : in  unsigned (0 downto 0);

        ALU_OUT, ALU_SRC_2, MEM_OUT :   IN unsigned(regWidth-1 DOWNTO 0);
        ra1, ra2, rdst1, rdst2 : IN unsigned(regAddrWidth-1 DOWNTO 0); 
        reg_one_write, reg_two_write       : IN unsigned (0 downto 0);
        wb_src : IN unsigned (1 downto 0);
        out_port_en : IN unsigned (0 downto 0);
        ior, iow : IN unsigned (0 downto 0);
        inport_data : IN unsigned (regWidth-1 DOWNTO 0);
        read_reg_one, read_reg_two         : IN  unsigned (0 downto 0);
        
        -- outputs
        ALU_OUT_out,ALU_SRC_2_out, MEM_OUT_out :   out unsigned(regWidth-1 DOWNTO 0);
        ra1_out, ra2_out, rdst1_out, rdst2_out : out unsigned(regAddrWidth-1 DOWNTO 0); 
        reg_one_write_out, reg_two_write_out       : out unsigned (0 downto 0);
        wb_src_out                             : out unsigned (1 downto 0);
        out_port_en_out : out unsigned (0 downto 0);
        ior_out, iow_out : out unsigned (0 downto 0);
        inport_data_out : out unsigned (regWidth-1 DOWNTO 0);
        read_reg_one_out, read_reg_two_out         : out  unsigned (0 downto 0)
    
    );
END ENTITY MEM_WB_REGISTER;

ARCHITECTURE Behavioral OF MEM_WB_REGISTER IS

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = "1" THEN
            -- Synchronous reset
            ALU_OUT_out <= (OTHERS => '0');
            ALU_SRC_2_out <= (OTHERS => '0');
            MEM_OUT_out <= (OTHERS => '0');
            ra1_out <= (OTHERS => '0');
            ra2_out <= (OTHERS => '0');
            rdst1_out <= (OTHERS => '0');
            rdst2_out <= (OTHERS => '0');
            reg_one_write_out <= "0";
            reg_two_write_out <= "0";
            wb_src_out <= (OTHERS => '0');
            out_port_en_out <= "0";
            ior_out <= "0";
            iow_out <= "0";
            inport_data_out <= (OTHERS => '0');
            read_reg_one_out <= "0";
            read_reg_two_out <= "0";
        ELSIF (clk'event and clk = "1") THEN
            -- Synchronous behavior
            ALU_OUT_out <= ALU_OUT; 
            ALU_SRC_2_out <= ALU_SRC_2; 
            MEM_OUT_out <= MEM_OUT; 
            ra1_out <= ra1; 
            ra2_out <= ra2; 
            rdst1_out <= rdst1; 
            rdst2_out <= rdst2; 
            reg_one_write_out <= reg_one_write ;
            reg_two_write_out <= reg_two_write ;
            wb_src_out <= wb_src; 
            out_port_en_out <= out_port_en ;
            ior_out <= ior ;
            iow_out <= iow ;
            inport_data_out <= inport_data ;
            read_reg_one_out <= read_reg_one ;
            read_reg_two_out <= read_reg_two ;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;