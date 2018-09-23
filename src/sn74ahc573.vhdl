-------------------------------------------------------------------------------
--
-- unit name: SN74AHC573 D-Type Transparent Latch (sn74ahc573)
-- author: Georg Ziegler
--
-- description: A octal D-type transparent latch with tri-state output
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Fix latching during high-Z output
-- Fix metastability check
-- Expand input/output to 8-bit/octal
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- entity declaration
entity sn74ahc573 is
    port ( d        : in std_logic;     -- Data input
           q        : out std_logic;    -- Data output
           oe_n     : in std_logic;     -- Output enable, active-low
           le       : in std_logic );   -- Latch enable

    -- TODO: add detailed timing constants
    constant T_PD   : delay_length := 9 ns;     -- Propagation delay
    constant T_W    : delay_length := 5 ns;     -- Pulse duration, LE high
    constant T_SU   : delay_length := 3.5 ns;   -- Setup time, data before LE falling edge
    constant T_H    : delay_length := 1.5 ns;   -- Hold time, data after LE falling edge
end entity sn74ahc573;

-- rtl architecture to check metastability
architecture rtl of sn74ahc573 is
    signal intern : std_logic := 'X';
begin

    -- concurrent replacement of behavioral process
    -- TODO: replace with state machine for more precise propagation delays
    intern <= 'Z' when oe_n = '1' else              -- high-impedance state
               d  when oe_n = '0' and le = '1' else -- latch input
               unaffected;                          -- else, nothing happens

    -- check metastability of latch enable signal
    checkMetaStability : process is
    begin
        -- wait for LE falling edge
        wait until falling_edge(le);

        --check pulse width
        assert le'delayed'stable(T_W)
            report "LE pulse width too short!"
            severity failure;

        -- check setup time
        assert intern'delayed'stable(T_SU)
            report "Input changed during setup time!"
            severity failure;

        -- check hold time
        wait for T_H;
        assert intern'delayed'stable(T_H + T_SU)
            report "Input signal changed during hold time!"
            severity failure;

    end process checkMetaStability;

    -- update output
    q <= intern;

end architecture rtl;
