-------------------------------------------------------------------------------
--
-- unit name: Testbench for SN74AHC573 (sn74ahc573_tb)
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the sn74ahc573 unit
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Test latching during high-Z output
-- Replace signal names with more descriptive/distinguishable names
-- Improve test to capture all edges of the FSM
-- Better insantiation with direct signal assignments
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity sn74ahc573_tb is
end entity sn74ahc573_tb;

-- test bench architecture
architecture testbench of sn74ahc573_tb is
    signal d, q : std_logic_vector (7 downto 0) := (others => 'X');
    signal oe_n, le : std_logic := 'X';
begin

    dut : entity work.sn74ahc573(rtl)
        port map ( d, q, oe_n, le );

    stimulus : process is
    begin
        -- start in high-Z state
        oe_n <= '1'; wait for 50 ns;

        -- load some latches
        oe_n <= '0'; le <= '0'; d <= X"AA"; wait for 100 ns;
        oe_n <= '0'; le <= '1'; d <= X"AA"; wait for 100 ns;
        oe_n <= '0'; le <= '1'; d <= X"55"; wait for 100 ns;
        oe_n <= '0'; le <= '0'; d <= X"55"; wait for 100 ns;
        oe_n <= '0'; le <= '0'; d <= X"AA"; wait for 100 ns;
        oe_n <= '1'; le <= '1'; d <= X"AA"; wait for 100 ns;
        oe_n <= '1'; le <= '1'; d <= X"55"; wait for 100 ns;

        -- wait in high-Z state
        -- oe_n <= '1'; le <= '0'; wait for 20 ns;

        -- WARNING: These signal changes violate metastability
            -- violate minimal pulse width
        -- le <= '0'; wait for 1 ns;
        -- oe_n <= '0'; le <= '1'; d <= '1'; wait for 4 ns;
        -- le <= '0'; wait for 11 ns;
            -- violate setup time
        -- oe_n <= '0'; le <= '1'; d <= '1'; wait for 4 ns;
        -- d <= '0';  wait for 1 ns;
        -- le <= '0'; wait for 10 ns;
            -- violate hold time
        -- oe_n <= '0'; le <= '1'; d <= '1'; wait for 4 ns;
        -- wait for 1 ns; le <= '0'; d <= '0' after 1 ns;

        -- wait forever
        wait;

    end process stimulus;


end architecture testbench;
