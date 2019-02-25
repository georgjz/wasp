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
    signal B        : std_logic;
    signal B_n      : std_logic;
    signal C        : std_logic;
    signal C_n      : std_logic;

    signal Dff_A    : std_logic;
    signal Dff_B    : std_logic;
    signal Dff_C    : std_logic;

    signal Ex_or_Nx : std_logic;
begin

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

    -- Glue Logic
    Ex_or_Nx <= input.examine or input.examine_next;

    Dff_A   <= (A_n and B and C) or
               (A and B_n) or
               (A and Ex_or_Nx) after 5 ns;

    Dff_B   <= (B_n and C) or
               (A_n and B and C_n) or
               (A_n and B_n and input.examine_next) or
               (A and B and Ex_or_Nx) after 5 ns;

    Dff_C   <= (A_n and B_n and C) or
               (A_n and B and C_n) or
               (A and B_n and C_n) or
               (A and B and Ex_or_Nx) or
               (C_n and input.examine) after 5 ns;

    -- update output
    output.set_addr_n       <= (A or B or C_n) after 5 ns;
    output.inc_addr         <= (A_n and B and C_n) after 5 ns;
    output.buffer_ctrl_n    <= (A_n or (B and C)) after 5 ns;
    output.ram_ctrl.cs_n    <= (A_n or (B_n and C_n) or (B and C)) after 5 ns;
    output.ram_ctrl.we_n    <= PULLUP;
    output.ram_ctrl.oe_n    <= (A_n or (B_n and C_n) or (B and C)) after 5 ns;
    output.addr_output      <= (A and B and C_n) after 5 ns;

end architecture structure;
