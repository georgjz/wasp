-------------------------------------------------------------------------------
--
-- unit name: Test Bench for the Positive Pulse Generator
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the Pulse Generator Positive
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
entity pulse_generator_positive_tb is
end entity pulse_generator_positive_tb;

-- test bench architecture
architecture testbench of pulse_generator_positive_tb is
    -- test signals
    signal sys_clk  : std_logic := '0';
    signal finished : std_logic := '0';
    signal input    : t_to_pulse_generator;
    signal output   : t_from_pulse_generator;
    -- clock constant
    constant HALF_PERIOD : delay_length := 50 ns; -- 7 MHz
begin

    -- device under test
    dut : entity work.pulse_generator_positive(structure)
        port map ( input  => input,
                   output => output );

    -- clock generation
    sys_clk <= not sys_clk after HALF_PERIOD when finished /= '1' else '0';
    input.clk <= sys_clk;

    -- generate test signals
    stimulus : process is
    begin

        -- set input to zero
        input.signal_in <= '0';
        wait for 3 * HALF_PERIOD;

        -- switch on
        input.signal_in <= '1';
        wait for 3 * HALF_PERIOD;
        -- wait for 10 * HALF_PERIOD;

        -- switch off
        input.signal_in <= '0';
        wait for 5 * HALF_PERIOD;

        -- switch on
        wait for 33 ns;
        input.signal_in <= '1';
        wait for 10 * HALF_PERIOD;

        -- switch off
        input.signal_in <= '0';
        wait for 5 * HALF_PERIOD;

        -- stop clock and wait
        finished <= '1';
        wait;

    end process stimulus;

end architecture testbench;
