library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.tp_pkg.all;

entity accu is
    generic(
        WIDTH_OF_ROM : integer range 0 to 100;
        WIDTH_OF_RAM : integer range 0 to 100;
        SIZE_ADDR : integer range 1 to 100;
        NBR_TILES : integer range 1 to 100
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        select_out : in std_logic_vector(NBR_TILES-1 downto 0);

        accu_out : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 15 downto 0);

        accu_in : input_accu := (others => (others => '0'))
    );
    end entity;

    architecture rtl of accu is

        type simple_acc is array (0 to NBR_TILES-1) of std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 15 downto 0);
        signal buff_simple_acc : simple_acc := (others => (others => '0'));

        signal buff_out : std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + 15 + NBR_TILES downto 0) := (others => '0');

        signal cpt : integer range 0 to 15;

    begin
        process(clk, rst)
        begin
            if rst = '1' then
                accu_out <= (others => '0');
                cpt <= 0;
                buff_out <= (others => '0');
            elsif rising_edge(clk) then
                    cpt <= cpt + 1;
                    buff_simple_acc <= buff_simple_acc + ("000000000000000" & accu_in); --somme des multiplications

                    if cpt = 16 then
                        cpt <= 0;
                        buff_out <= 
                    end if; 

            end if;
        end process;


    end architecture;
        

