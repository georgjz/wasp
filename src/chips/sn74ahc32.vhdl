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
    port ( input  : in t_to_quad_two_input_logic;
           output : out t_from_quad_two_input_logic );

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
    intern1 <= (input.a1 or input.b1);
    intern2 <= (input.a2 or input.b2);
    intern3 <= (input.a3 or input.b3);
    intern4 <= (input.a4 or input.b4);

    -- update outputs
    output.y1 <= intern1 after T_PD;
    output.y2 <= intern2 after T_PD;
    output.y3 <= intern3 after T_PD;
    output.y4 <= intern4 after T_PD;

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
    --
    -- end process checkMetaStability;

end architecture rtl;
