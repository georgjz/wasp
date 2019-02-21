-------------------------------------------------------------------------------
--
-- unit name: Test Bench for Address Counter
-- author: Georg Ziegler
--
-- description: Verifies the functionality of the Address Counter
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: What happens if address changes during latching?
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wasp_records_pkg.all;

-- entity declaration
entity addr_counter_tb is
end entity addr_counter_tb;

-- structural architecture
architecture testbench of addr_counter_tb is
    -- test signals
    signal sys_clk  : std_logic := '0';
    signal finished : std_logic := '0';
    signal input  : t_to_address_counter ( addr_in(10 downto 0) );         -- latch the new address to output
    signal output : t_from_address_counter ( addr_out(10 downto 0) );
    -- constants
    constant PULLUP : std_logic := '1';       -- represents pull-up/constant high
    constant GND    : std_logic := '0';       -- represents ground/constant low
    -- system clock
    constant HALF_PERIOD : delay_length := 50 ns; -- 10 MHz
begin

    -- device under test
    dut : entity work.addr_counter(structure)
        port map ( input  => input,
                   output => output );

    -- clock generation
    sys_clk <= not sys_clk after HALF_PERIOD when finished /= '1' else '0';
    input.clk <= sys_clk;

    -- generate test signals
    stimulus : process is
    begin
        -- initial signals
        input.set <= '0';
        input.inc <= '0';
        input.addr_in <= (others => '0');
        wait for HALF_PERIOD / 2;

        -- set address to $1ab
        input.set <= '1';
        input.addr_in <= B"001_1110_1110";
        wait for HALF_PERIOD;

        input.set <= '0';
        wait for HALF_PERIOD;

        -- increment address thrice
        input.inc <= '1';
        wait for 2 * HALF_PERIOD;
        input.inc <= '0';
        wait for 2 * HALF_PERIOD;
        input.inc <= '1';
        wait for 2 * HALF_PERIOD;
        input.inc <= '0';
        wait for 2 * HALF_PERIOD;
        input.inc <= '1';
        wait for 2 * HALF_PERIOD;
        input.inc <= '0';
        wait for 2 * HALF_PERIOD;

        input.addr_in <= B"111_1111_1111";
        input.set <= '1';
        wait for 2 * HALF_PERIOD;
        input.set <= '0';
        wait for 2 * HALF_PERIOD;
        input.inc <= '1';
        wait for 2 * HALF_PERIOD;
        input.inc <= '0';
        wait for 2 * HALF_PERIOD;
        input.inc <= '1';
        wait for 2 * HALF_PERIOD;
        input.inc <= '0';
        wait for 2 * HALF_PERIOD;
        input.inc <= '1';
        wait for 2 * HALF_PERIOD;
        input.inc <= '0';
        wait for 2 * HALF_PERIOD;

        -- stop clock and wait forever
        wait for 2 * HALF_PERIOD;
        finished <= '1';
        wait;

    end process stimulus;

end architecture testbench;
