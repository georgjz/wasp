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

    -- control signals for RAM
    type t_ram_ctrl is record
        cs_n        : std_logic;
        we_n        : std_logic;
        oe_n        : std_logic;
    end record t_ram_ctrl;

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
        ram_ctrl    : t_ram_ctrl;
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

    -- interface for quad logic chip
    type t_to_quad_two_input_logic is record
        a1          : std_logic;
        b1          : std_logic;
        a2          : std_logic;
        b2          : std_logic;
        a3          : std_logic;
        b3          : std_logic;
        a4          : std_logic;
        b4          : std_logic;
    end record t_to_quad_two_input_logic;

    type t_from_quad_two_input_logic is record
        y1          : std_logic;
        y2          : std_logic;
        y3          : std_logic;
        y4          : std_logic;
    end record t_from_quad_two_input_logic;

    -- interface for hex logic chip
    type t_to_hex_one_input_logic is record
        a1          : std_logic;
        a2          : std_logic;
        a3          : std_logic;
        a4          : std_logic;
        a5          : std_logic;
        a6          : std_logic;
    end record t_to_hex_one_input_logic;

    type t_from_hex_one_input_logic is record
        y1          : std_logic;
        y2          : std_logic;
        y3          : std_logic;
        y4          : std_logic;
        y5          : std_logic;
        y6          : std_logic;
    end record t_from_hex_one_input_logic;

end package wasp_records_pkg;
