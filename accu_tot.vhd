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
        
        data_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES downto 0);

        data_in : in input_accu
    );
end accu_tot;

architecture rtl of accu_tot is
    signal zero : std_logic_vector( NBR_TILES -1 downto 0) := (others => '0');
	signal buff_data_out : std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES downto 0);

begin
    
    process(clk, reset)
        begin
            if reset = '0' then
                data_out <= (others => '0');
            elsif rising_edge(clk) then
                if start = '1' then
                    for k in 0 to NBR_TILES - 1 loop
                        buff_data_out <= std_logic_vector(unsigned(buff_data_out) + (unsigned(zero) & unsigned(data_in(k))));
                    end loop;
                        data_out <= buff_data_out;
                        done <= '1';
                else
                    buff_data_out <= (others => '0');
                    done <= '0';
                end if;
            end if;
    end process;

end architecture;


 