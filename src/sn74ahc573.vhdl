-- simple model of a SN74AHC573 D-type Transparent Latch
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration
entity sn74ahc573 is
    port ( oe_n, le : in std_logic;     -- control signals
           d : in std_logic;            -- data input
           q : out std_logic );         -- data output

    -- TODO: add detailed timing constants
    constant t_pd   : delay_length := 9 ns;     -- Propagation delay
    constant t_w    : delay_length := 5 ns;     -- Pulse duration, LE high
    constant t_su   : delay_length := 3.5 ns;   -- Setup time, data before LE falling edge
    constant t_h    : delay_length := 1.5 ns;   -- Hold time, data after LE falling edge
end entity sn74ahc573;

-- rtl architecture to check metastability
architecture rtl of sn74ahc573 is
    signal intern : std_logic := 'X';
begin

    -- concurrent replacement of behavioral process
    -- TODO: replace with state machine for more precise propagation delays
    intern <= 'Z' when oe_n = '1' else              -- high-impedance state
               d  when oe_n = '0' and le = '1' else -- latch input
               unaffected;                          -- else, nothing happens

    -- check metastability of latch enable signal
    checkMetaStability : process is
    begin
        -- wait for LE falling edge
        wait until falling_edge(le);

        --check pulse width
        assert le'delayed'stable(t_w)
            report "LE pulse width too short!"
            severity failure;

        -- check setup time
        assert intern'delayed'stable(t_su)
            report "Input changed during setup time!"
            severity failure;

        -- check hold time
        wait for t_h;
        assert intern'delayed'stable(t_h + t_su)
            report "Input signal changed during hold time!"
            severity failure;

    end process checkMetaStability;

    -- update output
    q <= intern;

end architecture rtl;
