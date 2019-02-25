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
use work.wasp_records_pkg.all;

-- entity declaration
entity simple_wasp is
    port ( sys_clk      : in std_logic;
           examine      : in std_logic;
           examine_next : in std_logic;
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
    signal addr_bus_cnt_to_buffer : std_logic_vector (10 downto 0) := (others => 'Z');

    -- RAM control signals
    signal ram_ctrl : t_ram_ctrl;

    -- internal signals
    signal set_addr_n : std_logic := 'U';
    signal inc_addr : std_logic := 'U';
    signal addr_buffer_ctrl_n : std_logic := 'U';
    signal addr_output_latch  : std_logic := 'U';

    -- LED outputs
    signal data_leds : std_logic_vector (7 downto 0) := (others => 'Z');
    signal addr_leds : std_logic_vector (10 downto 0) := (others => 'Z');
begin

    -- RAM
    ram : entity work.idt6116xaxx(rtl)
        port map ( data => data_bus,
                   addr => addr_bus,
                   ctrl.cs_n => ram_ctrl.cs_n,
                   ctrl.we_n => ram_ctrl.we_n,
                   ctrl.oe_n => ram_ctrl.oe_n );

    -- control signal generator
    csg : entity work.control_signal_generator(structure)
        port map ( input.clk => sys_clk,
                   input.examine => examine,
                   input.examine_next => examine_next,
                   output.set_addr_n => set_addr_n,
                   output.inc_addr => inc_addr,
                   output.buffer_ctrl_n => addr_buffer_ctrl_n,
                   output.ram_ctrl => ram_ctrl,
                   output.addr_output => addr_output_latch );

    addrcounter : entity work.addr_counter(structure)
        port map ( input.clk => sys_clk,
                   input.set => set_addr_n,
                   input.inc => inc_addr,
                   input.addr_in => addr_input,
                   output.addr_out => addr_bus_cnt_to_buffer );

    addrbuffer: entity work.addr_buffer(structure)
        port map ( input.enable_n => addr_buffer_ctrl_n,
                   input.data_in => addr_bus_cnt_to_buffer,
                   output.data_out => addr_bus );

    -- address output
    addrled : entity work.addr_output_module(structure)
        port map ( input.latch => addr_output_latch,
                   input.data_in => addr_bus,
                   output.led_out => addr_leds );

    -- connect outputs to "LEDs"
    data_output <= data_leds;
    addr_output <= addr_leds;

end architecture structure;
