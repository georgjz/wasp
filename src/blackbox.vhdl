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
use work.wasp_records_pkg.all;

-- entity declaration
entity blackbox is
    generic ( constant ADDR_WIDTH : integer := 11);
    port    ( clk        : in std_logic;
              counter_in : in t_addr_counter ( d(ADDR_WIDTH -1 downto 0) );
              addr_out   : out std_logic_vector (ADDR_WIDTH - 1 downto 0) );  -- signals to display on LEDs
end entity blackbox;

-- structural architecture
architecture structure of addr_counter is
    -- additional/auxiliar control signals
    signal load_inv : std_logic := 'X';    -- inverted load_addr signal
    -- internal signals
    signal rco_ct0_ct1 : std_logic := 'X';  -- RCO signal from counter0 to counter1
    signal rco_ct1_ct2 : std_logic := 'X';  -- RCO signal from counter1 to counter2
begin

    -- additional/auxiliar signals
    -- TODO: replace with gate for correct delay
    load_inv <= not counter_in.load;

    -- -- bits 3 downto 0
    addr_counter0 : entity work.cd74ac161(rtl)
        port map ( clk    => clk,
                   clr_n  => counter_in.clr_n,
                   load_n => load_inv,
                   enp    => '0',
                   ent    => '0',
                   rco    => rco_ct0_ct1,
                   d      => counter_in.d(3 downto 0),
                   q      => addr_out(3 downto 0) );

end architecture structure;
