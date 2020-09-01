----------------------------------------------------------------------------------
-- GEOMETRY AND SHADING
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
use work.definitions.all;
use work.cube_presets.all;

entity GS is
	port(
			clk : in std_logic; --system clock
			rd : out std_logic; --is idle
			ce : in std_logic;
			data_in : in MOD_TRIANGLE;
			pixel_out : out PIXEL; --data for RT
			data_out_present : out std_logic;
			pixel_read : in std_logic;
			tex_load_en : out std_logic := '0';
			tex_rd : in std_logic;
			tex_coord : out INT_COORDS := ("0000000000","0000000000");
			tex_color : in COLOR24;
			
			fpu_operation_data : out std_logic_vector(3 downto 0);
			fpu_a_data : out FLOAT16;
			fpu_b_data : out FLOAT16;
			fpu_res_data : in FLOAT16;
			fpu_operation_valid : out std_logic := '0';
			fpu_res_valid : in std_logic
			);
end GS;

architecture Behavioral of GS is
begin

process (clk,ce) is
variable state : integer := 0;
variable waiting : std_logic := '0';

variable matrix_pp : TRANSFORM_MATRIX := matrix_pp_const;
variable light_norm_X : FLOAT16 := light_norm_X_const;
variable light_norm_Y : FLOAT16 := light_norm_Y_const;
variable light_norm_Z : FLOAT16 := light_norm_Z_const;

type registers is array (1 to 40) of FLOAT16;
type int_registers is array (1 to 11) of signed(9 downto 0);

variable pixel_data : PIXEL;
variable reg : registers;
variable ireg : int_registers;
variable result_reg : integer range 1 to 40;
variable vert : integer range 1 to 3;
variable jump : integer range 0 to 255;
variable nop : std_logic;
variable szkaler : std_logic_vector(17 downto 0) := "000000000000000000";				--clean uppppppp
begin
jump := 255;
nop := '0';
  -- THIS IS A STATE MACHINE WRITTEN LIKE PROGRAMME WHERE STATE IS A PROGRAM COUNTER
  if rising_edge(clk) and state /= 0 then
    if waiting = '1' then
		fpu_operation_valid <= '0';
      if fpu_res_valid = '1' then
	     reg(result_reg) := fpu_res_data;
	     state := state + 1;
		  waiting := '0';
		end if;
	 else
      case state is
			---------------------------------------------------
			--ProjectPoint
			---------------------------------------------------
--BEGIN GEOMETRY
    		when 1 =>
			  reg(6) := reg(2);
			  fpu_a_data <= matrix_pp(3,0);
			  fpu_b_data <= data_in(vert).geom_X;
			  fpu_operation_data <= "0001";
			  result_reg := 1;
		   when 2 =>
			  fpu_a_data <= matrix_pp(3,1);
			  fpu_b_data <= data_in(vert).geom_Y;
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 3 =>
			  fpu_a_data <= reg(1);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 1;
			when 4 => 
			  fpu_a_data <= matrix_pp(3,2);
			  fpu_b_data <= data_in(vert).geom_Z;
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 5 => 
			  fpu_a_data <= reg(1);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 1;
			when 6 => 
			  fpu_a_data <= matrix_pp(3,3);
			  fpu_b_data <= reg(1);
			  fpu_operation_data <= "0011";
			  result_reg := 31 - vert;
			--reg(31) - W
			when 7 => --Prespective.java line 80 (wyznacz X)
			  fpu_a_data <= matrix_pp(0,0);
			  fpu_b_data <= data_in(vert).geom_X;
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 8 => 
			  fpu_a_data <= matrix_pp(0,1);
			  fpu_b_data <= data_in(vert).geom_Y;
			  fpu_operation_data <= "0001";
			  result_reg := 3;
			when 9 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= reg(3);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 10 => 
			  fpu_a_data <= matrix_pp(0,2);
			  fpu_b_data <= data_in(vert).geom_Z;
			  fpu_operation_data <= "0001";
			  result_reg := 3;
			when 11 => 
			  fpu_a_data <= reg(3);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 12 => 
			  fpu_a_data <= matrix_pp(0,3);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 13 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= reg(31 - vert);
			  fpu_operation_data <= "0010";
			  result_reg := 2;
			when 14 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= HALF_SCREEN_WIDTH_F;		--scale to screen
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 15 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= HALF_SCREEN_WIDTH_F;		--move to center of screen
			  fpu_operation_data <= "0011";
			  result_reg := 28 - vert;
			--reg(31-vert) - W
			--reg(28-vert) - X
			when 16 => --Prespective.java line 81 (wyznacz Y)
			  fpu_a_data <= matrix_pp(1,0);
			  fpu_b_data <= data_in(vert).geom_X;
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 17 => 
			  fpu_a_data <= matrix_pp(1,1);
			  fpu_b_data <= data_in(vert).geom_Y;
			  fpu_operation_data <= "0001";
			  result_reg := 3;
			when 18 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= reg(3);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 19 => 
			  fpu_a_data <= matrix_pp(1,2);
			  fpu_b_data <= data_in(vert).geom_Z;
			  fpu_operation_data <= "0001";
			  result_reg := 3;
			when 20 => 
			  fpu_a_data <= reg(3);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 21 => 
			  fpu_a_data <= matrix_pp(1,3);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 22 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= reg(31-vert);
			  fpu_operation_data <= "0010";
			  result_reg := 2;
			when 23 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= HALF_SCREEN_HEIGHT_F or x"8000";
			  fpu_operation_data <= "0001";
			  result_reg := 2;  
			when 24 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= HALF_SCREEN_HEIGHT_F;
			  fpu_operation_data <= "0011";
			  result_reg := 25-vert;
			when 25 => --Prespective.java line 82 (wyznacz Z)
			  fpu_a_data <= matrix_pp(2,0);
			  fpu_b_data <= data_in(vert).geom_X;
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 26 => 
			  fpu_a_data <= matrix_pp(2,1);
			  fpu_b_data <= data_in(vert).geom_Y;
			  fpu_operation_data <= "0001";
			  result_reg := 3;
			when 27 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= reg(3);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 28 => 
			  fpu_a_data <= matrix_pp(2,2);
			  fpu_b_data <= data_in(vert).geom_Z;
			  fpu_operation_data <= "0001";
			  result_reg := 3;
			when 29 => 
			  fpu_a_data <= reg(3);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 30 => 
			  fpu_a_data <= matrix_pp(2,3);
			  fpu_b_data <= reg(2);
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 31 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= reg(31 - vert);
			  fpu_operation_data <= "0010";
			  result_reg := 22-vert;	--Z
			--przeliczanie oswietlenia
			when 32 =>
				fpu_a_data <= data_in(vert).norm_X;
				fpu_b_data <= x"5bf8";	--255
				fpu_operation_data <= "0001";
				result_reg := 4;
			when 33 =>
				fpu_a_data <= reg(4);
				fpu_b_data <= light_norm_X;
				fpu_operation_data <= "0001";
				result_reg := 4;
			when 34 =>
				fpu_a_data <= data_in(vert).norm_Y;
				fpu_b_data <= x"5bf8";	--255
				fpu_operation_data <= "0001";
				result_reg := 5;
			when 35 =>
				fpu_a_data <= reg(5);
				fpu_b_data <= light_norm_Y;
				fpu_operation_data <= "0001";
				result_reg := 5;
			when 36 =>
				fpu_a_data <= reg(4);
				fpu_b_data <= reg(5);
				fpu_operation_data <= "0011";
				result_reg := 4;
			when 37 =>
				fpu_a_data <= data_in(vert).norm_Z;
				fpu_b_data <= x"5bf8";	--255
				fpu_operation_data <= "0001";
				result_reg := 5;
			when 38 =>
				fpu_a_data <= reg(5);
				fpu_b_data <= light_norm_Z;
				fpu_operation_data <= "0001";
				result_reg := 5;
			when 39 =>
				fpu_a_data <= reg(5);
				fpu_b_data <= reg(4);
				fpu_operation_data <= "0011";
				result_reg := 4;
			when 40 => --loop for vertices in triangle
			if reg(4)(15) = '0' then
				reg(19-vert) := reg(4);
			else
				reg(19-vert) := x"0000";
			end if;
			  case vert is
			    when 1 =>
				   vert := 2;
					jump := BEGIN_GEOMETRY;
				 when 2 =>
				   vert := 3;
					jump := BEGIN_GEOMETRY;
				 when 3 =>
				   vert := 1;
					nop := '1';
			  end case;
			when 41 => --rzutowania x i y do int
				fpu_a_data <= reg(27);
				fpu_operation_data <= "1100";
				result_reg := 1;
			when 42 => --rzutowania x i y do int
				ireg(10) := signed(reg(1)(9 downto 0));
				fpu_a_data <= reg(26);
				fpu_operation_data <= "1100";
				result_reg := 1;
			when 43 => --rzutowania x i y do int
				ireg(9) := signed(reg(1)(9 downto 0));
				fpu_a_data <= reg(25);
				fpu_operation_data <= "1100";
				result_reg := 1;
			when 44 => --rzutowania x i y do int
				ireg(8) := signed(reg(1)(9 downto 0));
				fpu_a_data <= reg(24);
				fpu_operation_data <= "1100";
				result_reg := 1;
			when 45 => --rzutowania x i y do int
				ireg(7) := signed(reg(1)(9 downto 0));
				fpu_a_data <= reg(23);
				fpu_operation_data <= "1100";
				result_reg := 1;
			when 46 => --rzutowania x i y do int
				ireg(6) := signed(reg(1)(9 downto 0));
				fpu_a_data <= reg(22);
				fpu_operation_data <= "1100";
				result_reg := 1;
			when 47 => --parametry dzielenie przez w
				ireg(5) := signed(reg(1)(9 downto 0));
				fpu_a_data <= reg(21);
				fpu_b_data <= reg(30);
				fpu_operation_data <= "0010";
				result_reg := 21;
			when 48 => --parametry dzielenie przez w
				fpu_a_data <= reg(20);
				fpu_b_data <= reg(29);
				fpu_operation_data <= "0010";
				result_reg := 20;	
			when 49 => --parametry dzielenie przez w
				fpu_a_data <= reg(19);
				fpu_b_data <= reg(28);
				fpu_operation_data <= "0010";
				result_reg := 19;
			when 50 => --parametry dzielenie przez w
				fpu_a_data <= reg(18);
				fpu_b_data <= reg(30);
				fpu_operation_data <= "0010";
				result_reg := 18;
			when 51 => --parametry dzielenie przez w
				fpu_a_data <= reg(17);
				fpu_b_data <= reg(29);
				fpu_operation_data <= "0010";
				result_reg := 17;
			when 52 => --parametry dzielenie przez w
				fpu_a_data <= reg(16);
				fpu_b_data <= reg(28);
				fpu_operation_data <= "0010";
				result_reg := 16;
			when 53 => --parametry dzielenie przez w
				fpu_a_data <= data_in(1).tex_U;
				fpu_b_data <= reg(30);
				fpu_operation_data <= "0010";
				result_reg := 15;
			when 54 => --parametry dzielenie przez w
				fpu_a_data <= data_in(2).tex_U;
				fpu_b_data <= reg(29);
				fpu_operation_data <= "0010";
				result_reg := 14;
			when 55 => --parametry dzielenie przez w
				fpu_a_data <= data_in(3).tex_U;
				fpu_b_data <= reg(28);
				fpu_operation_data <= "0010";
				result_reg := 13;
			when 56 => --parametry dzielenie przez w
				fpu_a_data <= data_in(1).tex_V;
				fpu_b_data <= reg(30);
				fpu_operation_data <= "0010";
				result_reg := 12;
			when 57 => --parametry dzielenie przez w
				fpu_a_data <= data_in(2).tex_V;
				fpu_b_data <= reg(29);
				fpu_operation_data <= "0010";
				result_reg := 11;
			when 58 => --parametry dzielenie przez w
				fpu_a_data <= data_in(3).tex_V;
				fpu_b_data <= reg(28);
				fpu_operation_data <= "0010";
				result_reg := 10;
			when 59 => --odwrotności w
				fpu_a_data <= x"3c00";
				fpu_b_data <= reg(30);
				fpu_operation_data <= "0010";
				result_reg := 30;
			when 60 => --odwrotności w
				fpu_a_data <= x"3c00";
				fpu_b_data <= reg(29);
				fpu_operation_data <= "0010";
				result_reg := 29;
			when 61 => --odwrotności w
				fpu_a_data <= x"3c00";
				fpu_b_data <= reg(28);
				fpu_operation_data <= "0010";
				result_reg := 28;
			when 62 => --max i min x i y
				-- minX
				if ireg(10) < ireg(9) then
					ireg(4) := ireg(10);
				else
					ireg(4) := ireg(9);
				end if;
				if ireg(8) < ireg(4) then
					ireg(4) := ireg(8);
				end if;
				-- minY
				if ireg(7) < ireg(6) then
					ireg(3) := ireg(7);
				else
					ireg(3) := ireg(6);
				end if;
				if ireg(5) < ireg(3) then
					ireg(3) := ireg(5);
				end if;
				ireg(11) := ireg(4);
				nop := '1';
			when 63 => --max i min x i y
				-- maxX
				if ireg(10) > ireg(9) then
					ireg(2) := ireg(10);
				else
					ireg(2) := ireg(9);
				end if;
				if ireg(8) > ireg(2) then
					ireg(2) := ireg(8);
				end if;
				-- maxY
				if ireg(7) > ireg(6) then
					ireg(1) := ireg(7);
				else
					ireg(1) := ireg(6);
				end if;
				if ireg(5) > ireg(1) then
					ireg(1) := ireg(5);
				end if;
				nop := '1';
			when 64 => --area
				fpu_a_data <= reg(25);
				fpu_b_data <= reg(27);
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 65 => --area
				fpu_a_data <= reg(23);
				fpu_b_data <= reg(24);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 66 => --area
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 67 => --area
				fpu_a_data <= reg(22);
				fpu_b_data <= reg(24);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 68 => --area
				fpu_a_data <= reg(26);
				fpu_b_data <= reg(27);
				fpu_operation_data <= "0100";
				result_reg := 3;
			when 69 => --area
				fpu_a_data <= reg(2);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 70 => --area
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0100";
				result_reg := 31;
--BEGIN FORY
			when 71 => --double for
				if ireg(3) > ireg(1) then
					jump := END_PROGRAMME;
				else
					nop := '1';
				end if;
--BEGIN FORX
			when 72 => --double for
				if ireg(4) > ireg(2) then
					jump := CONTINUE_FORY;
				else
					nop := '1';
				end if;
			when 73 =>
				if ireg(3) > SCREEN_HEIGHT or ireg(3) < 1 or ireg(4) > SCREEN_WIDTH or ireg(4) < 1 then
					jump := END_PROGRAMME;
				else
					nop := '1';
				end if;
			when 74 => --iterX
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(4));
				fpu_operation_data <= "1101";
				result_reg := 9;
			when 75 => --iterY
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(3));
				fpu_operation_data <= "1101";
				result_reg := 8;
			when 76 => --w0
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(26);
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 77 => --w0
				fpu_a_data <= reg(22);
				fpu_b_data <= reg(23);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 78 => --w0
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 79 => --w0
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(23);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 80 => --w0
				fpu_a_data <= reg(25);
				fpu_b_data <= reg(26);
				fpu_operation_data <= "0100";
				result_reg := 3;
			when 81 => --w0
				fpu_a_data <= reg(2);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 82 => --w0
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0100";
				result_reg := 32;
			when 83 => --if w0-2 >= 0
				if reg(32)(15) = '1' then -- n < 0
					jump := CONTINUE_FORX;
				else
					nop := '1';
				end if;
			when 84 => --w1
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(25);
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 85 => --w1
				fpu_a_data <= reg(24);
				fpu_b_data <= reg(22);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 86 => --w1
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 87 => --w1
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(22);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 88 => --w1
				fpu_a_data <= reg(27);
				fpu_b_data <= reg(25);
				fpu_operation_data <= "0100";
				result_reg := 3;
			when 89 => --w1
				fpu_a_data <= reg(2);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 90 => --w1
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0100";
				result_reg := 33;
			when 91 => --if w0-2 >= 0
				if reg(33)(15) = '1' then -- n < 0
					jump := CONTINUE_FORX;
				else
					nop := '1';
				end if;
			when 92 => --w2
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(27);
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 93 => --w2
				fpu_a_data <= reg(23);
				fpu_b_data <= reg(24);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 94 => --w2
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 95 => --w2
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(24);
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 96 => --w2
				fpu_a_data <= reg(26);
				fpu_b_data <= reg(27);
				fpu_operation_data <= "0100";
				result_reg := 3;
			when 97 => --w2
				fpu_a_data <= reg(2);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 98 => --w2
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0100";
				result_reg := 34;
			when 99 => --if w0-2 >= 0
				if reg(34)(15) = '1' then -- n < 0
					jump := CONTINUE_FORX;
				else
					nop := '1';
				end if;
			when 100 => --w0-2 normalizacja
				fpu_a_data <= reg(32);
				fpu_b_data <= reg(31);
				fpu_operation_data <= "0010";
				result_reg := 32;
			when 101 => --w0-2 normalizacja
				fpu_a_data <= reg(33);
				fpu_b_data <= reg(31);
				fpu_operation_data <= "0010";
				result_reg := 33;
			when 102 => --w0-2 normalizacja
				fpu_a_data <= reg(34);
				fpu_b_data <= reg(31);
				fpu_operation_data <= "0010";
				result_reg := 34;
			when 103 => --interpolacja W
				fpu_a_data <= reg(32);
				fpu_b_data <= reg(30);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 104 => --interpolacja W
				fpu_a_data <= reg(33);
				fpu_b_data <= reg(29);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 105 => --interpolacja W
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;
			when 106 => --interpolacja W
				fpu_a_data <= reg(34);
				fpu_b_data <= reg(28);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 107 => --interpolacja W
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;	
			when 108 => --interpolacja W
				fpu_a_data <= x"3c00";
				fpu_b_data <= reg(1);
				fpu_operation_data <= "0010";
				result_reg := 35;
			when 109 => --interpolacja TU
				fpu_a_data <= reg(32);
				fpu_b_data <= reg(15);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 110 => --interpolacja TU
				fpu_a_data <= reg(33);
				fpu_b_data <= reg(14);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 111 => --interpolacja TU
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;
			when 112 => --interpolacja TU
				fpu_a_data <= reg(34);
				fpu_b_data <= reg(13);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 113 => --interpolacja TU
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;	
			when 114 => --interpolacja TU
				fpu_a_data <= reg(35);
				fpu_b_data <= reg(1);
				fpu_operation_data <= "0001";
				result_reg := 36;
			when 115 => --interpolacja TV
				fpu_a_data <= reg(32);
				fpu_b_data <= reg(12);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 116 => --interpolacja TV
				fpu_a_data <= reg(33);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 117 => --interpolacja TV
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;
			when 118 => --interpolacja TV
				fpu_a_data <= reg(34);
				fpu_b_data <= reg(10);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 119 => --interpolacja TV
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;	
			when 120 => --interpolacja TV
				fpu_a_data <= reg(35);
				fpu_b_data <= reg(1);
				fpu_operation_data <= "0001";
				result_reg := 37;
			when 121 => --interpolacja L
				fpu_a_data <= reg(32);
				fpu_b_data <= reg(18);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 122 => --interpolacja L
				fpu_a_data <= reg(33);
				fpu_b_data <= reg(17);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 123 => --interpolacja L
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;
			when 124 => --interpolacja L
				fpu_a_data <= reg(34);
				fpu_b_data <= reg(16);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 125 => --interpolacja L
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;	
			when 126 => --interpolacja L
				fpu_a_data <= reg(35);
				fpu_b_data <= reg(1);
				fpu_operation_data <= "0001";
				result_reg := 38;
			when 127 => --interpolacja Z
				fpu_a_data <= reg(32);
				fpu_b_data <= reg(21);
				fpu_operation_data <= "0001";
				result_reg := 1;
			when 128 => --interpolacja Z
				fpu_a_data <= reg(33);
				fpu_b_data <= reg(20);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 129 => --interpolacja Z
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;
			when 130 => --interpolacja Z
				fpu_a_data <= reg(34);
				fpu_b_data <= reg(19);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 131 => --interpolacja Z
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0011";
				result_reg := 1;	
			when 132 => --interpolacja Z
				fpu_a_data <= reg(35);	
				fpu_b_data <= reg(1);
				fpu_operation_data <= "0001";
				result_reg := 39;
			when 133 => --scale from U to S
				fpu_a_data <= reg(36);	
				fpu_b_data <= TEX_SIZE_F;
				fpu_operation_data <= "0001";
				result_reg := 36;
			when 134 => --scale from V to T
				fpu_a_data <= reg(37);	
				fpu_b_data <= TEX_SIZE_F;
				fpu_operation_data <= "0001";
				result_reg := 37;
			when 135 => --f2i TU
				fpu_a_data <= reg(36);	
				fpu_operation_data <= "1100";
				result_reg := 36;
			when 136 => --f2i TV
				fpu_a_data <= reg(37);	
				fpu_operation_data <= "1100";
				result_reg := 37;
			when 137 => --f2i L
				fpu_a_data <= reg(38);	
				fpu_operation_data <= "1100";
				result_reg := 38;
--WAIT FOR TEXEL
			when 138 =>
				tex_coord.coord_X <= signed("0000011111" and reg(36)(9 downto 0));	--TAKE ONLY FIRST 5 BIT (FASTER MODULO 64)
				tex_coord.coord_Y <= signed("0000011111" and reg(37)(9 downto 0));	--TAKE ONLY FIRST 5 BIT (FASTER MODULO 64)
				tex_load_en <='1';		-- powinien byc jedynka przez jeden cykl!
				if tex_rd = '1' then
					tex_load_en <='0';
					pixel_data.color := tex_color;
					nop := '1';
				else 
					jump := WAIT_FOR_TEXEL;
				end if;
			when 139 =>	--rysowanie pixela
				pixel_data.position.coord_X := ireg(4);
				pixel_data.position.coord_Y := ireg(3);
				pixel_data.depth := reg(39);
				szkaler := std_logic_vector(unsigned(pixel_data.color(23 downto 16)) * unsigned(reg(38)(9 downto 0)));
				pixel_data.color(23 downto 16) := szkaler(15 downto 8);		--modulo 256
				szkaler := std_logic_vector(unsigned(pixel_data.color(15 downto 8)) * unsigned(reg(38)(9 downto 0)));
				pixel_data.color(15 downto 8) := szkaler(15 downto 8);		--modulo 256
				szkaler := std_logic_vector(unsigned(pixel_data.color(7 downto 0)) * unsigned(reg(38)(9 downto 0)));
				pixel_data.color(7 downto 0) := szkaler(15 downto 8);		--modulo 256
				nop := '1';
--WAIT FOR DATA POLL
			when 140 =>
				if pixel_read = '1' then
					data_out_present <= '0';
					nop := '1';
				else
					pixel_out <= pixel_data;
					data_out_present <= '1';
					jump := WAIT_FOR_DATA_POLL;
				end if;
--CONTINUE FORX
			when 141 =>
				ireg(4):= ireg(4) + 1;
				jump := BEGIN_FORX;
--CONTINUE FORY
			when 142 =>
				ireg(4) := ireg(11);
				ireg(3) := ireg(3) + 1;
				jump := BEGIN_FORY;
--END PROGRAMME
			when 143 =>
				jump := 0;
			when others =>
	   end case;
		if jump /= 255 then
			state := jump;
		else
			if nop = '1' then
				fpu_operation_data <= "0000";
				state := state + 1;
			else
				fpu_operation_valid <= '1';
				waiting := '1';
			end if;
		end if;
	 end if;
  end if;
  
	if state = 0 then --waiting for data
		if ce = '1' then
			state := 1;
			rd <= '0';
		else
			rd <= '1';
		end if;
	else
		rd <= '0';
	end if;
end process;

end Behavioral;

