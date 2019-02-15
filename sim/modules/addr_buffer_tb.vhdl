-------------------------------------------------------------------------------
--
-- unit name: Test bench for the Address Buffer
-- author: Georg Ziegler
--
-- description: This module represents the Address Buffer. It decouples the
-- input bus from another.
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
entity addr_buffer_tb is
end entity addr_buffer_tb;

-- structural architecture
architecture testbench of addr_buffer_tb is
    -- test signal
    constant ADDR_WIDTH : integer := 11;
    signal input  : t_to_buffer (data_in(ADDR_WIDTH - 1 downto 0));
    signal output : t_from_buffer (data_out(ADDR_WIDTH - 1 downto 0));
begin

    -- device under test
    dut : entity work.addr_buffer(structure)
        port map ( input => input,
                   output => output );

    -- test signal generator
    stimulus : process is
    begin
        -- set all to low state
        input.enable_n <= '1';
        input.data_in <= (others => '0');
        wait for 50 ns;

        -- change input and latch it into buffer
        input.enable_n <= '0';
        input.data_in <= B"010_0101_1100";
        wait for 100 ns;

        -- disable output and change input several times
        input.enable_n <= '1';
        input.data_in <= B"100_1010_1001"; wait for 50 ns;
        input.data_in <= B"010_0100_1110"; wait for 50 ns;
        input.data_in <= B"101_0010_0101"; wait for 50 ns;
        input.data_in <= B"110_0101_1010"; wait for 50 ns;

        -- enable output
        input.enable_n <= '0';
        wait for 100 ns;

        -- wait forever
        wait;

    end process stimulus;

end architecture testbench;
