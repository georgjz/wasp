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
    signal input  : t_to_address_counter ( addr_in(10 downto 0) );         -- latch the new address to output
    signal output : t_from_address_counter ( addr_out(10 downto 0) );
    -- constants
    constant PULLUP : std_logic := '1';       -- represents pull-up/constant high
    constant GND    : std_logic := '0';       -- represents ground/constant low
begin

    -- device under test
    dut : entity work.addr_counter(structure)
        port map ( input  => input,
                   output => output );

    -- generate test signals
    stimulus : process is
    begin
        -- initial signals
        input.set <= '0';
        input.inc <= '0';
        input.addr_in <= (others => '0');
        wait for 50 ns;

        -- set address to $1ab
        input.set <= '1';
        input.addr_in <= B"001_1110_1110";
        -- input.addr_in <= B"001_1110_1110";
        wait for 100 ns;

        input.set <= '0';
        wait for 100 ns;

        -- increment address thrice
        input.inc <= '1';
        wait for 100 ns;
        input.inc <= '0';
        wait for 100 ns;
        input.inc <= '1';
        wait for 100 ns;
        input.inc <= '0';
        wait for 100 ns;
        input.inc <= '1';
        wait for 100 ns;
        input.inc <= '0';
        wait for 100 ns;

        -- wait forever
        wait;

    end process stimulus;

end architecture testbench;
