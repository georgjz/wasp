-------------------------------------------------------------------------------
--
-- unit name: The Switch Input Module of Wasp
-- author: Georg Ziegler
--
-- description: This module/entity represents the switch inputs of the Wasp
--
-- dependencies: ieee library, wasp_records_pkg
--
-------------------------------------------------------------------------------
-- TODO: Use generic in switch panel record
-- Move record to separate file
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wasp_records_pkg.all;

-- entity declaration
entity switch_input_module is
    generic ( constant ADDR_WIDTH : integer := 11;
              constant DATA_WIDTH : integer :=  8 );
    port    ( clk         : in std_logic;       -- system clock
              panel_input : in t_switch_panel( switch_input(ADDR_WIDTH - 1 downto 0) );
              addr_out    : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
              data_out    : out std_logic_vector (DATA_WIDTH - 1 downto 0)
               );
end entity switch_input_module;

-- structure architecture
architecture structure of switch_input_module is
    -- internal signals
    signal load_addr : std_logic := 'X';
begin

    -- code
    addr_counter : entity work.addr_counter(structure)
        port map ( clk              => clk,
                   counter_in.clr_n => '1',
                   -- counter_in.load  => panel_input.examine,
                   counter_in.load  => load_addr,
                   counter_in.d     => panel_input.switch_input,
                   addr_out         => addr_out );

    -- TODO: add ctrl signal module entity
    -- synce examine input with clock
    exam_syncer : entity work.syncer(structure)
        port map ( clk      => clk,
                   sig_in.d => panel_input.examine,
                   q        => load_addr );

end architecture structure;
