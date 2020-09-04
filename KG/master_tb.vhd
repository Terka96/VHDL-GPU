----------------------------------------------------------------------------------
-- MASTER TEST BENCH
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.definitions.all;

entity master_tb is
end master_tb;

architecture Behavioral of master_tb is

component top is
	port(
		clk : in std_logic;
		vga_vsync : out std_logic;
		vga_hsync : out std_logic;
		vga_clk : out std_logic;
		vga_r : out std_logic_vector( 7 downto 0 );
		vga_g : out std_logic_vector( 7 downto 0 );
		vga_b : out std_logic_vector( 7 downto 0 )
	);
end component;

component vga_tb is
	port (		
		clk : in std_logic;
		vga_vsync : in std_logic;
		vga_hsync : in std_logic;
		vga_clk : in std_logic;
		vga_r : in std_logic_vector( 7 downto 0 );
		vga_g : in std_logic_vector( 7 downto 0 );
		vga_b : in std_logic_vector( 7 downto 0 )
		);
end component;

component metrics_tb is
end component;

signal clk : std_logic := '0';
signal vga_vsync : std_logic;
signal vga_hsync : std_logic;
signal vga_clk : std_logic;
signal vga_r : std_logic_vector( 7 downto 0 );
signal vga_g : std_logic_vector( 7 downto 0 );
signal vga_b : std_logic_vector( 7 downto 0 );

begin

  top_entity : top port map(
		clk => clk,
		vga_vsync => vga_vsync,
		vga_hsync => vga_hsync,
		vga_clk => vga_clk,
		vga_r => vga_r,
		vga_g => vga_g,
		vga_b => vga_b
  );
  
  vga_tb_entity : vga_tb port map(
		clk => clk,
		vga_vsync => vga_vsync,
		vga_hsync => vga_hsync,
		vga_clk => vga_clk,
		vga_r => vga_r,
		vga_g => vga_g,
		vga_b => vga_b
  );
  
process is
begin
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
  clk <= '0';
end process;

end Behavioral;

