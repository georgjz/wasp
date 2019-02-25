-------------------------------------------------------------------------------
--
-- unit name: IDT6116xAxx 2K x 8 SRAM type memory chip
-- author: Georg Ziegler
--
-- description: A 2K x 8 static RAM chip with 8-bit data, and 11-bit address bus
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Add metastability check process and correct timing constrains
-- Port map with package
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wasp_records_pkg.all;

-- entity declaration
entity idt6116xaxx is
    generic ( constant DATA_WIDTH : integer := 8;
              constant ADDR_WIDTH : integer := 11 );
    port    ( data  : inout std_logic_vector (DATA_WIDTH - 1 downto 0);
              addr  : in    std_logic_vector (ADDR_WIDTH - 1 downto 0);
              ctrl  : in    t_ram_ctrl );

    -- timing constants
    constant T_ACS : delay_length := 15 ns;     -- memory access time
end entity idt6116xaxx;

-- rtl architecture with metastability and timing checks
architecture rtl of idt6116xaxx is
    -- internal signals
    constant RAM_DEPTH : integer := 2**ADDR_WIDTH;
    signal intern : std_logic_vector (DATA_WIDTH - 1 downto 0);
    -- the memory itself
    type RAM is array (integer range <>) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal mem : RAM (0 to RAM_DEPTH - 1);
begin

    -- Tri-State Buffer control
    data <= intern when (ctrl.cs_n = '0' and ctrl.oe_n = '0' and ctrl.we_n = '1') else
            (others => 'Z');

    -- Memory Read Block
    readFromMemory : process (addr, ctrl.cs_n, ctrl.oe_n, ctrl.we_n, mem) is
    begin
        if (ctrl.cs_n = '0' and ctrl.oe_n = '0' and ctrl.we_n = '1') then
            intern <= mem(to_integer(unsigned(addr))) after T_ACS;
        end if;
    end process;

    -- Memory Write Block
    writeToMemory : process (addr, data, ctrl.cs_n, ctrl.we_n) is
    begin
        if (ctrl.cs_n = '0' and ctrl.we_n = '0') then
            mem(to_integer(unsigned(addr))) <= data;
        end if;
    end process;

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
        -- code
    -- end process checkMetaStability;

end architecture rtl;
