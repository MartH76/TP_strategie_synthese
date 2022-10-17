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
  signal Datout_o: std_logic_vector(WIDTH_OF_RAM + WIDTH_OF_ROM + WIDTH_OF_ROM + NBR_TILES downto 0);
  signal select_out: std_logic_vector(NBR_TILES-1 downto 0) := (others => '0');

begin

  uut: top port map ( clk               => clk,
                      reset             => reset,
                      input_data        => input_data,
                      done              => done,
                      enable_load_ram_i => enable_load_ram_i,
                      Datout_o          => Datout_o,
                      select_out        => select_out );


    clk <= not clk after 10 ns;
    reset <= '0' after 100 ns, '1' after 200 ns;
    input_data <= x"FAB" after 300 ns;
    enable_load_ram_i <= "11111" after 400 ns; -- penser à inverser les bits generate 0 to NBR_TILES-1
    select_out <= "11111" after 1000 ns;
    

end;