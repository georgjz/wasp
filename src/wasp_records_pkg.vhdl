-------------------------------------------------------------------------------
--
-- unit name: wasp_records_pkg
-- author: Georg Ziegler
--
-- description: This package contains records used by various Wasp entities
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

package wasp_records_pkg is

    -- interface for output modules
    type t_to_output_module is record
        latch       : std_logic;
        data_in     : std_logic_vector;
    end record t_to_output_module;

    type t_from_output_module is record
        led_out     : std_logic_vector;
    end record t_from_output_module;

    -- interface for address counter
    type t_to_address_counter is record
        set         : std_logic;
        inc         : std_logic;
        addr_in     : std_logic_vector;
    end record t_to_address_counter;

    type t_from_address_counter is record
        addr_out    : std_logic_vector;
    end record t_from_address_counter;

    -- interface for control signal generator
    type t_to_control_signal_generator is record
        examine     : std_logic;
        examine_next: std_logic;
    end record t_to_control_signal_generator;

    type t_from_control_signal_generator is record
        set_addr    : std_logic;
        inc_addr    : std_logic;
        buffer_ctrl : std_logic;
        ram_cs_n    : std_logic;
        ram_we_n    : std_logic;
        ram_oe_n    : std_logic;
        addr_output : std_logic;
    end record t_from_control_signal_generator;

    -- interface for address buffer
    type t_to_buffer is record
        enable_n    : std_logic;
        data_in     : std_logic_vector;
    end record t_to_buffer;

    type t_from_buffer is record
        data_out    : std_logic_vector;
    end record t_from_buffer;

end package wasp_records_pkg;
