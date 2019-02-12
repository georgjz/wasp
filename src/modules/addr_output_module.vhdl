-------------------------------------------------------------------------------
--
-- unit name: The Address Output Module of Wasp
-- author: Georg Ziegler
--
-- description: This module/entity represents the LED outputs of the Wasp
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
entity addr_output_module is
    generic ( constant ADDR_WIDTH : integer := 11);
    port    ( latch   : in std_logic;         -- latch the new address to output
              addr_in : in std_logic_vector (ADDR_WIDTH - 1 downto 0);     -- address to latch to LEDs
              led_out : out std_logic_vector (ADDR_WIDTH - 1 downto 0) );  -- signals to display on LEDs
end entity addr_output_module;

-- structural architecture
architecture structure of addr_output_module is
    constant GND  : std_logic := '0';       -- represents ground/constant low
begin

    dlatch1 : entity work.sn74ahc573(rtl)
        port map ( oe_n => GND,                     -- output constantly enabled
                   le   => latch,                   -- will latch the new address
                   d(7 downto 3) => (7 downto 3 => GND),
                   d(2 downto 0) => addr_in(ADDR_WIDTH - 1 downto 8),
                   q(2 downto 0) => led_out(ADDR_WIDTH - 1 downto 8) );

    dlatch0 : entity work.sn74ahc573(rtl)
        port map ( oe_n => GND,                     -- output constantly enabled
                   le   => latch,                   -- will latch the new address
                   d    => addr_in(7 downto 0),
                   q    => led_out(7 downto 0) );

end architecture structure;
