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

    -- input of control switches
    type t_control_panel is record
        deposit     : std_logic;
        examine     : std_logic;
    end record t_control_panel;

    -- switch panel input
    type t_switch_panel is record
        switch_input  : std_logic_vector;
        control_input : t_control_panel;
        -- deposit      : std_logic;
        -- deposit_next : std_logic;
        -- examine      : std_logic;
        -- examine_next : std_logic;
    end record t_switch_panel;

    -- interface for address counter module
    type t_addr_counter is record
        -- clk         : std_logic;        -- system clock input
        load        : std_logic;        -- signal to load new address/data from input
        clr_n       : std_logic;        -- clear the counter to zero
        -- control_in  : t_control_panel;
        d           : std_logic_vector; -- address/data input
    end record t_addr_counter;

end package wasp_records_pkg;
