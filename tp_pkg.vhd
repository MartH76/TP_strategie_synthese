library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tp_pkg is
    constant NBR_TILES : integer range 0 to 100 := 40; 
    
     
    constant WIDTH_OF_RAM : integer range 0 to 100 := 12;
    constant WIDTH_OF_ROM : integer range 0 to 100 := 11;

    constant ROM_SIZE_ADDR : integer range 0 to 100 := 4;


    type input_accu is array (integer range 0 to  NBR_TILES - 1) of std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) - 1 downto 0);

    -- DRAM
    constant RAM_SIZE_ADDR : integer range 1 to 28 := 5;
    constant WIDTH_OF_WORD : integer range 0 to 100 := 12;


    -- signal qui sert pour le remplissage de la ram
    type input_ram is array (2**RAM_SIZE_ADDR - 1 downto 0) of std_logic_vector(WIDTH_OF_RAM - 1 downto 0);
    signal in_ram : input_ram := (  x"000",
                                    x"001",
                                    x"002",
                                    x"003",
                                    x"004",
                                    x"005",
                                    x"006",
                                    x"007",
                                    x"008",
                                    x"009",
                                    x"00A",
                                    x"00B",
                                    x"00C",
                                    x"00D",
                                    x"00E",
                                    x"00F",
                                    x"FF0",
                                    x"FF1",
                                    x"FF2",
                                    x"FF3",
                                    x"FF4",
                                    x"FF5",
                                    x"FF6",
                                    x"FF7",
                                    x"FF8",
                                    x"FF9",
                                    x"FFA",
                                    x"FFB",
                                    x"FFC",
                                    x"FFD",
                                    x"FFE",
                                    x"FFF");

end package;