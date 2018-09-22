-- behavioral model of a SN74AHC573 D-type Transparent Latch
library ieee;
use ieee.std_logic_1164.all;

-- entity declaration
entity sn74ahc573 is
    port ( oe_n, le : in std_logic;     -- control signals
           d : in std_logic;            -- data input
           q : out std_logic );         -- data output

    -- TODO: add timing constants
end entity sn74ahc573;

-- behavioral architecture to chech metastability
architecture behave of sn74ahc573 is
    signal intern : std_logic := 'X';
begin

    behavioral : process (oe_n, le, d) is
    begin
        -- check for high impedance
        if oe_n = '1' then
            intern <= 'Z';
        else
            if le = '1' then
                intern <= d;
            -- else
                -- intern <= unaffected;
            end if;
        end if;
    end process behavioral;

    q <= intern;

end architecture behave;
