----------------------------------------------------------------------------------
-- MASTER TEST BENCH
----------------------------------------------------------------------------------
-- Copyright 2020 Piotr Terczyński
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated           
-- documentation files (the "Software"), to deal in the       
-- Software without restriction, including without limitation 
-- the rights to use, copy, modify, merge, publish,           
-- distribute, sublicense, and/or sell copies of the Software,
-- and to permit persons to whom the Software is furnished to
-- do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice 
-- shall be included in all copies or substantial portions of
-- the Software.
--
-- 		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF 
-- ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
-- THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
-- OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR   
-- OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
		vga_b : out std_logic_vector( 7 downto 0 );
		
				--data for metrics
		metr_cu_rd : out std_logic_vector(1 to CU_COUNT);
		metr_cu_ce : out std_logic_vector(1 to CU_COUNT);
		metr_fb_rd : out std_logic;
		metr_cu_pc_data : out std_logic_vector(1 to CU_COUNT);
		metr_pc_fb_data : out std_logic;
		metr_cu_tex_load_en : out std_logic_vector(1 to CU_COUNT);
		metr_cu_tex_rd : out std_logic_vector(1 to CU_COUNT);
		metr_operation_number : out CU_INTEGERS;
		metr_instruction_number : out CU_INTEGERS;
		metr_pixel_drawn : out std_logic
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

component metrics is
	port(
		clk : in std_logic;	--system clock
		cu_rd : in std_logic_vector(1 to CU_COUNT);
		cu_ce : in std_logic_vector(1 to CU_COUNT);
		fb_rd : in std_logic;
		cu_pc_data : in std_logic_vector(1 to CU_COUNT);
		pc_fb_data : in std_logic;
		cu_tex_load_en : in std_logic_vector(1 to CU_COUNT);
		cu_tex_rd : in std_logic_vector(1 to CU_COUNT);
		operation_number : in CU_INTEGERS;
		instruction_number : in CU_INTEGERS;
		pixel_drawn : in std_logic
	);
end component;

signal clk : std_logic := '0';
signal vga_vsync : std_logic;
signal vga_hsync : std_logic;
signal vga_clk : std_logic;
signal vga_r : std_logic_vector( 7 downto 0 );
signal vga_g : std_logic_vector( 7 downto 0 );
signal vga_b : std_logic_vector( 7 downto 0 );

--signals for metrics
signal cu_rd : std_logic_vector(1 to CU_COUNT);
signal cu_ce : std_logic_vector(1 to CU_COUNT);
signal fb_rd : std_logic;
signal cu_pc_data : std_logic_vector(1 to CU_COUNT);
signal pc_fb_data : std_logic;
signal cu_tex_load_en : std_logic_vector(1 to CU_COUNT);
signal cu_tex_rd : std_logic_vector(1 to CU_COUNT);
signal pixel_drawn : std_logic;
signal cu_operation_number : CU_INTEGERS;
signal cu_instruction_number : CU_INTEGERS;


begin

  top_entity : top port map(
		clk => clk,
		vga_vsync => vga_vsync,
		vga_hsync => vga_hsync,
		vga_clk => vga_clk,
		vga_r => vga_r,
		vga_g => vga_g,
		vga_b => vga_b,
		
		metr_cu_rd => cu_rd,
		metr_cu_ce => cu_ce,
		metr_fb_rd => fb_rd,
		metr_cu_pc_data => cu_pc_data,
		metr_pc_fb_data => pc_fb_data,
		metr_cu_tex_load_en => cu_tex_load_en,
		metr_cu_tex_rd => cu_tex_rd,
		metr_operation_number => cu_operation_number,
		metr_instruction_number => cu_instruction_number,
		metr_pixel_drawn => pixel_drawn
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
  
	metrics_entity : metrics port map(
			clk => clk,
			cu_rd => cu_rd,
			cu_ce => cu_ce,
			fb_rd => fb_rd,
			cu_pc_data => cu_pc_data,
			pc_fb_data => pc_fb_data,
			cu_tex_load_en => cu_tex_load_en,
			cu_tex_rd => cu_tex_rd,
			operation_number => cu_operation_number,
			instruction_number => cu_instruction_number,
			pixel_drawn => pixel_drawn
	);
  
process is
begin
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
  clk <= '0';
end process;

end Behavioral;

