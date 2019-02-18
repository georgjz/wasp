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
    signal rco_c0_to_c1 : std_logic;    -- the ripple-carry from counter 0 to counter 1
    signal rco_c1_to_c2 : std_logic;    -- the ripple-carry from counter 1 to counter 2
    signal clk_0    : std_logic;        -- clk signal to counter 0
    signal clk_1    : std_logic;        -- clk signal to counter 1
    signal clk_2    : std_logic;        -- clk signal to counter 2
    signal load_n   : std_logic;        -- inverted set signal
begin

    counter2 : entity work.cd74ac161(rtl)
        port map ( clk           => clk_2,
                   clr_n         => PULLUP,
                   load_n        => load_n,
                   enp           => PULLUP,
                   ent           => rco_c1_to_c2,
                   rco           => open,
                   d(3)          => GND,
                   d(2 downto 0) => input.addr_in(ADDR_WIDTH - 1 downto 8),
                   -- q(3)          => GND,
                   q(2 downto 0) => output.addr_out(ADDR_WIDTH - 1 downto 8) );

    counter1 : entity work.cd74ac161(rtl)
        port map ( clk    => clk_1,
                   clr_n  => PULLUP,
                   load_n => load_n,
                   enp    => PULLUP,
                   ent    => rco_c0_to_c1,
                   rco    => rco_c1_to_c2,
                   d      => input.addr_in(7 downto 4),
                   q      => output.addr_out(7 downto 4) );

    counter0 : entity work.cd74ac161(rtl)
        port map ( clk    => clk_0,
                   clr_n  => PULLUP,
                   load_n => load_n,
                   enp    => PULLUP,
                   ent    => input.inc,
                   rco    => rco_c0_to_c1,
                   d      => input.addr_in(3 downto 0),
                   q      => output.addr_out(3 downto 0) );

    -- internal glue logic
    clk_0 <= input.set or input.inc;
    clk_1 <= input.set or input.inc;
    clk_2 <= input.set or input.inc;
    load_n <= not input.set;


end architecture structure;
