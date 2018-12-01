-------------------------------------------------------------------------------
--
-- unit name: Syncer, a signal-clock synchronizer based on Dffs
-- author: Georg Ziegler
--
-- description: This package contains a unit that will synchronize an input
--              signal to an input clock
--
-- dependencies: ieee library
--
-------------------------------------------------------------------------------
-- TODO: Replace input with record
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wasp_records_pkg.all;

-- entity declaration
entity syncer is
    -- generic ( constant DATA_WIDTH : integer := 8 );
    port    ( clk    : in std_logic;     -- input clock
              sig_in : in t_syncer;      -- input signal to be synced to clock
              q      : out std_logic );  -- synced output signal, held active for one cycle
end entity syncer;

-- structural architecture
architecture structure of syncer is
    -- internal signals
    signal meta : std_logic := 'X';
begin

    dff : entity work.sn74ahc74(rtl)
        port map (clk1   => clk,
                  pre1_n => '1',
                  clr1_n => '1',
                  d1     => sig_in.d,
                  q1     => meta,
                  q1_n   => open,
                  clk2   => clk,
                  pre2_n => '1',
                  clr2_n => '1',
                  d2     => meta,
                  q2     => q,
                  q2_n   => open );

end architecture structure;
