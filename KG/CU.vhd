----------------------------------------------------------------------------------
-- COMPUTE UNIT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
--use IEEE.NUMERIC_STD.ALL;

entity CU is
	port(
		clk : in std_logic;
		data_in : in MOD_TRIANGLE;
		rd : out std_logic;
		ce : in std_logic;
		pixel_out : out PIXEL;
		data_out_present : out std_logic;
		pixel_read : in std_logic;
		tex_rd : in std_logic;
		tex_coord_x : out TEX_ADDRESS;
		tex_coord_y : out TEX_ADDRESS;
		tex_color : in COLOR24
	);
end CU;

architecture Behavioral of CU is

component GS
	port(
			clk : in std_logic; --system clock
			rd : out std_logic; --is idle
			ce : in std_logic;
			rt_rd : in std_logic; --is rt idle
			rt_ce : out std_logic;
			data_in : in MOD_TRIANGLE;
			data_out : out PROJ_TRIANGLE; --data for RT
			
			fpu_operation_data : out std_logic_vector(3 downto 0);
			fpu_a_data : out FLOAT16;
			fpu_b_data : out FLOAT16;
			fpu_res_data : in FLOAT16;
			fpu_operation_valid : out std_logic;
			fpu_res_valid : in std_logic
			);
end component;

component RT
	port(
			clk : in std_logic; --system clock
			rd : out std_logic; --is idle
			ce : in std_logic;
			data_in : in PROJ_TRIANGLE; --data for RT
			pixel_out : out PIXEL; --data for RT
			data_out_present : out std_logic;
			pixel_read : in std_logic;
			tex_rd : in std_logic;
			tex_coord_x : out TEX_ADDRESS;
			tex_coord_y : out TEX_ADDRESS;
			tex_color : in COLOR24;
			
			fpu_operation_data : out std_logic_vector(3 downto 0);
			fpu_a_data : out FLOAT16;
			fpu_b_data : out FLOAT16;
			fpu_res_data : in FLOAT16;
			fpu_operation_valid : out std_logic := '0';
			fpu_res_valid : in std_logic
			);
end component;	
			
COMPONENT fpu
  PORT (
			clk : in std_logic; --system clock
			fpu_operation_data : in std_logic_vector(3 downto 0);
			fpu_a_data : in FLOAT16;
			fpu_b_data : in FLOAT16;
			fpu_res_data : out FLOAT16;
			fpu_operation_valid : in std_logic;
			fpu_res_valid : out std_logic
  );
END COMPONENT;
		
		
shared variable reg_mod_triangle : MOD_TRIANGLE;
signal mod_triangle : MOD_TRIANGLE;
signal proj_triangle : PROJ_TRIANGLE;
signal rt_rd : std_logic;
signal rt_ce : std_logic;
signal data_available : std_logic;

signal fpu_operation_data : std_logic_vector(3 downto 0);
signal fpu_a_data : FLOAT16;
signal fpu_b_data : FLOAT16;
signal fpu_res_data : FLOAT16;
signal fpu_operation_valid_gs : std_logic;
signal fpu_operation_valid_rt : std_logic;
signal fpu_operation_valid : std_logic;
signal fpu_res_valid : std_logic;

begin
  GS_entity : GS port map(
		clk => clk,
		rd => rd, --if GS ready then CU ready
		ce => ce,
		rt_rd => rt_rd,
		rt_ce => rt_ce,

		data_in => mod_triangle,
		data_out => proj_triangle,		
		fpu_operation_data => fpu_operation_data,
		fpu_a_data => fpu_a_data,
		fpu_b_data => fpu_b_data,
		fpu_res_data => fpu_res_data,
		fpu_operation_valid => fpu_operation_valid_gs,
		fpu_res_valid => fpu_res_valid
  );
  
  RT_entity : RT port map(
		clk => clk,
		rd => rt_rd,
		ce => rt_ce,
		data_in => proj_triangle,
		pixel_out => pixel_out,
		data_out_present =>data_out_present,
		pixel_read => pixel_read,
		tex_rd => tex_rd,
		tex_coord_x => tex_coord_x,
		tex_coord_y => tex_coord_y,
		tex_color => tex_color,
		
		fpu_operation_data => fpu_operation_data,
		fpu_a_data => fpu_a_data,
		fpu_b_data => fpu_b_data,
		fpu_res_data => fpu_res_data,
		fpu_operation_valid => fpu_operation_valid_rt,
		fpu_res_valid => fpu_res_valid
		);
	
  fpu_entity : fpu PORT MAP (
		clk => clk,
		fpu_operation_data => fpu_operation_data,
		fpu_a_data => fpu_a_data,
		fpu_b_data => fpu_b_data,
		fpu_res_data => fpu_res_data,
		fpu_operation_valid => fpu_operation_valid,
		fpu_res_valid => fpu_res_valid
  );
		
		
	fpu_operation_valid <= fpu_operation_valid_gs or fpu_operation_valid_rt;
		
  process (ce) is
  begin
    if rising_edge(ce) then
		reg_mod_triangle := data_in;
		mod_triangle <= reg_mod_triangle;
    end if;
  end process;

end Behavioral;

