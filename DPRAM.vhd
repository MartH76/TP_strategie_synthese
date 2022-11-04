library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tp_pkg.all;


entity DPRAM is
    port (
        clka   : in std_logic;
        clkb   : in std_logic;

        
        dina : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        addra : in std_logic_vector(RAM_SIZE_ADDR-1 downto 0);
        wea : in std_logic;
        ena : in std_logic;

        douta : out std_logic_vector(WIDTH_OF_RAM-1 downto 0);

        dinb : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
        addrb : in std_logic_vector(RAM_SIZE_ADDR-1 downto 0);
        web : in std_logic;
        enb : in std_logic;

        doutb : out std_logic_vector(WIDTH_OF_RAM-1 downto 0)        
    );
end entity;


-- architecture of dram
architecture rtl of DPRAM is
    type mem is array (integer range (2**(RAM_SIZE_ADDR))-1 downto 0) of std_logic_vector(WIDTH_OF_RAM-1 downto 0);
    shared variable memory : mem;



begin

    -- process (clka)
    -- begin
    --     if rising_edge(clka) then
    --         if (ena = '1' and wea = '1') then
    --                 memory(to_integer(unsigned(addra))) := dina;
    --         elsif (ena = '1' and wea = '0') then
    --                 douta <= memory(to_integer(unsigned(addra)));
    --         else
    --                 douta <= (others => 'Z');
    --         end if;
    --     end if;
    -- end process;


    -- process(clkb)
    -- begin
    --     if rising_edge(clkb) then
    --         if (enb = '1' and web = '1') then
    --                 memory(to_integer(unsigned(addrb))) := dinb;
    --         elsif (enb = '1' and web = '0') then
    --                 doutb <= memory(to_integer(unsigned(addrb)));
    --         else
    --                 doutb <= (others => 'Z');
    --         end if;
                
    --     end if;
    -- end process;


    process (clka)
    begin
        if rising_edge(clka) then
            if (ena = '1') then
                douta <= memory(to_integer(unsigned(addra))); 
                if (wea = '1') then
                    memory(to_integer(unsigned(addra))) := dina;
                end if;
            end if;
        end if;
    end process;


    process(clkb)
    begin
        if rising_edge(clkb) then
            if (enb = '1') then
                doutb <= memory(to_integer(unsigned(addrb))); 
                if (web = '1') then
                    memory(to_integer(unsigned(addrb))) := dinb;
                end if;
            end if;        
        end if;
    end process;

end architecture;

