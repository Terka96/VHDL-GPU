----------------------------------------------------------------------------------
-- COMPUTE UNIT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
use IEEE.NUMERIC_STD.ALL;

entity CU is
	port(
		clk : in std_logic;
		data_in : in MOD_TRIANGLE;
		rd : out std_logic;
		ce : in std_logic;
		pixel_out : out PIXEL;
		pixel_out_rd : out std_logic;
		pixel_read : in std_logic;
		tex_load_en : out std_logic;
		tex_rd : in std_logic;
		tex_coord : out INT_COORDS;
		tex_color : in COLOR24;
		operation : out integer :=0;
		instruction_number : out integer
	);
end CU;

architecture Behavioral of CU is

component GS
	port(
			clk : in std_logic; --system clock
			rd : out std_logic; --is idle
			ce : in std_logic;
			data_in : in MOD_TRIANGLE;
			pixel_out : out PIXEL; --data for RT
			pixel_out_rd : out std_logic := '0';
			pixel_read : in std_logic;
			tex_load_en : out std_logic;
			tex_rd : in std_logic;
			tex_coord : out INT_COORDS := ("0000000000000","0000000000000");
			tex_color : in COLOR24;
			
			fpu_operation_data : out std_logic_vector(3 downto 0);
			fpu_a_data : out FLOAT16;
			fpu_b_data : out FLOAT16;
			fpu_res_data : in FLOAT16;
			fpu_operation_valid : out std_logic := '0';
			fpu_res_valid : in std_logic;
			instruction_number : out integer
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
signal mod_triangle_sig : MOD_TRIANGLE;

signal fpu_operation_data : std_logic_vector(3 downto 0);
signal fpu_a_data : FLOAT16;
signal fpu_b_data : FLOAT16;
signal fpu_res_data : FLOAT16;
signal fpu_operation_valid : std_logic;
signal fpu_res_valid : std_logic;

begin
  GS_entity : GS port map(
		clk => clk,
		rd => rd, --if GS ready then CU ready
		ce => ce,

		data_in => mod_triangle_sig,
		pixel_out => pixel_out,
		pixel_out_rd => pixel_out_rd,
		pixel_read => pixel_read,
		tex_load_en => tex_load_en,
		tex_rd => tex_rd,
		tex_coord => tex_coord,
		tex_color => tex_color,
		fpu_operation_data => fpu_operation_data,
		fpu_a_data => fpu_a_data,
		fpu_b_data => fpu_b_data,
		fpu_res_data => fpu_res_data,
		fpu_operation_valid => fpu_operation_valid,
		fpu_res_valid => fpu_res_valid,
		instruction_number => instruction_number
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
		
		
  process (ce) is
  begin
    if rising_edge(ce) then
		reg_mod_triangle := data_in;
		mod_triangle_sig <= reg_mod_triangle;
    end if;
  end process;
  
	operation <= to_integer(unsigned(fpu_operation_data));


end Behavioral;

