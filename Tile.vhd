library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity Tile is 
port(
    clk : in std_logic;
    reset : in std_logic;
    start_MUL : in std_logic;
    start_accu : in std_logic;

    done : out std_logic;

    
);
end Tile;

architecture rtl of Tile is

    component MUL is 
    port(
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        mul_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM downto 0);
        sum_a : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        sum_b : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        multipl   : in std_logic_vector(WIDTH_OF_ROM downto 0)  
    );
    end component MUL;
    

    component ROM is 
        port(
            clk             : in std_logic;
            enrom           : in std_logic;
            addr            : in std_logic_vector (ROM_SIZE_ADDR-1 downto 0);
            data            : out std_logic_vector (WIDTH_OF_ROM-1 downto 0)
        );
    end component ROM;

    component DRAM is 
        port(
            clka   : in std_logic;
            clkb   : in std_logic;
            dina : in std_logic_vector(WIDTH_OF_WORD downto 0);
            addra : in std_logic_vector(SIZE_ADDR downto 0);
            wea : in std_logic;
            ena : in std_logic;
            douta : out std_logic_vector(WIDTH_OF_WORD downto 0);
            dinb : in std_logic_vector(WIDTH_OF_WORD downto 0);
            addrb : in std_logic_vector(SIZE_ADDR downto 0);
            web : in std_logic;
            enb : in std_logic;
            doutb : out std_logic_vector(WIDTH_OF_WORD downto 0)      
        );
    end component DRAM;

    component accu_tile is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            start : in std_logic;
            
            done : out std_logic;
    
            select_out : in std_logic;
    
            data_in : in std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM downto 0);
            data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM downto 0)
        );
    end component accu_tile;


begin
    DRAM : DRAM
    port map(
        clka => clk,
        clkb => clk,
        dina => data_in,
        addra => "00000000000000000000000000000000",
        wea => '1',
        ena => '1',
        douta => data_out,
        dinb => data_in,
        addrb => "00000000000000000000000000000000",
        web => '1',
        enb => '1',
        doutb => data_out
    );
    
    ROM : ROM
    port map(
        clk => clk,
        enrom => '1',
        addr => "00000000000000000000000000000000",
        data => data_out
    );

    MUL : MUL
    port map(
        clk => clk,
        rst => reset,
        start => start,
        mul_out => data_out,
        sum_a => data_in,
        sum_b => data_in,
        multipl => data_in
    );

    ACCU : accu_tile 
    port map(
        clk => clk,
        rst => reset,
        start => start,
        done => done,
        select_out => '1',
        data_in => data_out,
        data_out => data_out
    );

end architecture;