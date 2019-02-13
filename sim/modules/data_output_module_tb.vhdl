-------------------------------------------------------------------------------
--
-- unit name: Testbench for Wasp's Data Output Module
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the Data Output Module
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
entity data_output_module_tb is
end entity data_output_module_tb;

-- test bench architecture
architecture testbench of data_output_module_tb is
    signal data_in, led_out  : std_logic_vector (7 downto 0) := (others => 'X');
    signal latch_data_output : std_logic := 'X';
begin

    dut : entity work.data_output_module(structure)
        port map ( input.latch => latch_data_output,
                   input.data_in => data_in,
                   output.led_out => led_out );

    stimulus : process is
    begin

        -- latch zero to LEDs
        data_in <= X"00";
        latch_data_output <= '0';
        wait for 50 ns;
        latch_data_output <= '1';
        wait for 50 ns;
        latch_data_output <= '0';

        -- change addresses
        data_in <= X"de";
        wait for 50 ns;
        data_in <= X"ad";
        wait for 50 ns;
        data_in <= X"11";
        wait for 50 ns;
        data_in <= X"21";
        wait for 50 ns;

        -- latch latest address
        latch_data_output <= '1';
        wait for 50 ns;
        latch_data_output <= '0';

        -- wait forever
        wait;

    end process stimulus;


end architecture testbench;
