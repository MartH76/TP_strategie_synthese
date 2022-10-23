library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library work;
use work.tp_pkg.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
      port (
          clk : in std_logic;
          reset : in std_logic;
          input_data : in std_logic_vector(WIDTH_OF_RAM-1 downto 0);
          done : out std_logic;
          enable_load_ram_i : in std_logic_vector(NBR_TILES-1 downto 0);
          Datout_o : out std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES -1 downto 0);
          select_out : in std_logic_vector(NBR_TILES-1 downto 0)
      );
  end component;

  signal clk: std_logic := '0';
  signal reset: std_logic := '0';
  signal input_data: std_logic_vector(WIDTH_OF_RAM-1 downto 0) := (others => '0');
  signal done: std_logic;
  signal enable_load_ram_i: std_logic_vector(NBR_TILES-1 downto 0) := (others => '0');
  signal Datout_o: std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES - 1 downto 0);
  signal select_out: std_logic_vector(NBR_TILES-1 downto 0) := (others => '0');

  shared variable cpt_remplissage_ram : integer range 0 to (2**RAM_SIZE_ADDR) := 0;

begin

  uut: top port map ( clk               => clk,
                      reset             => reset,
                      input_data        => input_data,
                      done              => done,
                      enable_load_ram_i => enable_load_ram_i,
                      Datout_o          => Datout_o,
                      select_out        => select_out );


    clk <= not clk after 10 ns;

    stimulus: process
    begin
        reset <= '0';
        wait for 11 ns;
        reset <= '1';
        wait for 43 ns;

        select_out <= "11111" after 1000 ns;
        --remplissage de la ram
        
        wait until rising_edge(clk);
        enable_load_ram_i <= "11111";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        while cpt_remplissage_ram < (2**RAM_SIZE_ADDR) loop
            input_data <= in_ram(cpt_remplissage_ram);
            cpt_remplissage_ram := cpt_remplissage_ram + 1;
            wait until rising_edge(clk);
        end loop;
        enable_load_ram_i <= "00000";
        wait for 1 ms;
 
    end process; 

end;