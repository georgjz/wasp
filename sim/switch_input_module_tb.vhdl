-------------------------------------------------------------------------------
--
-- unit name: Testbench for Wasp's Switch Input Module entity
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the Switch Input Module
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
entity switch_input_module_tb is
end entity switch_input_module_tb;

-- test bench architecture
architecture testbench of switch_input_module_tb is
    -- system clock, stop clock generator
    signal sys_clk : std_logic := '0';
    signal finished : std_logic := '0';
    signal switch_input : t_switch_panel( switch_input(10 downto 0) );
    signal addr_out  : std_logic_vector (10 downto 0) := (others => 'X');
begin

    dut : entity work.switch_input_module(structure)
        port map ( clk         => sys_clk,
                   panel_input => switch_input,
                   addr_out    => addr_out,
                   data_out    => open );

    -- clock generator
    sys_clk <= not sys_clk after 100 ns when finished /= '1' else '0';

    stimulus : process is
        constant CLK_CYC : delay_length := 200 ns;
    begin

        -- wait for 3 clock cycles
        wait for 3 * CLK_CYC;
        switch_input.switch_input <= B"000_1010_1010";
        -- addr_in <= B"001_1111_0000";
        switch_input.examine <= '1';
        wait for CLK_CYC;
        switch_input.examine <= '0';
        -- wait for CLK_CYC / 2;

        wait for 6 * CLK_CYC;

        -- --
        -- -- -- load $1f0 address
        -- -- THIS SOULD VIOLATE SETUP TIME FOR LOAD SIGNAL
        -- wait for 1 ns;
        -- load_addr <= '1';
        -- wait for CLK_CYC/2 - 4 ns;
        -- addr_in <= B"001_1111_0000";
        -- load_addr <= '0';
        -- -- wait for  CLK_CYC;
        -- wait until falling_edge(sys_clk);
        -- load_addr <= '0';
        -- -- violate data setup
        -- wait for CLK_CYC/4;
        -- load_addr <= '1';
        -- wait for CLK_CYC/4 - 3 ns;
        -- addr_in <= B"001_1111_1111";
        -- wait for CLK_CYC/4;
        -- load_addr <= '0';
        -- addr_in <= B"000_0000_0000";
        -- wait for CLK_CYC/4;

        -- wait forever
        finished <= '1';
        wait for 3 * CLK_CYC;
        wait;

    end process stimulus;

end architecture testbench;
