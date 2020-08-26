----------------------------------------------------------------------------------
-- FRAME BUFFER
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
use IEEE.NUMERIC_STD.ALL;

entity FB is
	port(
			clk : in std_logic; --system clock
			data_in : in std_logic;
			pixel_in : in PIXEL;
			rd : out std_logic;
			-- VGA DRIVER
			vga_vsync : out std_logic;
			vga_hsync : out std_logic;
			vga_clk : out std_logic;
			vga_r : out std_logic_vector( 7 downto 0 );
			vga_g : out std_logic_vector( 7 downto 0 );
			vga_b : out std_logic_vector( 7 downto 0 )
			);
end FB;

architecture Behavioral of FB is

COMPONENT fpu_cmp_fb
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

type line is array (1 to SCREEN_WIDTH) of PIXEL;
type frame is array (1 to SCREEN_HEIGHT) of line;

signal fpu_a_valid : std_logic;
signal fpu_b_valid : std_logic;
signal fpu_res_valid : std_logic;
signal fpu_a_data : FLOAT16;
signal fpu_b_data : FLOAT16;
signal fpu_cmp_result : std_logic_vector(7 downto 0);
begin

fpu_cmp_fb_entity : fpu_cmp_fb PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_a_valid,
    s_axis_a_tdata => fpu_a_data,
    s_axis_b_tvalid => fpu_b_valid,
    s_axis_b_tdata => fpu_b_data,
    m_axis_result_tvalid => fpu_res_valid,
	 m_axis_result_tdata => fpu_cmp_result
  );
  
process (clk) is
variable cur_X : integer :=1;
variable cur_Y : integer :=1;
variable frame_buf : frame;
type state is (CLEAR_BUF,WAIT_FOR_DATA,WAIT_FOR_COMPARISON);
variable fbstate : state := CLEAR_BUF;
begin
if rising_edge(clk) then
	case fbstate is
		when CLEAR_BUF =>
			frame_buf(cur_Y)(cur_X) := (("0000000000","0000000000"),x"000000",x"7c00");
			if cur_X = (SCREEN_WIDTH - 1) and cur_Y = (screen_HEIGHT - 1) then
				fbstate := WAIT_FOR_DATA;
			end if;
		when WAIT_FOR_DATA =>
			if data_in = '1' then
				fpu_a_data <= pixel_in.depth;				
				fpu_b_data <= frame_buf(to_integer(pixel_in.position.coord_Y))(to_integer(pixel_in.position.coord_X)).depth;
				fpu_a_valid <= '1';
				fpu_b_valid <= '1';
				fbstate := WAIT_FOR_COMPARISON;
			end if;
			rd <= '1';
		when WAIT_FOR_COMPARISON =>
			if fpu_res_valid ='1' then
					if fpu_cmp_result(0) = '1' then --a < b
						frame_buf(to_integer(pixel_in.position.coord_Y))(to_integer(pixel_in.position.coord_X)) := pixel_in;
					end if;
				fbstate := WAIT_FOR_DATA;
			end if;
			fpu_a_valid <='0';
			fpu_b_valid <='0';
			rd <= '0';
	end case;
	
	--TODO ADJUST CLOCK FOR VGA
	cur_X := cur_X + 1;
	if cur_X > SCREEN_WIDTH then
		cur_X := 1;
		cur_Y := cur_Y + 1;
		if cur_Y > SCREEN_HEIGHT then
			cur_y := 1;
		end if;
	end if;
	
	if cur_Y = 1 then
		vga_vsync <= '1';
	else
		vga_vsync <= '0';
	end if;
	if cur_X = 1 then
		vga_hsync <= '1';
	else
		vga_hsync <= '0';
	end if;
	vga_r <= frame_buf(cur_Y)(cur_X).color(23 downto 16);
	vga_g <= frame_buf(cur_Y)(cur_X).color(15 downto 8);
	vga_b <= frame_buf(cur_Y)(cur_X).color(7 downto 0);
end if;
end process;

end Behavioral;
