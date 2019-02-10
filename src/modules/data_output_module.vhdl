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

-- entity declaration
entity data_output_module is
    generic ( constant DATA_WIDTH : integer := 8);
    port    ( latch   : in std_logic;         -- latch the new address to output
              data_in : in std_logic_vector (DATA_WIDTH - 1 downto 0);     -- address to latch to LEDs
              led_out : out std_logic_vector (DATA_WIDTH - 1 downto 0) );  -- signals to display on LEDs
end entity data_output_module;

-- structural architecture
architecture structure of data_output_module is
    constant GND  : std_logic := '0';       -- represents ground/constant low
begin

    dlatch0 : entity work.sn74ahc573(rtl)
        port map ( oe_n => GND,                     -- output constantly enabled
                   le   => latch,                   -- will latch the new address
                   d    => data_in,
                   q    => led_out );

end architecture structure;
