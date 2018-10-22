-------------------------------------------------------------------------------
--
-- unit name: The Switch Input Module of Wasp
-- author: Georg Ziegler
--
-- description: This module/entity represents the switch inputs of the Wasp
--
-- dependencies: ieee library, wasp_records_pkg
--
-------------------------------------------------------------------------------
-- TODO: Use generic in switch panel record
-- Move record to separate file
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wasp_records_pkg.all;

-- entity declaration
entity switch_input_module is
    generic ( constant ADDR_WIDTH : integer := 11;
              constant DATA_WIDTH : integer :=  8 );
    port    ( panel_input : in t_switch_panel( switch_input(ADDR_WIDTH - 1 downto 0) );
              addr_out    : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
              data_out    : out std_logic_vector (DATA_WIDTH - 1 downto 0)
               );
end entity switch_input_module;

-- structure architecture
architecture structure of switch_input_module is
begin

    -- code

end architecture structure;
