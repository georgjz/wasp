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
    signal D        : std_logic;
    signal D_n      : std_logic;

    signal ABCD     : std_logic;
    signal ABCD_n   : std_logic;

    signal Dff_A    : std_logic;
    signal Dff_B    : std_logic;
    signal Dff_C    : std_logic;
    signal Dff_D    : std_logic;

    signal ISS          : std_logic;
    signal DeNx_De_ExNx : std_logic;
    signal DeNx_De_Ex   : std_logic;
    signal De_ExNx_Ex   : std_logic;
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
                   clk2     => input.clk,
                   pre2_n   => PULLUP,
                   clr2_n   => PULLUP,
                   d2       => Dff_D,
                   q2       => D,
                   q2_n     => D_n );

    -- Glue Logic
    ISS <= input.deposit_next or input.deposit or input.examine_next or input.examine;
    DeNx_De_ExNx <= input.deposit_next or input.deposit or input.examine_next;
    DeNx_De_Ex   <= input.deposit_next or input.deposit or input.examine;
    De_ExNx_Ex <= input.deposit or input.examine_next or input.examine;

    ABCD    <= A and B and C and D;
    ABCD_n  <= A_n and B_n and C_n and D_n;

    Dff_A   <= (A and D) or
               (A and (B xor C)) or
               (ABCD_n and DeNx_De_ExNx) after 5 ns;

    Dff_B   <= (B and C_n) or
               (B_n and C and D) or
               (B and D_n and De_ExNx_Ex) or
               (A_n and C_n and D_n and input.deposit_next) or
               (A_n and B and input.deposit_next) after 5 ns;

    Dff_C   <= (C_n and D) or
               (C and D_n and (B_n or ISS)) or
               (B_n and D_n and (A or input.deposit_next)) or
               (A_n and B and C and ISS) after 5 ns;

    Dff_D   <= (D_n and (B xor C)) or
               (B and C and ISS) or
               ABCD or
               (A_n and D_n and DeNx_De_Ex) after 5 ns;

    -- update output
    output.set_addr_n       <= (A or B or C or D_n) after 5 ns;
    output.inc_addr         <= (ABCD or (A and B_n and C_n and D_n)) after 5 ns;
    output.buffer_addr_n    <= ((B_n and C_n) or (B_n and D_n) or (B and C and D)) after 5 ns;
    output.latch_data       <= A and B_n and C_n and D after 5 ns;
    output.buffer_data_n    <= (A_n or (B_n and C_n) or (B_n and D_n) or (B and C and D)) after 5 ns;

    output.ram_ctrl.cs_n    <= (B_n or (C and D)) after 5 ns;
    output.ram_ctrl.we_n    <= (A_n or B_n or (C and D)) after 5 ns;
    output.ram_ctrl.oe_n    <= (A or B_n or (C and D)) after 5 ns;
    output.addr_output      <= (B and C_n and D) after 5 ns;

end architecture structure;
