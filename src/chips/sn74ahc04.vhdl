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
    port ( input  : in t_to_hex_one_input_logic;
           output : out t_from_hex_one_input_logic );

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
    intern1 <= not input.a1;
    intern2 <= not input.a2;
    intern3 <= not input.a3;
    intern4 <= not input.a4;
    intern5 <= not input.a5;
    intern6 <= not input.a6;

    -- update outputs
    output.y1 <= intern1 after T_PD;
    output.y2 <= intern2 after T_PD;
    output.y3 <= intern3 after T_PD;
    output.y4 <= intern4 after T_PD;
    output.y5 <= intern5 after T_PD;
    output.y6 <= intern6 after T_PD;

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
    --
    -- end process checkMetaStability;

end architecture rtl;
