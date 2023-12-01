library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end ALU_tb;

architecture behavior of ALU_tb is 
    -- Component Declaration for the Unit Under Test (UUT)
    component ALU
    generic (n : integer := 32);
    port (
        aluIn1, aluIn2  : IN signed   (n-1 Downto 0);
        func            : IN unsigned   (3 Downto 0);
        cin             : IN unsigned;
        flagsOut        : OUT unsigned  (2 Downto 0);
        aluOut          : OUT signed  (n-1 Downto 0)
    );
    end component;
   
   --Inputs
   signal aluIn1, aluIn2 : signed(31 downto 0) := (others => '0');
   signal func : unsigned(3 downto 0) := (others => '0');
   signal cin : unsigned(0 downto 0) := "0";

    --Outputs
   signal flagsOut : unsigned(2 downto 0);
   signal aluOut : signed(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
    -- Instantiate the Unit Under Test (UUT)
   uut: ALU generic map(32) port map (
          aluIn1 => aluIn1,
          aluIn2 => aluIn2,
          func => func,
          cin => cin,
          flagsOut => flagsOut,
          aluOut => aluOut
        );

   -- Stimulus process
   stim_proc: process
   begin        
      -- hold reset state for 100 ns.
      -- Add operation
      aluIn1 <= to_signed(2, 32); 
      aluIn2 <= to_signed(-3, 32);  
      func <= x"9"; -- ADD operation
      wait for clk_period;

      -- Subtract operation
      aluIn1 <= to_signed(4, 32); 
      aluIn2 <= to_signed(-2, 32); 
      func <= x"A"; -- SUB operation
      wait for clk_period;

      -- And operation
      aluIn1 <= "00000000000000000000000000001111"; -- 15
      aluIn2 <= "00000000000000000000000000001010"; -- 10
      func <=  x"B";  -- AND operation
      wait for clk_period;

      -- Or operation
      aluIn1 <= "00000000000000000000000000001111"; -- 15
      aluIn2 <= "00000000000000000000000000001010"; -- 10
      func <= x"C";  -- OR operation
      wait for clk_period;

      -- XOR operation --alu out = 5(0101)
      aluIn1 <= "00000000000000000000000000001111"; -- 15
      aluIn2 <= "00000000000000000000000000001010"; -- 10
      func <= x"D"; -- XOR operation
      wait for clk_period;

      -- end simulation
      wait;
   end process;

end behavior;