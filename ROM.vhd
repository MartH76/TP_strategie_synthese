library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;

entity ROM is 
    port (
        clk             : in std_logic;
        enrom           : in std_logic;
        addr            : in std_logic_vector (ROM_SIZE_ADDR-1 downto 0);
        data            : out std_logic_vector (WIDTH_OF_ROM-1 downto 0)
    );
end entity;



--architecture of the ROM
architecture rtl of ROM is
        --declaration of the ROM
    type ROM_TYPE is array (2**ROM_SIZE_ADDR-1 downto 0) of std_logic_vector (WIDTH_OF_ROM-1 downto 0);
    constant ROM : ROM_TYPE := (
        "00000000000", --0
        "00000000001", --1
        "00000000010", --2
        "00000000011", --3
        "00000000100", --4
        "00000000101", --5
        "00000000110", --6
        "00000000111", --7
        "00000001000", --8
        "00000001001", --9
        "00000001010", --10
        "00000001011", --11
        "00000001100", --12
        "00000001101", --13
        "00000001110", --14
        "11111111111"  --15
    ); -- attention il faut réfléchir à tout tester (overflow...)
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if (enrom = '1') then
                data <= ROM(to_integer(unsigned(addr)));    
            end if;
        end if;
    end process;
end architecture;