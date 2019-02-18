-------------------------------------------------------------------------------
--
-- unit name: Testbench for IDT6116xAxx (idt6116xaxx_tb)
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the idt6116xaxx unit
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
entity idt6116xaxx_tb is
end entity idt6116xaxx_tb;

-- test bench architecture
architecture testbench of idt6116xaxx_tb is
    -- signal
    signal data_in : std_logic_vector (7 downto 0) := (others => 'Z');
    signal addr_in : std_logic_vector (10 downto 0) := (others => 'Z');
    signal cs_n, oe_n, we_n : std_logic := 'Z';
begin

    dut : entity work.idt6116xaxx(rtl)
        port map ( data => data_in,
                   addr => addr_in,
                   ctrl.cs_n => cs_n,
                   ctrl.we_n => we_n,
                   ctrl.oe_n => oe_n );

    -- code
    stimulus : process is
        type data_buffer is range 0 to 255;
        variable datum : data_buffer := 0;
    begin
        -- set control lines
        cs_n <= '1';
        oe_n <= '1';
        we_n <= '1';
        wait for 100 ns;

        -- write $de to $0000
        cs_n <= '0';
        oe_n <= '1';
        we_n <= '0';
        data_in <= X"de";
        addr_in <= B"000_0000_0000";
        wait for 100 ns;

        -- put back into hi-Z mode
        cs_n <= '1';
        oe_n <= '1';
        we_n <= '1';
        data_in <= (others => 'Z');
        wait for 100 ns;

        -- read data from $0000
        cs_n <= '0';
        oe_n <= '0';
        we_n <= '1';
        addr_in <= B"000_0000_0000";

        -- PROVOKE BUS CONFLICT
        data_in <= X"ad";
        wait for 100 ns;

        -- put back into hi-Z mode
        cs_n <= '1';
        oe_n <= '1';
        we_n <= '1';
        -- data_in <= (others => 'Z');
        wait for 100 ns;

        -- fill RAM with dummy data
        -- for i in 0 to (2**11 - 1) loop
        --     -- write cycle
        --     cs_n <= '0';        -- select chip
        --     we_n <= '0';        -- enable writing to chip
        --     oe_n <= '1';        -- disable output
        --     data_in <= X"da";
        --     addr_in <= std_logic_vector(to_unsigned(i, addr_in'length));
        --     wait for 100 ns;
        --     -- idle cycle
        --     cs_n <= '1';        -- deselect chip
        --     we_n <= '1';        -- disable writing
        --     wait for 50 ns;
        --     -- read cycle
        --     cs_n <= '0';        -- select chip
        --     oe_n <= '0';        -- enable output
        --     wait for 50 ns;
        -- end loop;

        -- wait forever
        wait;
    end process stimulus;

end architecture testbench;
