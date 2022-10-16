library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity Tile is 
port(
    clk : in std_logic;
    reset : in std_logic;

    select_out : in std_logic;

    input_data : in std_logic_vector(WIDTH_OF_WORD downto 0);

    data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM downto 0);

    done : out std_logic;
    
    enable_load_ram : in std_logic
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
        multipl   : in std_logic_vector(WIDTH_OF_ROM downto 0);
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

    component sequenceur is 
        port(
            clk             : in std_logic;
            reset           : in std_logic;

            enable_load_ram : in std_logic;

            start_mul       : out std_logic;
            start_accu_tile : out std_logic;  

            select_output   : in std_logic;

            -- input for DRAM
            input_data      : in std_logic_vector(WIDTH_OF_WORD downto 0);
            data_a          : in std_logic_vector(WIDTH_OF_WORD downto 0);
            data_b          : in std_logic_vector(WIDTH_OF_WORD downto 0);
            -- output for DRAM
            dina            : out std_logic_vector(WIDTH_OF_WORD downto 0);
            addra           : out std_logic_vector(SIZE_ADDR downto 0);
            wea             : out std_logic;
            ena             : out std_logic;

            dinb            : out std_logic_vector(WIDTH_OF_WORD downto 0);
            addrb           : out std_logic_vector(SIZE_ADDR downto 0);
            web             : out std_logic;
            enb             : out std_logic;

            -- mul
            sum_a           : out std_logic_vector(WIDTH_OF_RAM-1 downto 0);
            sum_b           : out std_logic_vector(WIDTH_OF_RAM-1 downto 0);
            multipl         : out std_logic_vector(WIDTH_OF_ROM downto 0)
        );
    end component sequenceur;


    signal s_clk            : std_logic;
    signal s_reset          : std_logic;

    signal s_sum_a          : std_logic_vector(WIDTH_OF_RAM-1 downto 0);
    signal s_sum_b          : std_logic_vector(WIDTH_OF_RAM-1 downto 0);
    signal s_multipl        :std_logic_vector(WIDTH_OF_ROM downto 0);

    signal s_rom_addr       : std_logic_vector(ROM_SIZE_ADDR-1 downto 0);
    signal s_ram_addr_a     : std_logic_vector(SIZE_ADDR downto 0);
    signal s_ram_addr_b     : std_logic_vector(SIZE_ADDR downto 0);

    signal s_wea            : std_logic;
    signal s_ena            : std_logic;
    signal s_web            : std_logic;
    signal s_enb            : std_logic;

    signal s_en_rom         : std_logic;

    signal s_start_mul      : std_logic;

    signal s_accu_in        : std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM downto 0);

    signal s_done_mul       : std_logic;


begin
    DRAM : DRAM
    port map(
        clka => s_clk,
        clkb => s_clk,
        dina => input_data,
        addra => s_ram_addr_a,
        wea => s_wea,
        ena => s_ena,
        douta => s_sum_a,
        dinb => input_data,
        addrb => s_ram_addr_b,
        web => s_web,
        enb => s_enb,
        doutb => s_sum_b
    );
    
    ROM : ROM
    port map(
        clk => s_clk,
        enrom => s_en_rom,
        addr => s_rom_addr,
        data => s_multipl
    );

    MUL : MUL
    port map(
        clk => s_clk,
        rst => s_reset,
        start => s_start_mul,
        mul_out => s_accu_in,
        sum_a => s_sum_a,
        sum_b => s_sum_b,
        multipl => s_multipl,
        done => s_done_mul
    );

    ACCU : accu_tile 
    port map(
        clk => s_clk,
        rst => s_reset,
        start => s_done_mul,
        done => done,
        select_out => '1',
        data_in => s_accu_in,
        data_out => data_out
    );

    SEQ : sequenceur
    port map(
        clk => s_clk,
        reset => s_reset,
        enable_load_ram => enable_load_ram,
        start_mul => s_start_mul,
        start_accu_tile => s_done_mul,
        select_output => select_out,
        input_data => input_data,
        data_a => s_sum_a,
        data_b => s_sum_b,
        dina => s_ram_addr_a,
        addra => s_ram_addr_a,
        wea => s_wea,
        ena => s_ena,
        dinb => s_ram_addr_b,
        addrb => s_ram_addr_b,
        web => s_web,
        enb => s_enb,
        sum_a => s_sum_a,
        sum_b => s_sum_b,
        multipl => s_multipl
    );

end architecture;