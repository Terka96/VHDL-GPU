----------------------------------------------------------------------------------
-- FLOATING POINT UNIT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.definitions.all;

entity fpu is
	port(
			clk : in std_logic; --system clock
			fpu_operation_data : in operation;
			fpu_a_data : in FLOAT16;
			fpu_b_data : in FLOAT16;
			fpu_res_data : out FLOAT16;
			fpu_operation_valid : in std_logic;
			fpu_res_valid : out std_logic
			);
end fpu;

architecture Behavioral of fpu is

signal reg_fpu_operation_data : operation := OP_NOP;

signal fpu_mul_enable : std_logic := '0';
signal fpu_div_enable : std_logic := '0';
signal fpu_add_enable : std_logic := '0';
signal fpu_f2i_enable : std_logic := '0';
signal fpu_i2f_enable : std_logic := '0';

signal fpu_operation_add_data : std_logic_vector (7 downto 0);
signal fpu_operation_cmp_data : std_logic_vector (7 downto 0);

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
  
--"0000" FPU_NOP
--"0001" FPU_MUL
--"0010" FPU_DIV
--"0011" FPU_ADD
--"0100" FPU_SUB
--"0101" lt
--"0110" eq
--"0111" le
--"1000" gt
--"1001" ne
--"1010" ge
--"1011" is NaN?
--"1100" FPU_F2I
--"1101" FPU_I2F
--"1110"
--"1111"


fpu_mul_enable <= fpu_operation_valid when reg_fpu_operation_data = OP_FMUL else '0';
fpu_div_enable <= fpu_operation_valid when reg_fpu_operation_data = OP_FDIV else '0';
fpu_add_enable <= fpu_operation_valid when (reg_fpu_operation_data = OP_FADD or reg_fpu_operation_data = OP_FSUB) else '0';
fpu_f2i_enable <= fpu_operation_valid when reg_fpu_operation_data = OP_FF2I else '0';
fpu_i2f_enable <= fpu_operation_valid when reg_fpu_operation_data = OP_FI2F else '0';
  
fpu_operation_add_data <= "00000000" when reg_fpu_operation_data = OP_FADD else	--add
									"00000001" when reg_fpu_operation_data = OP_FSUB else	--subtract
									"00000000";


fpu_res_data <= fpu_mul_res_data when (reg_fpu_operation_data = OP_FMUL) else
					fpu_div_res_data when (reg_fpu_operation_data = OP_FDIV) else
					fpu_add_res_data when (reg_fpu_operation_data = OP_FADD or reg_fpu_operation_data = OP_FSUB) else
					"0000001111111111" and fpu_f2i_res_data when (reg_fpu_operation_data = OP_FF2I) else
					fpu_i2f_res_data when (reg_fpu_operation_data = OP_FI2F) else
					"XXXXXXXXXXXXXXXX";

fpu_res_valid <= fpu_mul_res_valid when (reg_fpu_operation_data = OP_FMUL) else
					fpu_div_res_valid when (reg_fpu_operation_data = OP_FDIV) else
					fpu_add_res_valid when (reg_fpu_operation_data = OP_FADD or reg_fpu_operation_data = OP_FSUB) else
					fpu_f2i_res_valid when (reg_fpu_operation_data = OP_FF2I) else
					fpu_i2f_res_valid when (reg_fpu_operation_data = OP_FI2F) else
					'X';
					
process (fpu_operation_valid) is
begin
if rising_edge(fpu_operation_valid) then
  reg_fpu_operation_data <= fpu_operation_data;
end if;
end process;
					
end Behavioral;

