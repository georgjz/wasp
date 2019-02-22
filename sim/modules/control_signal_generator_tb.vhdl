-------------------------------------------------------------------------------
--
-- unit name: The Control Signal Generator Test Bench
-- author: Georg Ziegler
--
-- description: This test bench verifies functionality of the Control Signal Generator
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
entity control_signal_generator_tb is
end entity control_signal_generator_tb;

-- structural architecture
architecture testbench of control_signal_generator_tb is
    signal sys_clk      : std_logic := '0';
    signal finished     : std_logic := '0';
    signal examine      : std_logic := '0';
    signal examine_next : std_logic := '0';
    signal csg_output   : t_from_control_signal_generator;
    -- clock constant
    constant HALF_PERIOD : delay_length := 50 ns; -- 10 MHz
begin

    dut : entity work.control_signal_generator(structure)
        port map ( input.clk     => sys_clk,
                   input.examine => examine,
                   input.examine_next => examine_next,
                   output => csg_output );

    -- clock generator
    sys_clk <= not sys_clk after HALF_PERIOD when finished /= '1' else '0';

    -- generate test signals
    stimulus : process is
    begin
        -- check idle state
        wait for 2 * HALF_PERIOD;

        -- check examine switch
        examine <= '1';
        wait for 5 * HALF_PERIOD;
        examine <= '0';
        wait for 2 * HALF_PERIOD;

        -- check examine next switch
        examine_next <= '1';
        wait for 1 * HALF_PERIOD;
        examine_next <= '0';
        wait for 2 * HALF_PERIOD;

        -- stop clock and wait forever
        finished <= '1';
        wait;

    end process stimulus;

end architecture testbench;
