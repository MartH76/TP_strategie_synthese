library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity top is
    port (
        clk : in std_logic;
        reset : in std_logic;
        
        numero_tile : in std_logic_vector(NBR_TILES downto 0);

        done : out std_logic
    );
end top;

architecture rtl of TOP is

    component Tile is 
        port (
            clk : in std_logic;
            reset : in std_logic;

            select_out : in std_logic;

            input_data : in std_logic_vector(WIDTH_OF_WORD downto 0);

            data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM downto 0);

            done : out std_logic;
            
            enable_load_ram : in std_logic
        );
    end component Tile;

    component accu_tot is
        port (
            clk : in std_logic;
            reset : in std_logic;
    
            start : in std_logic;
            done : out std_logic;
            
            data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES downto 0);
    
            data_in : in input_accu
        );
    end component accu_tot;


begin

    

end architecture;