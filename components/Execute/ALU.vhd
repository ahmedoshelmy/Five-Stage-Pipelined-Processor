library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
 generic (n : integer := 32);
  port (
        aluIn1, aluIn2  : IN signed     (n-1 Downto 0);
        func            : IN unsigned   (3 Downto 0);
        cin             : IN unsigned   (0 Downto 0);
        flagsIn         : IN unsigned   (2 Downto 0);
        flagsOut        : OUT unsigned  (2 Downto 0);
        aluOut          : OUT signed    (n-1 Downto 0)
    );
end entity;

architecture archALU of ALU is
    -- no operands operations
    constant ALU_NOP : unsigned(3 Downto 0) := x"0";
    -- one operands operations
    constant ALU_NOT : unsigned(3 Downto 0) := x"1";
    constant ALU_NEG : unsigned(3 Downto 0) := x"2";
    constant ALU_INC : unsigned(3 Downto 0) := x"3";
    constant ALU_DEC : unsigned(3 Downto 0) := x"4";
    -- play with one operand
    constant ALU_BITSET : unsigned(3 Downto 0) := x"5";
    constant ALU_RCL    : unsigned(3 Downto 0) := x"6";
    constant ALU_RCR    : unsigned(3 Downto 0) := x"7";
    -- two operands operations
    constant ALU_ADD : unsigned(3 Downto 0) := x"9";
    constant ALU_SUB : unsigned(3 Downto 0) := x"A"; -- aluIn1 - aluIn2
    constant ALU_AND : unsigned(3 Downto 0) := x"B";
    constant ALU_OR  : unsigned(3 Downto 0) := x"C";
    constant ALU_XOR : unsigned(3 Downto 0) := x"D";
    -- buffers
    constant ALU_BUFF1 : unsigned(3 Downto 0) := x"E"; -- same as SWAP => output = aluIn1
    constant ALU_BUFF2 : unsigned(3 Downto 0) := x"F";  -- output = aluIn2


    begin
        -- concurrent statements
        process (aluIn1, aluIn2, func, cin) is
            variable aluOutReg : signed(n-1 downto 0);
            variable flagOutVar : unsigned(2 downto 0);
            variable CarryOnRight : signed(n downto 0) := (others => '0');
            variable CarryOnLeft : signed(n downto 0) := (others => '0');
            variable CarryO : signed(n downto 0) := (others => '0');
        begin
            -- main role
            aluOut <= aluOutReg;
            flagsOut <= flagOutVar;
            -- main alu operation
            case func is
                when ALU_NOT =>
                    aluOutReg := not aluIn1;
                when ALU_NEG =>
                    aluOutReg := (0 - aluIn1);
                when ALU_INC =>
                    aluOutReg := aluIn1 + 1;
                when ALU_DEC =>
                    aluOutReg := aluIn1 - 1; 

                --- !! TODO: implement these operations
                when ALU_BITSET =>
                    flagOutVar(2) := aluIn1(to_integer(unsigned(aluIn2)));
                    aluOutReg := (aluIn1 or (2 * aluIn2 )); 

                when ALU_RCL =>
                    CarryOnLeft(n-1 downto 0) := aluIn1(n-1 downto 0);
                    CarryOnLeft(n) := cin(0);
                    CarryO := CarryOnLeft rol to_integer(unsigned(aluIn2));
                    
                    aluOutReg := CarryO(n-1 downto 0);
                    flagOutVar(2)    := CarryO(n);
                    
                when ALU_RCR =>
                    CarryOnRight(n downto 1) := aluIn1(n-1 downto 0);
                    CarryOnRight(0) := cin(0);
                    CarryO := CarryOnLeft ror to_integer(unsigned(aluIn2));

                    aluOutReg := CarryO(n downto 1);
                    flagOutVar(2)    := CarryO(0);
                
                -- two operands
                when ALU_ADD =>
                    aluOutReg := signed(aluIn1) + signed(aluIn2);
                when ALU_SUB =>
                    aluOutReg := signed(aluIn1) - signed(aluIn2);
                when ALU_AND =>
                    aluOutReg := aluIn1 and aluIn2;
                when ALU_OR =>
                    aluOutReg := aluIn1 or aluIn2;
                when ALU_XOR =>
                    aluOutReg := aluIn1 xor aluIn2;
                -- buffers
                when ALU_BUFF1 =>
                    aluOutReg := aluIn1;
                when ALU_BUFF2 =>
                    aluOutReg := aluIn2;
    
                -- unknown operation, NOP, or '-', 'z', 'x', etc => output = Z
                when others =>
                    aluOutReg := (others => 'Z');

            end case;

            -- keep flags if NOP 
            -- !TODO: check if there's another operations that not affect flags
            if (func = ALU_NOP) then
                flagOutVar := flagsIn;
            else  
                flagOutVar(0) := '1' when aluOutReg = 0 else '0'; -- Z
                flagOutVar(1) := '1' when aluOutReg < 0 else '0'; -- N
            end if;

            

        end process;
end archALU ; -- archALU
