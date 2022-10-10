library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mul is 
generic(
    Width_ram : integer;
    Width_rom : integer
);
port(
    clk : in std_logic;
    rst : in std_logic;

    start : in std_logic;


    mul_out : out std_logic_vector(Width_ram+Width_rom downto 0);

    sum_a : in std_logic_vector(Width_ram-1 downto 0);
    sum_b : in std_logic_vector(Width_ram-1 downto 0);

    multipl   : in std_logic_vector(Width_rom downto 0)
);
end mul;

architecture rtl of mul is
    signal buff_calc: unsigned(Width_ram + Width_rom downto 0);
begin
    process(clk,rst)
    begin
        if rst = '0' then
            mul_out <= (others => '0');
        elsif(rising_edge(clk)) then
            if(start = '1') then
                buff_calc <= (unsigned(sum_a) + unsigned(sum_b))*unsigned(multipl);
                mul_out <= std_logic_vector(buff_calc);
            end if;
        end if;
    end process;
end architecture;