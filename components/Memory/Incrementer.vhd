LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Incrementer IS
    GENERIC (
        WIDTH : INTEGER := 4
    );
    PORT (
        in_value : IN STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
        out_value : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0)
    );
END ENTITY Incrementer;

ARCHITECTURE archInrementer OF Incrementer IS
BEGIN
    PROCESS (in_value)
    BEGIN
        out_value <= (OTHERS => '0');
        IF (in_value = (WIDTH - 1 DOWNTO 0 => '1')) THEN
            out_value <= (OTHERS => '0');
        ELSE
            out_value <= in_value + 1;
        END IF;
    END PROCESS;
END ARCHITECTURE archInrementer;