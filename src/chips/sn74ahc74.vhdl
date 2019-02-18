-------------------------------------------------------------------------------
--
-- unit name: SN74AHC74 Dual D-Flip-Flop (sn74ahc74)
-- author: Georg Ziegler
--
-- description: A dual D-flip-flop, presettable and sync'd
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Add pulse with check for /PRE and /CLR
-- Make input/output port into package
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
    constant T_W    : delay_length := 5 ns;     -- minimal pulse with for /PRE and /CLR
    constant T_SUD  : delay_length := 5 ns;     -- data setup time
    constant T_HD   : delay_length := 0.5 ns;   -- data hold time
    constant T_SUPC : delay_length := 3 ns;     -- inactive time /PRE and /CLR
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
        -- wait for clk, clear, or preset signal
        -- wait on clk1, pre1_n, clr1_n;
        wait until rising_edge(clk1);

        -- check preset signal
        -- if rising_edge(pre1_n) then
        --     assert pre1_n'delayed'stable(T_W)
        --         report "Pulse width on /PRE1 too short!"
        --         severity warning;
        -- end if;
        --
        -- -- check clear signal
        -- if rising_edge(clr1_n) then
        --     assert clr1_n'delayed'stable(T_W)
        --         report "Pulse width on /CLR1 too short!"
        --         severity warning;
        -- end if;

        -- check data setup time
        assert d1'delayed'stable(T_SUD)
            report "Data changed during setup time!"
            severity warning;

        -- check hold time
        wait for T_HD;
        assert d1'delayed'stable(T_SUD + T_HD)
            report "Data changed during hold time!"
            severity warning;

        wait until falling_edge(clk1);
        assert clk1'delayed'stable(T_W)
            report "Clock pulse too short!"
            severity warning;

    end process checkMetaStability;

end architecture rtl;
