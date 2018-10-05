-------------------------------------------------------------------------------
--
-- unit name: Test bench for IDT6116xAxx (idt6116xaxx_tb)
-- author: Georg Ziegler
--
-- description: This test bench verfies functionality of the idt6116xaxx unit
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
entity idt6116xaxx_tb is
end entity idt6116xaxx_tb;

-- test bench architecture
architecture test_bench of idt6116xaxx_tb is
    -- signal
    signal data_in : std_logic_vector (7 downto 0) := (others => 'Z');
    signal addr_in : std_logic_vector (10 downto 0) := (others => 'Z');
    signal cs_n, oe_n, we_n : std_logic := 'Z';
begin

    dut : entity work.idt6116xaxx(rtl)
        port map ( data => data_in,
                   addr => addr_in,
                   cs_n => cs_n,
                   we_n => we_n,
                   oe_n => oe_n );

    -- code
    stimulus : process is
        type data_buffer is range 0 to 255;
        variable datum : data_buffer := 0;
    begin
        -- set control lines
        cs_n <= '0';
        oe_n <= '0';
        we_n <= '0';
        wait for 100 ns;

        -- fill RAM with dummy data
        for i in 0 to 2**11 loop
            --code
            data_in <= X"da";
            addr_in <= std_logic_vector(to_unsigned(i, addr_in'length));
            wait for 100 ns;
        end loop;
        -- wait forever
        wait;
    end process stimulus;

end architecture test_bench;
