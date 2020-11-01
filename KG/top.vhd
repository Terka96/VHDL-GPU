----------------------------------------------------------------------------------
--KARTA GRAFICZNA
--BY PIOTR TERCZYNSKI
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;

entity top is
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
end top;

architecture Behavioral of top is

component D is
		port(
			clk : in std_logic; --system clock
			data_out : out MOD_TRIANGLE;
			cu_rd : in std_logic_vector(1 to CU_COUNT);
			cu_ce : out std_logic_vector(1 to CU_COUNT)
			);
end component;

component TP is
		port(
			clk : in std_logic; --system clock
			addr : in CU_TEX_COORDS;
			load_en : in std_logic_vector(1 to CU_COUNT);
			rd_out : out std_logic_vector(1 to CU_COUNT) := (others => '0');
			color : out COLOR24
		);
end component;

component CU is
	port(
		clk : in std_logic;	--system clock
		mod_triangle_in : in MOD_TRIANGLE;
		rd : out std_logic;
		ce : in std_logic;
		pixel_out : out PIXEL;
		pixel_out_rd : out std_logic;
		pixel_read : in std_logic;
		tex_load_en : out std_logic;
		tex_rd : in std_logic;
		tex_coord : out INT_COORDS;
		tex_color : in COLOR24;
		operation_number : out integer;
		instruction_number : out integer
	);
end component;

component PC is
	port(
			clk : in std_logic; --system clock
			fb_data_out : out std_logic;
			pixel_read : out std_logic_vector(1 to CU_COUNT);
			fb_pixel_out : out PIXEL;
			fb_rd : in std_logic;
			cu_data_in : in std_logic_vector(1 to CU_COUNT);
			cu_pixel_in : in CU_PIXELS
			);
end component;

component FB is
	port(
			clk : in std_logic; --system clock
			data_in : in std_logic;
			pixel_in : in PIXEL;
			pixel_drawn : out std_logic;
			rd : out std_logic;
			-- VGA DRIVER
			vga_vsync : out std_logic;
			vga_hsync : out std_logic;
			vga_clk : out std_logic;
			vga_r : out std_logic_vector( 7 downto 0 );
			vga_g : out std_logic_vector( 7 downto 0 );
			vga_b : out std_logic_vector( 7 downto 0 )
			);
end component;

signal data : MOD_TRIANGLE;
signal cu_rd : std_logic_vector(1 to CU_COUNT);
signal cu_ce : std_logic_vector(1 to CU_COUNT);
signal mm_rd : std_logic;
signal fb_rd : std_logic;
signal cu_pc_data : std_logic_vector(1 to CU_COUNT);
signal cu_pc_pixel : CU_PIXELS;
signal pc_fb_data : std_logic;
signal pc_fb_pixel : PIXEL;
signal pixel_read : std_logic_vector(1 to CU_COUNT);
signal cu_tex_coords_sig : CU_TEX_COORDS;
signal cu_tex_load_en : std_logic_vector(1 to CU_COUNT);
signal cu_tex_rd : std_logic_vector(1 to CU_COUNT);
signal tex_color : COLOR24;
signal pixel_drawn : std_logic;
signal cu_operation_number : CU_INTEGERS;
signal cu_instruction_number : CU_INTEGERS;

begin
  D_entity : D port map(
			clk => clk,
			data_out => data,
			cu_rd => cu_rd,
			cu_ce => cu_ce
			);
			
	TP_entity : TP port map(
			clk => clk,
			addr => cu_tex_coords_sig,
			load_en => cu_tex_load_en,
			rd_out => cu_tex_rd,
			color => tex_color
	);

  CU_BANK_entity : 
		for I in 1 to CU_COUNT generate
		CUX : CU port map(
		clk => clk,
		mod_triangle_in => data,
		rd => cu_rd(I),
		ce => cu_ce(I),
		pixel_out => cu_pc_pixel(I),
		pixel_out_rd => cu_pc_data(I),
		pixel_read => pixel_read(I),
		tex_load_en => cu_tex_load_en(I),
		tex_rd => cu_tex_rd(I),
		tex_coord => cu_tex_coords_sig(I),
		tex_color => tex_color,
		operation_number => cu_operation_number(I),
		instruction_number => cu_instruction_number(I)
  );
  end generate CU_BANK_entity;
  
  PC_entity : PC port map(
			clk => clk,
			fb_data_out => pc_fb_data,
			pixel_read => pixel_read,
			fb_pixel_out => pc_fb_pixel,
			fb_rd => fb_rd,
			cu_data_in => cu_pc_data,
			cu_pixel_in => cu_pc_pixel
			);
  
  FB_entity : FB port map(
			clk => clk,
			data_in => pc_fb_data,
			pixel_in => pc_fb_pixel,
			pixel_drawn => pixel_drawn,
			rd => fb_rd,
			-- VGA DRIVER
			vga_vsync => vga_vsync,
			vga_hsync => vga_hsync,
			vga_clk => vga_clk,
			vga_r => vga_r,
			vga_g => vga_g,
			vga_b => vga_b
		);
		
		metr_cu_rd <= cu_rd;
		metr_cu_ce <=cu_ce;
		metr_fb_rd <= fb_rd;
		metr_cu_pc_data <= cu_pc_data;
		metr_pc_fb_data <= pc_fb_data;
		metr_cu_tex_load_en <= cu_tex_load_en;
		metr_cu_tex_rd <= cu_tex_rd;
		metr_operation_number <= cu_operation_number;
		metr_instruction_number <= cu_instruction_number;
		metr_pixel_drawn <= pixel_drawn;

end Behavioral;

