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
    -- switch panel input
    type t_switch_panel is record
        switch_input : std_logic_vector;
        deposit      : std_logic;
        deposit_next : std_logic;
        examine      : std_logic;
        examine_next : std_logic;
    end record t_switch_panel;

end package wasp_records_pkg;
