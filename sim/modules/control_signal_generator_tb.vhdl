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
    signal examine      : std_logic := '0';
    signal examine_next : std_logic := '0';
    signal csg_output   : t_from_control_signal_generator;
begin

    dut : entity work.control_signal_generator(structure)
        port map ( input.examine => examine,
                   input.examine_next => examine_next,
                   output => csg_output );

    stimulus : process is
    begin
        -- check idle state
        wait for 100 ns;

        -- check examine switch
        examine <= '1';
        wait for 50 ns;
        examine <= '0';
        wait for 100 ns;

        -- check examine next switch
        examine_next <= '1';
        wait for 50 ns;
        examine_next <= '0';
        wait for 100 ns;

        -- wait forever
        wait;
    end process stimulus;

end architecture testbench;
