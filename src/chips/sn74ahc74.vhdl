-------------------------------------------------------------------------------
--
-- unit name: SN74AHC74 Dual D-Flop-Flop (sn74ahc74)
-- author: Georg Ziegler
--
-- description: A dual D-flip-flop, presettable and sync'd
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
entity sn74ahc74 is
    -- generic ( constant DATA_WIDTH : integer := 8 );
    port ( clk1   : in std_logic;       -- clk input
           pre1_n : in std_logic;       -- preset dff
           clr1_n : in std_logic;       -- reset dff
           d1     : in std_logic;       -- dff input
           q1     : out std_logic;      -- dff output
           q1_n   : out std_logic;      -- dff output
           clk2   : in std_logic;       -- clk input
           pre2_n : in std_logic;       -- preset dff
           clr2_n : in std_logic;       -- reset dff
           d2     : in std_logic;       -- dff input
           q2     : out std_logic;      -- dff output
           q2_n   : out std_logic );    -- dff output

    -- TODO: add detailed timing constants
    constant T_PPC  : delay_length := 9 ns;     -- Propagation delay /PRE or /CLR -> Q
    constant T_P    : delay_length := 8.5 ns;   -- Propagation delay CLK -> Q
end entity sn74ahc74;

-- rtl architecture to check metastability
architecture rtl of sn74ahc74 is
    signal intern1 : std_logic := 'X';
    signal intern2 : std_logic := 'X';
begin

    -- latch input 1
    intern1 <=
        d1  after T_P   when rising_edge(clk1) else
        '0' after T_PPC when clr1_n = '0' else
        '1' after T_PPC when pre1_n = '0' else
        unaffected;

    -- latch input 2
    intern2 <=
        d2  after T_P   when rising_edge(clk2) else
        '0' after T_PPC when clr2_n = '0' else
        '1' after T_PPC when pre2_n = '0' else
        unaffected;

    -- update output 1
    q1   <= intern1;
    q1_n <= not intern1;

    -- update output 1
    q2   <= intern2;
    q2_n <= not intern2;



    -- check metastability of latch enable signal
    checkMetaStability : process is
    begin
        wait;
        -- wait for clk, clear, or preset signal
        -- wait on c

        -- wait for LE falling edge
        -- wait until falling_edge(le);
        --
        -- --check pulse width
        -- assert le'delayed'stable(T_W)
        --     report "LE pulse width too short!"
        --     severity failure;
        --
        -- -- check setup time
        -- assert intern'delayed'stable(T_SU)
        --     report "Input changed during setup time!"
        --     severity failure;
        --
        -- -- check hold time
        -- wait for T_H;
        -- assert intern'delayed'stable(T_H + T_SU)
        --     report "Input signal changed during hold time!"
        --     severity failure;

    end process checkMetaStability;

end architecture rtl;
