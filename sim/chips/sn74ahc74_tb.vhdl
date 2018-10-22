-------------------------------------------------------------------------------
--
-- unit name: Testbench for SN74AHC74 (sn74ahc74_tb)
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the sn74ahc74 unit
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Add more test cases
-- Add metastability test
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity sn74ahc74_tb is
end entity sn74ahc74_tb;

-- test bench architecture
architecture testbench of sn74ahc74_tb is
    signal pre1_n : std_logic := 'X';       -- preset dff
    signal clr1_n : std_logic := 'X';       -- reset dff
    signal d1     : std_logic := 'X';       -- dff input
    signal q1     : std_logic := 'X';       -- dff output
    signal q1_n   : std_logic := 'X';       -- dff output
    signal pre2_n : std_logic := 'X';       -- preset dff
    signal clr2_n : std_logic := 'X';       -- reset dff
    signal d2     : std_logic := 'X';       -- dff input
    signal q2     : std_logic := 'X';       -- dff output
    signal q2_n   : std_logic := 'X';       -- dff output
    signal sys_clk, finished : std_logic := '0';
begin

    dut : entity work.sn74ahc74(rtl)
        port map ( sys_clk,
                   pre1_n,
                   clr1_n,
                   d1,
                   q1,
                   q1_n,
                   sys_clk,
                   pre2_n,
                   clr2_n,
                   d2,
                   q2,
                   q2_n );

    -- system clock generator
    sys_clk <= not sys_clk after 100 ns when finished /= '1' else '0';

    stimulus : process is
        constant CLK_CYC : delay_length := 200 ns;
    begin
        -- reset all signals
        pre1_n <= '1';
        clr1_n <= '1';
        d1 <= '0';
        pre2_n <= '1';
        clr2_n <= '1';
        d2 <= '0';

        -- wait for three cycles
        wait for 3 * CLK_CYC;

        -- hold d1 high for 4 cycles
        wait for 50 ns;
        d1 <= '1';
        wait for 4 * CLK_CYC;

        -- d1 low
        d1 <= '0';
        wait for 4 * CLK_CYC;

        -- preset
        pre1_n <= '0';
        wait for CLK_CYC / 2;
        pre1_n <= '1';
        wait for CLK_CYC / 2;

        -- clear
        clr1_n <= '0';
        wait for CLK_CYC / 2;
        clr1_n <= '1';
        wait for CLK_CYC / 2;

        -- WARNING: THIS SIGNALS VIOLATE METASTABILITY
        wait until falling_edge(sys_clk);
        wait for 97 ns;
        d1 <= '1';      -- violate setup time

        wait until falling_edge(sys_clk);
        wait for 100.1 ns;
        d1 <= '0';      -- violate hold time

        wait until rising_edge(sys_clk);
        -----------------------------------------------

        -- wait forever
        finished <= '1';
        wait for 3 * CLK_CYC;
        wait;

    end process stimulus;


end architecture testbench;
