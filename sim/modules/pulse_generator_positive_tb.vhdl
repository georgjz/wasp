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
    port    ( input  : in  t_to_pulse_generator;
              output : out t_from_pulse_generator );

    -- constants
    constant PULLUP : std_logic := '1';       -- represents pull-up/constant high
    constant GND    : std_logic := '0';       -- represents ground/constant low
end entity pulse_generator_positive_tb;

-- test bench architecture
architecture testbench of pulse_generator_positive_tb is
    -- test signals
    signal sys_clk : std_logic;
    signal input  : t_to_pulse_generator;
    signal output : t_from_pulse_generator;
begin

    -- device under test
    dut : entity work.pulse_generator_positive(structure)
        port map ( input  => input,
                   output => output );

    -- generate test signals
    stimulus : process is
    begin

        -- clock generation

    end process stimulus;

end architecture testbench;
