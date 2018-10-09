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

-- entity declaration
entity addr_counter_submodule_tb is
end entity addr_counter_submodule_tb;

-- test bench architecture
architecture testbench of addr_counter_submodule_tb is
    signal sys_clk, clr_n, load_addr, next_addr : std_logic := '0';
    signal addr_in, addr_out  : std_logic_vector (10 downto 0) := (others => 'X');
    -- stop clock generator
    signal finished : std_logic := '0';
begin

    dut : entity work.addr_counter_submodule(structure)
        port map ( clk       => sys_clk,
                   clr_n     => clr_n,
                   load_addr => load_addr,
                   next_addr => next_addr,
                   addr_in   => addr_in,
                   addr_out  => addr_out );

    -- clock generator
    sys_clk <= not sys_clk after 100 ns when finished /= '1' else '0';

    stimulus : process is
        constant CLK_CYC : delay_length := 200 ns;
    begin

        -- wait for 3 clock cycles
        clr_n <= '1';
        wait for 3 * CLK_CYC;
        wait for CLK_CYC / 2;

        -- load $1f0 address
        addr_in <= B"001_1111_0000";
        load_addr <= '1';
        wait for 2 * CLK_CYC;
        load_addr <= '0';

        -- count up
        for i in 0 to 20 loop
            wait for 10 ns;
            next_addr <= not next_addr;
            wait for 2 * CLK_CYC - 10 ns;
        end loop;
        next_addr <= '0';

        -- WARNING: THIS SIGNALS VIOLATE METASTABILITY
        wait for 100 ns;
        clr_n <= '0';
        wait for 98 ns;
        clr_n <= '1';
        wait for 2 * CLK_CYC;
        -- -------------------------------------------

        -- wait forever
        finished <= '1';
        wait for 3 * CLK_CYC;
        wait;

    end process stimulus;


end architecture testbench;
