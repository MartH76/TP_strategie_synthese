library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;


entity sequenceur is
    port (
        clk             : in std_logic;
        reset           : in std_logic;

        enable_load_ram : in std_logic;

        start_mul       : out std_logic;
        start_accu_tile : out std_logic;  
        
        select_output   : in std_logic;

        -- input for DRAM
        data_a          : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        data_b          : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        -- output for DRAM
        addra           : out std_logic_vector(SIZE_ADDR-1 downto 0);
        wea             : out std_logic;
        ena             : out std_logic;

        addrb           : out std_logic_vector(SIZE_ADDR-1 downto 0); 
        web             : out std_logic;
        enb             : out std_logic;

        -- rom
        en_rom         : out std_logic
    );
end entity;

architecture rtl of sequenceur is
    type state_type is (IDLE, LOAD_RAM, CONFIG_CALCULATION, CALCULATION);
    signal state : state_type := IDLE;

    signal counter_data_to_write : integer range 0 to (2**(SIZE_ADDR))-1 := 0;

    signal counter_nbr_multiplication : integer range 0 to (2**(WIDTH_OF_ROM))-1 := 0;
    
begin
    process(clk) is 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
                counter_data_to_write <= 0;
                counter_nbr_multiplication <= 0;
                start_mul <= '0';
                ena <= '0';
                enb <= '0';
                en_rom <= '0';
            else
                case state is
                    when IDLE =>

                        ena <= '0';
                        enb <= '0';
                        en_rom <= '0';

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
                                -- incrémentation du compteur d'addresses
                                counter_data_to_write <= counter_data_to_write + 1;
                                state <= LOAD_RAM;
                            else
                                counter_data_to_write <= 0;
                                state <= CONFIG_CALCULATION;
                            end if;
                        else
                            state <= CONFIG_CALCULATION;
                        end if;


                    when CONFIG_CALCULATION => -- chercher la data dans la dpram

                        -- lecture de la data dans la ram
                        addra <= std_logic_vector(to_unsigned(counter_nbr_multiplication, SIZE_ADDR));
                        ena <= '1';
                        wea <= '0';
                        addrb <= std_logic_vector(to_unsigned((2**(WIDTH_OF_ROM))-1 + counter_nbr_multiplication, SIZE_ADDR));
                        enb <= '1';
                        web <= '0';

                        -- lecture data dans la rom
                        en_rom <= '1';

                        state <= CALCULATION;
   
                    when CALCULATION =>
                        if(counter_nbr_multiplication < (2**(WIDTH_OF_ROM))-1) then
                            counter_nbr_multiplication <= counter_nbr_multiplication + 1;
                            start_mul <= '1';
                            state <= CONFIG_CALCULATION;
                        else
                            counter_nbr_multiplication <= 0;
                            start_mul <= '0';
                            state <= IDLE;
                        end if;


                    when others =>
                        state <= IDLE;
                end case;

            end if;
        end if;
    end process;
    

end architecture;
