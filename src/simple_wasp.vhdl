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
entity simple_wasp is
    port ( read_data    : in std_logic;
           write_data   : in std_logic;
           data_input   : in std_logic_vector (7 downto 0);
           data_output  : out std_logic_vector (7 downto 0);
           addr_input   : in std_logic_vector (10 downto 0);
           addr_output  : out std_logic_vector (10 downto 0) );
    end entity simple_wasp;

-- structural architecture
architecture structure of simple_wasp is
    -- data and address bus
    signal data_bus : std_logic_vector (7 downto 0) := (others => 'Z');
    signal addr_bus : std_logic_vector (10 downto 0) := (others => 'Z');

    -- control signals
    signal cs_n, oe_n, we_n, ld, la : std_logic := 'Z';

    -- LED outputs
    signal data_leds : std_logic_vector (7 downto 0) := (others => 'Z');
    signal addr_leds : std_logic_vector (10 downto 0) := (others => 'Z');
begin
    -- RAM
    ram : entity work.idt6116xaxx(rtl)
        port map ( data => data_bus,
                   addr => addr_bus,
                   cs_n => cs_n,
                   we_n => we_n,
                   oe_n => oe_n );

    -- data output
    dataled : entity work.data_output_module(structure)
        port map ( latch => ld,
                   data_in => data_bus,
                   led_out => data_leds );

    -- address output
    addrled : entity work.addr_output_module(structure)
        port map ( latch => la,
                   addr_in => addr_bus,
                   led_out => addr_leds );

    -- "glue logic"
    -- cs_n <= '0' when (read_data = '1' or write_data = '1') else
            -- '1';
    cs_n <= not (read_data or write_data);
    we_n <= not write_data;
    oe_n <= not read_data;
    ld   <= '1' when (read_data = '1' or write_data = '1') else
            '0';
    la   <= '1' when (read_data = '1' or write_data = '1') else
            '0';

    -- connect inputs to data and address bus
    data_bus <= data_input;
    addr_bus <= addr_input;

    -- connect outputs to "LEDs"
    data_output <= data_leds;
    addr_output <= addr_leds;

end architecture structure;