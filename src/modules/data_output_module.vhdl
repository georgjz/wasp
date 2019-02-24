-------------------------------------------------------------------------------
--
-- unit name: The Data Output Module of Wasp
-- author: Georg Ziegler
--
-- description: This module/entity represents the LED data outputs of the Wasp
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
entity data_output_module is
    generic ( constant DATA_WIDTH : integer := 8);
    port    ( input  : in  t_to_output_module ( data_in(DATA_WIDTH - 1 downto 0));         -- latch the new address to output
              output : out t_from_output_module ( led_out(DATA_WIDTH - 1 downto 0)) );

    -- constants          
    constant GND  : std_logic := '0';       -- represents ground/constant low
end entity data_output_module;

-- structural architecture
architecture structure of data_output_module is
begin

    dlatch0 : entity work.sn74ahc573(rtl)
        port map ( oe_n => GND,                     -- output constantly enabled
                   le   => input.latch,                   -- will latch the new address
                   d    => input.data_in,
                   q    => output.led_out );

end architecture structure;
