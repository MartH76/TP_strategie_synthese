library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;


entity mul is 
port(
    clk : in std_logic;
    rst : in std_logic;

    start : in std_logic;


    mul_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM -1  downto 0);

    sum_a : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
    sum_b : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);

    multipl   : in std_logic_vector(WIDTH_OF_ROM-1 downto 0);

    done : out std_logic
);
end mul;

architecture rtl of mul is
    signal buff_calc: unsigned(WIDTH_OF_RAM + WIDTH_OF_ROM - 1  downto 0);
begin
    process(clk, rst)
    begin
        if rst = '0' then
            buff_calc <= (others => '0');
        elsif(rising_edge(clk)) then
            if(start = '1') then
                buff_calc <= (unsigned(sum_a) + unsigned(sum_b))*unsigned(multipl); 
                done <= '1';
            else
                buff_calc <= (others => '0');
                done <= '0';
            end if;
        end if;
    end process;

    mul_out <= std_logic_vector(buff_calc);

end architecture;