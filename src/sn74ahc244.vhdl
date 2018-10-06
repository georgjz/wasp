-------------------------------------------------------------------------------
--
-- unit name: SN74AHC244 D-Type Transparent Latch (sn74ahc244)
-- author: Georg Ziegler
--
-- description: A octal Buffer/Driver with three-state output
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Fix latching during high-Z output
-- Expand input/output to 8-bit/octal
-- Model initial state of latch correctly
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity sn74ahc244 is
    generic ( constant DATA_WIDTH : integer := 8 );
    port    ( a        : in std_logic_vector (DATA_WIDTH - 1 downto 0);     -- Data input
              y        : out std_logic_vector (DATA_WIDTH - 1 downto 0);    -- Data output
              oe1_n : in std_logic;     -- Output enable, active-low for lower-half of a
              oe2_n : in std_logic );   -- Output enable, active-low for upper-half of a

    -- TODO: add detailed timing constants
    -- constant T_PD   : delay_length := 9 ns;     -- Propagation delay
    -- constant T_W    : delay_length := 5 ns;     -- Pulse duration, LE high
    -- constant T_SU   : delay_length := 3.5 ns;   -- Setup time, data before LE falling edge
    -- constant T_H    : delay_length := 1.5 ns;   -- Hold time, data after LE falling edge
end entity sn74ahc244;

-- rtl architecture to check metastability
architecture rtl of sn74ahc244 is
    signal intern : std_logic_vector (DATA_WIDTH - 1 downto 0) := (others => 'X');
begin

    -- read input
    intern <= a                        when (oe1_n = '0' and oe2_n = '0') else  -- buffer both nibbles
              (a(7 downto 4) & "ZZZZ") when (oe1_n = '1' and oe2_n = '0') else  -- lower nibble in high-Z
              ("ZZZZ" & a(3 downto 0)) when (oe1_n = '0' and oe2_n = '1') else  -- lower nibble in high-Z
              (others => 'Z');

    -- update output
    y <= intern;

    -- concurrent replacement of behavioral process
    -- latch the input according LE state
    -- intern <= d when le = '1' else
              -- unaffected;

    -- update output
    -- q <= intern after T_PD when oe_n = '0' else
         -- "ZZZZZZZZ" after T_PD;
         -- (others => 'Z') after T_PD;

    -- TODO: replace with state machine for more precise propagation delays

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
    --     -- wait for LE falling edge
    --     wait until falling_edge(le);
    --
    --     --check pulse width
    --     assert le'delayed'stable(T_W)
    --         report "LE pulse width too short!"
    --         severity failure;
    --
    --     -- check setup time
    --     assert intern'delayed'stable(T_SU)
    --         report "Input changed during setup time!"
    --         severity failure;
    --
    --     -- check hold time
    --     wait for T_H;
    --     assert intern'delayed'stable(T_H + T_SU)
    --         report "Input signal changed during hold time!"
    --         severity failure;
    --
    -- end process checkMetaStability;

end architecture rtl;
