-------------------------------------------------------------------------------
--
-- unit name: IDT6116xAxx 2K x 8 SRAM type memory chip
-- author: Georg Ziegler
--
-- description: A 2K x 8 static RAM chip with 8-bit data, and 12-bit address bus
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO:
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity idt6116xaxx is
    generic ( constant DATA_WIDTH : integer := 8;
              constant ADDR_WIDTH : integer := 11 );
    port    ( data  : inout std_logic_vector (DATA_WIDTH - 1 downto 0);
              addr  : in    std_logic_vector (ADDR_WIDTH - 1 downto 0);
              cs_n  : in    std_logic;
              we_n  : in    std_logic;
              oe_n  : in    std_logic );
end entity idt6116xaxx;

-- rtl architecture with metastability and timing checks
architecture rtl of idt6116xaxx is
-- internal signals
    constant RAM_DEPTH :integer := 2**ADDR_WIDTH;

    signal data_out : std_logic_vector (DATA_WIDTH - 1 downto 0);

    type RAM is array (integer range <>) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal mem : RAM (0 to RAM_DEPTH - 1);
begin
----------------Code Starts Here------------------
-- Tri-State Buffer control
    data <= data_out when (cs_n = '1' and oe_n = '1' and we_n = '0') else
            'Z';

    -- Memory Write Block
    writeToMemory : process (addr, data, cs_n, we_n) is
    begin
        if (cs_n = '1' and we_n = '1') then
            mem(conv_integer(addr)) <= data;
        end if;
end process;

    -- Memory Read Block
    readFromMemory : process (addr, cs_n, we_n, oe_n, mem) is
    begin
        if (cs = '1' and we = '0' and oe = '1')  then
            data_out <= mem(conv_integer(addr));
        end if;
    end process;

end architecture rtl;
