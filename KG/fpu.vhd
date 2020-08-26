----------------------------------------------------------------------------------
-- FLOATING POINT UNIT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.definitions.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpu is
	port(
			clk : in std_logic; --system clock
			fpu_operation_data : in std_logic_vector(3 downto 0);
			fpu_a_data : in FLOAT16;
			fpu_b_data : in FLOAT16;
			fpu_res_data : out FLOAT16;
			fpu_operation_valid : in std_logic;
			fpu_res_valid : out std_logic
			);
end fpu;

architecture Behavioral of fpu is

signal reg_fpu_operation_data : std_logic_vector (3 downto 0) := "0000";

signal fpu_mul_enable : std_logic := '0';
signal fpu_div_enable : std_logic := '0';
signal fpu_add_enable : std_logic := '0';
signal fpu_cmp_enable : std_logic := '0';
signal fpu_f2i_enable : std_logic := '0';
signal fpu_i2f_enable : std_logic := '0';

signal fpu_operation_add_data : std_logic_vector (7 downto 0);
signal fpu_operation_cmp_data : std_logic_vector (7 downto 0);

signal fpu_mul_res_data : FLOAT16;
signal fpu_div_res_data : FLOAT16;
signal fpu_add_res_data : FLOAT16;
signal fpu_cmp_res_data : FLOAT16;
signal fpu_f2i_res_data : FLOAT16;
signal fpu_i2f_res_data : FLOAT16;

signal fpu_mul_res_valid : std_logic;
signal fpu_div_res_valid : std_logic;
signal fpu_add_res_valid : std_logic;
signal fpu_cmp_res_valid : std_logic;
signal fpu_f2i_res_valid : std_logic;
signal fpu_i2f_res_valid : std_logic;


COMPONENT fpu_mul --"0001"
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

COMPONENT fpu_add --"0011" "0100"
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

COMPONENT fpu_div --"0010"
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

COMPONENT fpu_cmp --"0101" "0110" "0111" "1000" "1001" "1010" "1011"
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 s_axis_operation_tvalid : IN STD_LOGIC;
    s_axis_operation_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fpu_f2i --"1100"
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fpu_i2f --"1101"
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
  
fpu_cmp_entity : fpu_cmp PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => fpu_cmp_enable,
    s_axis_a_tdata => fpu_a_data,
    s_axis_b_tvalid => fpu_cmp_enable,
    s_axis_b_tdata => fpu_b_data,
	 s_axis_operation_tvalid => fpu_cmp_enable,
    s_axis_operation_tdata => fpu_operation_cmp_data,
    m_axis_result_tvalid => fpu_cmp_res_valid,
    m_axis_result_tdata => fpu_cmp_res_data(7 downto 0)
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
  
--"0000" NOP
--"0001" mul
--"0010" div
--"0011" add
--"0100" sub
--"0101" lt
--"0110" eq
--"0111" le
--"1000" gt
--"1001" ne
--"1010" ge
--"1011" is NaN?
--"1100" f2i
--"1101" i2f
--"1110"
--"1111"


fpu_mul_enable <= fpu_operation_valid when reg_fpu_operation_data = "0001" else '0';
fpu_div_enable <= fpu_operation_valid when reg_fpu_operation_data = "0010" else '0';
fpu_add_enable <= fpu_operation_valid when (reg_fpu_operation_data = "0011" or reg_fpu_operation_data = "0100") else '0';
fpu_cmp_enable <= fpu_operation_valid when (reg_fpu_operation_data = "0101" or reg_fpu_operation_data = "0110" or reg_fpu_operation_data = "0111" or 
												reg_fpu_operation_data = "1000" or reg_fpu_operation_data = "1001" or reg_fpu_operation_data = "1010" or reg_fpu_operation_data = "1011") else '0';
fpu_f2i_enable <= fpu_operation_valid when reg_fpu_operation_data = "1100" else '0';
fpu_i2f_enable <= fpu_operation_valid when reg_fpu_operation_data = "1101" else '0';
  
fpu_operation_add_data <= "00000000" when reg_fpu_operation_data = "0011" else	--add
									"00000001" when reg_fpu_operation_data = "0100" else	--subtract
									"00000000";

fpu_operation_cmp_data <= "00001100" when reg_fpu_operation_data = "0101" else	--less than
									"00010100" when reg_fpu_operation_data = "0110" else	--equal
									"00011100" when reg_fpu_operation_data = "0111" else	--less than or equal
									"00100100" when reg_fpu_operation_data = "1000" else	--grater than
									"00101100" when reg_fpu_operation_data = "1001" else	--not equal
									"00110100" when reg_fpu_operation_data = "1010" else	--grater than or equal
									"00000100" when reg_fpu_operation_data = "1011" else	--is NaN?
									"00000000";



fpu_res_data <= fpu_mul_res_data when (reg_fpu_operation_data = "0001") else
					fpu_div_res_data when (reg_fpu_operation_data = "0010") else
					fpu_add_res_data when (reg_fpu_operation_data = "0011" or reg_fpu_operation_data = "0100") else
					"0000000011111111" and fpu_cmp_res_data when (reg_fpu_operation_data = "0101" or reg_fpu_operation_data = "0110" or reg_fpu_operation_data = "0111" or 
												reg_fpu_operation_data = "1000" or reg_fpu_operation_data = "1001" or reg_fpu_operation_data = "1010" or reg_fpu_operation_data = "1011") else
					"0000001111111111" and fpu_f2i_res_data when (reg_fpu_operation_data = "1100") else
					fpu_i2f_res_data when (reg_fpu_operation_data = "1101") else
					"XXXXXXXXXXXXXXXX";

fpu_res_valid <= fpu_mul_res_valid when (reg_fpu_operation_data = "0001") else
					fpu_div_res_valid when (reg_fpu_operation_data = "0010") else
					fpu_add_res_valid when (reg_fpu_operation_data = "0011" or reg_fpu_operation_data = "0100") else
					fpu_cmp_res_valid when (reg_fpu_operation_data = "0101" or reg_fpu_operation_data = "0110" or reg_fpu_operation_data = "0111" or 
													reg_fpu_operation_data = "1000" or reg_fpu_operation_data = "1001" or reg_fpu_operation_data = "1010" or reg_fpu_operation_data = "1011") else
					fpu_f2i_res_valid when (reg_fpu_operation_data = "1100") else
					fpu_i2f_res_valid when (reg_fpu_operation_data = "1101") else
					'X';
					
process (fpu_operation_valid) is
begin
if rising_edge(fpu_operation_valid) then
  reg_fpu_operation_data <= fpu_operation_data;
end if;
end process;
					
end Behavioral;

