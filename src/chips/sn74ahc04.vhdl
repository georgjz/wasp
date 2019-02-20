-------------------------------------------------------------------------------
--
-- unit name: SN74AHC04 Hex NOT
-- author: Georg Ziegler
--
-- description: A chip with six NOT gates
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: metastability check
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wasp_records_pkg.all;

-- entity declaration
entity sn74ahc04 is
    port ( a1 : in std_logic;
           a2 : in std_logic;
           a3 : in std_logic;
           a4 : in std_logic;
           a5 : in std_logic;
           a6 : in std_logic;
           y1 : out std_logic;
           y2 : out std_logic;
           y3 : out std_logic;
           y4 : out std_logic;
           y5 : out std_logic;
           y6 : out std_logic );

    -- TODO: add detailed timing constants
    constant T_PD   : delay_length := 6.5 ns;     -- Propagation delay A/B to Y
end entity sn74ahc04;

-- rtl architecture to check metastability
architecture rtl of sn74ahc04 is
    signal intern1 : std_logic := 'X';
    signal intern2 : std_logic := 'X';
    signal intern3 : std_logic := 'X';
    signal intern4 : std_logic := 'X';
    signal intern5 : std_logic := 'X';
    signal intern6 : std_logic := 'X';
begin

    -- latch inputs
    intern1 <= not a1;
    intern2 <= not a2;
    intern3 <= not a3;
    intern4 <= not a4;
    intern5 <= not a5;
    intern6 <= not a6;

    -- update outputs
    y1 <= intern1 after T_PD;
    y2 <= intern2 after T_PD;
    y3 <= intern3 after T_PD;
    y4 <= intern4 after T_PD;
    y5 <= intern5 after T_PD;
    y6 <= intern6 after T_PD;

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
    --
    -- end process checkMetaStability;

end architecture rtl;
