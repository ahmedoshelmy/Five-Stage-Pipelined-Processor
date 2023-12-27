LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

-- entity icu is
--     port (
--         interrupt, clk, reset : in std_logic;
--         ack, stop_inc_pc : out std_logic;
--         change_pc : out std_logic;
--         int_pc : out std_logic_vector(31 downto 0);
--         instruction : out std_logic_vector(15 downto 0)
--     );
-- end entity icu;

-- architecture archICU of icu is
--     constant idle_state : unsigned(2 downto 0) := "000";
--     constant stall_state : unsigned(2 downto 0) := "001";
--     constant push_flags_state : unsigned(2 downto 0) := "010";
--     constant push_pc_state : unsigned(2 downto 0) := "011";
--     constant change_pc_state : unsigned(2 downto 0) := "100";

--     constant nop_bits : unsigned(15 downto 0) := "0000000000000000";
--     constant 
-- begin
-- end architecture archICU;

entity icu is
    port (
        int, clk, reset : in std_logic;
        push_pc : out unsigned(0 downto 0)
    );
end entity icu;

architecture archICU of icu is
begin
    push_pc <= int & "";
end architecture archICU;