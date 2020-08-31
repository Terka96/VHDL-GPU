----------------------------------------------------------------------------------
-- GEOMETRY AND SHADING
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
--use IEEE.NUMERIC_STD.ALL;

entity GS is
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
			fpu_operation_valid : out std_logic := '0';
			fpu_res_valid : in std_logic
			);
end GS;

architecture Behavioral of GS is
begin

process (clk,ce) is
variable state : integer := 0;
variable waiting : std_logic := '0';
variable light_norm_X : FLOAT16 := x"3565";
variable light_norm_Y : FLOAT16 := x"34c3";
variable light_norm_Z : FLOAT16 := x"bb24";

--variable light_norm_X : FLOAT16 := x"386c";
--variable light_norm_Y : FLOAT16 := x"2d4e";
--variable light_norm_Z : FLOAT16 := x"3aa2";

variable matrix_w2c : TRANSFORM_MATRIX := (
(x"3c00",x"0000",x"0000",x"8000"),
(x"0000",x"3c00",x"0000",x"b800"),
(x"8000",x"0000",x"3c00",x"bc00"),
(x"0000",x"0000",x"0000",x"3c00")
);

--side
variable matrix_pp : TRANSFORM_MATRIX := (
(x"43d4",x"0000",x"4046",x"c795"),
(x"0000",x"4538",x"0000",x"c7d5"),
(x"b827",x"0000",x"3b9b",x"43c0"),
(x"bffd",x"0000",x"4350",x"4cb0")
);

--side upper cut cube <-1,1>
--variable matrix_pp : TRANSFORM_MATRIX := (
--(x"3e14",x"0000",x"baa4",x"bc64"),
--(x"0000",x"3eed",x"0000",x"c532"),
--(x"b7af",x"0000",x"bb08",x"47f5"),
--(x"b7ab",x"0000",x"bb05",x"4812")
--);

--cup
--variable matrix_pp : TRANSFORM_MATRIX := (
--(x"48b7",x"0000",x"c674",x"37e9"),
--(x"0000",x"49b7",x"0000",x"c2db"),
--(x"b886",x"0000",x"ba9d",x"43f4"),
--(x"b884",x"0000",x"ba9a",x"442b")
--);

--front
--variable matrix_pp : TRANSFORM_MATRIX := (
--(x"417e",x"0000",x"0000",x"0000"),
--(x"0000",x"417e",x"0000",x"0000"),
--(x"0000",x"0000",x"bc02",x"439d"),
--(x"0000",x"0000",x"bc00",x"4400")
--);


variable reg_proj_triangle : PROJ_TRIANGLE;
type registers is array (1 to 6) of FLOAT16;
variable reg : registers;
variable result_reg : integer range 1 to 6;
variable vert : integer range 1 to 3;
variable jump : integer range 0 to 255;
begin
jump := 255;
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
    		when 1 => -- Perspective.java: line 85
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
			  result_reg := 1;
			--reg(1) - W
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
			  fpu_b_data <= reg(1);
			  fpu_operation_data <= "0010";
			  result_reg := 2;
			when 14 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= SCREEN_WIDTH_F;		--scale to screen
			  fpu_operation_data <= "0001";
			  result_reg := 2;
			when 15 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= SCREEN_WIDTH_F;		--move to center of screen
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			--reg(1) - W
			--reg(2) - X
			when 16 => --Prespective.java line 81 (wyznacz Y)
			  reg_proj_triangle(vert).screen_X := reg(2);
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
			  fpu_b_data <= reg(1);
			  fpu_operation_data <= "0010";
			  result_reg := 2;
			when 23 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= SCREEN_HEIGHT_F or x"8000";
			  fpu_operation_data <= "0001";
			  result_reg := 2;  
			when 24 => 
			  fpu_a_data <= reg(2);
			  fpu_b_data <= SCREEN_HEIGHT_F;
			  fpu_operation_data <= "0011";
			  result_reg := 2;
			when 25 => --Prespective.java line 82 (wyznacz Z)
			reg_proj_triangle(vert).screen_Y := reg(2);
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
			  fpu_b_data <= reg(1);
			  fpu_operation_data <= "0010";
			  result_reg := 2;
			--przeliczanie oświetlenia
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
			reg_proj_triangle(vert).depth := reg(2);
			if reg(4)(15) = '0' then
				reg_proj_triangle(vert).light_L := reg(4);
			else
				reg_proj_triangle(vert).light_L := x"0000";
			end if;
			reg_proj_triangle(vert).tex_U := data_in(vert).tex_U;
			reg_proj_triangle(vert).tex_V := data_in(vert).tex_V;
			  case vert is
			    when 1 =>
				   vert := 2;
					jump := 1;
				 when 2 =>
				   vert := 3;
					jump := 1;
				 when 3 =>
				   vert := 1;
					jump := 0;
					rt_ce <= '1';
			  end case;
			when others =>
	   end case;
		if jump /= 255 then
			state := jump;
		else
			fpu_operation_valid <= '1';
			waiting := '1';
		end if;
		data_out <= reg_proj_triangle;
	 end if;
  end if;
  
  if state = 0 then --waiting for data
    if ce = '1' then
	   state := 1;
		rd <= '0';
	 else
	   rd <= rt_rd;
	 end if;
	 if jump /= 0 then
		rt_ce <= '0';
	 end if;
	 fpu_operation_data <= "ZZZZ";
	 fpu_a_data <= "ZZZZZZZZZZZZZZZZ";
	 fpu_b_data <= "ZZZZZZZZZZZZZZZZ";
  else
	 rd <= '0';
  end if;
end process;

end Behavioral;

