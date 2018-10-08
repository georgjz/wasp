-------------------------------------------------------------------------------
--
-- unit name: The Address Counter Submodule of Wasp for the Input Panel/Module
-- author: Georg Ziegler
--
-- description: This module/entity represents the input address counter
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
entity addr_counter_submodule is
    generic ( constant ADDR_WIDTH : integer := 11);
    port    ( clk       : in std_logic;         -- system clock input
              clr_n     : in std_logic;         -- clear
              load_addr : in std_logic;         -- load the address at addr_in
              next_addr : in std_logic;         -- increment and load address at addr_in
              addr_in   : in std_logic_vector (ADDR_WIDTH - 1 downto 0);     -- address to latch to LEDs
              addr_out  : out std_logic_vector (ADDR_WIDTH - 1 downto 0) );  -- signals to display on LEDs
end entity addr_counter_submodule;

-- structural architecture
architecture structure of addr_counter_submodule is
    -- additional/auxiliar control signals
    signal load_addr_inv : std_logic := 'X';    -- inverted load_addr signal
    -- internal signals
    signal rco_ct0_ct1 : std_logic := 'X';  -- RCO signal from counter0 to counter1
    signal rco_ct1_ct2 : std_logic := 'X';  -- RCO signal from counter1 to counter2
begin

    -- additional/auxiliar signals
    -- TODO: replace with gate for correct delay
    load_addr_inv <= not load_addr;

    -- bits 11 downto 8
    addr_counter2 : entity work.cd74ac161(rtl)
        port map ( clk    => clk,
                   clr_n  => clr_n,
                   load_n => load_addr_inv,
                   enp    => rco_ct1_ct2,
                   ent    => rco_ct1_ct2,
                   rco    => open,
                   d(2 downto 0) => addr_in(ADDR_WIDTH - 1 downto 8),
                   q(2 downto 0) => addr_out(ADDR_WIDTH - 1 downto 8) );

    -- bits 7 downto 5
    addr_counter1 : entity work.cd74ac161(rtl)
        port map ( clk    => clk,
                   clr_n  => clr_n,
                   load_n => load_addr_inv,
                   enp    => rco_ct0_ct1,
                   ent    => rco_ct0_ct1,
                   rco    => rco_ct1_ct2,
                   d      => addr_in(7 downto 4),
                   q      => addr_out(7 downto 4) );

    -- bits 3 downto 0
    addr_counter0 : entity work.cd74ac161(rtl)
        port map ( clk    => clk,
                   clr_n  => clr_n,
                   load_n => load_addr_inv,
                   enp    => next_addr,
                   ent    => next_addr,
                   rco    => rco_ct0_ct1,
                   d      => addr_in(3 downto 0),
                   q      => addr_out(3 downto 0) );

end architecture structure;
