-------------------------------------------------------------------------------
--
-- unit name: CD74AC112 Dual Negative-Edge Triggered JK-Flip-Flop
-- author: Georg Ziegler
--
-- description: Two negative-edge triggered JK-flip-flip
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Improve input/port map with package
-- Improve metastability check
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity cd74ac112 is
    port    ( clk1   : in std_logic;            -- clock signal
              clr1_n : in std_logic;            -- async clear signal
              pre1_n : in std_logic;            -- load/preset signal
              j1     : in std_logic;
              k1     : in std_logic;
              q1     : out std_logic;
              q1_n   : out std_logic;
              clk2   : in std_logic;            -- clock signal
              clr2_n : in std_logic;            -- async clear signal
              pre2_n : in std_logic;            -- load/preset signal
              j2     : in std_logic;
              k2     : in std_logic;
              q2     : out std_logic;
              q2_n   : out std_logic );

    -- TODO: add detailed timing constants
    constant T_PD   : delay_length := 9.4 ns;   -- Propagation delay
    constant T_PW   : delay_length := 6 ns;     -- minium clock pulse width
    constant T_SU   : delay_length := 4.9 ns;   -- setup time for data input
    constant T_RC   : delay_length := 3.1 ns;   -- setup/recovery time load/clear
end entity cd74ac112;

-- rtl architecture to check metastability
architecture rtl of cd74ac112 is
    signal intern1 : std_logic;
    signal intern2 : std_logic;
begin

    -- JK-flip-flop 1
    intern1 <=
        'X'         when pre1_n = '0' and clr1_n = '0' else                                       -- error
        '1'         when (falling_edge(clk1) and (j1 = '1' and k1 = '0')) or pre1_n = '0' else    -- high K
        '0'         when (falling_edge(clk1) and (j1 = '0' and k1 = '1')) or clr1_n = '0' else    -- high K
        not intern1 when falling_edge(clk1) and j1 = '1' and k1 = '1' and pre1_n = '1' and clr1_n = '1' else                                               -- toggle
        unaffected;

    -- JK-flip-flop 2
    intern2 <=
        'X'         when pre2_n = '0' and clr2_n = '0' else                                       -- error
        '1'         when (falling_edge(clk2) and (j2 = '1' and k2 = '0')) or pre2_n = '0' else    -- high K
        '0'         when (falling_edge(clk2) and (j2 = '0' and k2 = '1')) or clr2_n = '0' else    -- high K
        not intern2 when falling_edge(clk2) and j2 = '1' and k2 = '1' and pre2_n = '1' and clr2_n = '1' else                                               -- toggle
        unaffected;

    -- update outputs
    q1   <= intern1 after T_PD;
    q1_n <= not intern1 after T_PD;
    q2   <= intern2 after T_PD;
    q2_n <= not intern2 after T_PD;


    -- check metastability for falling edge of clock
    checkMetaStability : process is
    begin
        -- wait for rising edge clock
        wait until falling_edge(clk1);

        -- check clk pulse width
        assert clk1'delayed'stable(T_PW)
            report "CLK pulse width too short!"
            severity warning;

        -- check clr recovery time
        assert clr1_n'stable(T_RC)
            report "/CLR changed during recovery time!"
            severity warning;

        -- check pre recovery time
        assert pre1_n'stable(T_RC)
            report "/PRE changed during recovery time!"
            severity warning;

        -- check data setup time
        assert j1'stable(T_SU)
            report "Data input changed during setup time!"
            severity warning;

        -- check data setup time
        assert k1'stable(T_SU)
            report "Data input changed during setup time!"
            severity warning;

    end process checkMetaStability;

end architecture rtl;
