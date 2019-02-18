-------------------------------------------------------------------------------
--
-- unit name: A simple Wasp model
-- author: Georg Ziegler
--
-- description: This testbench represents a simple Wasp version with data and
-- address output only
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
entity simple_wasp_tb is
    end entity simple_wasp_tb;
-- test bench architecture
architecture testbench of simple_wasp_tb is
    -- test signals
    signal read_data    : std_logic := '0';
    signal write_data   : std_logic := '0';
    signal data_input   : std_logic_vector (7 downto 0) := (others => '0');
    signal data_output  : std_logic_vector (7 downto 0);
    signal addr_input   : std_logic_vector (10 downto 0) := (others => '0');
    signal addr_output  : std_logic_vector (10 downto 0);
begin
    -- RAM
    wasp : entity work.simple_wasp(structure)
        port map ( read_data  => read_data,
                   write_data => write_data,
                   data_input => data_input,
                   data_output => data_output,
                   addr_input  => addr_input,
                   addr_output => addr_output );

    -- code
    stimulus : process is
        -- type data_buffer is range 0 to 255;
        -- variable datum : data_buffer := 0;
    begin
        -- just chill a bit
        wait for 50 ns;

        -- write $c0 to $010
        write_data <= '1';
        -- "manually" put the data and address on their respective buses
        data_input <= X"c0";
        addr_input <= B"000_0001_0000";
        wait for 100 ns;
        -- wait for 2 ns; -- PROVOKE METASTABILITY VIOLATION

        -- put RAM and output modules back into hi-Z mode
        write_data <= '0';
        wait for 100 ns;

        -- write $fe to $020
        write_data <= '1';
        -- "manually" put the data and address on their respective buses
        data_input <= X"fe";
        addr_input <= B"000_0010_0000";
        wait for 100 ns;

        -- put RAM and output modules back into hi-Z mode
        write_data <= '0';
        wait for 100 ns;

        -- RAM content: $c0 at $010, $fe at $020

        -- change the data bus to some random values, this should have no effect
        data_input <= X"aa"; wait for 50 ns;
        data_input <= X"12"; wait for 50 ns;
        data_input <= X"d5"; wait for 50 ns;
        data_input <= X"b1"; wait for 50 ns;
        data_input <= X"ff"; wait for 50 ns;

        -- read data from $010
        data_input <= (others => 'Z');
        read_data <= '1';
        addr_input <= B"000_0001_0000";
        wait for 100 ns;

        -- put RAM and output modules back into hi-Z mode
        read_data <= '0';
        wait for 100 ns;

        -- PROVOKE BUS CONFLICT
        -- data_in <= X"ad";
        -- wait for 100 ns;

        -- put back into hi-Z mode
        -- cs_n <= '1';
        -- oe_n <= '1';
        -- we_n <= '1';
        -- data_in <= (others => 'Z');
        -- wait for 100 ns;

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
