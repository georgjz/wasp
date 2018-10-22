-------------------------------------------------------------------------------
--
-- unit name: Testbench for Wasp's Address Counter Submodule
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the Address Counter Submodule
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
entity addr_counter_tb is
end entity addr_counter_tb;

-- test bench architecture
architecture testbench of addr_counter_tb is
    signal sys_clk, clr_n, load_addr, next_addr : std_logic := '0';
    signal addr_in, addr_out  : std_logic_vector (10 downto 0) := (others => 'X');
    -- stop clock generator
    signal finished : std_logic := '0';
begin

    dut : entity work.addr_counter(structure)
        port map ( clk              => sys_clk,
                   counter_in.load  => load_addr,
                   counter_in.clr_n => clr_n,
                   counter_in.d     => addr_in,
                   addr_out         => addr_out );

    -- clock generator
    sys_clk <= not sys_clk after 100 ns when finished /= '1' else '0';

    stimulus : process is
        constant CLK_CYC : delay_length := 200 ns;
    begin

        -- wait for 3 clock cycles
        clr_n <= '1';
        wait for 3 * CLK_CYC;
        addr_in <= B"001_1111_0000";
        wait for CLK_CYC;
        -- wait for CLK_CYC / 2;
        --
        -- -- load $1f0 address
        -- THIS SOULD VIOLATE SETUP TIME FOR LOAD SIGNAL
        wait for 1 ns;
        load_addr <= '1';
        wait for CLK_CYC/2 - 4 ns;
        addr_in <= B"001_1111_0000";
        load_addr <= '0';
        -- wait for  CLK_CYC;
        wait until falling_edge(sys_clk);
        load_addr <= '0';

        -- wait forever
        finished <= '1';
        wait for 3 * CLK_CYC;
        wait;

    end process stimulus;

end architecture testbench;
