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

        input_data : in std_logic_vector(WIDTH_OF_WORD downto 0);

        done : out std_logic;

        enable_load_ram_i : in std_logic_vector(NBR_TILES downto 0);
        --sortie
        Datout_o : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES downto 0)
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

    signal select_out : std_logic_vector(NBR_TILES downto 0);

    signal s_data_out_tile : input_accu;

    signal s_tile_done : std_logic;

begin

    accu : accu_tot
        port map (
            clk => clk,
            reset => reset,
            start => s_tile_done,
            done => done,
            data_out => Datout_o,
            data_in => s_data_out_tile
        );

    gen_tiles: for i in 0 to NBR_TILES generate
        tile_i : Tile
            port map (
                clk => clk,
                reset => reset,
                select_out => select_out(i),
                input_data => input_data,
                data_out => s_data_out_tile(i),
                done => s_tile_done,
                enable_load_ram => enable_load_ram_i(i)
            );
    end generate gen_tiles;
  
end architecture;