-------------------------------------------------------------------------------
--
-- unit name: Pulse Generator
-- author: Georg Ziegler
--
-- description: This module/entity generates a pulse with the length of one
-- clock cycle. The pulse is guaranteed to be high on the next rising edge, and
-- the following falling edge of the clock. So the signal will satisfy setup and
-- hold time restrictions.
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
use work.wasp_records_pkg.all;

-- entity declaration
entity pulse_generator is
    port    ( input  : in  t_to_pulse_generator;
              output : out t_from_pulse_generator );

    -- constants
    constant PULLUP : std_logic := '1';       -- represents pull-up/constant high
    constant GND    : std_logic := '0';       -- represents ground/constant low
end entity pulse_generator;

-- structural architecture
architecture structure of pulse_generator is
    -- internal signals
    signal A   : std_logic;    -- JK-flip-flop A
    signal A_n : std_logic;    -- JK-flip-flop A inverted
    signal B   : std_logic;    -- JK-flip-flop A
    signal B_n : std_logic;    -- JK-flip-flop A inverted

    signal A_n_and_In   : std_logic;
    signal B_and_In     : std_logic;
    signal In_n         : std_logic;

    signal A_n_and_B    : std_logic;

    -- signal open_dummy       : std_logic;
begin

    JK : entity work.cd74ac112(rtl)
        port map ( -- JK A
                   clk1    => input.clk,
                   pre1_n  => PULLUP,
                   clr1_n  => PULLUP,
                   j1      => B_and_In,
                   k1      => In_n,
                   q1      => A,
                   q1_n    => A_n,
                   -- JK B
                   clk2    => input.clk,
                   pre2_n  => PULLUP,
                   clr2_n  => PULLUP,
                   j2      => A_n_and_In,
                   k2      => PULLUP,
                   q2      => B,
                   q2_n    => B_n );

    AndChip : entity work.sn74ahc08(rtl)
        port map ( -- In * B
                   a1 => B,
                   b1 => input.signal_in,
                   y1 => B_and_In,
                   -- In * (not A)
                   a2 => A_n,
                   b2 => input.signal_in,
                   y2 => A_n_and_In,
                   -- not A * B
                   a3 => A_n,
                   b3 => B,
                   y3 => output.signal_out,
                   -- not used
                   a4 => GND,
                   b4 => GND,
                   y4 => open );

    NotChip : entity work.sn74ahc04(rtl)
        port map ( a1 => input.signal_in,
                   y1 => In_n,
                   a2 => PULLUP,
                   a3 => PULLUP,
                   a4 => PULLUP,
                   a5 => PULLUP,
                   a6 => PULLUP,
                   y2 => open,
                   y3 => open,
                   y4 => open,
                   y5 => open,
                   y6 => open );

    -- glue logic
    In_n <= not input.signal_in;

end architecture structure;
