-------------------------------------------------------------------------------
--
-- unit name: Test Bench for the SN74AHC04 Hex NOT
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the sn74ahc04 unit
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
-- use work.wasp_records_pkg.all;

-- entity declaration
entity sn74ahc04_tb is
end entity sn74ahc04_tb;

-- test bench architecture
architecture testbench of sn74ahc04_tb is
    -- test signals
    signal a1 : std_logic := '0';
    signal a2 : std_logic := '0';
    signal a3 : std_logic := '0';
    signal a4 : std_logic := '0';
    signal a5 : std_logic := '0';
    signal a6 : std_logic := '0';
    signal y1 : std_logic;
    signal y2 : std_logic;
    signal y3 : std_logic;
    signal y4 : std_logic;
    signal y5 : std_logic;
    signal y6 : std_logic;
begin

    -- device under test
    dut : entity work.sn74ahc04(rtl)
        port map ( a1 => a1,
                   a2 => a2,
                   a3 => a3,
                   a4 => a4,
                   a5 => a5,
                   a6 => a6,
                   y1 => y1,
                   y2 => y2,
                   y3 => y3,
                   y4 => y4,
                   y5 => y5,
                   y6 => y6 );

    -- generate test signals
    stimulus : process is
    begin

    -- wait a bit
    wait for 100 ns;

    -- all input combinations
    a1 <= '0';
    a2 <= '1';
    a3 <= '0';
    a4 <= '1';
    a5 <= '0';
    a6 <= '1';
    wait for 100 ns;

    -- set inputs to one
    a1 <= '1';
    a2 <= '1';
    a3 <= '1';
    a4 <= '1';
    a5 <= '1';
    a6 <= '1';
    wait for 100 ns;

    -- wait forever
    wait;

    end process stimulus;

end architecture testbench;
