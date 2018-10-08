-------------------------------------------------------------------------------
--
-- unit name: Testbench for a input panel model
-- author: Georg Ziegler
--
-- description: This testbench simulates a input panel
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
entity input_panel_tb is
end entity input_panel_tb;

-- test bench architecture
architecture test_bench of input_panel_tb is
    -- input control signal
    signal switch_input : std_logic_vector (11 downto 0) := (others => 'X');
    signal led_output   : std_logic_vector (7 downto 0) := (others => '0');
    signal deposit      : std_logic := '0';
    signal deposit_next : std_logic := '0';
    signal examine      : std_logic := '0';
    signal examine_next : std_logic := '0';
    -- inverted signals
    signal deposit_inv      : std_logic := '1';
    signal deposit_next_inv : std_logic := '1';
    signal examine_inv      : std_logic := '1';
    signal examine_next_inv : std_logic := '1';
    -- additional control signals
    signal addr_load    : std_logic := '1';
    signal addr_load_inv: std_logic := '0';
    -- internal signals
    signal rco_ct0_ct1  : std_logic := 'X';
    signal rco_ct1_ct2  : std_logic := 'X';
    -- system clock
    signal sys_clk      : std_logic := '0';
    constant CONST_HIGH : std_logic := '1';
    constant CONST_LOW  : std_logic := '0';
    -- internal buses
    signal addr_bus     : std_logic_vector (11 downto 0) := (others => 'X');
    signal data_bus     : std_logic_vector (7 downto 0) := (others => 'X');
    -- signal addr_in : std_logic_vector (10 downto 0) := (others => 'Z');
    -- stop signal
    signal finished : std_logic := '0';
begin

    -- system clock generation
    sys_clk <= not sys_clk after 50 ns when finished /= '1' else '0';

    -- inverted control signals
    deposit_inv      <= not deposit;
    deposit_next_inv <= not deposit_next;
    examine_inv      <= not examine;
    examine_next_inv <= not examine_next;

    -- address load control
    addr_load <= not (deposit or deposit_next or examine or examine_next);
    addr_load_inv <= not addr_load;

    -- bits 3 down to 0
    input_counter_0 : entity work.cd74ac161(rtl)
        port map ( clk    => sys_clk,
                   clr_n  => CONST_HIGH,
                   load_n => addr_load,
                   enp    => addr_load_inv, -- !!
                   ent    => addr_load_inv, -- !!
                   rco    => rco_ct1_ct2,
                   d      => switch_input(3 downto 0),
                   q      => addr_bus(3 downto 0) );

    -- bits 7 down to 4
    input_counter_1 : entity work.cd74ac161(rtl)
        port map ( clk    => sys_clk,
                   clr_n  => CONST_HIGH,
                   load_n => addr_load,
                   enp    => rco_ct0_ct1,
                   ent    => rco_ct0_ct1,
                   rco    => rco_ct1_ct2,
                   d      => switch_input(7 downto 4),
                   q      => addr_bus(7 downto 4) );

    -- bits 11 down to 8
    input_counter_2 : entity work.cd74ac161(rtl)
        port map ( clk    => sys_clk,
                   clr_n  => CONST_HIGH,
                   load_n => addr_load,
                   enp    => rco_ct1_ct2,
                   ent    => rco_ct1_ct2,
                   rco    => open,
                   d      => switch_input(11 downto 8),
                   q      => addr_bus(11 downto 8) );

    -- code
    stimulus : process is
        -- type data_buffer is range 0 to 255;
        -- variable datum : data_buffer := 0;
    begin

        -- wait for 3 clock cycles
        wait for 300 ns;

        -- set address input to $1de
        switch_input <= X"1de";
        wait for 100 ns;

        -- examine address $1de
        examine <= '1';
        wait for 50 ns;
        examine <= '0';

        -- stop clock and wait forever
        finished <= '1';
        wait for 300 ns;
        wait;
    end process stimulus;

end architecture test_bench;
