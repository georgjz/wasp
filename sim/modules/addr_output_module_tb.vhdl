-------------------------------------------------------------------------------
--
-- unit name: Testbench for Wasp's Address Output Module
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the Address Output Module
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Improve bit string width signal assignment
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity addr_output_module_tb is
end entity addr_output_module_tb;

-- test bench architecture
architecture testbench of addr_output_module_tb is
    signal addr_in, led_out  : std_logic_vector (10 downto 0) := (others => 'X');
    signal latch_addr_output : std_logic := 'X';
begin

    dut : entity work.addr_output_module(structure)
        port map ( input.latch => latch_addr_output,
                   input.data_in => addr_in,
                   output.led_out => led_out );

    stimulus : process is
    begin

        -- latch zero to LEDs
        addr_in <= B"000" & X"00";
        latch_addr_output <= '0';
        wait for 50 ns;
        latch_addr_output <= '1';
        wait for 50 ns;
        latch_addr_output <= '0';

        -- change addresses
        addr_in <= B"000" & X"de";
        wait for 50 ns;
        addr_in <= B"000" & X"ad";
        wait for 50 ns;
        addr_in <= B"000" & X"11";
        wait for 50 ns;
        addr_in <= B"000" & X"21";
        wait for 50 ns;

        -- latch latest address
        latch_addr_output <= '1';
        wait for 50 ns;
        latch_addr_output <= '0';

        -- wait forever
        wait;

    end process stimulus;


end architecture testbench;
