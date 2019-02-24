-------------------------------------------------------------------------------
--
-- unit name: The Control Signal Generator
-- author: Georg Ziegler
--
-- description: This module represents the Control Signal Generator for the Wasp.
-- It is meant to generate all control signals according to the user's input.
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
entity control_signal_generator is
    port    ( input  : in  t_to_control_signal_generator;
              output : out t_from_control_signal_generator );

    -- timing characteristics
    -- constant T_PD : delay_length := 15 ns;
    -- constants
    constant PULLUP : std_logic := '1';
    constant GND    : std_logic := '0';
end entity control_signal_generator;

-- structural architecture
architecture structure of control_signal_generator is
    -- internal signals
    signal A        : std_logic;
    signal A_n      : std_logic;
    signal Dff_A    : std_logic;
    signal B        : std_logic;
    signal B_n      : std_logic;
    signal Dff_B    : std_logic;
    signal C        : std_logic;
    signal C_n      : std_logic;
    signal Dff_Ca   : std_logic;
    signal Dff_C    : std_logic;

    signal A_and_In     : std_logic;
    signal An_and_Bn    : std_logic;
    signal An_and_Bn_and_C : std_logic;
    signal An_and_Bn_or_Bn_and_C : std_logic;
    signal A_and_Cn     : std_logic;
    signal B_and_C      : std_logic;
    signal B_and_Cn     : std_logic;
    signal Bn_and_C     : std_logic;
    signal Bn_or_Cn     : std_logic;
    signal Cn_and_In    : std_logic;
begin

    -- input gates
    InputAndGates : entity work.sn74ahc08(rtl)
        port map ( -- A and In
                   a1 => A,
                   b1 => input.examine,
                   y1 => A_and_In,
                   -- B and C
                   a2 => B,
                   b2 => C,
                   y2 => B_and_C,
                   -- B and not
                   a3 => B,
                   b3 => C_n,
                   y3 => B_and_Cn,
                   -- not C and In
                   a4 => C_n,
                   b4 => Input.examine,
                   y4 => Cn_and_In );

    InputOrGates : entity work.sn74ahc32(rtl)
        port map ( -- Dff A input
                   a1 => A_and_In,
                   b1 => B_and_C,
                   y1 => Dff_A,
                   -- Dff B input
                   a2 => An_and_Bn_and_C,
                   b2 => B_and_Cn,
                   y2 => Dff_B,
                   -- Dff C input A
                   a3 => B_and_Cn,
                   b3 => A_and_In,
                   y3 => Dff_Ca,
                   -- Dff C input
                   a4 => Dff_Ca,
                   b4 => Cn_and_In,
                   y4 => Dff_C );

    -- Dffs
    AandBDff : entity work.sn74ahc74(rtl)
        port map ( -- Dff A
                   clk1     => input.clk,
                   pre1_n   => PULLUP,
                   clr1_n   => PULLUP,
                   d1       => Dff_A,
                   q1       => A,
                   q1_n     => A_n,
                   -- Dff B
                   clk2     => input.clk,
                   pre2_n   => PULLUP,
                   clr2_n   => PULLUP,
                   d2       => Dff_B,
                   q2       => B,
                   q2_n     => B_n );

    CDff : entity work.sn74ahc74(rtl)
        port map ( -- Dff C
                   clk1     => input.clk,
                   pre1_n   => PULLUP,
                   clr1_n   => PULLUP,
                   d1       => Dff_C,
                   q1       => C,
                   q1_n     => C_n,
                   -- unused Dff
                   clk2     => GND,
                   pre2_n   => PULLUP,
                   clr2_n   => PULLUP,
                   d2       => GND,
                   q2       => open,
                   q2_n     => open );

    -- output gates
    OutputAndGates : entity work.sn74ahc08(rtl)
        port map ( -- not A and not B
                   a1 => A_n,
                   b1 => B_n,
                   y1 => An_and_Bn,
                   -- not A and not B and C
                   a2 => An_and_Bn,
                   b2 => C,
                   y2 => An_and_Bn_and_C,
                   -- not B and C
                   a3 => B_n,
                   b3 => C,
                   y3 => Bn_and_C,
                   -- A and not C
                   a4 => A,
                   b4 => C_n,
                   y4 => A_and_Cn );

    OutputOrGates : entity work.sn74ahc32(rtl)
        port map ( -- buffer ctrl
                   a1 => An_and_Bn,
                   b1 => Bn_and_C,
                   y1 => An_and_Bn_or_Bn_and_C,
                   -- chip select and output enable
                   a2 => B_n,
                   b2 => C_n,
                   y2 => Bn_or_Cn,
                   -- unused gate
                   a3 => GND,
                   b3 => GND,
                   y3 => open,
                   -- unused gate
                   a4 => GND,
                   b4 => GND,
                   y4 => open );

    -- output assignments
    output.set_addr <= An_and_Bn_and_C;
    output.inc_addr <= GND;
    output.buffer_ctrl_n <= An_and_Bn_or_Bn_and_C;
    output.ram_ctrl.cs_n <= Bn_or_Cn;
    output.ram_ctrl.we_n <= PULLUP;
    output.ram_ctrl.oe_n <= Bn_or_Cn;
    output.addr_output <= A_and_Cn;

end architecture structure;
