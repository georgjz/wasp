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
-- Fix delays
-- Add metastability check
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity cd74ac161 is
    generic ( constant DATA_WIDTH : integer := 4 );
    port    ( clk    : in std_logic;            -- clock signal
              clr_n  : in std_logic;            -- async clear signal
              load_n : in std_logic;            -- load/preset signal
              enp    : in std_logic;            -- enable
              ent    : in std_logic;
              rco    : out std_logic;
              d      : in std_logic_vector (DATA_WIDTH - 1 downto 0);
              q      : out std_logic_vector (DATA_WIDTH - 1 downto 0) );

    -- TODO: add detailed timing constants
    -- constant T_PD   : delay_length := 9 ns;     -- Propagation delay
    -- constant T_W    : delay_length := 5 ns;     -- Pulse duration, LE high
    -- constant T_SU   : delay_length := 3.5 ns;   -- Setup time, data before LE falling edge
    -- constant T_H    : delay_length := 1.5 ns;   -- Hold time, data after LE falling edge
end entity cd74ac161;

-- rtl architecture to check metastability
architecture rtl of cd74ac161 is
    signal intern : std_logic_vector (DATA_WIDTH - 1 downto 0) := (others => 'X');
    -- variable count : unsigned (3 downto 0);
begin

    -- clear or preset counter
    intern <= (others => '0')
                    when clr_n = '0' else
              d
                    when load_n = '0' else
              std_logic_vector(unsigned(intern) + 1)
                    when (rising_edge(clk) and enp = '1' and ent = '1');

    -- update RCO
    rco <= '1' when (intern = X"f" and ent = '1') else '0';

    -- update output
    q <= intern;

    -- check metastability of latch enable signal
    -- checkMetaStability : process is
    -- begin
        -- code
    -- end process checkMetaStability;

end architecture rtl;
