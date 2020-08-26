----------------------------------------------------------------------------------
-- RASTERIZATION AND TEXTURING
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;
--use IEEE.NUMERIC_STD.ALL;

entity RT is
	port(
			clk : in std_logic; --system clock
			rd : out std_logic := '1'; --is idle
			ce : in std_logic;
			data_in : in PROJ_TRIANGLE;
			pixel_out : out PIXEL; --data for RT
			data_out_present : out std_logic;
			pixel_read : in std_logic;
			tex_rd : in std_logic;
			tex_coord_x : out TEX_ADDRESS := "0000000000";
			tex_coord_y : out TEX_ADDRESS := "0000000000";
			tex_color : in COLOR24;
			
			fpu_operation_data : out std_logic_vector(3 downto 0);
			fpu_a_data : out FLOAT16;
			fpu_b_data : out FLOAT16;
			fpu_res_data : in FLOAT16;
			fpu_operation_valid : out std_logic := '0';
			fpu_res_valid : in std_logic
			);
end RT;

architecture Behavioral of RT is

begin
process (clk,ce) is
variable state : integer := 0;
variable waiting : std_logic := '0';
variable nop : std_logic;

variable pixel_data : PIXEL;
variable reg_proj_triangle : PROJ_TRIANGLE;
type registers is array (1 to 32) of FLOAT16;
type int_registers is array (1 to 10) of signed(9 downto 0);
variable reg : registers;
variable ireg : int_registers;
variable result_reg : integer range 1 to 32;
variable sort_vert_1 : integer range 1 to 3 := 1;
variable sort_vert_2 : integer range 1 to 3 := 2;
variable sort_vert_3 : integer range 1 to 3 := 3;
variable sort_swap : integer range 1 to 3;
variable jump : integer range 0 to 255;
begin
  -- THIS IS A STATE MACHINE WRITTEN LIKE PROGRAMME WHERE STATE IS A PROGRAM COUNTER
  if rising_edge(clk) and state /= 0 then
    jump := 255;
	 nop := '0';
    if waiting = '1' then
		fpu_operation_valid <= '0';
      if fpu_res_valid = '1' then
	     reg(result_reg) := fpu_res_data;
	     state := state + 1;
		  waiting := '0';
		end if;
	 else
      case state is
			when 1 =>
				fpu_a_data <= data_in(sort_vert_1).screen_Y;
				fpu_operation_data <= "1100";
				result_reg := 29;
			when 2 =>
				fpu_a_data <= data_in(sort_vert_2).screen_Y;
				fpu_operation_data <= "1100";
				result_reg := 27;
			when 3 =>
				fpu_a_data <= data_in(sort_vert_3).screen_Y;
				fpu_operation_data <= "1100";
				result_reg := 25;
			---------------------------------------------------
			--Sort vertices
			---------------------------------------------------
    		when 4 =>
				if reg(25)(9 downto 0) > reg(27)(9 downto 0) then
					sort_swap := sort_vert_3;
					sort_vert_3 := sort_vert_2;
					sort_vert_2 := sort_swap;
					reg(1) := reg(25);
					reg(25) := reg(27);
					reg(27) := reg(1);
				end if;
				nop := '1';
			when 5 =>
				if reg(27)(9 downto 0) > reg(29)(9 downto 0) then
					sort_swap := sort_vert_2;
					sort_vert_2 := sort_vert_1;
					sort_vert_1 := sort_swap;
					reg(1) := reg(27);
					reg(27) := reg(29);
					reg(29) := reg(1);
				end if;
				nop := '1';
			when 6 =>
				if reg(25)(9 downto 0) > reg(27)(9 downto 0) then
					sort_swap := sort_vert_3;
					sort_vert_3 := sort_vert_2;
					sort_vert_2 := sort_swap;
					reg(1) := reg(25);
					reg(25) := reg(27);
					reg(27) := reg(1);
				end if;
				nop := '1';
			when 7 =>
				fpu_a_data <= data_in(sort_vert_1).screen_X;
				fpu_operation_data <= "1100";
				result_reg := 30;
			when 8 =>
				fpu_a_data <= data_in(sort_vert_2).screen_X;
				fpu_operation_data <= "1100";
				result_reg := 28;
			when 9 => --nikogo to nie obchodzi
				fpu_a_data <= data_in(sort_vert_3).screen_X;
				fpu_operation_data <= "1100";
				result_reg := 26;
			---------------------------------------------------
			--Filling
			---------------------------------------------------
			when 10 =>
				if reg(29)(9 downto 0) = reg(25)(9 downto 0) then
					jump := END_PROGRAMME;
				else
					nop := '1';
				end if;
			when 11 =>
				fpu_a_data <= data_in(sort_vert_1).screen_X;
				fpu_b_data <= data_in(sort_vert_3).screen_X;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 12 =>
				fpu_a_data <= data_in(sort_vert_1).screen_Y;
				fpu_b_data <= data_in(sort_vert_3).screen_Y;
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 13 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 24;
			when 14 =>
				fpu_a_data <= data_in(sort_vert_1).depth;
				fpu_b_data <= data_in(sort_vert_3).depth;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 15 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 23;	
			when 16 =>
				fpu_a_data <= data_in(sort_vert_1).light_L;
				fpu_b_data <= data_in(sort_vert_3).light_L;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 17 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 22;	
			when 18 =>
				fpu_a_data <= data_in(sort_vert_1).tex_U;
				fpu_b_data <= data_in(sort_vert_3).tex_U;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 19 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 21;	
			when 20 =>
				fpu_a_data <= data_in(sort_vert_1).tex_V;
				fpu_b_data <= data_in(sort_vert_3).tex_V;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 21 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 20;	
			when 22 =>
				if reg(29)(9 downto 0) = reg(27)(9 downto 0) then
					jump := END_IF2;
				else
					nop := '1';	
				end if;
			when 23 =>
				fpu_a_data <= data_in(sort_vert_1).screen_X;
				fpu_b_data <= data_in(sort_vert_2).screen_X;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 24 =>
				fpu_a_data <= data_in(sort_vert_1).screen_Y;
				fpu_b_data <= data_in(sort_vert_2).screen_Y;
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 25 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 19;
			when 26 =>
				fpu_a_data <= data_in(sort_vert_1).depth;
				fpu_b_data <= data_in(sort_vert_2).depth;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 27 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 18;	
			when 28 =>
				fpu_a_data <= data_in(sort_vert_1).light_L;
				fpu_b_data <= data_in(sort_vert_2).light_L;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 29 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 17;	
			when 30 =>
				fpu_a_data <= data_in(sort_vert_1).tex_U;
				fpu_b_data <= data_in(sort_vert_2).tex_U;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 31 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 16;	
			when 32 =>
				fpu_a_data <= data_in(sort_vert_1).tex_V;
				fpu_b_data <= data_in(sort_vert_2).tex_V;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 33 =>
				ireg(1) := "0000000000";																--i
				ireg(2) := signed(reg(29)(9 downto 0)) - signed(reg(27)(9 downto 0));	--v1y - v2y
				
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 15;	
--BEGIN FOR1
			when 34 =>
				if ireg(1) >= ireg(2) then
					jump := END_IF2;
				else
					ireg(3) := signed(reg(29)(9 downto 0)) - ireg(1);								--line
					
					fpu_a_data(9 downto 0) <= std_logic_vector(ireg(1));
					fpu_operation_data <= "1101";
					result_reg := 1;
				end if;
			when 35 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(19);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 36 =>
				fpu_a_data <= reg(2);
				fpu_operation_data <= "1100";
				result_reg := 2;
			when 37 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(24);
				fpu_operation_data <= "0001";
				result_reg := 3;
			when 38 =>
				fpu_a_data <= reg(3);
				fpu_operation_data <= "1100";
				result_reg := 3;				
			when 39 =>
				ireg(5) := signed(reg(30)(9 downto 0)) - signed(reg(2)(9 downto 0));		--x1 for line
				ireg(6) := signed(reg(30)(9 downto 0)) - signed(reg(3)(9 downto 0));		--x2 for line
				
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(18);
				fpu_operation_data <= "0001";
				result_reg := 2;
			when 40 =>
				fpu_a_data <= data_in(sort_vert_1).depth;
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0100";
				result_reg := 2;	--z1
			when 41 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(23);
				fpu_operation_data <= "0001";
				result_reg := 3;
			when 42 =>
				fpu_a_data <= data_in(sort_vert_1).depth;
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0100";
				result_reg := 3;	--z2
			when 43 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(16);
				fpu_operation_data <= "0001";
				result_reg := 4;
			when 44 =>
				fpu_a_data <= data_in(sort_vert_1).tex_U;
				fpu_b_data <= reg(4);
				fpu_operation_data <= "0100";
				result_reg := 4;	--tu1
			when 45 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(21);
				fpu_operation_data <= "0001";
				result_reg := 5;
			when 46 =>
				fpu_a_data <= data_in(sort_vert_1).tex_U;
				fpu_b_data <= reg(5);
				fpu_operation_data <= "0100";
				result_reg := 5;	--tu2
			when 47 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(15);
				fpu_operation_data <= "0001";
				result_reg := 6;
			when 48 =>
				fpu_a_data <= data_in(sort_vert_1).tex_V;
				fpu_b_data <= reg(6);
				fpu_operation_data <= "0100";
				result_reg := 6;	--tv1
			when 49 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(20);
				fpu_operation_data <= "0001";
				result_reg := 7;
			when 50 =>
				fpu_a_data <= data_in(sort_vert_1).tex_V;
				fpu_b_data <= reg(7);
				fpu_operation_data <= "0100";
				result_reg := 7;	--tv2
			when 51 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(17);
				fpu_operation_data <= "0001";
				result_reg := 8;
			when 52 =>
				fpu_a_data <= data_in(sort_vert_1).light_L;
				fpu_b_data <= reg(8);
				fpu_operation_data <= "0100";
				result_reg := 8;	--ll1
			when 53 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(22);
				fpu_operation_data <= "0001";
				result_reg := 9;
			when 54 =>
				fpu_a_data <= data_in(sort_vert_1).light_L;
				fpu_b_data <= reg(9);
				fpu_operation_data <= "0100";
				result_reg := 9;	--ll2	
			---------------------------------------------------
			--DRAW LINE				free registers ir(7,8,9,10) r(10,11,12,13)
			---------------------------------------------------
			when 55 =>
				ireg(7) := abs(ireg(6) - ireg(5));
				
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(7));
				fpu_operation_data <= "1101";
				result_reg := 11;	--Math.abs(delta.x)
			when 56 =>
				fpu_a_data <= reg(3);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0100";
				result_reg := 3;	--delta z
				reg(13) := reg(2);					--ogarnij!
			when 57 =>
				fpu_a_data <= reg(3);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 3;	--dz
			when 58 =>
				fpu_a_data <= reg(5);
				fpu_b_data <= reg(4);
				fpu_operation_data <= "0100";
				result_reg := 4;	-- delta tu
				reg(31) := reg(4);					--ogarnij!
			when 59 =>
				fpu_a_data <= reg(4);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 4;	--du
			when 60 =>
				fpu_a_data <= reg(7);
				fpu_b_data <= reg(6);
				fpu_operation_data <= "0100";
				result_reg := 5;	-- delta tv
				reg(32) := reg(6);					--ogarnij!
			when 61 =>
				fpu_a_data <= reg(5);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 5;	--dv
			when 62 =>
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(8);
				fpu_operation_data <= "0100";
				result_reg := 6;	-- delta ll
			when 63 =>
				ireg(8) := "0000000000";	--i
				
				fpu_a_data <= reg(6);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 6;	--dl
--BEGIN FORDL1
			when 64 =>
				report "FOR1 i= " & integer'image(to_integer(ireg(1))) & "FORDL1 i= " & integer'image(to_integer(ireg(8)));
				if ireg(8) > ireg(7) then
					jump := CONTINUE_FOR1;
				else
					nop := '1';
				end if;
			when 65 =>
				if ireg(6) >= ireg(5) then
					ireg(9) := ireg(8);
				else
					ireg(9) := -ireg(8);
				end if;
				
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(8));
				fpu_operation_data <= "1101";
				result_reg := 9;
			when 66 =>
				ireg(9) := ireg(5) + ireg(9);								-- screen_X = ireg(9)
				pixel_data.position.coord_X := ireg(9);
				pixel_data.position.coord_Y := ireg(3);				-- screen_Y = ireg(3)
				if ireg(9) < 1 or ireg(9) > SCREEN_WIDTH or ireg(3) < 1 or ireg(3) > SCREEN_HEIGHT then
					jump := CONTINUE_FORDL1;
				else
					nop := '1';
				end if;
			when 67 =>
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(4);
				fpu_operation_data <= "0001";
				result_reg := 7;	-- i * du
			when 68 =>
				fpu_a_data <= reg(7);
				fpu_b_data <= reg(31);
				fpu_operation_data <= "0011";
				result_reg := 7;	-- i * du + tx1u
			when 69 =>
				fpu_a_data <= reg(7);
				fpu_b_data <= TEX_SIZE;
				fpu_operation_data <= "0001";
				result_reg := 7;	
			when 70 =>
				fpu_a_data <= reg(7);
				fpu_operation_data <= "1100";
				result_reg := 7;	-- tex_coord_X
			when 71 =>
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(5);
				fpu_operation_data <= "0001";
				result_reg := 8;	-- i * dv
			when 72 =>
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(32);
				fpu_operation_data <= "0011";
				result_reg := 8;	-- i * dv + tx1v
			when 73 =>
				fpu_a_data <= reg(8);
				fpu_b_data <= TEX_SIZE;
				fpu_operation_data <= "0001";
				result_reg := 8;	-- tex_coord_Y
			when 74 =>
				fpu_a_data <= reg(8);
				fpu_operation_data <= "1100";
				result_reg := 8;	-- tex_coord_Y
---------------------------------------------------------
-- dawaj mi pixel: (reg(7),reg(8))
---------------------------------------------------------
			when 75 =>	--cieniowanie
				fpu_a_data <= reg(9);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0001";
				result_reg := 8;	-- i * dz
				tex_coord_x <= signed("0000011111" and reg(7)(9 downto 0));	--TAKE ONLY FIRST 5 BIT (FASTER MODULO 64)
				tex_coord_y <= signed("0000011111" and reg(8)(9 downto 0));	--TAKE ONLY FIRST 5 BIT (FASTER MODULO 64)
			when 76 =>
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(13);
				fpu_operation_data <= "0011";
				result_reg := 8;	-- i * dz + p1.z						-- screen_depth = reg(8)
			when 77 =>
				pixel_data.depth := reg(8);
				pixel_data.color := tex_color;
				nop := '1';
--WAIT FOR DATA POLL1
			when 78 =>
				if pixel_read = '1' then
					data_out_present <= '0';
					nop := '1';
				else
					data_out_present <= '1';
					pixel_out <= pixel_data;
					jump := WAIT_FOR_DATA_POLL1;
				end if;
--CONTINUE FORDL1
			when 79 =>
				ireg(8):= ireg(8) + 1;	--i++
				jump := BEGIN_FORDL1;
--CONTINUE FOR1
			when 80 =>
				ireg(1) := ireg(1) + 1;
				jump := BEGIN_FOR1;
			---------------------------------------------------
			--LOWER TRIANGLE
			---------------------------------------------------
--END IF2
			when 81 =>
				if reg(27)(9 downto 0) = reg(25)(9 downto 0) then
					jump := END_PROGRAMME;
				else
					nop := '1';
				end if;
			when 82 =>
				fpu_a_data <= data_in(sort_vert_2).screen_X;
				fpu_b_data <= data_in(sort_vert_3).screen_X;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 83 =>
				fpu_a_data <= data_in(sort_vert_2).screen_Y;
				fpu_b_data <= data_in(sort_vert_3).screen_Y;
				fpu_operation_data <= "0100";
				result_reg := 2;
			when 84 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 19;
			when 85 =>
				fpu_a_data <= data_in(sort_vert_2).depth;
				fpu_b_data <= data_in(sort_vert_3).depth;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 86 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 18;	
			when 87 =>
				fpu_a_data <= data_in(sort_vert_2).light_L;
				fpu_b_data <= data_in(sort_vert_3).light_L;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 88 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 17;	
			when 89 =>
				fpu_a_data <= data_in(sort_vert_2).tex_U;
				fpu_b_data <= data_in(sort_vert_3).tex_U;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 90 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 16;	
			when 91 =>
				fpu_a_data <= data_in(sort_vert_2).tex_V;
				fpu_b_data <= data_in(sort_vert_3).tex_V;
				fpu_operation_data <= "0100";
				result_reg := 1;
			when 92 =>
				ireg(1) := "0000000000";																--i
				ireg(2) := signed(reg(27)(9 downto 0)) - signed(reg(25)(9 downto 0));	--v2y - v3y
				
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(2);
				fpu_operation_data <= "0010";
				result_reg := 15;	
--BEGIN FOR2
			when 93 =>
				if ireg(1) >= ireg(2) then
					jump := END_PROGRAMME;
				else
					ireg(3) := signed(reg(27)(9 downto 0)) - ireg(1);								--line
					ireg(4) := ireg(1) + signed(reg(29)(9 downto 0)) - signed(reg(27)(9 downto 0));	--i+Y
					fpu_a_data(9 downto 0) <= std_logic_vector(ireg(1));
					fpu_operation_data <= "1101";
					result_reg := 1;
				end if;
			when 94 =>
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(4));
				fpu_operation_data <= "1101";
				result_reg := 14;
			when 95 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(19);
				fpu_operation_data <= "0001";
				result_reg := 3;
			when 96 =>
				fpu_a_data <= reg(3);
				fpu_operation_data <= "1100";
				result_reg := 3;
			when 97 =>
				fpu_a_data <= reg(14);
				fpu_b_data <= reg(24);
				fpu_operation_data <= "0001";
				result_reg := 4;
			when 98 =>
				fpu_a_data <= reg(4);
				fpu_operation_data <= "1100";
				result_reg := 4;				
			when 99 =>
				ireg(5) := signed(reg(28)(9 downto 0)) - signed(reg(3)(9 downto 0));		--x1 for line
				ireg(6) := signed(reg(30)(9 downto 0)) - signed(reg(4)(9 downto 0));		--x2 for line
				
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(18);
				fpu_operation_data <= "0001";
				result_reg := 3;
			when 100 =>
				fpu_a_data <= data_in(sort_vert_2).depth;
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0100";
				result_reg := 3;	--z1
			when 101 =>
				fpu_a_data <= reg(14);
				fpu_b_data <= reg(23);
				fpu_operation_data <= "0001";
				result_reg := 4;
			when 102 =>
				fpu_a_data <= data_in(sort_vert_1).depth;
				fpu_b_data <= reg(4);
				fpu_operation_data <= "0100";
				result_reg := 4;	--z2
			when 103 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(16);
				fpu_operation_data <= "0001";
				result_reg := 5;
			when 104 =>
				fpu_a_data <= data_in(sort_vert_2).tex_U;
				fpu_b_data <= reg(5);
				fpu_operation_data <= "0100";
				result_reg := 5;	--tu1
			when 105 =>
				fpu_a_data <= reg(14);
				fpu_b_data <= reg(21);
				fpu_operation_data <= "0001";
				result_reg := 6;
			when 106 =>
				fpu_a_data <= data_in(sort_vert_1).tex_U;
				fpu_b_data <= reg(6);
				fpu_operation_data <= "0100";
				result_reg := 6;	--tu2
			when 107 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(15);
				fpu_operation_data <= "0001";
				result_reg := 7;
			when 108 =>
				fpu_a_data <= data_in(sort_vert_2).tex_V;
				fpu_b_data <= reg(7);
				fpu_operation_data <= "0100";
				result_reg := 7;	--tv1
			when 109 =>
				fpu_a_data <= reg(14);
				fpu_b_data <= reg(20);
				fpu_operation_data <= "0001";
				result_reg := 8;
			when 110 =>
				fpu_a_data <= data_in(sort_vert_1).tex_V;
				fpu_b_data <= reg(8);
				fpu_operation_data <= "0100";
				result_reg := 8;	--tv2
			when 111 =>
				fpu_a_data <= reg(1);
				fpu_b_data <= reg(17);
				fpu_operation_data <= "0001";
				result_reg := 9;
			when 112 =>
				fpu_a_data <= data_in(sort_vert_2).light_L;
				fpu_b_data <= reg(9);
				fpu_operation_data <= "0100";
				result_reg := 9;	--ll1
			when 113 =>
				fpu_a_data <= reg(14);
				fpu_b_data <= reg(22);
				fpu_operation_data <= "0001";
				result_reg := 10;
			when 114 =>
				fpu_a_data <= data_in(sort_vert_1).light_L;
				fpu_b_data <= reg(10);
				fpu_operation_data <= "0100";
				result_reg := 10;	--ll2	
			---------------------------------------------------
			--DRAW LINE				free registers ir(7,8,9,10) r(11,12,13)
			---------------------------------------------------
			when 115 =>
				ireg(7) := abs(ireg(6) - ireg(5));
				
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(7));
				fpu_operation_data <= "1101";
				result_reg := 11;	--Math.abs(delta.x)
			when 116 =>
				fpu_a_data <= reg(4);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0100";
				result_reg := 3;	--delta z
				reg(13) := reg(3);					--ogarnij!
			when 117 =>
				fpu_a_data <= reg(3);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 3;	--dz
			when 118 =>
				fpu_a_data <= reg(6);
				fpu_b_data <= reg(5);
				fpu_operation_data <= "0100";
				result_reg := 4;	-- delta tu
				reg(31) := reg(5);					--ogarnij
			when 119 =>
				fpu_a_data <= reg(4);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 4;	--du
			when 120 =>
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(7);
				fpu_operation_data <= "0100";
				result_reg := 5;	-- delta tv
				reg(32) := reg(7);					--ogarnij!
			when 121 =>
				fpu_a_data <= reg(5);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 5;	--dv
			when 122 =>
				fpu_a_data <= reg(10);
				fpu_b_data <= reg(9);
				fpu_operation_data <= "0100";
				result_reg := 6;	-- delta ll
			when 123 =>
				ireg(8) := "0000000000";	--i
				
				fpu_a_data <= reg(6);
				fpu_b_data <= reg(11);
				fpu_operation_data <= "0010";
				result_reg := 6;	--dl
				
--BEGIN FORDL2
			when 124 =>
				report "FOR2 i= " & integer'image(to_integer(ireg(1))) & "FORDL2 i= " & integer'image(to_integer(ireg(8)));
				if ireg(8) > ireg(7) then
					jump := CONTINUE_FOR2;
				else
					nop := '1';
				end if;
			when 125 =>
				if ireg(6) >= ireg(5) then
					ireg(9) := ireg(8);	--dx = 1
				else
					ireg(9) := -ireg(8);	--dx = -1
				end if;
				
				fpu_a_data(9 downto 0) <= std_logic_vector(ireg(8));
				fpu_operation_data <= "1101";
				result_reg := 12;
			when 126 =>
				ireg(9) := ireg(5) + ireg(9);							-- screen_X = ireg(9)
				pixel_data.position.coord_X := ireg(9);
				pixel_data.position.coord_Y := ireg(3);			-- screen_Y = ireg(3)
				if ireg(9) < 1 or ireg(9) > SCREEN_WIDTH or ireg(3) < 1 or ireg(3) > SCREEN_HEIGHT then
					jump := CONTINUE_FORDL2;
				else
					nop := '1';
				end if;
			when 127 =>
				fpu_a_data <= reg(12);
				fpu_b_data <= reg(4);
				fpu_operation_data <= "0001";
				result_reg := 7;	-- i * du
			when 128 =>
				fpu_a_data <= reg(7);
				fpu_b_data <= reg(31); --chyba mam to?!
				fpu_operation_data <= "0011";
				result_reg := 7;	-- i * du + tx1u
			when 129 =>
				fpu_a_data <= reg(7);
				fpu_b_data <= TEX_SIZE;
				fpu_operation_data <= "0001";
				result_reg := 7;	
			when 130 =>
				fpu_a_data <= reg(7);
				fpu_operation_data <= "1100";
				result_reg := 7;	-- tex_coord_X
			when 131 =>
				fpu_a_data <= reg(12);
				fpu_b_data <= reg(5);
				fpu_operation_data <= "0001";
				result_reg := 8;	-- i * dv
			when 132 =>
				fpu_a_data <= reg(8);
				fpu_b_data <= reg(32);	--chyba mam to?!
				fpu_operation_data <= "0011";
				result_reg := 8;	-- i * dv + tx1v
			when 133 =>
				fpu_a_data <= reg(8);
				fpu_b_data <= TEX_SIZE;
				fpu_operation_data <= "0001";
				result_reg := 8;
			when 134 =>
				fpu_a_data <= reg(8);
				fpu_operation_data <= "1100";
				result_reg := 8;	-- tex_coord_Y
---------------------------------------------------------
-- dawaj mi pixel: (reg(7),reg(8))
---------------------------------------------------------
			--faktycznie to trzeba by chyba policzyć dz jako reg(4) - reg(3)

			when 135 =>	--cieniowanie
				fpu_a_data <= reg(12);
				fpu_b_data <= reg(3);
				fpu_operation_data <= "0001";
				result_reg := 9;	-- i * dz
				
				tex_coord_x <= signed("0000011111" and reg(7)(9 downto 0));	--TAKE ONLY FIRST 5 BIT (FASTER MODULO 64)
				tex_coord_y <= signed("0000011111" and reg(8)(9 downto 0));	--TAKE ONLY FIRST 5 BIT (FASTER MODULO 64)
			when 136 =>
				fpu_a_data <= reg(13);	--chyba mam to?!
				fpu_b_data <= reg(9);
				fpu_operation_data <= "0011";
				result_reg := 9;	-- i * dz + p1.z						-- screen_depth = reg(9)
			when 137 =>
				pixel_data.depth := reg(9);
				pixel_data.color := tex_color;							--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! check if rd!
				nop := '1';
--WAIT FOR DATA POLL2
			when 138 =>
				if pixel_read = '1' then
					data_out_present <= '0';
					nop := '1';
				else
					pixel_out <= pixel_data;
					data_out_present <= '1';
					jump := WAIT_FOR_DATA_POLL2;
				end if;
--CONTINUE FORDL2
			when 139 =>
				ireg(8):= ireg(8) + 1;	--i++
				jump := BEGIN_FORDL2;
--CONTINUE FOR2
			when 140 =>
				ireg(1) := ireg(1) + 1;
				jump := BEGIN_FOR2;
--END PROGRAMME
			when 141 =>
				sort_vert_1 := 1;
				sort_vert_2 := 2;
				sort_vert_3 := 3;
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
	 fpu_operation_data <= "ZZZZ";
	 fpu_a_data <= "ZZZZZZZZZZZZZZZZ";
	 fpu_b_data <= "ZZZZZZZZZZZZZZZZ";
  else
	 rd <= '0';
  end if;
end process;

end Behavioral;

