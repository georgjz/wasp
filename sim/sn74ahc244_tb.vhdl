-------------------------------------------------------------------------------
--
-- unit name: Testbench for SN74AHC244 (sn74ahc244_tb)
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the sn74ahc244 unit
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Add more test cases
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity sn74ahc244_tb is
end entity sn74ahc244_tb;

-- test bench architecture
architecture testbench of sn74ahc244_tb is
    signal a_in, y_in : std_logic_vector (7 downto 0) := (others => 'X');
    signal oe1_n, oe2_n : std_logic := 'X';
begin

    dut : entity work.sn74ahc244(rtl)
        port map ( a => a_in,
                   y => y_in,
                   oe1_n => oe1_n,
                   oe2_n => oe2_n );

    stimulus : process is
    begin
        -- start in high-Z state
        oe1_n <= '1';
        oe2_n <= '1';
        wait for 100 ns;

        -- drive all outputs
        oe1_n <= '0';
        oe2_n <= '0';
        a_in <= X"DA";
        wait for 100 ns;

        -- drive lower-half only
        oe1_n <= '0';
        oe2_n <= '1';
        -- a_n <= X"DA";
        wait for 100 ns;

        -- drive upper-half only
        oe1_n <= '1';
        oe2_n <= '0';
        -- a_n <= X"DA";
        wait for 100 ns;

        -- end in high-Z state
        oe1_n <= '1';
        oe2_n <= '1';
        wait for 100 ns;

        -- wait forever
        wait;

    end process stimulus;


end architecture testbench;
