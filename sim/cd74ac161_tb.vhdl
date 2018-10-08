-------------------------------------------------------------------------------
--
-- unit name: Testbench for CD74AC161 (cd74ac161_tb)
-- author: Georg Ziegler
--
-- description: This testbench verfies functionality of the cd74ac161 unit
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
entity cd74ac161_tb is
end entity cd74ac161_tb;

-- test bench architecture
architecture testbench of cd74ac161_tb is
    signal clk    : std_logic := '0';            -- clock signal
    signal clr_n  : std_logic := 'X';            -- async clear signal
    signal load_n : std_logic := 'X';            -- load/preset signal
    signal enp    : std_logic := 'X';            -- enable
    signal ent    : std_logic := 'X';
    signal rco    : std_logic := 'X';
    signal d      : std_logic_vector (3 downto 0) := (others => 'X');
    signal q      : std_logic_vector (3 downto 0) := (others => 'X');
    -- stop signal
    signal finished : std_logic := '0';
begin

    dut : entity work.cd74ac161(rtl)
        port map ( clk => clk,
                   clr_n => clr_n,
                   load_n => load_n,
                   enp => enp,
                   ent => ent,
                   rco => rco,
                   d => d,
                   q => q );

    -- clk generator
    clk <= not clk after 50 ns when finished /= '1' else '0';


    -- test signals
    stimulus : process is
    begin
        -- wait for three clock cycles
        clr_n <= '1';
        load_n <= '1';
        enp <= '0';
        ent <= '0';
        wait for 300 ns;

        -- preload
        load_n <= '0';
        d <= X"a";
        wait for 100 ns;

        -- clear counter
        load_n <= '1';
        clr_n  <= '0';
        wait for 100 ns;

        -- preload
        load_n <= '0';
        clr_n  <= '1';
        d <= X"b";
        wait for 100 ns;

        -- count up
        load_n <= '1';
        enp <= '1';
        ent <= '1';
        wait for 1000 ns;

        -- inhibt for 500 ns
        enp <= '0';
        wait for 500 ns;

        -- clear counter
        load_n <= '1';
        clr_n  <= '0';
        wait for 100 ns;

        -- count up
        load_n <= '1';
        clr_n <= '1';
        enp <= '1';
        ent <= '1';
        wait for 1000 ns;

        -- stop clock and wait forever
        finished <= '1';
        wait for 100 ns;
        wait;

    end process stimulus;


end architecture testbench;
