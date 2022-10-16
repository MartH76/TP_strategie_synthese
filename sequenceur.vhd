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
        
        -- input for DRAM
        input_data : in std_logic_vector(WIDTH_OF_WORD downto 0);
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
                counter_data_to_write <= 0;
            else
                case state is
                    when IDLE =>
                        if (enable_load_ram = '1') then
                            state <= LOAD_RAM;
                        end if;



                    when LOAD_RAM =>
                        if (enable_load_ram = '1') then
                            -- si la ram n'est pas encore remplie
                            if (counter_data_to_write < (2**(SIZE_ADDR))-1) then
                                -- écriture dans la ram
                                addra <= std_logic_vector(to_unsigned(counter_data_to_write, SIZE_ADDR));
                                ena <= '1';
                                wea <= '1';        
                                dina <= input_data;
                                -- incrémentation du compteur d'addresses
                                counter_data_to_write <= counter_data_to_write + 1;
                                state <= LOAD_RAM;
                            else
                                counter_data_to_write <= 0;
                                state <= CALCULATION;
                            end if;
          
                        else
                            state <= CALCULATION;
                        end if;


                    when CALCULATION =>
                        start_mul <= '1';

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
