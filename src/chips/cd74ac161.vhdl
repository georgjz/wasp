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
    constant T_PD   : delay_length := 15.2 ns;    -- Propagation delay
    constant T_PW   : delay_length := 4.8 ns;   -- minium clock pulse width
    constant T_SUA  : delay_length := 4.4 ns;   -- setup time for data input
    constant T_SC   : delay_length := 5.3 ns;   -- setup/recovery time load/clear
end entity cd74ac161;

-- rtl architecture to check metastability
architecture rtl of cd74ac161 is
    signal intern : std_logic_vector (DATA_WIDTH - 1 downto 0) := (others => 'X');
begin

    -- clear or preset counter
    intern <=
    (others => '0')                         when clr_n = '0' else
    d                                       when load_n = '0' and rising_edge(clk) else
    std_logic_vector(unsigned(intern) + 1)  when (rising_edge(clk) and enp = '1' and ent = '1');

    -- update RCO
    rco <= '1' after T_PD when (intern = X"f" and ent = '1') else '0' after T_PD;

    -- update output
    q <= intern after T_PD;

    -- check metastability for rising edge of clock
    checkMetaStability : process is
    begin
        -- wait for rising edge clock
        wait until rising_edge(clk);

        -- check clk pulse width
        assert clk'delayed'stable(T_PW)
            report "CLK pulse width too short!"
            severity warning;

        -- check clk recovery time
        assert clr_n'stable(T_SC)
            report "/CLEAR changed during recovery time!"
            severity warning;

        -- check data setup time
        assert d'stable(T_SUA)
            report "Data input changed during setup time!"
            severity warning;

        -- check load signal setup time
        assert load_n'stable(T_SC)
            report "/LOAD signal changed during setup time!"
            severity warning;

    end process checkMetaStability;

end architecture rtl;
