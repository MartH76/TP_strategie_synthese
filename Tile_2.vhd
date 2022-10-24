library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity Tile_2 is 
port(
    clk : in std_logic;
    reset : in std_logic;

    select_out : in std_logic;

    input_data : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);

    data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) - 1 downto 0);

    done : out std_logic;

    enable_load_ram : in std_logic;

    --ram
    addra : in std_logic_vector(RAM_SIZE_ADDR-1 downto 0);
    addrb : in std_logic_vector(RAM_SIZE_ADDR-1 downto 0);

    ena : in std_logic;
    enb : in std_logic;
    wea : in std_logic;
    web : in std_logic;

    --rom
    enrom : in std_logic;
    addr : in std_logic_vector(ROM_SIZE_ADDR-1 downto 0);

    --mul
    start : in std_logic;

    --accu
    start_accu : in std_logic
);
end Tile_2;

architecture rtl of Tile_2 is

    component MUL is 
    port(
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        mul_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM  downto 0);
        sum_a : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        sum_b : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        multipl   : in std_logic_vector(WIDTH_OF_ROM-1 downto 0);
        done : out std_logic  
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

    component DPRAM is 
        port(
            clka   : in std_logic;
            clkb   : in std_logic;
            dina : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
            addra : in std_logic_vector(RAM_SIZE_ADDR-1 downto 0);
            wea : in std_logic;
            ena : in std_logic;
            douta : out std_logic_vector(WIDTH_OF_RAM-1 downto 0);
            dinb : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
            addrb : in std_logic_vector(RAM_SIZE_ADDR-1 downto 0);
            web : in std_logic;
            enb : in std_logic;
            doutb : out std_logic_vector(WIDTH_OF_RAM-1 downto 0)      
        );
    end component DPRAM;

    component accu_tile is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            start : in std_logic;
            
            done : out std_logic;
    
            select_out : in std_logic;
    
            start_accu : in std_logic;

            data_in : in std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM  downto 0);
            data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) - 1 downto 0)
        );
    end component accu_tile;


    signal s_sum_a          : std_logic_vector(WIDTH_OF_RAM-1 downto 0);
    signal s_sum_b          : std_logic_vector(WIDTH_OF_RAM-1 downto 0);
    signal s_multipl        :std_logic_vector(WIDTH_OF_ROM-1 downto 0);

    signal s_start_mul      : std_logic;

    signal s_accu_in        : std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM downto 0);

    signal s_done_mul       : std_logic;

    signal s_start_accu     : std_logic;

    
begin

    DPRAM_1 : DPRAM
    port map(
        clka => clk,
        clkb => clk,
        dina => input_data,
        addra => addra,
        wea => wea,
        ena => ena,
        douta => s_sum_a,
        dinb => input_data,
        addrb => addrb,
        web => web,
        enb => enb,
        doutb => s_sum_b
    );
    
    ROM_1 : ROM
    port map(
        clk => clk,
        enrom => enrom,
        addr => addr,
        data => s_multipl
    );

    MULTIPLIEUR : MUL
    port map(
        clk => clk,
        rst => reset,
        start => start,
        mul_out => s_accu_in,
        sum_a => s_sum_a,
        sum_b => s_sum_b,
        multipl => s_multipl,
        done => s_done_mul
    );

    ACCU : accu_tile 
    port map(
        clk => clk,
        rst => reset,
        start => s_done_mul,
        done => done,
        select_out => select_out,
        data_in => s_accu_in,
        data_out => data_out,
        start_accu => start_accu
    );

end architecture;