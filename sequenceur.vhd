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
        
    
        -- output for DRAM
        addra           : out std_logic_vector(RAM_SIZE_ADDR-1 downto 0);
        wea             : out std_logic;
        ena             : out std_logic;

        addrb           : out std_logic_vector(RAM_SIZE_ADDR-1 downto 0); 
        web             : out std_logic;
        enb             : out std_logic;

        -- rom
        en_rom         : out std_logic;
        addr_rom       : out std_logic_vector(ROM_SIZE_ADDR-1 downto 0)
    );
end entity;

architecture rtl of sequenceur is
    type state_type is (IDLE, LOAD_RAM, CONFIG_CALCULATION, CALCULATION);
    signal state : state_type := IDLE;

    signal counter_data_to_write : integer range 0 to (2**(RAM_SIZE_ADDR)) := 1;

    signal counter_nbr_multiplication : integer range 0 to (2**(ROM_SIZE_ADDR)) := 0;
    
begin
    process(clk, reset) is 
    begin
        if rising_edge(clk) then
            if reset = '0' then
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
                        addra <= (others => '0');
                        addrb <= (others => '0');
                        ena <= '0';
                        enb <= '0';
                        wea <= '0';
                        web <= '0';
                        en_rom <= '0';

                        if (enable_load_ram = '1') then
                            state <= LOAD_RAM;
                        end if;


                        
                    when LOAD_RAM =>
                        if (enable_load_ram = '1') then
                            ena <= '1';
                            wea <= '1'; 
                            -- si la ram n'est pas encore remplie
                            addra <= std_logic_vector(to_unsigned(counter_data_to_write, RAM_SIZE_ADDR));       
                            -- incrémentation du compteur d'addresses
                            counter_data_to_write <= counter_data_to_write + 1;

                            if (counter_data_to_write < (2**(RAM_SIZE_ADDR))) then
                                -- écriture dans la ram
                                state <= LOAD_RAM;
                            else
                                counter_data_to_write <= 0;
                                ena <= '1'; -- on active la ram port a
                                enb <= '1'; -- on active la ram port b
                                wea <= '0'; -- on active la lecture
                                web <= '0'; -- on active la lecture
                                en_rom <= '1'; -- on active la rom
                                addra <= std_logic_vector(to_unsigned(0, RAM_SIZE_ADDR));
                                addrb <= std_logic_vector(to_unsigned(((2**(RAM_SIZE_ADDR-1))), RAM_SIZE_ADDR));
                                state <= CONFIG_CALCULATION;
                            end if;
                        end if;
                        


                    when CONFIG_CALCULATION => -- chercher la data dans la dpram

                        -- lecture de la data dans la ram
                        addra <= std_logic_vector(to_unsigned(counter_nbr_multiplication, RAM_SIZE_ADDR));
                        addrb <= std_logic_vector(to_unsigned(((2**(RAM_SIZE_ADDR-1)) + counter_nbr_multiplication), RAM_SIZE_ADDR));
                        -- lecture data dans la rom
                        addr_rom <= std_logic_vector(to_unsigned(counter_nbr_multiplication, ROM_SIZE_ADDR));
                        state <= CALCULATION;
   
                    when CALCULATION =>
                        if(counter_nbr_multiplication < (2**(ROM_SIZE_ADDR))) then
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
