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

end package wasp_records_pkg;
