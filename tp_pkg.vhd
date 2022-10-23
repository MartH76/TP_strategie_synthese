library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tp_pkg is
    constant NBR_TILES : integer range 0 to 100 := 2; 
    
     
    constant WIDTH_OF_RAM : integer range 0 to 100 := 12;
    constant WIDTH_OF_ROM : integer range 0 to 100 := 11;

    constant ROM_SIZE_ADDR : integer range 0 to 100 := 4;


    type input_accu is array (0 to  NBR_TILES - 1) of std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM - 1 downto 0);

    -- DRAM
    constant RAM_SIZE_ADDR : integer range 1 to 28 := 5;
    constant WIDTH_OF_WORD : integer range 0 to 100 := 12;


    type input_ram is array (0 to 2**RAM_SIZE_ADDR - 1) of std_logic_vector(WIDTH_OF_RAM - 1 downto 0);
end package;