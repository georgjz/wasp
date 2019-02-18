-------------------------------------------------------------------------------
--
-- unit name: The Control Signal Generator
-- author: Georg Ziegler
--
-- description: This module represents the Control Signal Generator for the Wasp.
-- It is meant to generate all control signals according to the user's input.
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
entity control_signal_generator is
    port    ( input  : in  t_to_control_signal_generator;
              output : out t_from_control_signal_generator );
              
    -- timing characteristics
    constant T_PD : delay_length := 15 ns;
end entity control_signal_generator;

-- structural architecture
architecture structure of control_signal_generator is
    constant PULLUP : std_logic := '1';
begin

    -- address counter control signals
    output.set_addr <= input.examine after T_PD;
    output.inc_addr <= input.examine_next after T_PD;

    -- address buffer control signals
    output.buffer_ctrl <= input.examine nor input.examine_next after T_PD;

    -- RAM control signals
    output.ram_cs_n <= input.examine nor input.examine_next after T_PD;
    output.ram_we_n <= PULLUP;
    output.ram_oe_n <= input.examine nor input.examine_next after T_PD;

    -- Address output module control signal
    output.addr_output <= input.examine xor input.examine_next after T_PD;

end architecture structure;
