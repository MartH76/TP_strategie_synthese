library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;


entity sequenceur is
    port (
        clk   : in std_logic;
        reset : in std_logic;

        start_mul : in std_logic;
        start_accu_tile : in std_logic;
        start_accu_tot : in std_logic;


        
    );
end entity;

architecture rtl of sequenceur is


begin

    

end architecture;
