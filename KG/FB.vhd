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
			pixel_drawn : out std_logic := '0';
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

COMPONENT fb_memory
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
  );
END COMPONENT;

signal fpu_a_valid : std_logic;
signal fpu_b_valid : std_logic;
signal fpu_res_valid : std_logic;
signal fpu_a_data : FLOAT16;
signal fpu_b_data : FLOAT16;
signal fpu_cmp_result : std_logic_vector(7 downto 0);

type dout is array(0 to ((SCREEN_WIDTH/4)-1)) of std_logic_vector(39 downto 0);

signal fb_addra : std_logic_vector(9 downto 0) := (others => '0');
signal fb_addrb : std_logic_vector(9 downto 0) := (others => '0');
signal fb_we : std_logic_vector(0 to ((SCREEN_WIDTH/4)-1)) := (others => '0');
signal fb_dina : std_logic_vector(39 downto 0) := (others => '0');
signal fb_douta : dout;
signal fb_doutb : dout;
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
  
frame_buffer : for I in 0 to (SCREEN_WIDTH/4)-1 generate
 frame_mem_block : fb_memory 
  PORT MAP (
    clka => clk,
    wea => fb_we(I to I),
    addra => fb_addra,
    dina => fb_dina,
    douta => fb_douta(I),
    clkb => clk,
    web => "0",
    addrb => fb_addrb,
    dinb => "0000000000000000000000000000000000000000",
    doutb => fb_doutb(I)
  );
end generate frame_buffer; 

process (clk) is
variable cur_X : integer :=0;
variable cur_Y : integer :=0;
variable prev_mod : integer:=0;
variable cur : integer :=0;
variable pixel_req,pixel_buf : PIXEL;
variable draw_color_reg : COLOR24;
type state is (CLEAR_BUF,WAIT_FOR_DATA,WAIT_FOR_BRAM,COMPARE,WAIT_FOR_COMPARISON);
variable fbstate : state := CLEAR_BUF;
variable delay : boolean := false;
begin
if rising_edge(clk) then
	case fbstate is
		when CLEAR_BUF =>
			fb_dina <= "0000000000000000000000000111110000000000";
			fb_addra <= std_logic_vector(to_unsigned(cur,10));
			fb_we <= (others => '1');
			if delay = true then
				delay := false;
				if cur = 1024 then
					fbstate := WAIT_FOR_DATA;
				else
					cur := cur + 1;
				end if;
			else
				delay := true;
			end if;
			cur_X := 0;
			cur_Y := 0;
		when WAIT_FOR_DATA =>
			fb_we <= (others => '0');
			pixel_drawn <= '0';
			if data_in = '1' then
				pixel_req := pixel_in;
				fb_addra <= std_logic_vector(pixel_req.position.coord_Y(7 downto 0))& std_logic_vector(pixel_req.position.coord_X(1 downto 0));
				fbstate := WAIT_FOR_BRAM;
			else
				rd <= '1';
			end if;
		when WAIT_FOR_BRAM =>
				fb_addra <= std_logic_vector(pixel_req.position.coord_Y(7 downto 0))& std_logic_vector(pixel_req.position.coord_X(1 downto 0));
				fbstate := COMPARE;
		when COMPARE =>
			pixel_buf.depth := fb_douta(to_integer(pixel_req.position.coord_X(12 downto 2)))(15 downto 0);
			pixel_buf.color := fb_douta(to_integer(pixel_req.position.coord_X(12 downto 2)))(39 downto 16);
			fpu_a_data <= pixel_req.depth;
			fpu_b_data <= pixel_buf.depth;
			fpu_a_valid <= '1';
			fpu_b_valid <= '1';
			rd <= '0';
			fbstate := WAIT_FOR_COMPARISON;
		when WAIT_FOR_COMPARISON =>
			if fpu_res_valid ='1' then
					if fpu_cmp_result(0) = '1' then --a < b
						fb_dina(39 downto 16) <= pixel_req.color;
						fb_dina(15 downto 0) <= pixel_req.depth;
						fb_addra <= std_logic_vector(pixel_req.position.coord_Y(7 downto 0))& std_logic_vector(pixel_req.position.coord_X(1 downto 0));
						fb_we(to_integer(pixel_req.position.coord_X(12 downto 2))) <= '1';
						pixel_drawn <= '1';
					end if;
					fbstate := WAIT_FOR_DATA;
			end if;
			fpu_a_valid <='0';
			fpu_b_valid <='0';
			rd <= '0';
--		when WRITE_TO_FB =>
--			fb_dina(44 downto 21) <= pixel_req.color;
--			fb_dina(20 downto 5) <= pixel_req.depth;
--			fb_addra <= std_logic_vector(pixel_req.position.coord_X(9 downto 0));
--			fb_we(to_integer(pixel_req.position.coord_Y)) <= '1';
--			pixel_drawn <= '0';
--			rd <= '0';
--			fbstate := WAIT_FOR_DATA;
	end case;
	
	cur_X := cur_X + 1;
	if cur_X >= SCREEN_WIDTH then
		cur_X := 0;
		cur_Y := cur_Y + 1;
		if cur_Y >= SCREEN_HEIGHT then
			cur_Y := 0;
		end if;
	end if;
	if cur_X = 0 then
		vga_hsync <= '1';
		if cur_Y = 0 then
			vga_vsync <= '1';
		end if;
	else
		vga_vsync <= '0';
		vga_hsync <= '0';
	end if;
	
	draw_color_reg := fb_doutb(prev_mod)(39 downto 16);
	fb_addrb <= std_logic_vector(to_unsigned(cur_Y,10)(7 downto 0))&std_logic_vector(to_unsigned(cur_X+1,13)(1 downto 0));
	prev_mod := to_integer(to_unsigned(cur_X,13)(12 downto 2));
	
	vga_r <= draw_color_reg(23 downto 16);
	vga_g <= draw_color_reg(15 downto 8);
	vga_b <= draw_color_reg(7 downto 0);
end if;
end process;

end Behavioral;
