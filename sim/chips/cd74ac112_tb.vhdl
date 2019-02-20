-------------------------------------------------------------------------------
--
-- unit name: Testbench for CD74AC161 (cd74ac161_tb)
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the cd74ac161 unit
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Improve metastability check
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity cd74ac112_tb is
end entity cd74ac112_tb;

-- test bench architecture
architecture testbench of cd74ac112_tb is
    -- test signals
    signal clk1   : std_logic := '0';
    signal clr1_n : std_logic := '0';
    signal pre1_n : std_logic := '0';
    signal j1     : std_logic := '0';
    signal k1     : std_logic := '0';
    signal q1     : std_logic := '0';
    signal q1_n   : std_logic := '0';
    signal clk2   : std_logic := '0';
    signal clr2_n : std_logic := '0';
    signal pre2_n : std_logic := '0';
    signal j2     : std_logic := '0';
    signal k2     : std_logic := '0';
    signal q2     : std_logic := '0';
    signal q2_n   : std_logic := '0';
    -- clock signals
    signal sys_clk  : std_logic := '0';
    signal finished : std_logic := '0';
    constant HALF_PERIOD : delay_length := 25 ns; -- 14 MHz
begin

    dut : entity work.cd74ac112(rtl)
    port map ( clk1   => clk1,
               clr1_n => clr1_n,
               pre1_n => pre1_n,
               j1     => j1,
               k1     => k1,
               q1     => q1,
               q1_n   => q1_n,
               clk2   => clk2,
               clr2_n => clr2_n,
               pre2_n => pre2_n,
               j2     => j2,
               k2     => k2,
               q2     => q2,
               q2_n   => q2_n );

    -- clk generator
    sys_clk <= not sys_clk after HALF_PERIOD when finished /= '1' else '0';


    -- test signals
    stimulus : process is
    begin
        -- wait for three clock cycles
        wait for 5 * HALF_PERIOD;
        wait for HALF_PERIOD / 2;

        -- generate all inputs
        j1 <= '0'; k1 <= '0'; clr1_n <= '0'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '0'; k1 <= '0'; clr1_n <= '1'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '0'; k1 <= '0'; clr1_n <= '1'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '0'; k1 <= '1'; clr1_n <= '0'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '0'; k1 <= '1'; clr1_n <= '0'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '0'; k1 <= '1'; clr1_n <= '1'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '0'; k1 <= '1'; clr1_n <= '1'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '0'; clr1_n <= '0'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '0'; clr1_n <= '0'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '0'; clr1_n <= '1'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '0'; clr1_n <= '1'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '1'; clr1_n <= '0'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '1'; clr1_n <= '0'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '1'; clr1_n <= '1'; pre1_n <= '0'; wait for 2 * HALF_PERIOD;
        j1 <= '1'; k1 <= '1'; clr1_n <= '1'; pre1_n <= '1'; wait for 2 * HALF_PERIOD;

        wait for 6 * HALF_PERIOD;

        -- WARNING: THESE SIGNALS VIOLATE METASTABILITY
        -- violate clear recovery
        -- wait until falling_edge(clk);
        -- clr_n <= '0';
        -- wait for 46 ns;
        -- clr_n <= '1';
        --
        -- -- violate load setup
        -- wait until falling_edge(clk);
        -- load_n <= '0';
        -- wait for 46 ns;
        -- load_n <= '1';
        --
        -- -- violate data setup
        -- wait until falling_edge(clk);
        -- d <= X"e";
        -- wait for 47 ns;
        -- d <= X"f";
        --
        -- wait until falling_edge(clk);
        -- -- --------------------------------------------

        -- stop clock and wait forever
        finished <= '1';
        wait;

    end process stimulus;


end architecture testbench;
