-------------------------------------------------------------------------------
--
-- unit name: Test Bench for the SN74AHC00 Quad 2-Input NAND
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the sn74ahc00 unit
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
entity sn74ahc00_tb is
end entity sn74ahc00_tb;

-- test bench architecture
architecture testbench of sn74ahc00_tb is
    -- test signals
    signal input  : t_to_quad_two_input_logic;
    signal output : t_from_quad_two_input_logic;
begin

    -- device under test
    dut : entity work.sn74ahc00(rtl)
        port map ( input => input,
                   output => output );

    -- generate test signals
    stimulus : process is
    begin

    -- set inputs to zero
    input.a1 <= '0';
    input.b1 <= '0';
    input.a2 <= '0';
    input.b2 <= '0';
    input.a3 <= '0';
    input.b3 <= '0';
    input.a4 <= '0';
    input.b4 <= '0';
    wait for 100 ns;

    -- all input combinations
    input.a1 <= '0';
    input.b1 <= '0';
    input.a2 <= '0';
    input.b2 <= '1';
    input.a3 <= '1';
    input.b3 <= '0';
    input.a4 <= '1';
    input.b4 <= '1';
    wait for 100 ns;

    -- set inputs to zero
    input.a1 <= '0';
    input.b1 <= '0';
    input.a2 <= '0';
    input.b2 <= '0';
    input.a3 <= '0';
    input.b3 <= '0';
    input.a4 <= '0';
    input.b4 <= '0';
    wait for 100 ns;

    -- wait forever
    wait;

    end process stimulus;

end architecture testbench;
