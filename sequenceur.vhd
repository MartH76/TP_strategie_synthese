library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;


entity sequenceur is
    port (
        clk   : in std_logic;
        reset : in std_logic;

        enable_load_ram : in std_logic;

        start_mul : out std_logic;
        start_accu_tile : out std_logic;  
        
        -- output for DRAM
        dina : out std_logic_vector(WIDTH_OF_WORD downto 0);
        addra : out std_logic_vector(SIZE_ADDR downto 0);
        wea : out std_logic;
        ena : out std_logic;

        dinb : out std_logic_vector(WIDTH_OF_WORD downto 0);
        addrb : out std_logic_vector(SIZE_ADDR downto 0);
        web : out std_logic;
        enb : out std_logic;
    );
end entity;

architecture rtl of sequenceur is
    type state_type is (IDLE, LOAD_RAM, CALCULATION, DATA_READ);
    signal state : state_type := IDLE;

    signal counter_data_to_write : integer range 0 to (2**(SIZE_ADDR))-1 := 0;
begin
    process(clk) is 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
            else
                case state is
                    when IDLE =>
                        if (enable_load_ram = '1') then
                            state <= LOAD_RAM;
                        end if;



                    when LOAD_RAM =>
                        if (enable_load_ram = '1') then
                            state <= LOAD_RAM;

                        else
                            state <= CALCULATION;
                        end if;
                    when CALCULATION =>


                        state <= DATA_READ;
                    when DATA_READ =>


                        state <= IDLE;
                    when others =>

                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;
    

end architecture;
