-------------------------------------------------------------------------------
--
-- unit name: A simple Wasp model
-- author: Georg Ziegler
--
-- description: This testbench represents a simple Wasp version with data and
-- address output only
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

-- entity declaration
entity simple_wasp_tb is
end entity simple_wasp_tb;

-- test bench architecture
architecture testbench of simple_wasp_tb is
    -- test signals
    signal sys_clk  : std_logic := '0';
    signal finished : std_logic := '0';
    signal examine      : std_logic := '0';
    signal examine_next : std_logic := '0';
    signal data_input   : std_logic_vector (7 downto 0) := (others => '0');
    signal data_output  : std_logic_vector (7 downto 0);
    signal addr_input   : std_logic_vector (10 downto 0) := (others => '0');
    signal addr_output  : std_logic_vector (10 downto 0);
    -- clock
    constant HALF_PERIOD : delay_length := 50 ns; -- 10 MHz
begin

    -- clock generator
    sys_clk <= not sys_clk after HALF_PERIOD when finished /= '1' else '0';

    -- RAM
    wasp : entity work.simple_wasp(structure)
        port map ( sys_clk => sys_clk,
                   examine  => examine,
                   examine_next => examine_next,
                   data_input => data_input,
                   data_output => data_output,
                   addr_input  => addr_input,
                   addr_output => addr_output );

    -- code
    stimulus : process is
    begin
        -- just chill a bit
        wait for 10 * HALF_PERIOD;
        examine <= '1';
        wait for 12 * HALF_PERIOD;
        examine <= '0';
        wait for 12 * HALF_PERIOD;

        examine_next <= '1';
        wait for 12 * HALF_PERIOD;
        examine_next <= '0';
        wait for 12 * HALF_PERIOD;

        -- stop clock and wait forever
        finished <= '1';
        wait;

    end process stimulus;

end architecture testbench;
