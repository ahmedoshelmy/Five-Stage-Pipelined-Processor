
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY MEMORY IS
    GENERIC (
        CACHE_WORD_WIDTH : INTEGER := 16;
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        RST : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        MEMR : IN STD_LOGIC;
        MEMW : IN STD_LOGIC;
        PROTECT : IN STD_LOGIC;
        FREE : IN STD_LOGIC;
        ADDRESS_BUS : IN STD_LOGIC_VECTOR(ADDRESS_BITS - 1 DOWNTO 0);
        DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEMOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_RST_VAL, PC_INT_VAL : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY MEMORY;

ARCHITECTURE ARCHMEMORY OF MEMORY IS
    TYPE MEMORYTYPE IS ARRAY((2 ** ADDRESS_BITS) - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(CACHE_WORD_WIDTH - 1 DOWNTO 0);
    TYPE PROTECTMEMORYTYPE IS ARRAY((2 ** ADDRESS_BITS) - 1 DOWNTO 0) OF STD_LOGIC;
    SIGNAL CACHE : MEMORYTYPE;
    SIGNAL ISPROTECTEDMEMORY : PROTECTMEMORYTYPE; -- 1 Means protected
    SIGNAL initial_flag : STD_LOGIC := '1';
BEGIN
    PROCESS (CLK, RST) 
        FILE memory_file : text OPEN read_mode IS "cache.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(CACHE_WORD_WIDTH - 1 DOWNTO 0);
    BEGIN
        PC_RST_VAL <= CACHE(0) & CACHE(1);
        PC_INT_VAL <= CACHE(2) & CACHE(3);
        IF RST = '1' THEN
            CACHE <= (OTHERS => (OTHERS => '0'));
            INITIAL_FLAG <= '1';
        -- reading file once
        ELSIF (initial_flag = '1') THEN
            FOR i IN CACHE'RANGE LOOP
                IF NOT endfile(memory_file) THEN
                    readline(memory_file, file_line);
                    read(file_line, temp_data);
                    CACHE(i) <= temp_data;
                ELSE
                    file_close(memory_file);

                END IF;
            END LOOP;
            initial_flag <= '0';
        -- syncronys behaviour
        ELSIF RISING_EDGE(CLK) THEN
            IF MEMR = '1' THEN
                MEMOUT(31 DOWNTO 16) <= CACHE(TO_INTEGER (unsigned(ADDRESS_BUS)));
                MEMOUT(15 DOWNTO 0) <= CACHE(TO_INTEGER(unsigned(ADDRESS_BUS)) + 1);
                -- MEMOUT(15 DOWNTO 0) <= CACHE(TO_INTEGER (unsigned(ADDRESS_BUS + 1)));
            END IF;
            IF MEMW = '1' AND ISPROTECTEDMEMORY(TO_INTEGER(unsigned(ADDRESS_BUS))) = '0' THEN
                -- Assuming Big Endian
                CACHE(TO_INTEGER(unsigned(ADDRESS_BUS))) <= DATAIN(31 DOWNTO 16);
                CACHE(TO_INTEGER(unsigned(ADDRESS_BUS)) + 1) <= DATAIN(15 DOWNTO 0);

            END IF;
                
                
            -- Protect and free 
            IF PROTECT = '1' THEN
                ISPROTECTEDMEMORY(TO_INTEGER (unsigned(ADDRESS_BUS))) <= '1';
            END IF;
            IF FREE = '1' THEN
                ISPROTECTEDMEMORY(TO_INTEGER (unsigned(ADDRESS_BUS))) <= '0';
            END IF;

        END IF;
    END PROCESS;
END ARCHMEMORY;

-- TO_INTEGER here IS used TO convert STDLOGIC VECTOR TO INTEGER