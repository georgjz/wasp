-------------------------------------------------------------------------------
--
-- unit name: Testbench for signal-clock syncer
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the syncer unit
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
entity syncer_tb is
end entity syncer_tb;

-- test bench architecture
architecture testbench of syncer_tb is
    signal sys_clk : std_logic := '0';            -- clock signal
    signal d       : std_logic := 'X';
    signal q       : std_logic := 'X';
    -- stop signal
    signal finished : std_logic := '0';
begin

    dut : entity work.syncer(structure)
        port map ( clk      => sys_clk,
                   sig_in.d => d,
                   q        => q );

    -- clk generator
    sys_clk <= not sys_clk after 50 ns when finished /= '1' else '0';


    -- test signals
    stimulus : process is
        constant CLK_CYC : delay_length := 100 ns;
    begin
        -- wait for three clock cycles
        wait for 3 * CLK_CYC;

        d <= '1';
        wait for CLK_CYC;
        d <= '0';
        wait for 3 * CLK_CYC;

        -- stop clock and wait forever
        finished <= '1';
        wait for 100 ns;
        wait;

    end process stimulus;

end architecture testbench;
