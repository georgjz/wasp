-- Test Bench for SN74AHC573 model
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration
entity sn74ahc573_tb is
end entity sn74ahc573_tb;

-- test bench architecture
architecture test_bench of sn74ahc573_tb is
    signal oe_n, le, d, q : std_logic := '0';
begin

    dut : entity work.sn74ahc573(rtl)
        port map ( oe_n, le, d, q );

    stimulus : process is
    begin
        -- start in high-Z mode
        oe_n <= '1'; wait for 20 ns;

        -- load some latches
        -- oe_n <= '0'; le <= '1'; d <= '0'; wait for 100 ns;
        -- oe_n <= '0'; le <= '1'; d <= '1'; wait for 100 ns;
        -- oe_n <= '0'; le <= '0'; d <= '1'; wait for 100 ns;
        -- oe_n <= '0'; le <= '0'; d <= '0'; wait for 100 ns;
        -- oe_n <= '1'; le <= '1'; d <= '0'; wait for 100 ns;
        -- oe_n <= '1'; le <= '1'; d <= '1'; wait for 100 ns;

        -- WARNING: These signal changes violate metastability
        oe_n <= '0'; le <= '1'; d <= '1'; wait for 4 ns;
            -- violate minimal pulse width
        -- le <= '0'; wait for 1 ns;
            -- violate setup time
        -- d <= '0';  wait for 1 ns;
        -- le <= '0'; wait for 1 ns;
            -- violate hold time
        wait for 1 ns; le <= '0';
        wait for 1 ns; d <= '0';
        wait for 1 ns;

        -- wait forever
        wait;

    end process stimulus;


end architecture test_bench;
