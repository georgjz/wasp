-------------------------------------------------------------------------------
--
-- unit name: Test Bench for the SN74AHC08 Quad 2-Input AND
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the sn74ahc08 unit
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
entity sn74ahc08_tb is
end entity sn74ahc08_tb;

-- test bench architecture
architecture testbench of sn74ahc08_tb is

    -- test signals
    signal a1 : std_logic := '0';
    signal b1 : std_logic := '0';
    signal a2 : std_logic := '0';
    signal b2 : std_logic := '0';
    signal a3 : std_logic := '0';
    signal b3 : std_logic := '0';
    signal a4 : std_logic := '0';
    signal b4 : std_logic := '0';
    signal y1 : std_logic;
    signal y2 : std_logic;
    signal y3 : std_logic;
    signal y4 : std_logic;
begin

    -- device under test
    dut : entity work.sn74ahc08(rtl)
        port map ( a1 => a1,
                   b1 => b1,
                   a2 => a2,
                   b2 => b2,
                   a3 => a3,
                   b3 => b3,
                   a4 => a4,
                   b4 => b4,
                   y1 => y1,
                   y2 => y2,
                   y3 => y3,
                   y4 => y4 );

    -- generate test signals
    stimulus : process is
    begin

    -- wait a bit
    wait for 100 ns;

    -- all input combinations
    a1 <= '0';
    b1 <= '0';
    a2 <= '0';
    b2 <= '1';
    a3 <= '1';
    b3 <= '0';
    a4 <= '1';
    b4 <= '1';
    wait for 100 ns;

    -- set inputs to zero
    a1 <= '0';
    b1 <= '0';
    a2 <= '0';
    b2 <= '0';
    a3 <= '0';
    b3 <= '0';
    a4 <= '0';
    b4 <= '0';
    wait for 100 ns;

    -- wait forever
    wait;

    end process stimulus;

end architecture testbench;
