library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity accu_tot is
    port (
        clk : in std_logic;
        reset : in std_logic;

        start : in std_logic;
        done : out std_logic;
        
        data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) + NBR_TILES - 1 downto 0);

        data_in : in input_accu
    );
end accu_tot;

architecture rtl of accu_tot is
    signal s_done : std_logic;

    shared variable buff_data_out : std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 2**(ROM_SIZE_ADDR) + NBR_TILES - 1 downto 0);

begin
    
    process(clk, reset)
        begin
            if reset = '0' then
                data_out <= (others => '0');
            elsif rising_edge(clk) then
                if start = '1' then
                    for k in 0 to NBR_TILES - 1 loop
                        buff_data_out := std_logic_vector(unsigned(buff_data_out) + unsigned(data_in(k)));
                    end loop;
                    if(s_done = '0')then 
                        data_out <= buff_data_out;
                        s_done <= '1';
                    end if;
                    if start = '0' then
                        s_done <= '0';
                    end if;
                else
                    buff_data_out := (others => '0');
                    s_done <= '0';
                end if;
            end if;
    end process;
    done <= s_done;
end architecture;


 