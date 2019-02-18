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
use work.wasp_records_pkg.all;

-- entity declaration
entity sn74ahc04_tb is
end entity sn74ahc04_tb;

-- test bench architecture
architecture testbench of sn74ahc04_tb is
    -- test signals
    signal input  : t_to_hex_one_input_logic;
    signal output : t_from_hex_one_input_logic;
begin

    -- device under test
    dut : entity work.sn74ahc04(rtl)
        port map ( input => input,
                   output => output );

    -- generate test signals
    stimulus : process is
    begin

    -- set inputs to zero
    input.a1 <= '0';
    input.a2 <= '0';
    input.a3 <= '0';
    input.a4 <= '0';
    input.a5 <= '0';
    input.a6 <= '0';
    wait for 100 ns;

    -- all input combinations
    input.a1 <= '0';
    input.a2 <= '1';
    input.a3 <= '0';
    input.a4 <= '1';
    input.a5 <= '0';
    input.a6 <= '1';
    wait for 100 ns;

    -- set inputs to one
    input.a1 <= '1';
    input.a2 <= '1';
    input.a3 <= '1';
    input.a4 <= '1';
    input.a5 <= '1';
    input.a6 <= '1';
    wait for 100 ns;

    -- wait forever
    wait;

    end process stimulus;

end architecture testbench;
