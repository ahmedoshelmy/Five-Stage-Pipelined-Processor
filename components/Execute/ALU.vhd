library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
 generic (n : integer := 32);
  port (
        aluIn1, aluIn2  : IN signed     (n-1 Downto 0);
        func            : IN unsigned   (3 Downto 0);
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
        process (aluIn1, aluIn2, func, flagsIn) is
            variable CarryOnRight : signed(n downto 0) := (others => '0');
            variable CarryOnLeft : signed(n downto 0) := (others => '0');
            variable CarryO : signed(n downto 0) := (others => '0');
            variable aluOutVar : signed(n-1 downto 0) := (others => '0');
        begin


            case func is
                when ALU_NOT =>
                    aluOutVar := not aluIn1;
                when ALU_NEG =>
                    aluOutVar := (0 - aluIn1);
                when ALU_INC =>
                    CarryOnLeft := aluIn1 + 1;
                    aluOutVar := CarryOnLeft(n-1 downto 0);
                    flagsOut(2) <= CarryOnLeft(n); -- C
                when ALU_DEC =>
                    aluOutVar := aluIn1 - 1; 
                    flagsOut(2) <= '1' when aluIn1 = "0" else '0'; -- C

                --- !! TODO: implement these operations
                when ALU_BITSET =>
                    flagsOut(2) <= aluIn1(to_integer(unsigned(aluIn2)));
                    aluOutVar := (aluIn1 or (2 * aluIn2 )); 

                when ALU_RCL =>
                    CarryOnLeft(n-1 downto 0) := aluIn1(n-1 downto 0);
                    CarryOnLeft(n) := flagsIn(2);
                    CarryO := CarryOnLeft rol to_integer(unsigned(aluIn2));
                    
                    aluOutVar := CarryO(n-1 downto 0);
                    flagsOut(2)    <= CarryO(n);
                    
                when ALU_RCR =>
                    CarryOnRight(n downto 1) := aluIn1(n-1 downto 0);
                    CarryOnRight(0) := flagsIn(2);
                    CarryO := CarryOnLeft ror to_integer(unsigned(aluIn2));

                    aluOutVar := CarryO(n downto 1);
                    flagsOut(2)    <= CarryO(0);
                
                -- two operands
                -- TODO: check on flags
                when ALU_ADD =>
                    CarryOnLeft := resize(aluIn1, n+1) + resize(aluIn2, n+1);
                    aluOutVar   := CarryOnLeft(n-1 downto 0);
                    flagsOut(2) <= CarryOnLeft(n); -- C
                when ALU_SUB =>
                    CarryOnLeft := resize(aluIn1, n+1) - resize(aluIn2, n+1);
                    aluOutVar := CarryOnLeft(n-1 downto 0);
                    flagsOut(2) <= CarryOnLeft(n); -- C
                when ALU_AND =>
                    aluOutVar := aluIn1 and aluIn2;
                when ALU_OR =>
                    aluOutVar := aluIn1 or aluIn2;
                when ALU_XOR =>
                    aluOutVar := aluIn1 xor aluIn2;
                -- buffers
                when ALU_BUFF1 =>
                    aluOutVar := aluIn1;
                when ALU_BUFF2 =>
                    aluOutVar := aluIn2;
    
                -- unknown operation, NOP, or '-', 'z', 'x', etc => output = Z
                when others =>
                    aluOutVar := (others => '0');

            end case;

            -- main role
            -- main alu operation
                        -- keep flags if NOP 
            -- !TODO: check if there's another operations that not affect flags
            aluOut <= aluOutVar;
            if (func = ALU_NOP) then
                flagsOut <= flagsIn;
            else  
                flagsOut(0) <= '1' when signed(aluOutVar) = "0" else '0'; -- Z
                flagsOut(1) <= '1' when signed(aluOutVar) < 0 else '0'; -- N
                REPORT "flags changed: " & to_string(flagsOut) & " alu out: " & to_string(aluOut);
            end if;
        end process;
end archALU ; -- archALU