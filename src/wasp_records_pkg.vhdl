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
-- use work.wasp_records_pkg.all;

package wasp_records_pkg is

    -- interface for output modules
    type t_output_module is record
        latch       : std_logic;
        addr_in     : std_logic_vector;
        led_out     : std_logic_vector;
    end record t_output_module;

end package wasp_records_pkg;
