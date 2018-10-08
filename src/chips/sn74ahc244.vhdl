-------------------------------------------------------------------------------
--
-- unit name: SN74AHC244 Octal Tri-State Buffer (sn74ahc244)
-- author: Georg Ziegler
--
-- description: A octal Buffer/Driver with three-state output
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Improve delay mechanism
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity sn74ahc244 is
    generic ( constant DATA_WIDTH : integer := 8 );
    port    ( a     : in std_logic_vector (DATA_WIDTH - 1 downto 0);     -- Data input
              y     : out std_logic_vector (DATA_WIDTH - 1 downto 0);    -- Data output
              oe1_n : in std_logic;     -- Output enable, active-low for lower-half of a
              oe2_n : in std_logic );   -- Output enable, active-low for upper-half of a

    -- TODO: add detailed timing constants
    constant T_PLH  : delay_length := 6.5 ns;   -- Propagation delay A -> Y
    constant T_PZ   : delay_length := 8.5 ns;   -- Propagation delay /OE -> Y
end entity sn74ahc244;

-- rtl architecture to check metastability
architecture rtl of sn74ahc244 is
    signal intern : std_logic_vector (DATA_WIDTH - 1 downto 0) := (others => 'X');
begin

    -- read input
    intern <=
        a                        after T_PZ when (oe1_n = '0' and oe2_n = '0') else  -- buffer both nibbles
        (a(7 downto 4) & "ZZZZ") after T_PZ when (oe1_n = '1' and oe2_n = '0') else  -- lower nibble in high-Z
        ("ZZZZ" & a(3 downto 0)) after T_PZ when (oe1_n = '0' and oe2_n = '1') else  -- lower nibble in high-Z
        (others => 'Z') after T_PZ;

    -- update output
    y <= intern;

end architecture rtl;
