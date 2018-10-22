-------------------------------------------------------------------------------
--
-- unit name: CD74AC161 4-Bit Synchronous Binary Counter (cd74ac161)
-- author: Georg Ziegler
--
-- description: A presettable, synchronous 4-bit binary counter
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Improve input/port map with package
-- Improve delays
-- Improve metastability check
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity blackbox is
    generic ( constant DATA_WIDTH : integer := 4 );
    port    ( clk    : in std_logic;            -- clock signal
              clr_n  : in std_logic;            -- async clear signal
              load_n : in std_logic;            -- load/preset signal
              enp    : in std_logic;            -- enable
              ent    : in std_logic;
              rco    : out std_logic;
              d      : in std_logic_vector (DATA_WIDTH - 1 downto 0);
              q      : out std_logic_vector (DATA_WIDTH - 1 downto 0) );

end entity blackbox;

-- rtl architecture to check metastability
architecture rtl of blackbox is
    signal load_inv : std_logic := 'X';
    signal rco_ct0_ct1 : std_logic := 'X';
begin


    -- additional/auxiliar signals
    -- TODO: replace with gate for correct delay
    load_inv <= not load_n;

    -- -- bits 3 downto 0
    addr_counter0 : entity work.cd74ac161(rtl)
        port map ( clk    => clk,
                   clr_n  => clr_n,
                   load_n => load_inv,
                   enp    => '0',
                   ent    => '0',
                   rco    => rco_ct0_ct1,
                   d      => d(3 downto 0),
                   q      => q(3 downto 0) );


end architecture rtl;
