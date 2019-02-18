-------------------------------------------------------------------------------
--
-- unit name: Positive Pulse Generator
-- author: Georg Ziegler
--
-- description: This module/entity generates a pulse with the length of one
-- clock cycle. The pulse is guaranteed to be high on the next falling edge, and
-- the following rising edge of the clock.
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
entity pulse_generator_positive is
    port    ( input  : in  t_to_pulse_generator;
              output : out t_from_pulse_generator );

    -- constants
    constant PULLUP : std_logic := '1';       -- represents pull-up/constant high
    constant GND    : std_logic := '0';       -- represents ground/constant low
end entity pulse_generator_positive;

-- structural architecture
architecture structure of pulse_generator_positive is
    -- internal signals
    signal A   : std_logic;    -- dlatch A
    signal A_n : std_logic;    -- dlatch A inverted
    signal B   : std_logic;    -- dlatch A
    signal B_n : std_logic;    -- dlatch A inverted

    signal A_and_B          : std_logic;
    signal An_and_Bn        : std_logic;
    signal A_and_B_or_In    : std_logic;
    signal An_and_Bn_and_In : std_logic;

    signal An_and_B         : std_logic;
begin

    Dff : entity work.sn74ac74(rtl)
        port map ( clk_1        => input.clk,
                   pre1_n       => PULLUP,
                   clr1_n       => PULLUP,
                   d1           => A_and_B_or_In,
                   q1           => A,
                   q1_n         => A_n,
                   -- B Dff
                   clk_2        => input.clk,
                   pre2_n       => PULLUP,
                   clr2_n       => PULLUP,
                   d2           => An_and_Bn_and_In,
                   q2           => B,
                   q2_n         => B_n );

    AndChip : entity work.sn74ahc08(rtl)
        port map ( input.a1     => A,
                   input.b1     => B,
                   output.y1    => A_and_B,
                   input.a2     => A_n,
                   input.b2     => B_n,
                   output.y2    => An_and_Bn,
                   input.a3     => An_and_Bn,
                   input.b3     => input.signal_in,
                   output.y3    => An_and_Bn_and_In,
                   input.a4     => A_n,
                   input.b4     => B,
                   output.y4    => output.signal_out );

    OrChip : entity work.sn74ahc32(rtl)
        port map ( input.a1     => A_and_B,
                   input.b1     => input.signal_in,
                   output.y1    => A_and_B_or_In,
                   input.a2     => open,
                   input.b2     => open,
                   input.a3     => open,
                   input.b3     => open,
                   input.a4     => open,
                   input.b4     => open );

end architecture structure;
