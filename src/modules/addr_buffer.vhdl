-------------------------------------------------------------------------------
--
-- unit name: The Address Buffer
-- author: Georg Ziegler
--
-- description: This module represents the Address Buffer. It decouples the
-- a bus from another.
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
use work.wasp_records_pkg.all;

-- entity declaration
entity addr_buffer is
    generic ( constant ADDR_WIDTH : integer := 11);
    port    ( input  : in  t_to_buffer (data_in(ADDR_WIDTH - 1 downto 0));
              output : out t_from_buffer (data_out(ADDR_WIDTH - 1 downto 0)) );
end entity addr_buffer;

-- structural architecture
architecture structure of addr_buffer is
    -- internal signal
    signal intern : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    -- timing characteristics
    constant T_PD : delay_length := 15 ns;
begin

    -- high-impedance control
    output.data_out <= intern after T_PD when input.enable_n = '0' else
                       (others => 'Z') after T_PD;

    -- latch input to internal signal
    intern <= input.data_in;

end architecture structure;
