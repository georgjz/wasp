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
                   ctrl.cs_n => cs_n,
                   ctrl.we_n => we_n,
                   ctrl.oe_n => oe_n );

    -- data output
    dataled : entity work.data_output_module(structure)
        port map ( input.latch => ld,
                   input.data_in => data_bus,
                   output.led_out => data_leds );

    -- address output
    addrled : entity work.addr_output_module(structure)
        port map ( input.latch => la,
                   input.data_in => addr_bus,
                   output.led_out => addr_leds );

    -- "glue logic"
    cs_n <= not (read_data or write_data);
    we_n <= not write_data;
    oe_n <= not read_data;
    ld   <= (read_data or write_data);
    la   <= (read_data or write_data);

    -- connect inputs to data and address bus
    data_bus <= data_input;
    addr_bus <= addr_input;

    -- connect outputs to "LEDs"
    data_output <= data_leds;
    addr_output <= addr_leds;

end architecture structure;
