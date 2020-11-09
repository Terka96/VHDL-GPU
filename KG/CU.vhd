----------------------------------------------------------------------------------
-- COMPUTE UNIT
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
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
use work.model_presets.all;
use work.texture.all;
use IEEE.NUMERIC_STD.ALL;

entity CU is
	port(
		clk : in std_logic;
		mod_triangle_in : in MOD_TRIANGLE;
		rd : out std_logic := '1';
		ce : in std_logic;
		pixel_out : out PIXEL;
		pixel_out_rd : out std_logic := '0';
		pixel_read : in std_logic;
		tex_load_en : out std_logic;
		tex_rd : in std_logic;
		tex_coord : out INT_COORDS;
		tex_color : in COLOR24;
		operation_number : out integer := 0;
		instruction_number : out integer := 1
	);
end CU;

architecture Behavioral of CU is

signal reg_fpu_operation_data : operation := OP_NOP;

signal fpu_mul_enable : std_logic := '0';
signal fpu_div_enable : std_logic := '0';
signal fpu_add_enable : std_logic := '0';
signal fpu_f2i_enable : std_logic := '0';
signal fpu_i2f_enable : std_logic := '0';

signal fpu_operation_add_data : std_logic_vector (7 downto 0);
signal fpu_operation_cmp_data : std_logic_vector (7 downto 0);

signal fpu_a_data : FLOAT16;
signal fpu_b_data : FLOAT16;

signal fpu_mul_res_data : FLOAT16;
signal fpu_div_res_data : FLOAT16;
signal fpu_add_res_data : FLOAT16;
signal fpu_f2i_res_data : FLOAT16;
signal fpu_i2f_res_data : FLOAT16;

signal fpu_mul_res_valid : std_logic;
signal fpu_div_res_valid : std_logic;
signal fpu_add_res_valid : std_logic;
signal fpu_f2i_res_valid : std_logic;
signal fpu_i2f_res_valid : std_logic;


COMPONENT fpu_mul --FPU_MUL
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fpu_add --FPU_ADD FPU_SUB
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 s_axis_operation_tvalid : IN STD_LOGIC;
    s_axis_operation_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fpu_div --FPU_DIV
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fpu_f2i --FPU_F2I
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fpu_i2f --FPU_I2F
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

type registers is array (1 to 128) of FLOAT16;

begin

fpu_mul_entity : fpu_mul PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_mul_enable,
    s_axis_a_tdata => fpu_a_data,
    s_axis_b_tvalid => fpu_mul_enable,
    s_axis_b_tdata => fpu_b_data,
    m_axis_result_tvalid => fpu_mul_res_valid,
    m_axis_result_tdata => fpu_mul_res_data
  );
  
fpu_div_entity : fpu_div PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_div_enable,
    s_axis_a_tdata => fpu_a_data,
    s_axis_b_tvalid => fpu_div_enable,
    s_axis_b_tdata => fpu_b_data,
    m_axis_result_tvalid => fpu_div_res_valid,
    m_axis_result_tdata => fpu_div_res_data
  );
  
fpu_add_entity : fpu_add PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_add_enable,
    s_axis_a_tdata => fpu_a_data,
    s_axis_b_tvalid => fpu_add_enable,
    s_axis_b_tdata => fpu_b_data,
	 s_axis_operation_tvalid => fpu_add_enable,
    s_axis_operation_tdata => fpu_operation_add_data,
    m_axis_result_tvalid => fpu_add_res_valid,
    m_axis_result_tdata => fpu_add_res_data
  );
  
fpu_f2i_entity : fpu_f2i PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_f2i_enable,
    s_axis_a_tdata => fpu_a_data,
    m_axis_result_tvalid => fpu_f2i_res_valid,
    m_axis_result_tdata => fpu_f2i_res_data
  );
  
fpu_i2f_entity : fpu_i2f PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_i2f_enable,
    s_axis_a_tdata => fpu_a_data,
    m_axis_result_tvalid => fpu_i2f_res_valid,
    m_axis_result_tdata => fpu_i2f_res_data
  );


process (clk) is
variable pixel_data : PIXEL;
variable texel_data : COLOR24;
variable reg_mod_triangle : MOD_TRIANGLE;
variable reg : registers := (
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------",matrix_pp_const(0,0),
matrix_pp_const(0,1),matrix_pp_const(0,2),matrix_pp_const(0,3),matrix_pp_const(1,0),
matrix_pp_const(1,1),matrix_pp_const(1,2),matrix_pp_const(1,3),matrix_pp_const(2,0),
matrix_pp_const(2,1),matrix_pp_const(2,2),matrix_pp_const(2,3),matrix_pp_const(3,0),
matrix_pp_const(3,1),matrix_pp_const(3,2),matrix_pp_const(3,3),HALF_SCREEN_WIDTH_F,
HALF_SCREEN_HEIGHT_F,x"bc00",x"5bf8",light_norm_x_const,
light_norm_y_const,light_norm_z_const,x"3c00",std_logic_vector(to_signed(SCREEN_WIDTH,16)),
std_logic_vector(to_signed(SCREEN_HEIGHT,16)),TEX_SIZE_F,"0000000000000000","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------",
"----------------","----------------","----------------","----------------"
);

variable pc : integer := 1;
variable jump : integer;
variable instr : instruction;
variable szkalerR,szkalerG,szkalerB : std_logic_vector(17 downto 0) := "000000000000000000";				--clean uppppppp
variable fpu_data_rd : std_logic := '0';
begin
if rising_edge(clk) then
jump := 1024;
instr := cu_programme(pc);
	case instr.op is
		when OP_NOP =>	--no operation
		when OP_FMUL =>	--multiply float
			fpu_a_data <= reg(instr.regA);
			fpu_b_data <= reg(instr.regB);
			if fpu_data_rd = '0' then
				fpu_data_rd := '1';
				fpu_mul_enable <= '1';
			else
				fpu_mul_enable <= '0';
			end if;
			if fpu_mul_res_valid = '1' then
				reg(instr.JWB) := fpu_mul_res_data;
				fpu_data_rd := '0';
			else
				jump := pc;
			end if;
		when OP_FDIV =>	--divide float
			fpu_a_data <= reg(instr.regA);
			fpu_b_data <= reg(instr.regB);
			if fpu_data_rd = '0' then
				fpu_data_rd := '1';
				fpu_div_enable <= '1';
			else
				fpu_div_enable <= '0';
			end if;
			if fpu_div_res_valid = '1' then
				reg(instr.JWB) := fpu_div_res_data;
				fpu_data_rd := '0';
			else
				jump := pc;
			end if;
		when OP_FADD =>	--addition float
			fpu_a_data <= reg(instr.regA);
			fpu_b_data <= reg(instr.regB);
			fpu_operation_add_data <= "00000000";
			if fpu_data_rd = '0' then
				fpu_data_rd := '1';
				fpu_add_enable <= '1';
			else
				fpu_add_enable <= '0';
			end if;
			if fpu_add_res_valid = '1' then
				reg(instr.JWB) := fpu_add_res_data;
				fpu_data_rd := '0';
			else
				jump := pc;
			end if;
		when OP_FSUB =>	--substract float
			fpu_a_data <= reg(instr.regA);
			fpu_b_data <= reg(instr.regB);
			fpu_operation_add_data <= "00000001";
			if fpu_data_rd = '0' then
				fpu_data_rd := '1';
				fpu_add_enable <= '1';
			else
				fpu_add_enable <= '0';
			end if;
			if fpu_add_res_valid = '1' then
				reg(instr.JWB) := fpu_add_res_data;
				fpu_data_rd := '0';
			else
				jump := pc;
			end if;
		when OP_FF2I =>	--cast float to int
			fpu_a_data <= reg(instr.regA);
			if fpu_data_rd = '0' then
				fpu_data_rd := '1';
				fpu_f2i_enable <= '1';
			else
				fpu_f2i_enable <= '0';
			end if;
			if fpu_f2i_res_valid = '1' then
				reg(instr.JWB) := fpu_f2i_res_data;
				fpu_data_rd := '0';
			else
				jump := pc;
			end if;
		when OP_FI2F =>	--cast int to float
			fpu_a_data <= reg(instr.regA);
			if fpu_data_rd = '0' then
				fpu_data_rd := '1';
				fpu_i2f_enable <= '1';
			else
				fpu_i2f_enable <= '0';
			end if;
			if fpu_i2f_res_valid = '1' then
				reg(instr.JWB) := fpu_i2f_res_data;
				fpu_data_rd := '0';
			else
				jump := pc;
			end if;
		when OP_FMAX0 =>--max ( regA, 0 ) float
			if reg(instr.regA)(15) = '1' then
				reg(instr.JWB) := x"0000";
			else
				reg(instr.JWB) := reg(instr.regA);
			end if;
		when OP_FJLT0 =>--jump less than 0 float
			if reg(instr.regA)(15) = '1' then
				jump := instr.JWB;
			end if;
		when OP_MIN =>	--min int
			if signed(reg(instr.regA)(12 downto 0)) < signed(reg(instr.regB)(12 downto 0)) then
				reg(instr.JWB) := reg(instr.regA);
			else
				reg(instr.JWB) := reg(instr.regB);
			end if;
		when OP_MAX =>	--max int
			if signed(reg(instr.regA)(12 downto 0)) > signed(reg(instr.regB)(12 downto 0)) then
				reg(instr.JWB) := reg(instr.regA);
			else
				reg(instr.JWB) := reg(instr.regB);
			end if;
		when OP_JGT =>	--jump if greater than
			if signed(reg(instr.regA)(12 downto 0)) > signed(reg(instr.regB)(12 downto 0)) then
				jump := instr.JWB;
			end if;
		when OP_MOV =>	--move
			reg(instr.JWB) := reg(instr.regA);
		when OP_JUMP =>	--unconditioned jump
			jump := instr.JWB;
		when OP_INC =>	--increment int
			reg(instr.JWB)(12 downto 0) := std_logic_vector(signed(reg(instr.regA)(12 downto 0)) + 1);
		when OP_W4D =>	--wait for data
			if ce = '0' then
				jump := pc;
				rd <= '1';
			else
				rd <= '0';
				reg_mod_triangle := mod_triangle_in;
			end if;
		when OP_LDM =>	--load model to reg
			reg(instr.JWB) := reg_mod_triangle(instr.regA);
		when OP_TEX =>	--load tex
			tex_coord.coord_X <= signed(TEX_MODULO and reg(instr.regB)(12 downto 0));	--TAKE ONLY FIRST 6 BITS (FASTER MODULO 64)
			tex_coord.coord_Y <= signed(TEX_MODULO and reg(instr.regA)(12 downto 0));	--TAKE ONLY FIRST 6 BITS (FASTER MODULO 64)
			if tex_rd = '1' then
				tex_load_en <='0';
				pixel_data.color := tex_color;
			else 
				tex_load_en <='1';
				jump := pc;
			end if;
		when OP_SH =>	--shade texel
			pixel_data.position.coord_X := signed(reg(instr.regA)(12 downto 0));
			pixel_data.position.coord_Y := signed(reg(instr.regB)(12 downto 0));
			pixel_data.depth := reg(39);
			szkalerR := std_logic_vector(unsigned(pixel_data.color(23 downto 16)) * unsigned(reg(38)(9 downto 0)));
			pixel_data.color(23 downto 16) := szkalerR(15 downto 8);		--modulo 256
			szkalerG := std_logic_vector(unsigned(pixel_data.color(15 downto 8)) * unsigned(reg(38)(9 downto 0)));
			pixel_data.color(15 downto 8) := szkalerG(15 downto 8);		--modulo 256
			szkalerB := std_logic_vector(unsigned(pixel_data.color(7 downto 0)) * unsigned(reg(38)(9 downto 0)));
			pixel_data.color(7 downto 0) := szkalerB(15 downto 8);		--modulo 256
		when OP_OUT =>	--set pixel output
			if pixel_read = '1' then
				pixel_out_rd <= '0';
			else
				pixel_out <= pixel_data;
				pixel_out_rd <= '1';
				jump := pc;
			end if;
	end case;
	--program controll
	if jump = 1024 then
		pc := pc + 1;
	else
		pc := jump;
	end if;
	
	case instr.op is
		when OP_W4D => operation_number <= 0;
		when OP_NOP => operation_number <= 1;
		when OP_FMUL => operation_number <= 2;
		when OP_FDIV => operation_number <= 3;
		when OP_FADD => operation_number <= 4;
		when OP_FSUB => operation_number <= 5;
		when OP_FF2I => operation_number <= 6;
		when OP_FI2F => operation_number <= 7;
		when OP_FJLT0 => operation_number <= 8;
		when OP_FMAX0 => operation_number <= 9;
		when OP_MIN => operation_number <= 10;
		when OP_MAX => operation_number <= 11;
		when OP_INC => operation_number <= 12;
		when OP_JGT => operation_number <= 13;
		when OP_MOV => operation_number <= 14;
		when OP_TEX => operation_number <= 15;
		when OP_SH => operation_number <= 16;
		when OP_OUT => operation_number <= 17;
		when OP_JUMP => operation_number <= 18;
		when OP_LDM => operation_number <= 19;
		when others => operation_number <= 20;
	end case;
	instruction_number <= pc;
end if;
end process;
					
end Behavioral;

