-------------------------------------------------------------------------------
--
-- unit name: SN74AHC32 Quad 2-Input OR
-- author: Georg Ziegler
--
-- description: A chip with four 2-input OR gates
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
entity sn74ahc32 is
    port ( a1 : in std_logic;
           b1 : in std_logic;
           a2 : in std_logic;
           b2 : in std_logic;
           a3 : in std_logic;
           b3 : in std_logic;
           a4 : in std_logic;
           b4 : in std_logic;
           y1 : out std_logic;
           y2 : out std_logic;
           y3 : out std_logic;
           y4 : out std_logic );

    -- TODO: add detailed timing constants
    constant T_PD   : delay_length := 6.5 ns;     -- Propagation delay A/B to Y
end entity sn74ahc32;

-- rtl architecture to check metastability
architecture rtl of sn74ahc32 is
    signal intern1 : std_logic := 'X';
    signal intern2 : std_logic := 'X';
    signal intern3 : std_logic := 'X';
    signal intern4 : std_logic := 'X';
begin

    -- latch inputs
    intern1 <= (a1 or b1);
    intern2 <= (a2 or b2);
    intern3 <= (a3 or b3);
    intern4 <= (a4 or b4);

    -- update outputs
    y1 <= intern1 after T_PD;
    y2 <= intern2 after T_PD;
    y3 <= intern3 after T_PD;
    y4 <= intern4 after T_PD;

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
    --
    -- end process checkMetaStability;

end architecture rtl;
