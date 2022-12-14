library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity accu_tile is
    port (
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        
        done : out std_logic;
        start_accu : in std_logic;
        select_out : in std_logic;

        data_in : in std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM downto 0);

        data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) - 1 downto 0)
    );
end accu_tile;

architecture rtl of accu_tile is

    signal counter_accu_tile : integer range 0 to 2**ROM_SIZE_ADDR := 0;

	signal buff_data_out : std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) - 1 downto 0) := (others => '0');
begin
    
        process(clk, rst)
        begin
            if rst = '0' then
                buff_data_out <= (others => '0');
                counter_accu_tile <= 0;
                done <= '0';
            elsif rising_edge(clk) then
                if(start = '1' and select_out = '1') then

                    --if (counter_accu_tile = 0) then
					--	buff_data_out <= (others => '0');
                    --end if;

                    if counter_accu_tile = 2**ROM_SIZE_ADDR then
                        done <= '1';
                        counter_accu_tile <= 0;
                        --buff_data_out <= (others => '0');
                    else
                        if(counter_accu_tile = 0) then
                            buff_data_out <= (others => '0');
                        end if; 
                        if (start_accu = '1') then
                            buff_data_out <= std_logic_vector(unsigned(buff_data_out) +  unsigned(data_in));
                            done <= '0';
                            counter_accu_tile <= counter_accu_tile + 1;
                        end if;
                    end if;
                    
                end if;
            end if;
        end process;

        data_out <= buff_data_out when select_out = '1' else (others => '0');

end architecture;
