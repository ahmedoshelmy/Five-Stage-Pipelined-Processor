library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTIONS_MEMORY is
    port(instruction: in std_logic_vector(15 downto 0);
        pc: in std_logic_vector (31 downto 0);
        inst_imm: out std_logic_vector (15 downto 0);
        clk: in std_logic;
        we: in std_logic
        );
end entity INSTRUCTIONS_MEMORY;
    
architecture INSTRUCTIONS_MEMORY_ARCH of INSTRUCTIONS_MEMORY is
    type inst_array is array(0 to 4095) of std_logic_vector (15 downto 0);
    signal instArray : inst_array;
    signal  i: std_logic_vector (11 downto 0):= (OTHERS => '0'); 
begin
    process(clk) is 
    begin
        if(rising_edge(clk)) then 
            if we = '1' then
                instArray(to_integer(unsigned(i)))<= std_logic_vector( signed( instruction ) );
                i <= std_logic_vector(to_unsigned(to_integer(unsigned( i )) + 1, 12));
            else inst_imm <= instArray(to_integer(unsigned(PC)));
            end if;
        end if;
    end process;
end architecture INSTRUCTIONS_MEMORY_ARCH;