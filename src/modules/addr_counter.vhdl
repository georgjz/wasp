-------------------------------------------------------------------------------
--
-- unit name: The Address Counter
-- author: Georg Ziegler
--
-- description: This module/entity counts up address, it is async presettable
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
entity addr_counter is
    generic ( constant ADDR_WIDTH : integer := 11);
    port    ( input  : in  t_to_address_counter ( addr_in(ADDR_WIDTH - 1 downto 0));         -- latch the new address to output
              output : out t_from_address_counter ( addr_out(ADDR_WIDTH - 1 downto 0)) );

    -- constants
    constant PULLUP : std_logic := '1';       -- represents pull-up/constant high
    constant GND    : std_logic := '0';       -- represents ground/constant low
end entity addr_counter;

-- structural architecture
architecture structure of addr_counter is
    -- internal signals
    signal rco0_out     : std_logic;    -- the ripple-carry from counter 0 to counter 1
    signal rco1_out     : std_logic;    -- the ripple-carry from counter 1 to counter 2
    signal rco0_and_inc : std_logic;
    signal rco1_and_inc : std_logic;
    signal load_n   : std_logic;        -- inverted set signal
begin

    counter2 : entity work.cd74ac161(rtl)
        port map ( clk           => input.clk,
                   clr_n         => PULLUP,
                   load_n        => load_n,
                   ent           => PULLUP,
                   enp           => rco1_and_inc,
                   rco           => open,
                   d(3)          => GND,
                   d(2 downto 0) => input.addr_in(ADDR_WIDTH - 1 downto 8),
                   -- q(3)          => open,
                   q(2 downto 0) => output.addr_out(ADDR_WIDTH - 1 downto 8) );

    counter1 : entity work.cd74ac161(rtl)
        port map ( clk    => input.clk,
                   clr_n  => PULLUP,
                   load_n => load_n,
                   ent    => PULLUP,
                   enp    => rco0_and_inc,
                   rco    => rco1_out,
                   d      => input.addr_in(7 downto 4),
                   q      => output.addr_out(7 downto 4) );

    counter0 : entity work.cd74ac161(rtl)
        port map ( clk    => input.clk,
                   clr_n  => PULLUP,
                   load_n => load_n,
                   ent    => PULLUP,
                   enp    => input.inc,
                   rco    => rco0_out,
                   d      => input.addr_in(3 downto 0),
                   q      => output.addr_out(3 downto 0) );

    AndChip : entity work.sn74ahc08(rtl)
        port map ( -- rco0 * inc
                   a1 => input.inc,
                   b1 => rco0_out,
                   y1 => rco0_and_inc,
                   -- In * (not A)
                   a2 => input.inc,
                   b2 => rco1_out,
                   y2 => rco1_and_inc,
                   -- not used
                   a3 => GND,
                   b3 => GND,
                   y3 => open,
                   -- not used
                   a4 => GND,
                   b4 => GND,
                   y4 => open );

    -- internal glue logic
    load_n <= not input.set after 6 ns;


end architecture structure;
