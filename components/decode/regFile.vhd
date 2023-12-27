
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY regfile IS
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
END ENTITY regfile;

ARCHITECTURE ArchRegFile OF regFile IS
    TYPE reg_array IS ARRAY (0 TO REG_COUNT - 1) OF unsigned (REG_WIDTH - 1 DOWNTO 0);
    SIGNAL registers : reg_array := (OTHERS => (OTHERS => '0'));
BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF (rst = "1") THEN
            -- REMOVE THIS LINE 
            --registers <= (others => (others => '0'));
            registers(0) <= x"00000000";
            registers(1) <= x"00000005";
            registers(2) <= x"00000019";
            registers(3) <= x"FFFFFFFD";
            registers(4) <= x"FFFFF320";
            registers(5) <= x"00000000";
            registers(6) <= x"00000000";
            registers(7) <= x"00000000";
        -- sync behaviour of neg edge
        elsif (clk'event and clk = "0") then
            if (reg_one_write = "1") then
                report "Writing to register " & integer'image(to_integer(wa1)) & " with value " & integer'image(to_integer(wd1)) & " at time " & time'image(now);
                registers(to_integer(wa1)) <= wd1;
            END IF;
            IF (reg_two_write = "1") THEN
                registers(to_integer(unsigned(wa2))) <= wd2;
            END IF;
        END IF;

    END PROCESS;
    rd1 <= registers(to_integer(ra1));
    rd2 <= registers(to_integer(ra2));
END ARCHITECTURE ArchRegFile;